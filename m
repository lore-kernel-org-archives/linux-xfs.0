Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0BA7262A
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jun 2026 01:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781142804; cv=none; b=OPkpUtef+VXZ7kNSrVc5AtxKiAZ9v4u7GU707XN0YdW2evknmA1bqqXMglss0jL9lwdiK609HV/2X2YPmViOPCYjB8LUy0B6hn27ywRvPtsNtNagsTY7SjkKQP5A5JPcmDEvgdTtwSSCkSqScluYJzKp7XarXv0xPzyYb6X2MKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781142804; c=relaxed/simple;
	bh=AlucqnqgdFLZnWnq67RzmhXsMCe3qAjaLX6iKzf11m4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Q+kU1/BeEDeHjgA8Qh9crJ/NoEVmqYLJOsB5K/5ek4Vq3ZkmtZ+oulZ6Ma1rOfKBhHiVXZxdmDlo2p5YiGA2LV/CKsiqsboM3JFVE5oMUO2cmacjqK/v1ZfUIRq6ExMgRLvVgamU/erGDvqi/yEt0aJgcQa9lCtwCTQshpO0BtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 4ff2aa14653811f1aa26b74ffac11d73-20260611
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:c3a7e24b-00ce-493a-baf5-f6e8e1aa0e10,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:e7bac3a,CLOUDID:9e13f821531dfaf2f4517d077cf88720,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:5,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4ff2aa14653811f1aa26b74ffac11d73-20260611
X-User: sangyao@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <sangyao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2087297860; Thu, 11 Jun 2026 09:53:15 +0800
From: Yao Sang <sangyao@kylinos.cn>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	Yao Sang <sangyao@kylinos.cn>
Subject: [PATCH] xfs: shut down zoned file systems on writeback errors
Date: Thu, 11 Jun 2026 09:53:05 +0800
Message-Id: <20260611015305.1583003-1-sangyao@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zoned writeback allocates space from an open zone and advances the
in-memory allocation state before submitting the bio.  The completion
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
Zoned writeback allocates space from an open zone before submitting the
bio.  If the device later rejects the write, XFS cannot reliably recover
the in-core open-zone allocation state from ioend completion, because it
cannot know whether or how far the device write pointer advanced.

The issue was investigated with xfs/643 and xfs/646 on an external ZNS
realtime device.  Both tests can expose the same failure mode once a
writeback error happens after consuming open-zone space:

- xfs/643 exposes it through the GC defragmentation path.
- xfs/646 exposes it through the truncate/EOF-zeroing space wait path.

Without forcing shutdown, later writers can wait for open-zone or GC
progress that will never arrive. Forcing shutdown wakes the existing
zoned allocation waiters and turns later waits into -EIO.

Tested with:
- xfstests: xfs/642, xfs/643, xfs/644,
  xfs/646, xfs/647 

 fs/xfs/xfs_aops.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 1a82cf625a08..4bcb47da5989 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -139,6 +139,16 @@ xfs_end_ioend_write(
 	 */
 	error = blk_status_to_errno(ioend->io_bio.bi_status);
 	if (unlikely(error)) {
+		/*
+		 * Zoned writes update the in-core open zone accounting before
+		 * I/O submission.  A failed write leaves that state inconsistent,
+		 * so shut down the filesystem instead of letting later writers
+		 * wait forever for open zone space to become available.
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

