Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F9535943;
	Fri, 27 Dec 2024 02:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735268006; cv=none; b=CYMe5wdZVDjygrRSSL7i+0DYZLkoNTmMgdtBvbIEDVrAC6UP4gxSQ5KKmoTMo6avP6OZAf0iUwf1KnayI4qRvFS3rpLiz6BDHIKXt9QJRmN1cSiASLbMjXPK1GevDmFWk2EczaoWH5qWyBvFduVySurDTWDnGX8A8K5L9Zg0ex0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735268006; c=relaxed/simple;
	bh=zr5TWsDcwmZy5fMMlcMkxO9AkENbekHHC4JeH0Pw4XM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LkkNUedwN3wODcij7gfNHsmJYf9IRfl0L08J2RwhCG+dN4dEPtQB4nDNMfhommEfe/dv7t0ek2z6VihT/6b6aaY1jKpbVtHD7Yb8p7/RO5cceLq9VgtlQm2whprBFCImimvH+yH4L9c6NeJWTtEnpbRIjDUQvWoSbnIcOx7XqNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b3a168bcc3fd11efa216b1d71e6e1362-20241227
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
X-CID-O-INFO: VERSION:1.1.41,REQID:b8f129ff-88e4-4a67-b997-7b015b64705b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-INFO: VERSION:1.1.41,REQID:b8f129ff-88e4-4a67-b997-7b015b64705b,IP:0,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:-5
X-CID-META: VersionHash:6dc6a47,CLOUDID:4713c9fcfa201ded0d0050ac64e8a49c,BulkI
	D:241227105309K676RDA0,BulkQuantity:0,Recheck:0,SF:17|19|66|78|102,TC:nil,
	Content:0|50,EDM:-3,IP:nil,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-UUID: b3a168bcc3fd11efa216b1d71e6e1362-20241227
X-User: xiaopei01@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 172982060; Fri, 27 Dec 2024 10:53:07 +0800
From: Pei Xiao <xiaopei01@kylinos.cn>
To: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Pei Xiao <xiaopei01@kylinos.cn>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] xfs: use kvmemdup() to replace kvmalloc + memcpy
Date: Fri, 27 Dec 2024 10:53:02 +0800
Message-Id: <1a12a05451a1fc9bc37e739a79a0ba667656ade4.1735267151.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix cocci warning:
fs/xfs/libxfs/xfs_attr_leaf.c:1061:13-20: WARNING opportunity for kmemdup

Fixes: de631e1a8b71 ("xfs: use kvmalloc for xattr buffers")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403210204.LPPBJMhf-lkp@intel.com/
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index fddb55605e0c..db45f22e89d0 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1136,8 +1136,9 @@ xfs_attr3_leaf_to_shortform(
 
 	trace_xfs_attr_leaf_to_sf(args);
 
-	tmpbuffer = kvmalloc(args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
-	memcpy(tmpbuffer, bp->b_addr, args->geo->blksize);
+	tmpbuffer = kvmemdup(bp->b_addr, args->geo->blksize, GFP_KERNEL | __GFP_NOFAIL);
+	if (!tmpbuffer)
+		return -ENOMEM;
 
 	leaf = (xfs_attr_leafblock_t *)tmpbuffer;
 	xfs_attr3_leaf_hdr_from_disk(args->geo, &ichdr, leaf);
-- 
2.25.1

