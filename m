Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44910 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727575AbeLEVG4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:06:56 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 238B9308A958
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 21:06:56 +0000 (UTC)
Subject: [PATCH 06/10] xfs: teach xfs_btree_[sl]block_verify_crc to populate
 verifier context
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <d45b96da-4ad1-3099-756e-8970934742f5@redhat.com>
Date: Wed, 5 Dec 2018 15:06:51 -0600
MIME-Version: 1.0
In-Reply-To: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

Rather than simply returning true/false, populate the verifier
context as well.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_btree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index d4728f70fcc3..0b88cb04a719 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -297,11 +297,11 @@ xfs_btree_lblock_verify_crc(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn)))
-			return false;
+			return XFS_CORRUPTED_RETURN(vc);
 		return xfs_buf_verify_cksum(vc, bp, XFS_BTREE_LBLOCK_CRC_OFF);
 	}
 
-	return true;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 /*
@@ -336,11 +336,11 @@ xfs_btree_sblock_verify_crc(
 
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
-			return false;
+			return XFS_CORRUPTED_RETURN(vc);
 		return xfs_buf_verify_cksum(vc, bp, XFS_BTREE_SBLOCK_CRC_OFF);
 	}
 
-	return true;
+	return XFS_VERIFIED_RETURN(vc);
 }
 
 static int
-- 
2.17.0
