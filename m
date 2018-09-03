Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:47955 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725762AbeICF6q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Sep 2018 01:58:46 -0400
Date: Mon, 3 Sep 2018 11:40:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v8 00/28] Parent Pointers v8
Message-ID: <20180903014051.GN5631@dastard>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
 <20180903012006.GM5631@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180903012006.GM5631@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Sep 03, 2018 at 11:20:06AM +1000, Dave Chinner wrote:
> On Tue, Aug 28, 2018 at 12:22:13PM -0700, Allison Henderson wrote:
> > Hi all,
> > 
> > This is the 8th version of parent pointer attributes for xfs. The goal of
> > this patch set is to add a parent pointer attribute to each inode.  The
> > attribute name containing the parent inode, generation, and directory offset,
> > while the  attribute value contains the file name.  This feature will enable
> > future optimizations for online scrub, or any other feature that could make
> > use of quickly deriving an inodes path from  the mount point.  This set also
> > introduces deferred attribute operations, though it is currently only used by
> >  the new parent pointer code.
> 
> Hi Allison,
> 
> FYI, A couple of minor things I noticed on import of the patch set
> to 4.19-rc1:
> 
> ......
> Applying: xfs: parent pointer attribute creation
> .git/rebase-apply/patch:131: trailing whitespace.
> 	error = xfs_attr_set(child, (const unsigned char *)&rec, sizeof(rec), 
> .git/rebase-apply/patch:136: new blank line at EOF.
> +
> .git/rebase-apply/patch:296: new blank line at EOF.
> +
> warning: 3 lines add whitespace errors.
> Applying: xfs: add parent attributes to link
> Applying: xfs: remove parent pointers in unlink
> .git/rebase-apply/patch:97: new blank line at EOF.
> +
> warning: 1 line adds whitespace errors.
> Applying: xfs: Add parent pointers to rename
> Applying: xfs: Add the parent pointer support to the superblock version 5.
> Applying: xfs: Add helper function xfs_attr_list_context_init
> Applying: xfs: Increase XFS_DEFER_OPS_NR_INODES to 4
> Applying: xfs: Add parent pointer ioctl
> .git/rebase-apply/patch:340: new blank line at EOF.
> +
> warning: 1 line adds whitespace errors.
> Applying: xfs: Add delayed attributes error tag
> ......
> 
> Also, I get a couple of compiler warnings:
> 
> fs/xfs/libxfs/xfs_attr.c: In function ¿xfs_attr_set¿:
> fs/xfs/libxfs/xfs_attr.c:446:48: warning: passing argument 3 of ¿xfs_attr_set_deferred¿ discards ¿const¿ qualifier from pointer target type [-Wdiscarded-qualifiers]
>   error = xfs_attr_set_deferred(dp, args.trans, name, namelen,
>                                                 ^~~~
> In file included from fs/xfs/libxfs/xfs_attr.c:25:0:
> fs/xfs/libxfs/xfs_attr.h:197:5: note: expected ¿void *¿ but argument is of type ¿const unsigned char *¿
>  int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
>      ^~~~~~~~~~~~~~~~~~~~~
> fs/xfs/libxfs/xfs_attr.c: In function ¿xfs_attr_remove¿:
> fs/xfs/libxfs/xfs_attr.c:584:4: warning: passing argument 3 of ¿xfs_attr_remove_deferred¿ discards ¿const¿ qualifier from pointer target type [-Wdiscarded-qualifiers]
>     name, namelen, flags);
>     ^~~~
> In file included from fs/xfs/libxfs/xfs_attr.c:25:0:
> fs/xfs/libxfs/xfs_attr.h:200:5: note: expected ¿void *¿ but argument is of type ¿const unsigned char *¿
>  int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
>      ^~~~~~~~~~~~~~~~~~~~~~~~

Another couple:

fs/xfs/libxfs/xfs_attr.c: In function ¿xfs_leaf_has_attr¿:
fs/xfs/libxfs/xfs_attr.c:863:27: error: variable ¿dp¿ set but not used [-Werror=unused-but-set-variable]
  struct xfs_inode        *dp;
                           ^~
fs/xfs/libxfs/xfs_attr_leaf.c: In function ¿xfs_shortform_has_attr¿:
fs/xfs/libxfs/xfs_attr_leaf.c:635:15: error: variable ¿mp¿ set but not used [-Werror=unused-but-set-variable]
  xfs_mount_t *mp;
               ^~

The fixup patch I wrote to make it compile is below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs-pp: make it compile
---
 fs/xfs/libxfs/xfs_attr.c      |  8 +++-----
 fs/xfs/libxfs/xfs_attr.h      |  4 ++--
 fs/xfs/libxfs/xfs_attr_leaf.c | 19 +++++++++----------
 fs/xfs/xfs_parent_utils.c     |  6 +++---
 4 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 40274c2904b6..147be48ce534 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -481,9 +481,9 @@ int
 xfs_attr_set_deferred(
 	struct xfs_inode	*dp,
 	struct xfs_trans	*tp,
-	void			*name,
+	const char		*name,
 	unsigned int		namelen,
-	void			*value,
+	const char		*value,
 	unsigned int		valuelen,
 	int			flags)
 {
@@ -616,7 +616,7 @@ int
 xfs_attr_remove_deferred(
 	struct xfs_inode        *dp,
 	struct xfs_trans	*tp,
-	void			*name,
+	const char		*name,
 	unsigned int		namelen,
 	int                     flags)
 {
@@ -860,11 +860,9 @@ STATIC int
 xfs_leaf_has_attr(
 	struct xfs_da_args      *args)
 {
-	struct xfs_inode        *dp;
 	struct xfs_buf          *bp;
 	int                     error = 0;
 
-	dp = args->dp;
 	args->blkno = 0;
 	error = xfs_attr3_leaf_read(args->trans, args->dp,
 			args->blkno, -1, &bp);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 913dcb790beb..5387e6177fa6 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -195,9 +195,9 @@ int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
 		       const unsigned char *name, size_t namelen, int flags);
 int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 int xfs_attr_set_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
-			  void *name, unsigned int name_len, void *value,
+			  const char *name, unsigned int name_len, const char *value,
 			  unsigned int valuelen, int flags);
 int xfs_attr_remove_deferred(struct xfs_inode *dp, struct xfs_trans *tp,
-			    void *name, unsigned int namelen, int flags);
+			    const char *name, unsigned int namelen, int flags);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 09483fe97cd7..f1b3c734147e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -627,18 +627,17 @@ xfs_attr_fork_remove(
  * Return successful if attr is found, or ENOATTR if not
  */
 int
-xfs_shortform_has_attr(xfs_da_args_t *args)
+xfs_shortform_has_attr(
+	struct xfs_da_args	 *args)
 {
-	xfs_attr_shortform_t *sf;
-	xfs_attr_sf_entry_t *sfe;
-	int base, size = 0, end, i;
-	xfs_mount_t *mp;
-	xfs_inode_t *dp;
+	struct xfs_attr_shortform *sf;
+	struct xfs_attr_sf_entry *sfe;
+	int			base = sizeof(struct xfs_attr_sf_hdr);
+	int			size = 0;
+	int			end;
+	int			i;
 
-	dp = args->dp;
-	mp = dp->i_mount;
-	base = sizeof(xfs_attr_sf_hdr_t);
-	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
+	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
 	sfe = &sf->list[0];
 	end = sf->hdr.count;
 	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index 6d8b1e3130c7..1dc6aad6c628 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -47,8 +47,8 @@ xfs_parent_add_deferred(
 
 	xfs_init_parent_name_rec(&rec, parent, diroffset);
 
-	return xfs_attr_set_deferred(child, tp, &rec, sizeof(rec),
-		(void *)child_name->name, child_name->len, ATTR_PARENT);
+	return xfs_attr_set_deferred(child, tp, (const char *)&rec, sizeof(rec),
+		child_name->name, child_name->len, ATTR_PARENT);
 }
 
 /*
@@ -65,7 +65,7 @@ xfs_parent_remove_deferred(
 
 	xfs_init_parent_name_rec(&rec, parent, diroffset);
 
-	return xfs_attr_remove_deferred(child, tp, &rec, sizeof(rec),
+	return xfs_attr_remove_deferred(child, tp, (const char *)&rec, sizeof(rec),
 		ATTR_PARENT);
 }
 
