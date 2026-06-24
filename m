Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F121E1E16
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 08:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782289033; cv=none; b=j+iz8KiuPIOCizSNQeUpbrOWMshjeC2L5n+DQDcoHGzBq1yYg2P2oHLcJH7XClAPNF99p4UsvN2Mm3SMdwH9IcnVis2AIUTVEEh6TQGP6iKdvSJ9MdAJ25xEgCZQNHVieSDxKED8vAlDfGtDgqEq5ujdmtauAqmVpbGCPZIW2TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782289033; c=relaxed/simple;
	bh=w2Rhstrbm5vhj1iNxYXg4NqGUycehAvnGju0R5gA6hg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uRppL5fJ3hL9eGdZCX82Iwts49WBt54Rb+kzCi1vOuTJoxUVAGb00IMxtNL8TDDa8EbkgJxJ+9LifkWOnpL9GfG+Pzsfs7kSKfC0EnAELcndm0vftVmAnOywBuJaIz4gtCcgNSV8mQWoi/Hq4xDBvT7c43pahxpMhS07TP9v5S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 60edc49a6fa411f1aa26b74ffac11d73-20260624
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_UNTRUSTED
	SN_LOWREP, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:e93d98b2-5163-4d53-8829-9dea24594189,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:e93d98b2-5163-4d53-8829-9dea24594189,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:fc28c7536cd69e552370f01083affc99,BulkI
	D:260624160944Q83QD6MV,BulkQuantity:1,Recheck:0,SF:17|19|38|66|78|102|127|
	136|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,
	Bulk:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 60edc49a6fa411f1aa26b74ffac11d73-20260624
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(123.149.0.228)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1831963908; Wed, 24 Jun 2026 16:12:01 +0800
From: liuh <liuhuan01@kylinos.cn>
To: djwong@kernel.org,
	hch@lst.de
Cc: linux-xfs@vger.kernel.org,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH] fsr: preserve xfrog_bulkstat error codes
Date: Wed, 24 Jun 2026 16:11:35 +0800
Message-ID: <20260624081135.12390-1-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the bulkstat loop condition in fsrfs() to assign the return
value of xfrog_bulkstat() to ret before comparing it against zero.

Without the extra parentheses, operator precedence causes ret
to receive only the result of the comparison (0 or 1), which
discards the actual error code and breaks error reporting.

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 fsr/xfs_fsr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index e74180c1..68cc0ea4 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -678,7 +678,7 @@ fsrfs(char *mntdir, xfs_ino_t startino, int targetrange)
 		return -1;
 	}
 
-	while ((ret = -xfrog_bulkstat(&fsxfd, breq) == 0)) {
+	while ((ret = -xfrog_bulkstat(&fsxfd, breq)) == 0) {
 		struct xfs_bulkstat	*buf = breq->bulkstat;
 		struct xfs_bulkstat	*p;
 		struct xfs_bulkstat	*endp;
-- 
2.43.0

