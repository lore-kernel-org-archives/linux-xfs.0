Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C411D17D355
	for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2025 05:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737524143; cv=none; b=ZC5/AxpQYuc72SFdlu/mScHWVz+u7xJZQnMV5Rgf/Wryly3MLLe4B386vkz4CWipH0CT/RES0rBGF2HTCzRQtYsGdOHdBJHL4cjIw7VTYBw9EbgJUEQxX5xjH/IB/HBk6DSVPn5MpKhGqxnw7UduWveQkGU8cKAQoZVgAXv7SH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737524143; c=relaxed/simple;
	bh=jrnt/ZIV+Kn9IY+B+ExGau000cp4MYYyhyUrmm6cTag=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g4WblvoxEU31inRpYeGkQlUgtuTManozY9+yQ6i4nty2wo67Augz16FpvBC741NUHELAXKWNwzbpEuRcxGGNc3zdEpNnM9Trk0wQQVhocIsZ+tXzMtr1quS7nbQ8WSMC7LMJSIej0TqUi060OhTNiaFMp626SjxKoc7b0RpxbOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b006944ad88211efa216b1d71e6e1362-20250122
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD
	AMN_C_TI, AMN_C_BU, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:455d11e0-bade-429d-8f00-a28206a810df,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.1.45,REQID:455d11e0-bade-429d-8f00-a28206a810df,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:6493067,CLOUDID:7547a915e95b49dcee1e3233b20a74b5,BulkI
	D:250122111345HPZY64K4,BulkQuantity:1,Recheck:0,SF:17|19|25|38|45|66|78|10
	2,TC:nil,Content:0|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,QS:nil,BEC
	:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: b006944ad88211efa216b1d71e6e1362-20250122
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(123.53.36.254)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 232966728; Wed, 22 Jan 2025 13:35:28 +0800
From: liuhuan01@kylinos.cn
To: david@fromorbit.com,
	djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH v1] mkfs: fix the issue of maxpct set to 0 not taking effect
Date: Wed, 22 Jan 2025 13:35:05 +0800
Message-Id: <20250122053505.156729-1-liuhuan01@kylinos.cn>
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

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 mkfs/xfs_mkfs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 956cc295..6f0275d2 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1034,13 +1034,14 @@ struct cli_params {
 	int	proto_slashes_are_spaces;
 	int	data_concurrency;
 	int	log_concurrency;
+	int	imaxpct;
+	int	imaxpct_using_default;
 
 	/* parameters where 0 is not a valid value */
 	int64_t	agcount;
 	int64_t	rgcount;
 	int	inodesize;
 	int	inopblock;
-	int	imaxpct;
 	int	lsectorsize;
 	uuid_t	uuid;
 
@@ -1826,6 +1827,7 @@ inode_opts_parser(
 		break;
 	case I_MAXPCT:
 		cli->imaxpct = getnum(value, opts, subopt);
+		cli->imaxpct_using_default = false;
 		break;
 	case I_PERBLOCK:
 		cli->inopblock = getnum(value, opts, subopt);
@@ -3835,7 +3837,7 @@ calculate_imaxpct(
 	struct cli_params	*cli)
 {
 	cfg->imaxpct = cli->imaxpct;
-	if (cfg->imaxpct)
+	if (!cli->imaxpct_using_default)
 		return;
 
 	/*
@@ -4891,6 +4893,7 @@ main(
 		.data_concurrency = -1, /* auto detect non-mechanical storage */
 		.log_concurrency = -1, /* auto detect non-mechanical ddev */
 		.autofsck = FSPROP_AUTOFSCK_UNSET,
+		.imaxpct_using_default = true,
 	};
 	struct mkfs_params	cfg = {};
 
-- 
2.43.0

