Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC152238D52
	for <linux-xfs@vger.kernel.org>; Fri, 12 Jun 2026 02:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781232291; cv=none; b=MxM8bmeAhbvxt+u9uOK9XL5mf9BmlrNCz44ADyANl3DKcnuB071+FX85+LBPzYK1TC4wDM1fGOmfBZIWY3soo5jjgkvy+6pyo6THOqX25EUTd90VC4Sgt52pesaVei/ne1FpJN1bH0JXGqXsBs/MTHs7rL2e24Ff5YfZE+79sm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781232291; c=relaxed/simple;
	bh=3Qs+Q2XeeBKRNAh3bT1eQqDZNaUvLhDKLEFmA5tBfJw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mt7GZNbHS5IqSt0MTBwefzQZtPA7G6Z+AJFcztPIJIa6R7XnbmScA//m5rhX4vtQ9SbWUpUIRlIEIho6mXRrFO2al+CA8B7NsIA/23PqNlBp6A4rOUpCp9HTNJg8w8Jsck6YriPsk60MqpoDHngRAUTeVC/J+jbdaQtoEzb9c50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: aa854ab0660811f1aa26b74ffac11d73-20260612
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_FG_IT, GTI_RG_INFO, GTI_C_BU
	AMN_T1, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:7ff0a824-d68f-42f8-b633-cf6c1ccc4d22,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:7ff0a824-d68f-42f8-b633-cf6c1ccc4d22,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:8060785ff4112986622af416623a0d8f,BulkI
	D:2606121044440EH4BJVY,BulkQuantity:0,Recheck:0,SF:10|66|78|102|127|136|85
	0|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:99|1,File:nil,RT:nil,Bulk
	:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,
	BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: aa854ab0660811f1aa26b74ffac11d73-20260612
X-User: sangyao@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <sangyao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1829306371; Fri, 12 Jun 2026 10:44:43 +0800
From: Yao Sang <sangyao@kylinos.cn>
To: hch@infradead.org
Cc: cem@kernel.org,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	Yao Sang <sangyao@kylinos.cn>
Subject: [PATCH v2] xfs: shut down zoned file systems on writeback errors
Date: Fri, 12 Jun 2026 10:44:30 +0800
Message-Id: <20260612024430.253758-1-sangyao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zoned writeback allocates space from an open zone and advances the
in-memory allocation state before submitting the bio. The completion
path only records the written blocks and updates the mapping on success.
If the write fails, XFS cannot tell how far the device write pointer
advanced and cannot safely roll the open zone accounting back.

This was observed while investigating xfs/643 and xfs/646 on an external
ZNS realtime device. A writeback error after consuming space from an
open zone left later writers waiting for open-zone or GC progress that
could not happen. xfs/643 exposed this through the GC defragmentation
path, while xfs/646 exposed the same failure mode through the
truncate/EOF-zeroing space wait path.

There is no local recovery path in ioend completion that can restore a
consistent zoned allocation state after the device has rejected the
write. Treat writeback errors for zoned inodes as fatal and force a
file system shutdown from the ioend completion path. The existing
shutdown path wakes zoned allocation waiters and makes future space
waits return -EIO instead of leaving tasks stuck waiting for progress.

Signed-off-by: Yao Sang <sangyao@kylinos.cn>
---
Changes in v2:
- Reflow the comment to improve readability.

Link to v1:
https://lore.kernel.org/all/20260611015305.1583003-1-sangyao@kylinos.cn 

 fs/xfs/xfs_aops.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1a82cf625a08..2a0c54256e93 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -139,6 +139,17 @@ xfs_end_ioend_write(
 	 */
 	error = blk_status_to_errno(ioend->io_bio.bi_status);
 	if (unlikely(error)) {
+		/*
+		 * Zoned writes update the in-core open zone accounting before
+		 * I/O submission.  A failed write leaves that state
+		 * inconsistent, so shut down the filesystem instead of letting
+		 * later writers wait forever for open zone space to become
+		 * available.
+		 */
+		if (is_zoned) {
+			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+			goto done;
+		}
 		if (ioend->io_flags & IOMAP_IOEND_SHARED) {
 			ASSERT(!is_zoned);
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
-- 
2.25.1

