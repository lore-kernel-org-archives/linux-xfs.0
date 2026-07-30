Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6DE3EC833;
	Thu, 30 Jul 2026 09:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785402376; cv=none; b=enwIOzHOSU+pBodBT0ID5gFXjP9t2hMyr2F10WP0kN7kvcB6NoH3Duvv/PMa7/ihNQ2LxzX2amRVxz0n9pdgKzFMiwfzNLxGs+L4MPvJD8Pmhr8T1WQ/cAQuWmksS+Nc31Q7KUpXYwXZj1xlQdumyg7Y/hL2kahA/2hL6IB/XV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785402376; c=relaxed/simple;
	bh=XlsSHKdIrf6iMesfsYve0V7r4C2Bn1qO8ieYyc+vGaw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ps53nfZSZ/MbLlDuuO5NJvLY9Bu3Dotf2oFV4VQVkGlutD91lw4lOrmpYfIE2VOwXfXEu18vZklwdkDv1GT/04phgJlVKcAwF6BCD+StDSPUopBbd8NL4ZWybCJA0lJcomskeBq+K2o+boxeEpo4Y//Xiq3QphuTvKgLYzi/Ig0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: e592f6448bf511f1aa26b74ffac11d73-20260730
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:b9205243-daae-4e74-8821-094bbc7f14ab,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e7bac3a,CLOUDID:f53d4f239354e00ab07ca0bbdae3278f,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e592f6448bf511f1aa26b74ffac11d73-20260730
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 661930609; Thu, 30 Jul 2026 17:06:06 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: cem@kernel.org,
	djwong@kernel.org,
	chandanrlinux@gmail.com
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] xfs: fix heap buffer overflow in xfs_bmbt_to_bmdr
Date: Thu, 30 Jul 2026 17:06:02 +0800
Message-Id: <20260730090602.183293-1-zenghongling@kylinos.cn>
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
Change in v2:
- Ensure memcpy operations consistently use nrecs instead of dmxr.
---
 fs/xfs/libxfs/xfs_bmap_btree.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 758a4b1ccf5b..e32cdcbdeed0 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -151,6 +151,7 @@ xfs_bmbt_to_bmdr(
 	int			dmxr;
 	xfs_bmbt_key_t		*fkp;
 	__be64			*fpp;
+	int                     nrecs;
 	xfs_bmbt_key_t		*tkp;
 	__be64			*tpp;
 
@@ -167,14 +168,19 @@ xfs_bmbt_to_bmdr(
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
-	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
-	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
+	tpp = xfs_bmdr_ptr_addr(dblock, 1, nrecs);
+	memcpy(tkp, fkp, sizeof(*fkp) * nrecs);
+	memcpy(tpp, fpp, sizeof(*fpp) * nrecs);
 }
 
 STATIC struct xfs_btree_cur *
-- 
2.25.1

