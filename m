Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ABF17FE
	for <linux-xfs@vger.kernel.org>; Tue, 20 Aug 2024 02:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724120313; cv=none; b=IgiXgK/GTcKyG1Gn9GLSW1G40RM+4myKJirxNfWo3ZVyHh6TEl4rQ4JUzzbiICxFIY6D8R4fp/G2G+qn50cQWIEy92nccAczzMIn3bY+iBtbbSOiqn2ZdU9r5aJEaFMlgJU62Z1pEJXn77LwK30m6Fkp+sZJQ5nM5wWQq/Wuk6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724120313; c=relaxed/simple;
	bh=eUMwp3S5xbJCsKqKjaUNUaa3EJkE5dBm6njaBEkBLTU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=mHIRh5MjIwTP5UxkacYeZmJv0ZNvjLmKmtECrqsfQ0dbgMdeRDj6GUoVYHCUPiVs4mE1Z1ulMgY1tzq9oZaWPjDr7BK0LLxcpAFwS36zhkb6g9IVX2fh+T8BdE01y2hGa/l/meD0pbVpX3Jj9NXJUJ19Gc0pkJP5z+U+hmkaj6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 7ca653205e9711efa216b1d71e6e1362-20240820
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR, DN_TRUSTED
	SRC_TRUSTED, SA_UNTRUSTED, SA_LOWREP, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN
	GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD
	AMN_C_TI, AMN_C_BU, ABX_GENE_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:082a3338-cd7b-4ad8-abfb-2526b68c497b,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:30
X-CID-INFO: VERSION:1.1.38,REQID:082a3338-cd7b-4ad8-abfb-2526b68c497b,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:30
X-CID-META: VersionHash:82c5f88,CLOUDID:487b9cadfd5ca818dd537906069868c1,BulkI
	D:240820094828Z09OTTML,BulkQuantity:1,Recheck:0,SF:43|74|66|23|17|19|102,T
	C:nil,Content:0,EDM:5,IP:-2,URL:11|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:ni
	l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-UUID: 7ca653205e9711efa216b1d71e6e1362-20240820
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(1.198.31.154)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 402167868; Tue, 20 Aug 2024 09:56:59 +0800
From: liuhuan01@kylinos.cn
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	cmaiolino@redhat.com,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH] xfs_db: do some checks in init to prevent corruption
Date: Tue, 20 Aug 2024 09:56:54 +0800
Message-Id: <20240820015654.17418-1-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: liuh <liuhuan01@kylinos.cn>

Recently, I was testing xfstests. When I run xfs/350 case, it always generate coredumps during the process.
Total two types of coredump:
	(a) xfs_db -c "sb 0" -c "print sectlog" /dev/loop1
	(b) xfs_db -c "sb 0" -c "print agblock" /dev/loop1

For coredump (a) system will generate signal SIGSEGV corrupt the process. And the stack as follow:
corrupt at: q = *++b; in function crc32_body
	#0  crc32_body
	#1  crc32_le_generic
	#2  crc32c_le
	#3  xfs_start_cksum_safe
	#4  libxfs_verify_cksum
	#5  xfs_buf_verify_cksum
	#6  xfs_agf_read_verify
	#7  libxfs_readbuf_verify
	#8  libxfs_buf_read_map
	#9  libxfs_trans_read_buf_map
	#10 libxfs_trans_read_buf
	#11 libxfs_read_agf
	#12 libxfs_alloc_read_agf
	#13 libxfs_initialize_perag_data
	#14 init
	#15 main

For coredump (b) system will generate signal SIGFPE corrupt the process. And the stack as follow:
corrupt at: (*bpp)->b_pag = xfs_perag_get(btp->bt_mount, xfs_daddr_to_agno(btp->bt_mount, blkno)); in function libxfs_getbuf_flags
	#0  libxfs_getbuf_flags
	#1  libxfs_getbuf_flags
	#2  libxfs_buf_read_map
	#3  libxfs_buf_read
	#4  libxfs_mount
	#5  init
	#6  main

Analyze the above two issues separately:
	coredump (a) was caused by the corrupt superblock metadata: (mp)->m_sb.sb_sectlog, it was 128;
	coredump (b) was caused by the corrupt superblock metadata: (mp)->m_sb.sb_agblocks, it was 0;

Current, xfs_db doesn't validate the superblock, it goes to corruption if superblock is damaged, theoretically.

So do some check in xfs_db init function to prevent corruption and leave some hints.

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 db/init.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/db/init.c b/db/init.c
index cea25ae5..4402f85f 100644
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
@@ -140,6 +147,13 @@ init(
 	mp->m_log = &xlog;
 	blkbb = 1 << mp->m_blkbb_log;
 
+	if (unlikely(sbp->sb_sectlog < XFS_MIN_SECTORSIZE_LOG || sbp->sb_sectlog > XFS_MAX_SECTORSIZE_LOG)) {
+		fprintf(stderr,
+			_("%s: device %s sectlog(%u) unexpected\n"),
+			progname, x.data.name, sbp->sb_sectlog);
+		exit(1);
+	}
+
 	/* Did we limit a broken agcount in libxfs_mount? */
 	if (sbp->sb_agcount != agcount)
 		exitcode = 1;
-- 
2.43.0

