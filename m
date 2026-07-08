Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F302B1F8755
	for <linux-xfs@vger.kernel.org>; Wed,  8 Jul 2026 03:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783481023; cv=none; b=ky/5f02TAOLeaKscfCMXlRyQh0UPYAQkY4RJbafhiPv4HZ3bSe8qJVs0pCOVEXd3PT1bu1jFRMnoA/X+a/KiM+5IZLmaWR7eUSh2JvM5T09bS7W+3ypRg7jEHrNiMPFBAK/hvRHhuFw0nj/GRDgS+a5yLwSQC9aO/D9nq+23pnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783481023; c=relaxed/simple;
	bh=tQhwmAsk5N+nCMWHjyrLxmd8wkCMved6wVrHqgEZBiY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZIocH5YQMFvjA3JhA1MDbE7UA4KwkbwCdB889qaCVJ91CPSq9zQu3GtZ1tREoW1oeNJ2q+ToK/k2j1/kK5hArN9sA5CRVo4qp/VWwdbOutt3y6sTCJ2Xhh7yTI1UPb4cezoE7YK70tZGyYn8XWRMfHyrXiIo3a9KWFl6g5MMP8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 66918dc27a7c11f1aa26b74ffac11d73-20260708
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP
	SRC_LOWREP, DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:44425524-bbda-475c-9c4d-0dbe99be82ae,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:44425524-bbda-475c-9c4d-0dbe99be82ae,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:53ca383b3ed78d8357d5e14de41bedfc,BulkI
	D:2607081123351K1UGUEE,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|102|127|
	136|850|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,
	Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BR
	R:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 66918dc27a7c11f1aa26b74ffac11d73-20260708
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(123.53.36.53)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 349499363; Wed, 08 Jul 2026 11:23:34 +0800
From: liuh <liuhuan01@kylinos.cn>
To: djwong@kernel.org,
	aalbersh@redhat.com
Cc: linux-xfs@vger.kernel.org,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH v5] mkfs: simplify setup_proto file status checks
Date: Wed,  8 Jul 2026 11:23:02 +0800
Message-ID: <20260708032301.11458-2-liuhuan01@kylinos.cn>
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
 mkfs/proto.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index a460aebd..ff867afe 100644
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
+		fprintf(stderr, _("%s: failed to fstat %s: %s\n"),
+			progname, fname, strerror(errno));
+		goto out_fail;
+	}
 
 	/*
 	 * Handle directory inputs.
@@ -101,6 +104,20 @@ setup_proto(
 		return result;
 	}
 
+	if (!S_ISREG(statbuf.st_mode)) {
+		fprintf(stderr, _("%s: %s not a regular file\n"),
+			progname, fname);
+		goto out_fail;
+	}
+
+	if (statbuf.st_size < 0) {
+		fprintf(stderr, _("%s: %s invalid file size\n"),
+			progname, fname);
+		goto out_fail;
+	}
+
+	size = statbuf.st_size;
+
 	/*
 	 * Else this is a protofile, let's handle traditionally.
 	 */
-- 
2.43.0

