Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:46998 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753244AbeDRCrQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:47:16 -0400
Subject: [PATCH 04/11] xfs_repair: zap corrupt remote symlink
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:46:57 -0700
Message-ID: <152401961698.13319.6780338835004190495.stgit@magnolia>
In-Reply-To: <152401958920.13319.10756339531174871801.stgit@magnolia>
References: <152401958920.13319.10756339531174871801.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

If a remote symlink has a corrupted remote block, just zap the symlink.
Fixes total lack of repair activity in xfs/382.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/dinode.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index 9af4f05..ceffc52 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1330,6 +1330,13 @@ _("cannot read inode %" PRIu64 ", file block %d, disk block %" PRIu64 "\n"),
 				lino, i, fsbno);
 			return 1;
 		}
+		if (bp->b_error == -EFSCORRUPTED) {
+			do_warn(
+_("Corrupt symlink remote, block %" PRIu64 ", inode %" PRIu64 ".\n"),
+				fsbno, lino);
+			libxfs_putbuf(bp);
+			return 1;
+		}
 		if (bp->b_error == -EFSBADCRC) {
 			do_warn(
 _("Bad symlink buffer CRC, block %" PRIu64 ", inode %" PRIu64 ".\n"

