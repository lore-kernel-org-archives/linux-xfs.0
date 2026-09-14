Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC213E9C05;
	Mon, 14 Sep 2026 08:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789374118; cv=none; b=h325wdYMhtXe5VP2GWWQrZiS7NeXHIboQqQToQHUcOuTyGpLHmzfFptiiaKPJOm9bwAh4/Zk8aQXYmetXdxsteE5DFVofttKWwFbA6LKhNYHEjsw6D34O6Fo6kpucl48jAp9CwiHy+jUBSGuRBk05Ebk6PNWfQMYrF/nA7ciPaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789374118; c=relaxed/simple;
	bh=LbnFp4+CT2nMOLz80Ij7J5fZfBQD52afATNGtK1Yvp4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MvuGnLUbeFq6QstsGlAQytzoXRAJrRGtQSYCGSxDGjtAEuyQWCuDhvu1/KivGUpdk8g3eu0h3/cTP4EMw5T8uG3onY7Ec6+VImC//RxSUOzfxuTX9LoxjoGm6Sbbze0gWaZ59qDLbjXjYTCj9BQhRiCZJa619Bn2Zh2h80gSRxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 52e29e64b01511f19a56ed5b684f684d-20260914
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:f822e2ca-3bbb-4bba-b338-b46171f08832,IP:15,
	URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:f822e2ca-3bbb-4bba-b338-b46171f08832,IP:15,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:09e111d4de98d9f656132ae5247fdfa6,BulkI
	D:260914162149TY3AGGQF,BulkQuantity:0,SF:10|66|78|102|127|850|865|898,TC:n
	il,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,B
	EC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 52e29e64b01511f19a56ed5b684f684d-20260914
X-User: yijiangshan@kylinos.cn
Received: from localhost.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <yijiangshan@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 680573069; Mon, 14 Sep 2026 16:21:45 +0800
From: Jiangshan Yi <yijiangshan@kylinos.cn>
To: cem@kernel.org
Cc: djwong@kernel.org,
	ljp1205831794@gmail.com,
	gaoyingjie@uniontech.com,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	13667453960@163.com,
	Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: [PATCH] xfs: remove duplicate INO1_WRITTEN check
Date: Mon, 14 Sep 2026 16:21:11 +0800
Message-Id: <20260914082111.195006-1-yijiangshan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit a23eca88448e ("xfs: fix exchange-range reflink flag clearing
issue with INO1_WRITTEN") duplicated commit b2d5a81dae38 ("xfs: fix
exchange-range reflink flag clearing issue with INO1_WRITTEN"), so
xmi_can_exchange_reflink_flags() ended up with two identical
XFS_EXCHMAPS_INO1_WRITTEN checks.  The second one is dead code,
since the first one already returned false.  Remove it.

Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
---
 fs/xfs/libxfs/xfs_exchmaps.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_exchmaps.c b/fs/xfs/libxfs/xfs_exchmaps.c
index 49eda8d0994d..3efed37cb98a 100644
--- a/fs/xfs/libxfs/xfs_exchmaps.c
+++ b/fs/xfs/libxfs/xfs_exchmaps.c
@@ -959,16 +959,6 @@ xmi_can_exchange_reflink_flags(
 {
 	struct xfs_mount		*mp = req->ip1->i_mount;
 
-	/*
-	 * The INO1_WRITTEN optimization can skip exchanging hole and
-	 * unwritten mappings, which means we cannot guarantee that all
-	 * shared extents actually moved to the other file.  Clearing the
-	 * reflink flag of an inode that still holds shared extents breaks
-	 * the CoW write path, so refuse to exchange the flags in that case.
-	 */
-	if (req->flags & XFS_EXCHMAPS_INO1_WRITTEN)
-		return false;
-
 	/*
 	 * The INO1_WRITTEN optimization can skip exchanging hole and
 	 * unwritten mappings, which means we cannot guarantee that all
-- 
2.25.1

