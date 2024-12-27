Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AA48821;
	Fri, 27 Dec 2024 03:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735269088; cv=none; b=TGZ+fYfjP1qp7+cYYTtskDo2UO9rI8AatPlhG1TUE7bvRVNOtxeydL0B4ZTQTGmH27siqf8RtCq8HwSHXmaHR5BZBGaIa53ky/UQspf0CavoU69bEz6mDHKBVpecNE4woXAe6rR8LQ+LIXhCczGjAMg/OeN5mGJSPGWK01/+CTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735269088; c=relaxed/simple;
	bh=DkzZ/100jfOGd9j8/PGJ+efWq5TpHNONwHX7JCkEiIg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ASNCRwyVxQxmtHbwSLApywMPU9eAfxAc35FX2p0yYnQBY1U+OvuVjEzR3SR+C/2XlPC8TyPC/ymeAT5hVvUoa5FHBeTCzZo80m//GwxO8Ea20p8Rv/3ijHIy13K65zy1viYFx96zN8Xv2EhxCtXiZq5Btl3ddtJ6aOa+U7kGVUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3d6fa246c40011efa216b1d71e6e1362-20241227
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS, GTI_C_CI, GTI_FG_IT
	GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI
	AMN_C_BU
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:e9d8e195-98e2-45c2-9a6f-991961c0fa2e,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:15
X-CID-INFO: VERSION:1.1.41,REQID:e9d8e195-98e2-45c2-9a6f-991961c0fa2e,IP:0,URL
	:0,TC:0,Content:-5,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:15
X-CID-META: VersionHash:6dc6a47,CLOUDID:9e67724ffc62f2b686f0294a9de20808,BulkI
	D:241227111118SU2DMDBF,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102,TC:nil,
	Content:0|50,EDM:5,IP:nil,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,CO
	L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-UUID: 3d6fa246c40011efa216b1d71e6e1362-20241227
X-User: xiaopei01@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2020058914; Fri, 27 Dec 2024 11:11:18 +0800
From: Pei Xiao <xiaopei01@kylinos.cn>
To: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cem@kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] xfs: use kmemdup() to replace kmalloc + memcpy
Date: Fri, 27 Dec 2024 11:11:13 +0800
Message-Id: <37bbe1eb5f72685e54abb1ee6b50eaff788ecd93.1735268963.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cocci warnings:
    fs/xfs/libxfs/xfs_dir2.c:336:15-22: WARNING opportunity for kmemdup

Fixes: 30f712c9dd69 ("libxfs: move source files")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412260425.O3CDUhIi-lkp@intel.com/
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
---
 fs/xfs/libxfs/xfs_dir2.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 202468223bf9..24251e42bdeb 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -379,12 +379,11 @@ xfs_dir_cilookup_result(
 					!(args->op_flags & XFS_DA_OP_CILOOKUP))
 		return -EEXIST;
 
-	args->value = kmalloc(len,
+	args->value = kmemdup(name, len,
 			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_RETRY_MAYFAIL);
 	if (!args->value)
 		return -ENOMEM;
 
-	memcpy(args->value, name, len);
 	args->valuelen = len;
 	return -EEXIST;
 }
-- 
2.25.1

