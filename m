Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7344E7F50
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 03:46:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3889E304081
	for <xfs@oss.sgi.com>; Thu, 27 Feb 2014 01:46:22 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	wnqvfoKHR9CAag2A for <xfs@oss.sgi.com>;
	Thu, 27 Feb 2014 01:46:19 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WIxXH-0007av-6s
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:45:47 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1WIxXH-0007pf-5v
	for xfs@oss.sgi.com; Thu, 27 Feb 2014 20:45:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] mkfs: proto file creation does not set ftype correctly
Date: Thu, 27 Feb 2014 20:45:44 +1100
Message-Id: <1393494344-30056-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1393494344-30056-1-git-send-email-david@fromorbit.com>
References: <1393494344-30056-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Hence running xfs_repair on a ftype enable filesystem that has
contents created by a proto file will throw warnings on mismatched
ftype entries and correct them. xfs/031 fails due to this problem.

Fix it by settin gup the xname structure with the correct type
fields.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 mkfs/proto.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index 4cc0df6..4d3680d 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -438,6 +438,7 @@ parseproto(
 	creds.cr_gid = (int)getnum(pp);
 	xname.name = (uchar_t *)name;
 	xname.len = name ? strlen(name) : 0;
+	xname.type = 0;
 	tp = libxfs_trans_alloc(mp, 0);
 	flags = XFS_ILOG_CORE;
 	xfs_bmap_init(&flist, &first);
@@ -453,6 +454,7 @@ parseproto(
 		if (buf)
 			free(buf);
 		libxfs_trans_ijoin(tp, pip, 0);
+		xname.type = XFS_DIR3_FT_REG_FILE;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_ihold(tp, pip);
 		break;
@@ -469,6 +471,7 @@ parseproto(
 
 		libxfs_trans_ijoin(tp, pip, 0);
 
+		xname.type = XFS_DIR3_FT_REG_FILE;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_ihold(tp, pip);
 		libxfs_trans_log_inode(tp, ip, flags);
@@ -490,6 +493,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		}
 		libxfs_trans_ijoin(tp, pip, 0);
+		xname.type = XFS_DIR3_FT_BLKDEV;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_ihold(tp, pip);
 		flags |= XFS_ILOG_DEV;
@@ -504,6 +508,7 @@ parseproto(
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
+		xname.type = XFS_DIR3_FT_CHRDEV;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_ihold(tp, pip);
 		flags |= XFS_ILOG_DEV;
@@ -516,6 +521,7 @@ parseproto(
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
+		xname.type = XFS_DIR3_FT_FIFO;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_ihold(tp, pip);
 		break;
@@ -529,6 +535,7 @@ parseproto(
 			fail(_("Inode allocation failed"), error);
 		flags |= newfile(tp, ip, &flist, &first, 1, 1, buf, len);
 		libxfs_trans_ijoin(tp, pip, 0);
+		xname.type = XFS_DIR3_FT_SYMLINK;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &first, &flist);
 		libxfs_trans_ihold(tp, pip);
 		break;
@@ -546,6 +553,7 @@ parseproto(
 			isroot = 1;
 		} else {
 			libxfs_trans_ijoin(tp, pip, 0);
+			xname.type = XFS_DIR3_FT_DIR;
 			newdirent(mp, tp, pip, &xname, ip->i_ino,
 				  &first, &flist);
 			pip->i_d.di_nlink++;
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
