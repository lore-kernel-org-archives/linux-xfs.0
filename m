Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB2A2F5B;
	Fri,  1 Aug 2025 08:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754037763; cv=none; b=jiND7f/Mxox9v27P+0pDMbPLkIcO3GxQJgt3CdC49gOAxSnOgwVxuyyr7+Dka54WjXrRjQJg6RPh//8eGA9yvJg93K92c0k3jftlTVrfYtNtKY3RGr5B5E7TBNppUl92cPoR78DHAQHbx37XKyW/hF/f5vlKoxyFjuA7diKBuT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754037763; c=relaxed/simple;
	bh=NeXMw0sZHShpRr67yZ0q58g3ZLU7+3OWKfeN9hXUJ0M=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pwsbYUVXVmJZL3SOv3n1FwkimImuUkmRY8zj/pkr7VVkj6w8ArQTtuRsNvNbDTBg7SZFpLm9ht0ECfB2UzLY9Vz211PJJxer6m1MqtmSrBPU8/ck5imnBMNkyG/dtOPE8RpUMCiG0iXfa6hI4eDhzMfPOCEVTRYcTJVlBVVd+Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 737c85806eb311f0b29709d653e92f7d-20250801
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD
	AMN_C_TI, AMN_C_BU, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:e5d3c9c8-975a-4cf0-bd95-44f2bf305e6c,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.1.45,REQID:e5d3c9c8-975a-4cf0-bd95-44f2bf305e6c,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:6493067,CLOUDID:07321bf41f8c4a7c13233b0926743eca,BulkI
	D:250801164227N6XVGJTR,BulkQuantity:0,Recheck:0,SF:17|19|23|43|66|74|78|10
	2,TC:nil,Content:0|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BE
	C:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-UUID: 737c85806eb311f0b29709d653e92f7d-20250801
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(123.149.3.168)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1574273075; Fri, 01 Aug 2025 16:42:26 +0800
From: liuhuan01@kylinos.cn
To: cem@kernel.org
Cc: djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH v1] xfs: prevent readdir infinite loop with billions subdirs
Date: Fri,  1 Aug 2025 16:41:46 +0800
Message-Id: <20250801084145.501276-1-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: liuh <liuhuan01@kylinos.cn>

When a directory contains billions subdirs, readdir() repeatedly
got same data and goes to infinate loop.
The root cause is that the pos gets truncated during assignment.
Fix it.

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 fs/xfs/xfs_dir2_readdir.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 06ac5a7de60a..a7ec0d0c8070 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -465,7 +465,7 @@ xfs_dir2_leaf_getdents(
 		length = xfs_dir2_data_entsize(mp, dep->namelen);
 		filetype = xfs_dir2_data_get_ftype(mp, dep);
 
-		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
+		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & XFS_DIR2_MAX_DATAPTR;
 		if (XFS_IS_CORRUPT(dp->i_mount,
 				   !xfs_dir2_namecheck(dep->name,
 						       dep->namelen))) {
@@ -491,9 +491,9 @@ xfs_dir2_leaf_getdents(
 	 * All done.  Set output offset value to current offset.
 	 */
 	if (curoff > xfs_dir2_dataptr_to_byte(XFS_DIR2_MAX_DATAPTR))
-		ctx->pos = XFS_DIR2_MAX_DATAPTR & 0x7fffffff;
+		ctx->pos = XFS_DIR2_MAX_DATAPTR;
 	else
-		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
+		ctx->pos = xfs_dir2_byte_to_dataptr(curoff) & XFS_DIR2_MAX_DATAPTR;
 	if (bp)
 		xfs_trans_brelse(args->trans, bp);
 	return error;
-- 
2.25.1

