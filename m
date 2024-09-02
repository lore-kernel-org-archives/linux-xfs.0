Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA1313E04C
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 10:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725271995; cv=none; b=ReoG7djd+VHRfkGN6PSHAIm3KEORhPaji6tjRiwgfRdPn02kLgymByZ9MvZnnQUBAlrHprGiOrVFgdSTuj9K6Ew7+nYFOqC6hYH3sxxw9lmg7dpn+Aci2VmxPwE3Ds/2WHQIVIy74OvT36aX1Xn6kX9pIFhmifsDMQmXDypm3bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725271995; c=relaxed/simple;
	bh=6+0MS+5X5xgHjBraIrYEZdmHy4nXfXMIuGtXViJjLQc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rebSlcMMS3mkF0jhowfPa5/gVL7g/5s6S4emSMVlzMJ6U3XHnY2s5aisI0uxk4Bx1mSLH1RBB8YSkjomDNfXFC1oQW5KHs3iPvtuQPPDFV0BhN/teua6OKQcAzGsQuTtHlZ0xfmMZhTwiq12cXdBO6Qe9BQjlTl+GEgYwOL0T2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: f13586c6691311efa216b1d71e6e1362-20240902
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_DIGIT_LEN
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	DN_TRUSTED, SRC_TRUSTED, SA_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, CIE_UNKNOWN, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_T1, AMN_GOOD, AMN_C_TI
	AMN_C_BU, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:95bc8f37-eeda-44d9-9623-ad45350439a1,IP:10,
	URL:0,TC:0,Content:-25,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,A
	CTION:release,TS:-45
X-CID-INFO: VERSION:1.1.38,REQID:95bc8f37-eeda-44d9-9623-ad45350439a1,IP:10,UR
	L:0,TC:0,Content:-25,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:EDM_GE969F26,AC
	TION:release,TS:-45
X-CID-META: VersionHash:82c5f88,CLOUDID:38c4438324127fc6daa6b50667568060,BulkI
	D:240902180023VPTGU3ZR,BulkQuantity:1,Recheck:0,SF:66|25|17|19|43|74|102,T
	C:nil,Content:0,EDM:1,IP:-2,URL:11|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:ni
	l,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,
	TF_CID_SPAM_ULN
X-UUID: f13586c6691311efa216b1d71e6e1362-20240902
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(123.53.36.118)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 775084852; Mon, 02 Sep 2024 18:13:04 +0800
From: liuhuan01@kylinos.cn
To: david@fromorbit.com
Cc: cmaiolino@redhat.com,
	djwong@kernel.org,
	linux-xfs@vger.kernel.org,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH v2] xfs_db: make sure agblocks is valid to prevent corruption
Date: Mon,  2 Sep 2024 18:12:39 +0800
Message-Id: <20240902101238.12895-1-liuhuan01@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <Zs5jMo1Vzg9gxA/J@dread.disaster.area>
References: <Zs5jMo1Vzg9gxA/J@dread.disaster.area>
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

So, try to get agblocks from agf/agi 0, if failed use the default geometry to calc agblocks.
The worst thing is cannot get agblocks accroding above method, then set it to 1.

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 db/Makefile |   2 +-
 db/init.c   | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/db/Makefile b/db/Makefile
index 83389376..322d5617 100644
--- a/db/Makefile
+++ b/db/Makefile
@@ -68,7 +68,7 @@ CFILES = $(HFILES:.h=.c) \
 LSRCFILES = xfs_admin.sh xfs_ncheck.sh xfs_metadump.sh
 
 LLDLIBS	= $(LIBXFS) $(LIBXLOG) $(LIBFROG) $(LIBUUID) $(LIBRT) $(LIBURCU) \
-	  $(LIBPTHREAD)
+	  $(LIBPTHREAD) $(LIBBLKID)
 LTDEPENDENCIES = $(LIBXFS) $(LIBXLOG) $(LIBFROG)
 LLDFLAGS += -static-libtool-libs
 
diff --git a/db/init.c b/db/init.c
index cea25ae5..15124ee2 100644
--- a/db/init.c
+++ b/db/init.c
@@ -38,6 +38,121 @@ usage(void)
 	exit(1);
 }
 
+static void
+xfs_guess_default_ag_geometry(uint64_t *agsize, uint64_t *agcount, struct libxfs_init *x)
+{
+	struct fs_topology	ft;
+	int			blocklog;
+	uint64_t		dblocks;
+	int			multidisk;
+
+	memset(&ft, 0, sizeof(ft));
+	get_topology(x, &ft, 1);
+
+	/*
+	 * get geometry from get_topology result.
+	 * Use default block size (2^12)
+	 */
+	blocklog = 12;
+	multidisk = ft.data.swidth | ft.data.sunit;
+	dblocks = x->data.size >> (blocklog - BBSHIFT);
+	calc_default_ag_geometry(blocklog, dblocks, multidisk,
+				 agsize, agcount);
+}
+
+static xfs_agblock_t
+xfs_get_agblock_from_agf(struct xfs_mount *mp)
+{
+	xfs_agblock_t agblocks = 0;
+	int error;
+	struct xfs_buf *bp;
+	struct xfs_agf *agf;
+
+	error = -libxfs_buf_read_uncached(mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, 0, XFS_AGF_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error) {
+		fprintf(stderr, "xfs_get_agblock from agf-0 error %d\n", error);
+		return agblocks;
+	}
+
+	if (xfs_has_crc(mp) && !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF)) {
+		fprintf(stderr, "xfs_get_agblock from agf-0 badcrc\n");
+		return agblocks;
+	}
+
+	agf = bp->b_addr;
+	agblocks = be32_to_cpu(agf->agf_length);
+
+	libxfs_buf_relse(bp);
+
+	return agblocks;
+}
+
+static xfs_agblock_t
+xfs_get_agblock_from_agi(struct xfs_mount *mp)
+{
+	xfs_agblock_t agblocks = 0;
+	int error;
+	struct xfs_buf *bp;
+	struct xfs_agi *agi;
+
+	error = -libxfs_buf_read_uncached(mp->m_ddev_targp,
+			XFS_AG_DADDR(mp, 0, XFS_AGI_DADDR(mp)),
+			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error) {
+		fprintf(stderr, "xfs_get_agblock from agi-0 error %d\n", error);
+		return agblocks;
+	}
+
+	if (xfs_has_crc(mp) && !xfs_buf_verify_cksum(bp, XFS_AGI_CRC_OFF)) {
+		fprintf(stderr, "xfs_get_agblock from agi-0 badcrc\n");
+		return agblocks;
+	}
+
+	agi = bp->b_addr;
+	agblocks = be32_to_cpu(agi->agi_length);
+
+	libxfs_buf_relse(bp);
+
+	return agblocks;
+}
+
+/*
+ * If sb_agblocks was damaged, try to read it from agf/agi 0.
+ * With read agf/agi fails use default geometry to calc agblocks/agcount.
+ * The worst thing is cannot get agblocks according above method, then set to 1.
+ */
+static xfs_agblock_t
+xfs_try_get_agblocks(struct xfs_mount *mp, struct libxfs_init *x)
+{
+	xfs_agblock_t agblocks;
+	uint64_t agsize, agcount;
+
+	/* firset try to get agblocks from agf-0 */
+	agblocks = xfs_get_agblock_from_agf(mp);
+	if (XFS_FSB_TO_B(mp, agblocks) >= XFS_MIN_AG_BYTES &&
+		XFS_FSB_TO_B(mp, agblocks) <= XFS_MAX_AG_BYTES)
+		return agblocks;
+
+	/* second try to get agblocks from agi-0 */
+	agblocks = xfs_get_agblock_from_agi(mp);
+	if (XFS_FSB_TO_B(mp, agblocks) >= XFS_MIN_AG_BYTES &&
+		XFS_FSB_TO_B(mp, agblocks) <= XFS_MAX_AG_BYTES)
+		return agblocks;
+
+	/* third use default geometry to calc agblocks/agcount */
+	xfs_guess_default_ag_geometry(&agsize, &agcount, x);
+
+	if (XFS_FSB_TO_B(mp, agsize) < XFS_MIN_AG_BYTES ||
+		XFS_FSB_TO_B(mp, agsize) > XFS_MAX_AG_BYTES)
+		agblocks = 1; /* the worst is set to 1 */
+	else
+		agblocks = agsize;
+
+	return agblocks;
+}
+
 static void
 init(
 	int		argc,
@@ -129,6 +244,19 @@ init(
 		}
 	}
 
+	/* If sb_agblocks was damaged, try to get agblocks */
+	if (XFS_FSB_TO_B(&xmount, sbp->sb_agblocks) < XFS_MIN_AG_BYTES ||
+		XFS_FSB_TO_B(&xmount, sbp->sb_agblocks) > XFS_MAX_AG_BYTES) {
+		xfs_agblock_t agblocks;
+		xfs_agblock_t bad_agblocks = sbp->sb_agblocks;
+
+		agblocks = xfs_try_get_agblocks(&xmount, &x);
+		sbp->sb_agblocks = agblocks;
+
+		fprintf(stderr, "wrong agblocks, try to get from agblocks %u -> %u\n",
+			bad_agblocks, sbp->sb_agblocks);
+	}
+
 	agcount = sbp->sb_agcount;
 	mp = libxfs_mount(&xmount, sbp, &x, LIBXFS_MOUNT_DEBUGGER);
 	if (!mp) {
-- 
2.43.0

