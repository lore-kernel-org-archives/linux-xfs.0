Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 902D77F98
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 06:56:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6BA3830404E
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 04:56:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Sl8RQIuJOD27kU3l (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 04:56:09 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id DACF4AC859
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 11:56:08 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t75Bu8ux008192
	for <xfs@oss.sgi.com>; Wed, 5 Aug 2015 07:56:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: relocate sparse inode mount warning
Date: Wed,  5 Aug 2015 07:56:06 -0400
Message-Id: <1438775767-59687-1-git-send-email-bfoster@redhat.com>
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

The sparse inodes feature is currently considered experimental. We warn
at mount time from xfs_mount_validate_sb(). This function is part of the
superblock verifier codepath, however, which means it could be invoked
repeatedly on superblock reads or writes. This is currently only
noticeable from userspace, where mkfs produces multiple warnings at
format time.

As mkfs warnings were not the intent of this change, relocate the mount
time warning to xfs_fs_fill_super(), which is only invoked once and only
in kernel space.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_sb.c | 3 ---
 fs/xfs/xfs_super.c     | 4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 21009db..4742514 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -186,9 +186,6 @@ xfs_mount_validate_sb(
 	if (xfs_sb_version_hassparseinodes(sbp)) {
 		uint32_t	align;
 
-		xfs_alert(mp,
-	"EXPERIMENTAL sparse inode feature enabled. Use at your own risk!");
-
 		align = XFS_INODES_PER_CHUNK * sbp->sb_inodesize
 				>> sbp->sb_blocklog;
 		if (sbp->sb_inoalignmt != align) {
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 1fb16562..f98ce83 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1528,6 +1528,10 @@ xfs_fs_fill_super(
 		}
 	}
 
+	if (xfs_sb_version_hassparseinodes(&mp->m_sb))
+		xfs_alert(mp,
+	"EXPERIMENTAL sparse inode feature enabled. Use at your own risk!");
+
 	error = xfs_mountfs(mp);
 	if (error)
 		goto out_filestream_unmount;
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
