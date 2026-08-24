Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0963F822A;
	Mon, 24 Aug 2026 09:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787564749; cv=none; b=iKic02saTCyUj7qT4NEi5pYqXxR3FxkfGkNd+WgXbxNTtURMI86N4v8aYvkTHkwZDgGbOTpyfNujAGLKYsq3Dh4LTB4DpBlhMp6DfhKgJhcMBL64bHK33aWmwz2Lt62Bt2w+lIJOinjpDX2WCoqvWH6vPBJvJkuvWg1YcL+eZZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787564749; c=relaxed/simple;
	bh=Q7RZPYxOCzFyQhNN1XICSt3skMiGsldsWnEiMR6LIKs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=B2UCLM6UbOcvCgOkV3jx0QYImLxT7GWrzeDybnS5mRKuc5ErnUK8oYxbfzwqOiy9wNi6cghaTp08zor+uMQUd0CB8BriS71m0UH0yNdix7HGSZPSTWC0gAJoWQTpx8NXlRCKDzvLDPNXpPAKncCr1parL8MeabBA8Dy6PSSbWIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 9051affe9fa011f19a56ed5b684f684d-20260824
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:409010a3-a1d6-4c0f-a352-5df3bfe2562d,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:9f3345e84f4d72416099d08503cd2cf0,BulkI
	D:nil,BulkQuantity:0,SF:102|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:n
	il,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LE
	S:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9051affe9fa011f19a56ed5b684f684d-20260824
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 119831218; Mon, 24 Aug 2026 17:45:39 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: cem@kernel.org,
	darrick.wong@oracle.com,
	chandanrlinux@gmail.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: fix array bounds checking in log recovery
Date: Mon, 24 Aug 2026 17:45:35 +0800
Message-Id: <20260824094535.219503-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The log recovery code increments array indices based on bits set in
blf_data_map without verifying that the indices stay within the bounds
of the item->ri_buf array.

Since blf_data_map is from untrusted log data, a malicious log could set
many bits while ri_total is small, causing array index overflow.

This can result in an out-of-bounds access during log recovery, causing
a kernel crash or memory corruption.

This patch adds array bounds checking for ri_buf access in
xlog_recover_do_reg_buffer() and xlog_recover_do_inode_buffer().

The check in xlog_recover_do_inode_buffer() is placed right before the
actual array access, not after incrementing the index, to avoid false
positives when processing the last valid region.

Fixes: 1094d3f12363 ("xfs: refactor log recovery buffer item dispatch for pass2 commit functions")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 fs/xfs/xfs_buf_item_recover.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 57929f115055..7148716366ba 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -485,6 +485,19 @@ xlog_recover_do_reg_buffer(
 			break;
 		nbits = xfs_contig_bits(buf_f->blf_data_map,
 					buf_f->blf_map_size, bit);
+
+		/*
+		 * The bitmap can have more bits set than there are regions
+		 * in ri_buf, so we must check array bounds before using the
+		 * index to access ri_buf[i].
+		 */
+		if (XFS_IS_CORRUPT(mp, i >= item->ri_total)) {
+			xfs_alert(mp,
+		"Buffer log item index (%d) exceeds allocated regions (%d).",
+					i, item->ri_total);
+			return -EFSCORRUPTED;
+		}
+
 		ASSERT(nbits > 0);
 		ASSERT(item->ri_buf[i].iov_base != NULL);
 		ASSERT(item->ri_buf[i].iov_len % XFS_BLF_CHUNK == 0);
@@ -688,6 +701,19 @@ xlog_recover_do_inode_buffer(
 		if (next_unlinked_offset < reg_buf_offset)
 			continue;
 
+		/*
+		 * Check array bounds here (right before accessing ri_buf)
+		 * rather than after incrementing item_index. This avoids
+		 * incorrectly rejecting logs when item_index reaches
+		 * ri_total after processing the final valid region.
+		 */
+		if (XFS_IS_CORRUPT(mp, item_index >= item->ri_total)) {
+			xfs_alert(mp,
+		"Inode buffer log item index (%d) exceeds allocated regions (%d).",
+				item_index, item->ri_total);
+			return -EFSCORRUPTED;
+		}
+
 		ASSERT(item->ri_buf[item_index].iov_base != NULL);
 		ASSERT((item->ri_buf[item_index].iov_len % XFS_BLF_CHUNK) == 0);
 		ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
-- 
2.25.1

