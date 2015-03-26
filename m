Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 925F47F50
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 11:48:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6D5B4304043
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 09:48:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vQv8GFH1CHjGp8c2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Mar 2015 09:48:50 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 02EF1B6F2F
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 16:48:50 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-237.bos.redhat.com [10.18.41.237])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t2QGmn16017249
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2015 12:48:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] mkfs: don't zero old superblocks if file was truncated
Date: Thu, 26 Mar 2015 12:48:48 -0400
Message-Id: <1427388528-62906-1-git-send-email-bfoster@redhat.com>
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

If the force overwrite option is passed to mkfs, we attempt to zero old
superblock metadata on the mkfs target. We attempt to read the primary
superblock to identify the secondary superblocks.

If the mkfs target is a regular file, it is truncated on open and the
secondary superblock zeroing operation returns a spurious and incorrect
error message due to a 0-byte read:

$ mkfs.xfs -f -d file=1,name=xfs.fs,size=32m
...
existing superblock read failed: Inappropriate ioctl for device

Fix the error reporting in zero_old_xfs_structures() to only print an
error string if the pread() call returns an error. Warn the user if the
read doesn't match the sector size. Finally, detect the case where we
know we've already truncated a regular file and skip the sb zeroing.

Reported-by: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 mkfs/xfs_mkfs.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 484e7a8..5084d75 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -817,6 +817,13 @@ zero_old_xfs_structures(
 	__uint32_t		bsize;
 	int			i;
 	xfs_off_t		off;
+	int			tmp;
+
+	/*
+	 * We open regular files with O_TRUNC|O_CREAT. Nothing to do here...
+	 */
+	if (xi->disfile && xi->dcreat)
+		return;
 
 	/*
 	 * read in existing filesystem superblock, use its geometry
@@ -830,11 +837,16 @@ zero_old_xfs_structures(
 	}
 	memset(buf, 0, new_sb->sb_sectsize);
 
-	if (pread(xi->dfd, buf, new_sb->sb_sectsize, 0) != new_sb->sb_sectsize) {
+	tmp = pread(xi->dfd, buf, new_sb->sb_sectsize, 0);
+	if (tmp < 0) {
 		fprintf(stderr, _("existing superblock read failed: %s\n"),
 			strerror(errno));
-		free(buf);
-		return;
+		goto done;
+	}
+	if (tmp != new_sb->sb_sectsize) {
+		fprintf(stderr,
+	_("warning: could not read existing superblock, skip zeroing\n"));
+		goto done;
 	}
 	libxfs_sb_from_disk(&sb, buf);
 
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
