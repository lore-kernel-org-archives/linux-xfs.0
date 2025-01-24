Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3441D63DF
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jan 2025 06:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737701730; cv=none; b=nMq/ZQktBmdz9EU2WnPCqfhG4l4YiHf0J1PKW1zxmAtUtd3FyNne92jq0n3RuPgBnbzILfmCkf3WBFlrKuN38NwFOpGtN/asYzk+rmBssUj0RbhjBntqmjvqtOhTdohHzgizabWTKsL0sy6EjpiMeCNzisEGHmbuatloHJYrYds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737701730; c=relaxed/simple;
	bh=6h59fiCHStfiiy67F3ogSr8UJ6jJ8iLNTfnnKzDkazA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IIKIZ44x8qPllYytuCnwGZQx7+UokmYw/es3mEm2laaMZuj03Og4xd0XH/mQ7Q8+gnzlBBl5bUoipTvpWi4+6o9rOKROIYM6gL2nj0IbcS7nvX1JwxjlCXSaiE0joPjgaqz0htGoJsG42d4tRLTjwQOLpmO4sCGSS9svJb8x+0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 29d8623cda2011efa216b1d71e6e1362-20250124
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, OB_FP, CIE_BAD, CIE_GOOD_SPF
	CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, AMN_C_TI, AMN_C_BU, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:6fab7eb2-51eb-4617-ba3d-ad2d11866378,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.1.45,REQID:6fab7eb2-51eb-4617-ba3d-ad2d11866378,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:6493067,CLOUDID:f0c2d8a829ca705a25f0e1028441df35,BulkI
	D:250124145136HAJ9R8DT,BulkQuantity:2,Recheck:0,SF:17|19|23|38|43|66|74|78
	|102,TC:nil,Content:0|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: 29d8623cda2011efa216b1d71e6e1362-20250124
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(1.193.57.161)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1653265335; Fri, 24 Jan 2025 14:55:14 +0800
From: liuhuan01@kylinos.cn
To: david@fromorbit.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH v2] mkfs: fix the issue of maxpct set to 0 not taking effect
Date: Fri, 24 Jan 2025 14:55:10 +0800
Message-Id: <20250124065510.11574-1-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: liuh <liuhuan01@kylinos.cn>

It does not take effect when maxpct is specified as 0.

Firstly, the man mkfs.xfs shows that setting maxpct to 0 means that all of the filesystem can become inode blocks.
However, when using mkfs.xfs and specifying maxpct = 0, the result is not as expected.
        [root@fs ~]# mkfs.xfs -f -i maxpct=0 xfs.img
        data     =                       bsize=4096   blocks=262144, imaxpct=25
                 =                       sunit=0      swidth=0 blks

The reason is that the judging condition will never succeed when specifying maxpct = 0. As a result, the default algorithm was applied.
    cfg->imaxpct = cli->imaxpct;
    if (cfg->imaxpct)
        return;
It's important that maxpct can be set to 0 within the kernel xfs code.

The result with patch:
        [root@fs ~]# mkfs.xfs -f -i maxpct=0 xfs.img
        data     =                       bsize=4096   blocks=262144, imaxpct=0
                 =                       sunit=0      swidth=0 blks

        [root@fs ~]# mkfs.xfs -f xfs.img
        data     =                       bsize=4096   blocks=262144, imaxpct=25
                 =                       sunit=0      swidth=0 blks

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 mkfs/xfs_mkfs.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 956cc295..f4216000 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1034,13 +1034,13 @@ struct cli_params {
 	int	proto_slashes_are_spaces;
 	int	data_concurrency;
 	int	log_concurrency;
+	int	imaxpct;
 
 	/* parameters where 0 is not a valid value */
 	int64_t	agcount;
 	int64_t	rgcount;
 	int	inodesize;
 	int	inopblock;
-	int	imaxpct;
 	int	lsectorsize;
 	uuid_t	uuid;
 
@@ -3834,9 +3834,10 @@ calculate_imaxpct(
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
@@ -4891,6 +4892,7 @@ main(
 		.data_concurrency = -1, /* auto detect non-mechanical storage */
 		.log_concurrency = -1, /* auto detect non-mechanical ddev */
 		.autofsck = FSPROP_AUTOFSCK_UNSET,
+		.imaxpct = -1,
 	};
 	struct mkfs_params	cfg = {};
 
-- 
2.43.0

