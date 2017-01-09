Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56202 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755034AbdAIPjL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:39:11 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/32] xfs: don't call xfs_sb_quota_from_disk twice
Date: Mon,  9 Jan 2017 16:38:32 +0100
Message-Id: <1483976343-661-2-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>, Dave Chinner <david@fromorbit.com>

From: Eric Sandeen <sandeen@redhat.com>

commit e6fc6fcf4447c9266038c55c25e4c7c14bee110c upstream.

Source xfsprogs commit: ee3754254e8c186c99b6cdd4d59f741759d04acb

Kernel commit 5ef828c4 ("xfs: avoid false quotacheck after unclean
shutdown") made xfs_sb_from_disk() also call xfs_sb_quota_from_disk
by default.

However, when this was merged to libxfs, existing separate
calls to libxfs_sb_quota_from_disk remained, and calling it
twice in a row on a V4 superblock leads to issues, because:

        if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
...
                sbp->sb_pquotino = sbp->sb_gquotino;
                sbp->sb_gquotino = NULLFSINO;

and after the second call, we have set both pquotino and gquotino
to NULLFSINO.

Fix this by making it safe to call twice, and also remove the extra
calls to libxfs_sb_quota_from_disk.

This is only spotted when running xfstests with "-m crc=0" because
the sb_from_disk change came about after V5 became default, and
the above behavior only exists on a V4 superblock.

Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_sb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a70aec9..7a39240 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -338,13 +338,16 @@ xfs_sb_quota_from_disk(struct xfs_sb *sbp)
 					XFS_PQUOTA_CHKD : XFS_GQUOTA_CHKD;
 	sbp->sb_qflags &= ~(XFS_OQUOTA_ENFD | XFS_OQUOTA_CHKD);
 
-	if (sbp->sb_qflags & XFS_PQUOTA_ACCT)  {
+	if (sbp->sb_qflags & XFS_PQUOTA_ACCT &&
+	    sbp->sb_gquotino != NULLFSINO)  {
 		/*
 		 * In older version of superblock, on-disk superblock only
 		 * has sb_gquotino, and in-core superblock has both sb_gquotino
 		 * and sb_pquotino. But, only one of them is supported at any
 		 * point of time. So, if PQUOTA is set in disk superblock,
-		 * copy over sb_gquotino to sb_pquotino.
+		 * copy over sb_gquotino to sb_pquotino.  The NULLFSINO test
+		 * above is to make sure we don't do this twice and wipe them
+		 * both out!
 		 */
 		sbp->sb_pquotino = sbp->sb_gquotino;
 		sbp->sb_gquotino = NULLFSINO;
-- 
2.1.4

