Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6B88F4A;
	Mon, 30 Dec 2024 07:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735543114; cv=none; b=o8hK8JCv/InXj9qlaQaIKYNvD9C1/SJgp/akr4ORY3/Gbn7ANopQ8JjIjTBCUA4N/aQGH0wcWFb+yGXG5Pajiu8A3jotx4ZL1n456/Fu7QL7SPwIXPHNnd8IjXa+8Fq0q9f5+gFZhce2ZzFU11XjohKn2PyGtuI9pzIPQvP2fYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735543114; c=relaxed/simple;
	bh=4gDoJ+ZtTSmqpcBNyhQUwBHmZNsE/18d7ZyfuTFTsR8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=P8wlI1jiz6jndsnFMn+xaVe8nKnkWnqhCsa98CNrz1PPw/Stvqr3fgv6Y4syiv/+vIXR6NsJH6uWyHGSwuwuI8KIByT2HF5o+TiKYWEP3IYiN9i8BpoK9RzrRP+kdQCN3KyiWzweJtx6df54uIVyA6BiiQ+fAmUAt7O3Tn3Iohk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3ffad366c67e11efa216b1d71e6e1362-20241230
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	OB_FP, CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS, GTI_C_CI
	GTI_FG_IT, GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD
	AMN_C_TI, AMN_C_BU
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:b99129f1-3f34-4c56-ad0b-23aa6afcd0e0,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-INFO: VERSION:1.1.41,REQID:b99129f1-3f34-4c56-ad0b-23aa6afcd0e0,IP:0,URL
	:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:20
X-CID-META: VersionHash:6dc6a47,CLOUDID:1fa4754afc19d7360f90239db02c312f,BulkI
	D:241230151823KKEE82PJ,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102,TC:nil,
	Content:0|50,EDM:5,IP:nil,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,CO
	L:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-UUID: 3ffad366c67e11efa216b1d71e6e1362-20241230
X-User: xiaopei01@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2124759663; Mon, 30 Dec 2024 15:18:21 +0800
From: Pei Xiao <xiaopei01@kylinos.cn>
To: cem@kernel.org,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] xfs: Use refcount_t instead of atomic_t for xmi_refcount
Date: Mon, 30 Dec 2024 15:18:16 +0800
Message-Id: <4236d961cf3dd2413cebd56619d0f5927c8e749a.1735542858.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use an API that resembles more the actual use of xmi_refcount.

Found by cocci:
    fs/xfs/xfs_exchmaps_item.c:57:5-24: WARNING: atomic_dec_and_test
variation before object free at line 58.

Fixes: 6c08f434bd33 ("xfs: introduce a file mapping exchange log intent item")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412260634.uSDUNyYS-lkp@intel.com/
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
---
 fs/xfs/xfs_exchmaps_item.c | 6 +++---
 fs/xfs/xfs_exchmaps_item.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_exchmaps_item.c b/fs/xfs/xfs_exchmaps_item.c
index 264a121c5e16..5975a16c54e3 100644
--- a/fs/xfs/xfs_exchmaps_item.c
+++ b/fs/xfs/xfs_exchmaps_item.c
@@ -57,8 +57,8 @@ STATIC void
 xfs_xmi_release(
 	struct xfs_xmi_log_item	*xmi_lip)
 {
-	ASSERT(atomic_read(&xmi_lip->xmi_refcount) > 0);
-	if (atomic_dec_and_test(&xmi_lip->xmi_refcount)) {
+	ASSERT(refcount_read(&xmi_lip->xmi_refcount) > 0);
+	if (refcount_dec_and_test(&xmi_lip->xmi_refcount)) {
 		xfs_trans_ail_delete(&xmi_lip->xmi_item, 0);
 		xfs_xmi_item_free(xmi_lip);
 	}
@@ -138,7 +138,7 @@ xfs_xmi_init(
 
 	xfs_log_item_init(mp, &xmi_lip->xmi_item, XFS_LI_XMI, &xfs_xmi_item_ops);
 	xmi_lip->xmi_format.xmi_id = (uintptr_t)(void *)xmi_lip;
-	atomic_set(&xmi_lip->xmi_refcount, 2);
+	refcount_set(&xmi_lip->xmi_refcount, 2);
 
 	return xmi_lip;
 }
diff --git a/fs/xfs/xfs_exchmaps_item.h b/fs/xfs/xfs_exchmaps_item.h
index efa368d25d09..b8be3bca3155 100644
--- a/fs/xfs/xfs_exchmaps_item.h
+++ b/fs/xfs/xfs_exchmaps_item.h
@@ -38,7 +38,7 @@ struct kmem_cache;
  */
 struct xfs_xmi_log_item {
 	struct xfs_log_item		xmi_item;
-	atomic_t			xmi_refcount;
+	refcount_t			xmi_refcount;
 	struct xfs_xmi_log_format	xmi_format;
 };
 
-- 
2.25.1

