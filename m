Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE693C3C15;
	Thu, 30 Jul 2026 08:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785400458; cv=none; b=QeK73t8ksCXDI5ycuZ9PAhW+8kGAhAfsjW5lxZIwUNue4aRn9Kbm2AqhdWXvdEwjCkCCEo4vyUlay2SMN0CBnXxZ1t19q3bnkUFLUM6r/i0sXvabVeiMub7MVJcI5fo8CTvMn5tKHsQ8jmymtvuXPurWMRL3eSt8EAoXu8AnzSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785400458; c=relaxed/simple;
	bh=YSs4BlEquPcSPpnK2UsyKKe20Sr7YtURrM/X3GzVqkM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u8Jp9BuuJp7EBADLAaj9Gl1AX8y8+TgKi2HYOfeKjV+lIBV7k2aNX+Tf4kibA/tjVt2iyHyfVDhrQLZE6ndBYyv0kH6Hlogl6C+MbiBhYfIJYYYE1cmqi1be4BBN7vXIECv3ZN49eZUYKxSC5ITYxOuYR7nKzRz0q+w9BPGbiw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 6ed33c668bf111f1aa26b74ffac11d73-20260730
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:2120fc2d-6822-4645-aaee-17b2bc0885ab,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:d5c7be6754db9e223efc16618ac57051,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6ed33c668bf111f1aa26b74ffac11d73-20260730
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 418250093; Thu, 30 Jul 2026 16:34:08 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: cem@kernel.org,
	djwong@kernel.org,
	chandanrlinux@gmail.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] xfs: fix heap buffer overflow in xfs_bmbt_to_bmdr
Date: Thu, 30 Jul 2026 16:34:04 +0800
Message-Id: <20260730083404.169353-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The xfs_bmbt_to_bmdr() function converts an in-memory btree root to
on-disk form during log recovery. It uses bb_numrecs from the source
to determine memcpy size without validating against the destination
fork capacity.

Current code:
  dmxr = xfs_bmdr_maxrecs(dblocklen, 0);           // destination capacity
  ...
  dmxr = be16_to_cpu(dblock->bb_numrecs);          // overwrite with source value!
  memcpy(..., * dmxr);                              // may overflow destination!

If bb_numrecs is larger than the destination fork capacity,
memcpy writes beyond the fork buffer, causing heap overflow.

Fix by validating bb_numrecs against the destination capacity
before using it for memcpy operations.

Cc: stable@vger.kernel.org
Fixes: 8ea5682d0711 ("xfs: refactor log recovery item dispatch for pass2 readhead functions")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 fs/xfs/libxfs/xfs_bmap_btree.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 758a4b1ccf5b..3b606bd8aec9 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -151,6 +151,7 @@ xfs_bmbt_to_bmdr(
 	int			dmxr;
 	xfs_bmbt_key_t		*fkp;
 	__be64			*fpp;
+	int                     nrecs;
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
@@ -167,12 +168,17 @@ xfs_bmbt_to_bmdr(
 	ASSERT(rblock->bb_level != 0);
 	dblock->bb_level = rblock->bb_level;
 	dblock->bb_numrecs = rblock->bb_numrecs;
+
+	/* Validate record count against destination fork capacity */
+	nrecs = be16_to_cpu(rblock->bb_numrecs);
 	dmxr = xfs_bmdr_maxrecs(dblocklen, 0);
+	if (nrecs > dmxr)
+		return;
+
 	fkp = xfs_bmbt_key_addr(mp, rblock, 1);
 	tkp = xfs_bmdr_key_addr(dblock, 1);
 	fpp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, rblocklen);
-	tpp = xfs_bmdr_ptr_addr(dblock, 1, dmxr);
-	dmxr = be16_to_cpu(dblock->bb_numrecs);
+	tpp = xfs_bmdr_ptr_addr(dblock, 1, nrecs);
 	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
 	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
 }
-- 
2.25.1

