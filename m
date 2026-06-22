Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCC439A4B3
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 09:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782119061; cv=none; b=NHt3VFIGp3PzzZ70zC7rNZzrYDiCI3IPjXCPgCtJl3RlkHXOZhl1aQTNnRHF8mtiubZaGn79xTeYC7kmbfpFBlDMBCcjFQ68B9dI+Iy72earLmX5D68WMZyyhuiJm/qxNBuwpfkt8KSAoKOafR3t28hf0JWppZp3hStx/qFTkMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782119061; c=relaxed/simple;
	bh=JRzlz99iwHsvcpMqwoUfRwISlguB+7k7gAULy1JnATU=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=YNsoUrEECzVsLOa4FeZbfQ9SnWU09TTtga1XuRfr7+FnTgXcIEMDOJpUX5JHvycYUhOuWtLwX/a4EshskOikgkq/QLwuugCyLvAfxZLVzHEQCgPlHtsj+8GzKz9YzZl4za0ygAcOB8Bs19/JpI/qGSL2iTCBesx5rNy2pgeKcxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=none smtp.helo=mailgw.kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mailgw.kylinos.cn
X-UUID: 95e3e5406e0911f1aa26b74ffac11d73-20260622
Message-ID:<1782119051695882.15077.seg@mailgw.kylinos.cn>
X-Spam-Fingerprint: 0
X-GW-Reason: 11109
X-Content-Feature:
	ica/max.line-size 70
	audit/email.address 1
	dict/adv 1
	dict/operate 1
	meta/cnt.alert 1
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_UNTRUSTED
	SN_UNFAMILIAR, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD_SPF
	CIE_UNKNOWN, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:fc237e7b-bf32-45de-bc8a-696bdf14d044,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:fc237e7b-bf32-45de-bc8a-696bdf14d044,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:175cca9a3a37865c4d1ead1f994db828,BulkI
	D:2606221509022OJYKI7I,BulkQuantity:1,Recheck:0,SF:17|19|66|78|102|127|136
	|850|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk
	:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 95e3e5406e0911f1aa26b74ffac11d73-20260622
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(123.149.0.228)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 854523988; Mon, 22 Jun 2026 15:11:27 +0800
From: liuh <liuhuan01@kylinos.cn>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH] mkfs: simplify setup_proto file status checks
Date: Mon, 22 Jun 2026 15:11:10 +0800
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

setup_proto() calls filesize() before validating the source type with
fstat(), even though both operations ultimately require the same file
status information.

Perform a single fstat() immediately after opening the source path and
reuse the resulting metadata for both source type validation and file
size retrieval. This simplifies the setup logic and eliminates a
redundant metadata lookup.

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 mkfs/proto.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index a460aebd..51f61e18 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -82,14 +82,17 @@ setup_proto(
 		return result;
 	}
 
-	if ((fd = open(fname, O_RDONLY)) < 0 || (size = filesize(fd)) < 0) {
+	if ((fd = open(fname, O_RDONLY)) < 0) {
 		fprintf(stderr, _("%s: failed to open %s: %s\n"),
 			progname, fname, strerror(errno));
 		goto out_fail;
 	}
 
-	if (fstat(fd, &statbuf) < 0)
-		fail(_("invalid or unreadable source path"), errno);
+	if (fstat(fd, &statbuf) < 0) {
+		fprintf(stderr, _("%s: failed to stat %s: %s\n"),
+			progname, fname, strerror(errno));
+		goto out_fail;
+	}
 
 	/*
 	 * Handle directory inputs.
@@ -101,6 +104,11 @@ setup_proto(
 		return result;
 	}
 
+	/*
+	 * Get size from statbuf for regular file
+	 */
+	size = statbuf.st_size;
+
 	/*
 	 * Else this is a protofile, let's handle traditionally.
 	 */
-- 
2.43.0

