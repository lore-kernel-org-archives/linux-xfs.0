Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C2B187FA4
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 06:56:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 917E48F804B
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 04:56:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id O83DfbW5zGBFYJFC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 04:56:09 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id DBEC92B9DE5
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 11:56:08 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t75Bu8fv008194
	for <xfs@oss.sgi.com>; Wed, 5 Aug 2015 07:56:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] libxfs: remove sparse inode mount warning
Date: Wed,  5 Aug 2015 07:56:07 -0400
Message-Id: <1438775767-59687-2-git-send-email-bfoster@redhat.com>
In-Reply-To: <1438775767-59687-1-git-send-email-bfoster@redhat.com>
References: <1438775767-59687-1-git-send-email-bfoster@redhat.com>
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

The sparse inodes experimental feature warning fires multiple times
during mkfs because the warning is emitted as part of the superblock
verifier codepath. The warning is intended as a mount-time warning only
and has been relocated as such in the kernel repo.

Remove the warning from libxfs such that it is not emitted from
userspace.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 libxfs/xfs_sb.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index ab30dc5..039596e 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -180,9 +180,6 @@ xfs_mount_validate_sb(
 	if (xfs_sb_version_hassparseinodes(sbp)) {
 		uint32_t	align;
 
-		xfs_alert(mp,
-	"EXPERIMENTAL sparse inode feature enabled. Use at your own risk!");
-
 		align = XFS_INODES_PER_CHUNK * sbp->sb_inodesize
 				>> sbp->sb_blocklog;
 		if (sbp->sb_inoalignmt != align) {
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
