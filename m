Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3685C12A177;
	Fri, 27 Dec 2024 09:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735290255; cv=none; b=PJysQOFn+4y9SszLgZN/p4KokkD8TkV+mevEjUxyuceUiUCaBOj6t8RbtnGuuCF/vdc1C2OfnosGtCfYgR098hBTEFTCgq/5wFEEWdHr+spsXZrJMvSoHeBiaoUEx739iFkRu5UfdUr48L3lEB4AXqEELiRg+cKRTn6lCF/yUvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735290255; c=relaxed/simple;
	bh=5O0Dh6DbJ8C6YnTF1mPh25gbh/2k+plj2jl1kku9uPc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OnExA/FMYh0C2luhdxTzoyGz+HseYKhgNrXaaPal6qEiVyE4SEeYo3auAMiqxda/vUXkt9Twi8NJBiLqGUPU4Y8NvaOtBJmHv4lCsyJYTejYux5niwUFSgrtvNR66IUqvfqstvnWCowbLpNgVx1d3juLkkznTkLTDglgjHU9bnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 83f031dcc43111efa216b1d71e6e1362-20241227
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NO_NAME, HR_CTE_8B, HR_CTT_MISS
	HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_AS_FROM, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_C_CI, GTI_FG_IT, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, AMN_C_TI, AMN_C_BU
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:9778ffe9-75be-4e9f-82d2-ae4670949e4c,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-INFO: VERSION:1.1.41,REQID:9778ffe9-75be-4e9f-82d2-ae4670949e4c,IP:0,URL
	:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:20
X-CID-META: VersionHash:6dc6a47,CLOUDID:bcb1bcfd26fece6d670173d51f9e5342,BulkI
	D:2412271704033QOYZHZE,BulkQuantity:0,Recheck:0,SF:17|19|66|78|81|82|102,T
	C:nil,Content:0|50,EDM:5,IP:nil,URL:1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:
	nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-UUID: 83f031dcc43111efa216b1d71e6e1362-20241227
X-User: xiaopei01@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <xiaopei01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1032778717; Fri, 27 Dec 2024 17:04:01 +0800
From: Pei Xiao <xiaopei01@kylinos.cn>
To: xiaopei01@kylinos.cn
Cc: djwong@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	lkp@intel.com
Subject: [PATCH V2] xfs: use kvmemdup() to replace kvmalloc + memcpy
Date: Fri, 27 Dec 2024 17:03:56 +0800
Message-ID: <1a12a05451a1fc9bc37e739a79a0ba667656ade4.1735267151.git.xiaopei01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <1a12a05451a1fc9bc37e739a79a0ba667656ade4.1735267151.git.xiaopei01@kylinos.cn>
References: <1a12a05451a1fc9bc37e739a79a0ba667656ade4.1735267151.git.xiaopei01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20241227090356.bJVOacG0NAFeMZzNZ8N2LUufHz0MRDxx87xkekGEM4E@z>

Fix cocci warning:
fs/xfs/libxfs/xfs_attr_leaf.c:1061:13-20: WARNING opportunity for kmemdup

use kvmemdup() to replace kvmalloc + memcpy

Fixes: de631e1a8b71 ("xfs: use kvmalloc for xattr buffers")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403210204.LPPBJMhf-lkp@intel.com/
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>

---
Changes for V2:
- Add information on how to fix
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

