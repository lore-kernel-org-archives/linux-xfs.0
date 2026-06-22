Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065A5361DC0
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 07:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782112298; cv=none; b=HZO34xWs+Zi0SgD0n8bfld7xnfEa8D/+ZzT3WXHvgO1QUulBGlR2P9weIRIxbWaU2T48KJHNmD/XQXVH4XSw0nUl170UkdUXxiuq4rAr0eY9IzmVsh1WWECGA6tIHDCGnlLK0Nuem/IdAisr9rucXbcPpeonGxwhbtsk88AhpZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782112298; c=relaxed/simple;
	bh=JRzlz99iwHsvcpMqwoUfRwISlguB+7k7gAULy1JnATU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XcvbNgXOQ5AGFfmudd0tUGcXOkh1mEjCmVd6vdXsaqScXZ0caBVFAJ+KkAGcZgQDFfEKVSk+HF5Q/KddI0zLWhLZfe9jNmGFI03I6QH3yJLKVnMUf9vnVasX7+kPOPxbebwlPJHd2TF5zZj1qvB6epBLbMgVIRm5QSDWbl2JF/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 95e3e5406e0911f1aa26b74ffac11d73-20260622
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
Message-ID: <20260622071110.28854-1-liuhuan01@kylinos.cn>
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

