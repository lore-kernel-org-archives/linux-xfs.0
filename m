Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4257C7F4E
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 12:55:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1006AC001
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 10:55:42 -0700 (PDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id z5uXCMqHtx3ZfE5b (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2015 10:55:40 -0700 (PDT)
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 976CAAB9F
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2015 17:55:39 +0000 (UTC)
From: Jan Kara <jack@suse.com>
Subject: [PATCH] xfs: Fix file type directory corruption for btree directories
Date: Fri, 21 Aug 2015 19:55:22 +0200
Message-Id: <1440179722-6029-1-git-send-email-jack@suse.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Jan Kara <jack@suse.com>

Users have occasionally reported that file type for some directory
entries is wrong. This mostly happened after updating libraries some
libraries. After some debugging the problem was traced down to
xfs_dir2_node_replace(). The function uses args->filetype as a file type
to store in the replaced directory entry however it also calls
xfs_da3_node_lookup_int() which will store file type of the current
directory entry in args->filetype. Thus we fail to change file type of a
directory entry to a proper type.

Fix the problem by storing new file type in a local variable before
calling xfs_da3_node_lookup_int().

Reported-by: Giacomo Comes <comes@naic.edu>
Signed-off-by: Jan Kara <jack@suse.com>
---
 fs/xfs/libxfs/xfs_dir2_node.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 41b80d3d3877..1006710a7c92 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -2132,6 +2132,7 @@ xfs_dir2_node_replace(
 	int			error;		/* error return value */
 	int			i;		/* btree level */
 	xfs_ino_t		inum;		/* new inode number */
+	int			ftype;		/* new file type */
 	xfs_dir2_leaf_t		*leaf;		/* leaf structure */
 	xfs_dir2_leaf_entry_t	*lep;		/* leaf entry being changed */
 	int			rval;		/* internal return value */
@@ -2145,7 +2146,12 @@ xfs_dir2_node_replace(
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
+	/*
+	 * We have to save new inode number and ftype since
+	 * xfs_da3_node_lookup_int() is going to overwrite them
+	 */
 	inum = args->inumber;
+	ftype = args->filetype;
 	/*
 	 * Lookup the entry to change in the btree.
 	 */
@@ -2183,7 +2189,7 @@ xfs_dir2_node_replace(
 		 * Fill in the new inode number and log the entry.
 		 */
 		dep->inumber = cpu_to_be64(inum);
-		args->dp->d_ops->data_put_ftype(dep, args->filetype);
+		args->dp->d_ops->data_put_ftype(dep, ftype);
 		xfs_dir2_data_log_entry(args, state->extrablk.bp, dep);
 		rval = 0;
 	}
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
