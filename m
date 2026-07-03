Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFAE33E344
	for <linux-xfs@vger.kernel.org>; Fri,  3 Jul 2026 08:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783068041; cv=none; b=knbIoS7iNcFuIay2ZOZc2wuEVstd+BMYAPOA6kdu+US6gbSEt1n7Y673yKccuE7uaAM+4ECu65bXCQ5k9A1bSVvOC08qvOWULI1k5CaPJW5wXWfhxqCzgFPtSh7WvlGuyzyRRGZPZUBG29RO2K9BOk6OEg2Pbc958lAikEuMHxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783068041; c=relaxed/simple;
	bh=7qd55gn1nLWYLSvHmXQQouDyNlA8GEcelqQZ3ZsbdgI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pzIcrxOzYuEdCDLMV2EnEd40MkCkBsRVfuXM1ZlPoYMn0LoUxROTcFZT5eQBuO50hGmRhvoddoZ/XcsjEJ+3kpLLoADLWQVPCmJHven7gtQW2p2M1r+hyzUPoZ2zAUaHQsyG7OnqcACmyugWkC3zLVjPASAyAJD0Ry1ZTwKoAcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: dae5d04076ba11f1aa26b74ffac11d73-20260703
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_FROM_NAME, HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER
	HR_SJ_NOR_SYM, HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT
	HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME, DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO
	GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6b1a6a08-1afe-4fed-90f1-d1860e2782eb,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:6b1a6a08-1afe-4fed-90f1-d1860e2782eb,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:d993bd8d6f3fedb6e879f7f564cbcb13,BulkI
	D:260703162122A71RF10N,BulkQuantity:2,Recheck:0,SF:17|19|66|78|102|127|136
	|850|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk
	:40,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: dae5d04076ba11f1aa26b74ffac11d73-20260703
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(1.193.56.173)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1531251693; Fri, 03 Jul 2026 16:40:33 +0800
From: liuh <liuhuan01@kylinos.cn>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH v4] mkfs: simplify setup_proto file status checks
Date: Fri,  3 Jul 2026 16:40:05 +0800
Message-ID: <20260703084004.9811-2-liuhuan01@kylinos.cn>
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
 mkfs/proto.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mkfs/proto.c b/mkfs/proto.c
index a460aebd..5f7a9b15 100644
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
@@ -101,6 +104,14 @@ setup_proto(
 		return result;
 	}
 
+	if (!S_ISREG(statbuf.st_mode)) {
+		fprintf(stderr, _("%s: %s not a regular file\n"),
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

