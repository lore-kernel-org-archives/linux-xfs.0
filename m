Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3835C7F3F
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 11:11:52 -0500 (CDT)
Received: from eagdhcp-232-136.americas.sgi.com
	(eagdhcp-232-136.americas.sgi.com [128.162.232.136])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AEAC8AC008
	for <xfs@oss.sgi.com>; Thu,  6 Jun 2013 09:11:48 -0700 (PDT)
Received: from eagdhcp-232-136.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-136.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r56GBneI002460
	for <xfs@oss.sgi.com>; Thu, 6 Jun 2013 11:11:49 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20130606161027.166439519@sgi.com>
Date: Thu, 06 Jun 2013 11:10:33 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH 1/1] xfs: fix the symbolic link assert in xfs_ifree
References: <20130606161032.753011157@sgi.com>
Content-Disposition: inline; filename=xfs-fix-assert-in-xfs_ifree.patch
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

Adding an extended attribute to a symbolic link can force that
link to an remote extent. xfs_inactive() incorrectly assumes
that any symbolic link small enough to be in the inode core
is incore, the remote extent is not cleaned and xfs_ifree()
asserts on presence the remote extent.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_vnodeops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/fs/xfs/xfs_vnodeops.c
===================================================================
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -325,7 +325,7 @@ xfs_inactive(
 		/*
 		 * Zero length symlinks _can_ exist.
 		 */
-		if (ip->i_d.di_size > XFS_IFORK_DSIZE(ip)) {
+		if (ip->i_d.di_nextents) {
 			error = xfs_inactive_symlink_rmt(ip, &tp);
 			if (error)
 				goto out_cancel;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
