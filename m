Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D1D27D760
	for <linux-xfs@vger.kernel.org>; Fri, 11 Apr 2025 07:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744355549; cv=none; b=pnPWTdR/q08A7LvYC8/+WIbYzP+U0UIP3JfR29PST+k79wjKEYVMGYnCkLnlrPtJmiTef3xaAcC+P0qv0LeUeo6sHRqWIIMn0BNFTx8CD7NdZtKg8xVHpNOmMcf4dHZ0Rj5L9DgYlUZTrZiDLabOfmwI/yIgYzhNnJqDQPV+oBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744355549; c=relaxed/simple;
	bh=vTZcr2BIrgtWKI4cQ6AFCaLinMTwgYGOuUUMaa1lIEM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l/7jPvsiLbemImvEWd8cA5d1mqzwi83hB2WxqQQpxkBv9/caHyUbsNkLk/3m+UFERqDqZ/ygWUHyflIr0qYhFJHySHo38hw6m0qJ2ywWN/TQVQsdY8GygK26mYF5dW5wEQ2HTMkVJfTbkwnkdWw+JRg9dnzEMtPmqA41LggNKQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 475388a816a411f0a216b1d71e6e1362-20250411
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD
	AMN_C_TI, AMN_C_BU, ABX_GENE_RDNS
X-CID-UNFAMILIAR: 1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:68d4f7af-f47e-42c5-8c75-d58c698e4d78,IP:10,
	URL:0,TC:0,Content:-25,EDM:25,RT:0,SF:18,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:28
X-CID-INFO: VERSION:1.1.45,REQID:68d4f7af-f47e-42c5-8c75-d58c698e4d78,IP:10,UR
	L:0,TC:0,Content:-25,EDM:25,RT:0,SF:18,FILE:0,BULK:0,RULE:Release_HamU,ACT
	ION:release,TS:28
X-CID-META: VersionHash:6493067,CLOUDID:7e0aad251b43b172258fc4b6d2a72033,BulkI
	D:250411151208TN1YUZ7W,BulkQuantity:0,Recheck:0,SF:16|19|23|38|43|66|74|78
	|102,TC:nil,Content:0|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil
	,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_USA,TF_CID_SPAM_FSD
X-UUID: 475388a816a411f0a216b1d71e6e1362-20250411
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(1.198.31.137)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 645759566; Fri, 11 Apr 2025 15:12:07 +0800
From: liuhuan01@kylinos.cn
To: david@fromorbit.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH v3] mkfs: fix the issue of maxpct set to 0 not taking effect
Date: Fri, 11 Apr 2025 15:12:03 +0800
Message-Id: <20250411071203.10598-1-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: liuh <liuhuan01@kylinos.cn>

If a filesystem has the sb_imax_pct field set to zero, there is no limit to the number of inode blocks in the filesystem.

However, when using mkfs.xfs and specifying maxpct = 0, the result is not as expected.
	[root@fs ~]# mkfs.xfs -f -i maxpct=0 xfs.img
	data     =               bsize=4096   blocks=262144, imaxpct=25
	         =               sunit=0      swidth=0 blks

The reason is that the condition will never succeed when specifying maxpct = 0. As a result, the default algorithm was applied.
	cfg->imaxpct = cli->imaxpct;
	if (cfg->imaxpct)
		return;

The result with patch:
	[root@fs ~]# mkfs.xfs -f -i maxpct=0 xfs.img
	data     =               bsize=4096   blocks=262144, imaxpct=0
	         =               sunit=0      swidth=0 blks

	[root@fs ~]# mkfs.xfs -f xfs.img
	data     =               bsize=4096   blocks=262144, imaxpct=25
	         =               sunit=0      swidth=0 blks

Cc: <linux-xfs@vger.kernel.org> # v4.15.0
Fixes: d7240c965389e1 ("mkfs: rework imaxpct calculation")
Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 mkfs/xfs_mkfs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 3f4455d4..25bed4eb 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1048,13 +1048,13 @@ struct cli_params {
 	int	data_concurrency;
 	int	log_concurrency;
 	int	rtvol_concurrency;
+	int	imaxpct;
 
 	/* parameters where 0 is not a valid value */
 	int64_t	agcount;
 	int64_t	rgcount;
 	int	inodesize;
 	int	inopblock;
-	int	imaxpct;
 	int	lsectorsize;
 	uuid_t	uuid;
 
@@ -4048,9 +4048,10 @@ calculate_imaxpct(
 	struct mkfs_params	*cfg,
 	struct cli_params	*cli)
 {
-	cfg->imaxpct = cli->imaxpct;
-	if (cfg->imaxpct)
+	if (cli->imaxpct >= 0) {
+		cfg->imaxpct = cli->imaxpct;
 		return;
+	}
 
 	/*
 	 * This returns the % of the disk space that is used for
@@ -5181,6 +5182,7 @@ main(
 		.log_concurrency = -1, /* auto detect non-mechanical ddev */
 		.rtvol_concurrency = -1, /* auto detect non-mechanical rtdev */
 		.autofsck = FSPROP_AUTOFSCK_UNSET,
+		.imaxpct = -1, /* set sb_imax_pct automatically */
 	};
 	struct mkfs_params	cfg = {};
 
-- 
2.43.0

