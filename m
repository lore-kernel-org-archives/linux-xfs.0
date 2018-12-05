Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44668 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728297AbeLEVCZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Dec 2018 16:02:25 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 590A6307CDDE
        for <linux-xfs@vger.kernel.org>; Wed,  5 Dec 2018 21:02:25 +0000 (UTC)
Subject: [PATCH 01/10] xfs: change xfs_attr3_rmt_hdr_ok to return bool
References: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <1b1b2992-5304-e9e2-b20e-ac41235744f7@redhat.com>
Date: Wed, 5 Dec 2018 15:02:15 -0600
MIME-Version: 1.0
In-Reply-To: <542b81dc-b564-c5fa-86b4-b4dc8ac50b63@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

xfs_attr3_rmt_hdr_ok is only checked for true/false and the caller
does nothing with the returned failaddr, so make it a bool.

(its usage and naming lend itself to a bool too, i.e. test (!ok))

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_remote.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
index d89363c6b523..f86680e08613 100644
--- a/fs/xfs/libxfs/xfs_attr_remote.c
+++ b/fs/xfs/libxfs/xfs_attr_remote.c
@@ -53,7 +53,7 @@ xfs_attr3_rmt_blocks(
  * does CRC, location and bounds checking, the unpacking function checks the
  * attribute parameters and owner.
  */
-static xfs_failaddr_t
+static bool
 xfs_attr3_rmt_hdr_ok(
 	void			*ptr,
 	xfs_ino_t		ino,
@@ -64,16 +64,16 @@ xfs_attr3_rmt_hdr_ok(
 	struct xfs_attr3_rmt_hdr *rmt = ptr;
 
 	if (bno != be64_to_cpu(rmt->rm_blkno))
-		return __this_address;
+		return false;
 	if (offset != be32_to_cpu(rmt->rm_offset))
-		return __this_address;
+		return false;
 	if (size != be32_to_cpu(rmt->rm_bytes))
-		return __this_address;
+		return false;
 	if (ino != be64_to_cpu(rmt->rm_owner))
-		return __this_address;
+		return false;
 
 	/* ok */
-	return NULL;
+	return true;
 }
 
 static xfs_failaddr_t
@@ -287,7 +287,7 @@ xfs_attr_rmtval_copyout(
 		byte_cnt = min(*valuelen, byte_cnt);
 
 		if (xfs_sb_version_hascrc(&mp->m_sb)) {
-			if (xfs_attr3_rmt_hdr_ok(src, ino, *offset,
+			if (!xfs_attr3_rmt_hdr_ok(src, ino, *offset,
 						  byte_cnt, bno)) {
 				xfs_alert(mp,
 "remote attribute header mismatch bno/off/len/owner (0x%llx/0x%x/Ox%x/0x%llx)",
-- 
2.17.0
