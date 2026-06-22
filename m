Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164A313959D
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2026 02:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782096220; cv=none; b=THBU+oo8G976GQjOE5Vt9oYTNTBEVXq6EkMkSGJ/ZMN7yMBAYnej4xLhyRS20K9MpKiYy26W+xo1ZRTcBKvhYCM5rWzLMf2bw1nAPOHP2xOud0XGuNdcEHvcuJAD5dMwFkTH7Chm/ySbuwH0h0a1JCH2QSbpecFAS1QI+hdCiLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782096220; c=relaxed/simple;
	bh=Sf6jFPf+jIlKzNjS0TCPyi0TnWep2SPbrGG/FWYTX/k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BEFu7Fx7+vzieKI7x3iTlDHxae2of6yO/NAB1C/L4zUz2og3afn4habNekb3fSfXC5ePRJOjt8SMXQ/BcUtsj5bMYgcQIpGQKnDUFWASCCuOWRSZFp1eqVxWzBWsDQpMZ9Gx8v6Y6iuCQl1/fNs592ECqsB89ghqDrlrMMBn/B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 28b0c5126de411f1aa26b74ffac11d73-20260622
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
X-CID-O-INFO: VERSION:1.3.12,REQID:020127b3-8d81-4bfa-a833-36e60726669b,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:020127b3-8d81-4bfa-a833-36e60726669b,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:1771a7f5d7da2474cbd570bce1d8b024,BulkI
	D:260622101811XVBERNKZ,BulkQuantity:5,Recheck:0,SF:17|19|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:40,
	QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
	,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 28b0c5126de411f1aa26b74ffac11d73-20260622
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(123.149.0.228)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1172038268; Mon, 22 Jun 2026 10:43:32 +0800
From: liuh <liuhuan01@kylinos.cn>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH] mkfs: remove duplicate include of convert.h
Date: Mon, 22 Jun 2026 10:43:11 +0800
Message-ID: <20260622024311.26681-1-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The header file "libfrog/convert.h" is included twice in xfs_mkfs.c.
Clean it up by removing the redundant second inclusion.

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 mkfs/xfs_mkfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index dd8a48c3..64e8a6a6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -15,7 +15,6 @@
 #include "libfrog/dahashselftest.h"
 #include "libfrog/fsproperties.h"
 #include "libfrog/zones.h"
-#include "libfrog/convert.h"
 #include "proto.h"
 #include <ini.h>
 
-- 
2.43.0

