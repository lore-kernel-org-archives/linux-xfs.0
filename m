Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35099 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbdHGMyI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2017 08:54:08 -0400
Received: by mail-wm0-f47.google.com with SMTP id m85so6453410wma.0
        for <linux-xfs@vger.kernel.org>; Mon, 07 Aug 2017 05:54:08 -0700 (PDT)
Message-ID: <8948A7010F7A4A758A580103D54CE381@alyakaslap>
From: "Alex Lyakas" <alex@zadarastorage.com>
Subject: [RFC - PATCH] xfs: hold xfs_buf locked between shortform->leaf conversion and the addition of the first attribute
Date: Mon, 7 Aug 2017 15:54:03 +0300
MIME-Version: 1.0
Content-Type: text/plain;
        format=flowed;
        charset="iso-8859-1";
        reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, bfoster@redhat.com, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>

The new attribute leaf buffer is not held locked across the transaction roll
between the shortform->leaf modification and the addition of the new entry.
As a result, the attribute buffer modification being made is not atomic
from an operational perspective.
Hence the AIL push can grab it in the transient state of "just created"
after the initial transaction is rolled, because the buffer has been 
released.
This leads to xfs_attr3_leaf_verify() asserting that hdr.count is zero,
treating this as in-memory corruption, and shutting down the filesystem.

More info at:
https://www.spinics.net/lists/linux-xfs/msg08778.html

This patch is based on kernel 3.18.19, which is a long-term (although EOL) 
kernel.
This is the reason it is marked as RFC.

Reproducing the issue is achieved by adding "msleep(1000)" after the 
xfs_trans_roll() call.
>From the limited testing, this patch seems to fix the issue.
Once/if the community approves this patch, we will do a formal testing.

Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
---
fs/xfs/libxfs/xfs_attr.c      | 24 +++++++++++++++++++++---
fs/xfs/libxfs/xfs_attr_leaf.c |  5 ++++-
fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 353fb42..c0ced12 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -285,20 +285,21 @@ xfs_attr_set(

     xfs_trans_ijoin(args.trans, dp, 0);

     /*
      * If the attribute list is non-existent or a shortform list,
      * upgrade it to a single-leaf-block attribute list.
      */
     if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
         (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
          dp->i_d.di_anextents == 0)) {
+        xfs_buf_t *leaf_bp = NULL;

         /*
          * Build initial attribute list (if required).
          */
         if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
             xfs_attr_shortform_create(&args);

         /*
          * Try to add the attr to the attribute list in
          * the inode.
@@ -328,48 +329,65 @@ xfs_attr_set(
             xfs_iunlock(dp, XFS_ILOCK_EXCL);

             return error ? error : err2;
         }

         /*
          * It won't fit in the shortform, transform to a leaf block.
          * GROT: another possible req'mt for a double-split btree op.
          */
         xfs_bmap_init(args.flist, args.firstblock);
-        error = xfs_attr_shortform_to_leaf(&args);
+        error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
+        /* hold the leaf buffer locked, when "args.trans" transaction 
commits */
+        if (leaf_bp)
+            xfs_trans_bhold(args.trans, leaf_bp);
+
         if (!error) {
             error = xfs_bmap_finish(&args.trans, args.flist,
                         &committed);
         }
         if (error) {
             ASSERT(committed);
+            if (leaf_bp)
+                xfs_buf_relse(leaf_bp);
             args.trans = NULL;
             xfs_bmap_cancel(&flist);
             goto out;
         }

         /*
          * bmap_finish() may have committed the last trans and started
          * a new one.  We need the inode to be in all transactions.
+         * We also need to rejoin the leaf buffer to the new transaction
+         * and prevent it from being unlocked, before we commit it in 
xfs_trans_roll().
+         * If bmap_finish() did not commit, then we are in the same 
transaction,
+         * and no need to call xfs_trans_bhold() again.
          */
-        if (committed)
+        if (committed) {
             xfs_trans_ijoin(args.trans, dp, 0);
+            xfs_trans_bjoin(args.trans, leaf_bp);
+            xfs_trans_bhold(args.trans, leaf_bp);
+        }

         /*
          * Commit the leaf transformation.  We'll need another (linked)
          * transaction to add the new attribute to the leaf.
          */

         error = xfs_trans_roll(&args.trans, dp);
-        if (error)
+        if (error) {
+            xfs_buf_relse(leaf_bp);
             goto out;
+        }

+        /* rejoin the leaf buffer to the new transaction */
+        xfs_trans_bjoin(args.trans, leaf_bp);
     }

     if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
         error = xfs_attr_leaf_addname(&args);
     else
         error = xfs_attr_node_addname(&args);
     if (error)
         goto out;

     /*
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b7cd0a0..2e03c32 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -649,23 +649,24 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
         args->valuelen = sfe->valuelen;
         memcpy(args->value, &sfe->nameval[args->namelen],
                             args->valuelen);
         return -EEXIST;
     }
     return -ENOATTR;
}

/*
  * Convert from using the shortform to the leaf.
+ * Upon success, return the leaf buffer.
  */
int
-xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
+xfs_attr_shortform_to_leaf(xfs_da_args_t *args, xfs_buf_t **bpp)
{
     xfs_inode_t *dp;
     xfs_attr_shortform_t *sf;
     xfs_attr_sf_entry_t *sfe;
     xfs_da_args_t nargs;
     char *tmpbuffer;
     int error, i, size;
     xfs_dablk_t blkno;
     struct xfs_buf *bp;
     xfs_ifork_t *ifp;
@@ -733,20 +734,22 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
         ASSERT(error == -ENOATTR);
         error = xfs_attr3_leaf_add(bp, &nargs);
         ASSERT(error != -ENOSPC);
         if (error)
             goto out;
         sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
     }
     error = 0;

out:
+    if (error == 0)
+        *bpp = bp;
     kmem_free(tmpbuffer);
     return error;
}

/*
  * Check a leaf attribute block to see if all the entries would fit into
  * a shortform attribute list.
  */
int
xfs_attr_shortform_allfit(
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 4f3a60a..d58e9e4 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -41,21 +41,21 @@ typedef struct xfs_attr_inactive_list {
  * Function prototypes for the kernel.
  *========================================================================*/

/*
  * Internal routines when attribute fork size < XFS_LITINO(mp).
  */
void    xfs_attr_shortform_create(struct xfs_da_args *args);
void    xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
int    xfs_attr_shortform_lookup(struct xfs_da_args *args);
int    xfs_attr_shortform_getvalue(struct xfs_da_args *args);
-int    xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
+int    xfs_attr_shortform_to_leaf(struct xfs_da_args *args, xfs_buf_t 
**bpp);
int    xfs_attr_shortform_remove(struct xfs_da_args *args);
int    xfs_attr_shortform_list(struct xfs_attr_list_context *context);
int    xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
int    xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes);
void    xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);

/*
  * Internal routines when attribute fork size == XFS_LBSIZE(mp).
  */
int    xfs_attr3_leaf_to_node(struct xfs_da_args *args);
-- 
1.9.1

