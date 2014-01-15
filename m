Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 713EF29E27
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:55 -0600 (CST)
Received: from eagdhcp-232-151.americas.sgi.com
	(eagdhcp-232-151.americas.sgi.com [128.162.232.151])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 627C18F8037
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 16:30:52 -0800 (PST)
Received: from eagdhcp-232-151.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-151.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s0G0Ureo003624
	for <xfs@oss.sgi.com>; Wed, 15 Jan 2014 18:30:53 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-151.americas.sgi.com)
Message-Id: <20140116000851.737600194@sgi.com>
Date: Wed, 15 Jan 2014 16:00:19 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [RFC 07/17] xfs: (parent ptr) add parent pointer support to xfs_create
References: <20140115220012.624438534@sgi.com>
Content-Disposition: inline; filename=07-pptr-add-to-xfs_create.patch
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

Add the parent inode / entry offset into the parent inode entries
when creating a new file or directory. The first entry will always
go into the inode.

---
 fs/xfs/xfs_inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: b/fs/xfs/xfs_inode.c
===================================================================
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1163,6 +1163,7 @@ xfs_create(
 	struct xfs_dquot	*pdqp = NULL;
 	struct xfs_trans_res	tres;
 	uint			resblks;
+	uint			offset;
 
 	trace_xfs_create(dp, name);
 
@@ -1265,11 +1266,17 @@ xfs_create(
 	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
 					&first_block, &free_list, resblks ?
 					resblks - XFS_IALLOC_SPACE_RES(mp) : 0,
-					NULL);
+					&offset);
 	if (error) {
 		ASSERT(error != ENOSPC);
 		goto out_trans_abort;
 	}
+
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		/* set the parent pointer and offset to the inode core fields */
+		ip->i_d.di_parent = cpu_to_be64(dp->i_ino);
+		ip->i_d.di_poffset = cpu_to_be32(offset);
+	}
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
