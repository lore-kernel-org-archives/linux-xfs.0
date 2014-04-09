Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7A2B78001
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 17:06:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1CF9AC001
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 15:06:52 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id alCkMTEhUvNfmkGJ for <xfs@oss.sgi.com>;
	Wed, 09 Apr 2014 15:06:51 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id EDD736088B51
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 17:06:50 -0500 (CDT)
Message-ID: <5345C47B.40308@sandeen.net>
Date: Wed, 09 Apr 2014 17:06:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs: remove unused calculation in xfs_dir2_sf_addname()
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

The "add_entsize" calculated here is never used.
"incr_isize" accounts for the inode expansion of the
old entries + parent + new entry all by itself.

Once we've removed add_entsize there, it's just a pointless
intermediate variable elsewhere, so remove it.  
For that matter, old_isize is gratuitous too, so nuke that.

And add a few comments so the magic "+1's" and "+2's" make
a bit more sense.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

xfs_dir2_sf.c |   21 +++++++--------------
1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_dir2_sf.c b/fs/xfs/xfs_dir2_sf.c
index 3725fb1..51e3c1e 100644
--- a/fs/xfs/xfs_dir2_sf.c
+++ b/fs/xfs/xfs_dir2_sf.c
@@ -285,14 +285,12 @@ int						/* error */
 xfs_dir2_sf_addname(
 	xfs_da_args_t		*args)		/* operation arguments */
 {
-	int			add_entsize;	/* size of the new entry */
 	xfs_inode_t		*dp;		/* incore directory inode */
 	int			error;		/* error return value */
 	int			incr_isize;	/* total change in size */
 	int			new_isize;	/* di_size after adding name */
 	int			objchange;	/* changing to 8-byte inodes */
 	xfs_dir2_data_aoff_t	offset = 0;	/* offset for new entry */
-	int			old_isize;	/* di_size before adding name */
 	int			pick;		/* which algorithm to use */
 	xfs_dir2_sf_hdr_t	*sfp;		/* shortform structure */
 	xfs_dir2_sf_entry_t	*sfep = NULL;	/* shortform entry */
@@ -316,8 +314,7 @@ xfs_dir2_sf_addname(
 	/*
 	 * Compute entry (and change in) size.
 	 */
-	add_entsize = dp->d_ops->sf_entsize(sfp, args->namelen);
-	incr_isize = add_entsize;
+	incr_isize = dp->d_ops->sf_entsize(sfp, args->namelen);
 	objchange = 0;
 #if XFS_BIG_INUMS
 	/*
@@ -325,11 +322,8 @@ xfs_dir2_sf_addname(
 	 */
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM && sfp->i8count == 0) {
 		/*
-		 * Yes, adjust the entry size and the total size.
+		 * Yes, adjust the inode size.  old count + (parent + new)
 		 */
-		add_entsize +=
-			(uint)sizeof(xfs_dir2_ino8_t) -
-			(uint)sizeof(xfs_dir2_ino4_t);
 		incr_isize +=
 			(sfp->count + 2) *
 			((uint)sizeof(xfs_dir2_ino8_t) -
@@ -337,8 +331,7 @@ xfs_dir2_sf_addname(
 		objchange = 1;
 	}
 #endif
-	old_isize = (int)dp->i_d.di_size;
-	new_isize = old_isize + incr_isize;
+	new_isize = (int)dp->i_d.di_size + incr_isize;
 	/*
 	 * Won't fit as shortform any more (due to size),
 	 * or the pick routine says it won't (due to offset values).
@@ -1110,9 +1103,9 @@ xfs_dir2_sf_toino4(
 }
 
 /*
- * Convert from 4-byte inode numbers to 8-byte inode numbers.
- * The new 8-byte inode number is not there yet, we leave with the
- * count 1 but no corresponding entry.
+ * Convert existing entries from 4-byte inode numbers to 8-byte inode numbers.
+ * The new entry w/ an 8-byte inode number is not there yet; we leave with
+ * i8count set to 1, but no corresponding 8-byte entry.
  */
 static void
 xfs_dir2_sf_toino8(
@@ -1145,7 +1138,7 @@ xfs_dir2_sf_toino8(
 	ASSERT(oldsfp->i8count == 0);
 	memcpy(buf, oldsfp, oldsize);
 	/*
-	 * Compute the new inode size.
+	 * Compute the new inode size (nb: entry count + 1 for parent)
 	 */
 	newsize =
 		oldsize +


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
