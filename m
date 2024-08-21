Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DBE158D8F
	for <linux-xfs@vger.kernel.org>; Wed, 21 Aug 2024 10:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724237072; cv=none; b=o7cPYCyLdxGzqiRQWrLz4I6QZJXYmYzFYsEJfAep0PXe7NB5UmHj0AgQqJBP/2HPqlotm7vK4mTlTHXA+yEXQ7Iw/sXWA/JjYOBc6YyY+/uDH2O9usKWMW5PAY7MUB24T5GdltCgS91niN1rVRcfK9ypWvIfTPMUxuLUGEILp78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724237072; c=relaxed/simple;
	bh=9d+1bz8hJjGwmIydu24yoy2B5pKBRVcV+U4lU++cFng=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IITzC0mKGoGpxiKrzF0H1nfxPTJi6abr3TyW2/yKButGM+aJqRQZlOynnbn61j+8TH0kxN4L55e+3RVe2I3ohJwtwjZazLH8zLfqomciTeoP2QMockrgVG5PyFr406vE2tXPg5pgJU9xPchq8nbQugNL2xWQ7h04pNrC5R/S7bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 509fb7265faa11efa216b1d71e6e1362-20240821
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, DN_TRUSTED
	SRC_TRUSTED, SA_UNTRUSTED, SA_LOWREP, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, OB_FP, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, AMN_C_TI, AMN_C_BU, ABX_GENE_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:1b8da95b-683b-4711-8d63-3a7533b947d5,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.1.38,REQID:1b8da95b-683b-4711-8d63-3a7533b947d5,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:82c5f88,CLOUDID:0566353a1978007b804ef3e34beb29cb,BulkI
	D:2408211840348MD1MCJO,BulkQuantity:2,Recheck:0,SF:66|23|17|19|43|74|102,T
	C:nil,Content:0,EDM:5,IP:-2,URL:11|1,File:nil,RT:nil,Bulk:41,QS:nil,BEC:ni
	l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULN
X-UUID: 509fb7265faa11efa216b1d71e6e1362-20240821
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(1.198.31.154)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1397448813; Wed, 21 Aug 2024 18:44:17 +0800
From: liuhuan01@kylinos.cn
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	cmaiolino@redhat.com,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH] xfs_db: make sure agblocks is valid to prevent corruption
Date: Wed, 21 Aug 2024 18:44:12 +0800
Message-Id: <20240821104412.8539-1-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: liuh <liuhuan01@kylinos.cn>

Recently, I was testing xfstests. When I run xfs/350 case, it always generate coredump during the process.
	xfs_db -c "sb 0" -c "p agblocks" /dev/loop1

System will generate signal SIGFPE corrupt the process. And the stack as follow:
corrupt at: (*bpp)->b_pag = xfs_perag_get(btp->bt_mount, xfs_daddr_to_agno(btp->bt_mount, blkno)); in function libxfs_getbuf_flags
	#0  libxfs_getbuf_flags
	#1  libxfs_getbuf_flags
	#2  libxfs_buf_read_map
	#3  libxfs_buf_read
	#4  libxfs_mount
	#5  init
	#6  main

The coredump was caused by the corrupt superblock metadata: (mp)->m_sb.sb_agblocks, it was 0.
In this case, user cannot run in expert mode also.

Never check (mp)->m_sb.sb_agblocks before use it cause this issue.
Make sure (mp)->m_sb.sb_agblocks > 0 before libxfs_mount to prevent corruption and leave a message.

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 db/init.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/db/init.c b/db/init.c
index cea25ae5..2d3295ba 100644
--- a/db/init.c
+++ b/db/init.c
@@ -129,6 +129,13 @@ init(
 		}
 	}
 
+	if (unlikely(sbp->sb_agblocks == 0)) {
+		fprintf(stderr,
+			_("%s: device %s agblocks unexpected\n"),
+			progname, x.data.name);
+		exit(1);
+	}
+
 	agcount = sbp->sb_agcount;
 	mp = libxfs_mount(&xmount, sbp, &x, LIBXFS_MOUNT_DEBUGGER);
 	if (!mp) {
-- 
2.43.0

