Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:18322 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753005AbdHQQxl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Aug 2017 12:53:41 -0400
Date: Thu, 17 Aug 2017 09:53:31 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs_db: make write/fuzz -c and -d work on non-crc filesystems
Message-ID: <20170817165331.GF4796@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>, eguan@redhat.com

For a non-crc filesystem, make write/fuzz -c and -d work properly
instead of bailing out.  Since there's no checksum to update, both
cases collapse to setting the field value without calling the write
verifier.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/fuzz.c  |    8 ++++++--
 db/write.c |    7 +++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/db/fuzz.c b/db/fuzz.c
index 76dbf94..53cedbc 100644
--- a/db/fuzz.c
+++ b/db/fuzz.c
@@ -125,7 +125,9 @@ fuzz_f(
 		return 0;
 	}
 
-	if (invalid_data && iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF) {
+	if (invalid_data &&
+	    iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF &&
+	    xfs_sb_version_hascrc(&mp->m_sb)) {
 		dbprintf(_("Cannot recalculate CRCs on this type of object\n"));
 		return 0;
 	}
@@ -149,7 +151,9 @@ fuzz_f(
 	local_ops.verify_read = stashed_ops->verify_read;
 	iocur_top->bp->b_ops = &local_ops;
 
-	if (corrupt) {
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		local_ops.verify_write = xfs_dummy_verify;
+	} else if (corrupt) {
 		local_ops.verify_write = xfs_dummy_verify;
 		dbprintf(_("Allowing fuzz of corrupted data and bad CRC\n"));
 	} else if (iocur_top->typ->crc_off == TYP_F_CRC_FUNC) {
diff --git a/db/write.c b/db/write.c
index 9fc6d8e..5ef76bc 100644
--- a/db/write.c
+++ b/db/write.c
@@ -138,7 +138,8 @@ write_f(
 	}
 
 	if (invalid_data &&
-	    iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF) {
+	    iocur_top->typ->crc_off == TYP_F_NO_CRC_OFF &&
+	    xfs_sb_version_hascrc(&mp->m_sb)) {
 		dbprintf(_("Cannot recalculate CRCs on this type of object\n"));
 		return 0;
 	}
@@ -162,7 +163,9 @@ write_f(
 	local_ops.verify_read = stashed_ops->verify_read;
 	iocur_top->bp->b_ops = &local_ops;
 
-	if (corrupt) {
+	if (!xfs_sb_version_hascrc(&mp->m_sb)) {
+		local_ops.verify_write = xfs_dummy_verify;
+	} else if (corrupt) {
 		local_ops.verify_write = xfs_dummy_verify;
 		dbprintf(_("Allowing write of corrupted data and bad CRC\n"));
 	} else if (iocur_top->typ->crc_off == TYP_F_CRC_FUNC) {
