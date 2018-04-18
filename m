Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48002 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753076AbeDRCrD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:47:03 -0400
Subject: [PATCH 02/11] xfs_repair: don't leak buffer on xattr remote buf
 verifier error
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:46:44 -0700
Message-ID: <152401960402.13319.3526134260258053342.stgit@magnolia>
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

If we try to read an xattr remote buffer and hit a verifier error,
release the buffer instead of leaking it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 repair/attr_repair.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index bb5ab3d..3e6efd0 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -433,6 +433,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 		if (bp->b_error == -EFSBADCRC || bp->b_error == -EFSCORRUPTED) {
 			do_warn(
 	_("Corrupt remote block for attributes of inode %" PRIu64 "\n"), ino);
+			libxfs_putbuf(bp);
 			clearit = 1;
 			break;
 		}

