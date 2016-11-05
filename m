Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36574 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750935AbcKEAIW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 20:08:22 -0400
Subject: [PATCH 03/16] xfs_io: fix libxfs naming violation
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 04 Nov 2016 17:08:17 -0700
Message-ID: <147830449771.26713.16395684581974689675.stgit@birch.djwong.org>
In-Reply-To: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
References: <147830447710.26713.9536263528122988931.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

All the calls to libxfs code should start with 'libxfs'
per libxfs_api_defs.h.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/db/io.c b/db/io.c
index 8610f4d..f398195 100644
--- a/db/io.c
+++ b/db/io.c
@@ -504,7 +504,7 @@ write_cur(void)
 	/* If we didn't write the crc automatically, re-check inode validity */
 	if (xfs_sb_version_hascrc(&mp->m_sb) &&
 	    skip_crc && iocur_top->ino_buf) {
-		iocur_top->ino_crc_ok = xfs_verify_cksum(iocur_top->data,
+		iocur_top->ino_crc_ok = libxfs_verify_cksum(iocur_top->data,
 						mp->m_sb.sb_inodesize,
 						XFS_DINODE_CRC_OFF);
 	}

