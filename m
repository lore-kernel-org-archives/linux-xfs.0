Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 79BF17F53
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 19:55:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 593B3304062
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 17:55:17 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id KI3fedTMBwALi3JG for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 17:55:16 -0700 (PDT)
Message-ID: <53F694F9.9030406@sandeen.net>
Date: Thu, 21 Aug 2014 19:55:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/4] xfs: check resblks before calling xfs_dir_canenter
References: <53F6942B.80808@redhat.com>
In-Reply-To: <53F6942B.80808@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

Move the resblks test out of the xfs_dir_canenter,
and into the caller.

This makes a little more sense on the face of it;
xfs_dir_canenter immediately returns if resblks !=0;
and given some of the comments preceding the calls:

 * Check for ability to enter directory entry, if no space reserved.

even more so.

It also facilitates the next patch.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 6cef221..ea84e1c 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -535,22 +535,17 @@ out_free:
 
 /*
  * See if this entry can be added to the directory without allocating space.
- * First checks that the caller couldn't reserve enough space (resblks = 0).
  */
 int
 xfs_dir_canenter(
 	xfs_trans_t	*tp,
 	xfs_inode_t	*dp,
-	struct xfs_name	*name,		/* name of entry to add */
-	uint		resblks)
+	struct xfs_name	*name)		/* name of entry to add */
 {
 	struct xfs_da_args *args;
 	int		rval;
 	int		v;		/* type-checking value */
 
-	if (resblks)
-		return 0;
-
 	ASSERT(S_ISDIR(dp->i_d.di_mode));
 
 	args = kmem_zalloc(sizeof(*args), KM_SLEEP | KM_NOFS);
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index c8e86b0..4dff261 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -136,7 +136,7 @@ extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				xfs_fsblock_t *first,
 				struct xfs_bmap_free *flist, xfs_extlen_t tot);
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, uint resblks);
+				struct xfs_name *name);
 
 /*
  * Direct call from the bmap code, bypassing the generic directory layer.
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index fea3c92..c92cb48 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1153,9 +1153,11 @@ xfs_create(
 	if (error)
 		goto out_trans_cancel;
 
-	error = xfs_dir_canenter(tp, dp, name, resblks);
-	if (error)
-		goto out_trans_cancel;
+	if (!resblks) {
+		error = xfs_dir_canenter(tp, dp, name);
+		if (error)
+			goto out_trans_cancel;
+	}
 
 	/*
 	 * A newly created regular or special file just has one directory
@@ -1421,9 +1423,11 @@ xfs_link(
 		goto error_return;
 	}
 
-	error = xfs_dir_canenter(tp, tdp, target_name, resblks);
-	if (error)
-		goto error_return;
+	if (!resblks) {
+		error = xfs_dir_canenter(tp, tdp, target_name);
+		if (error)
+			goto error_return;
+	}
 
 	xfs_bmap_init(&free_list, &first_block);
 
@@ -2759,9 +2763,11 @@ xfs_rename(
 		 * If there's no space reservation, check the entry will
 		 * fit before actually inserting it.
 		 */
-		error = xfs_dir_canenter(tp, target_dp, target_name, spaceres);
-		if (error)
-			goto error_return;
+		if (!spaceres) {
+			error = xfs_dir_canenter(tp, target_dp, target_name);
+			if (error)
+				goto error_return;
+		}
 		/*
 		 * If target does not exist and the rename crosses
 		 * directories, adjust the target directory link count
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 6a944a2..02ae62a 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -269,9 +269,11 @@ xfs_symlink(
 	/*
 	 * Check for ability to enter directory entry, if no space reserved.
 	 */
-	error = xfs_dir_canenter(tp, dp, link_name, resblks);
-	if (error)
-		goto error_return;
+	if (!resblks) {
+		error = xfs_dir_canenter(tp, dp, link_name);
+		if (error)
+			goto error_return;
+	}
 	/*
 	 * Initialize the bmap freelist prior to calling either
 	 * bmapi or the directory create code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
