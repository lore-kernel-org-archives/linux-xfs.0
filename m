Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CFF13B5A1
	for <linux-xfs@vger.kernel.org>; Sun, 29 Sep 2024 08:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727600024; cv=none; b=SHKqRkNUsC1w4a9NG68lwWLucY+mqDxriD/8QWarr4lR8NIeQm8/oSrqPcVhPp14goG4wA36QPF5gyOORCAEOlw5dj+U0d3pP+G4ATHVqoouL1rSeNSAxBiuiaGlEG5iiik4LBC9vFMszEuqs72nwBfBlsdSJs8BnCUvZXzP3Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727600024; c=relaxed/simple;
	bh=mb1TOBgmlxTkJzJ5Z8fXjyRYBfU1Zp6jOth2uaJFfBc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WSvU7VTX7Ilgrzx9zNnm4WuOcQFiE2oNefHyKRtjAwRZvFSm/3kOPQYvKk19Kq6fuAFe1tLnwJXR8AH+oQIhWm/ceSpFzVoGDRznaATBIF5CXEFnRqf1cUA4q5oGOUQ66I19zRH9y6bgOId7nh67fdqpKhsCXWPOS4oggGveNqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 4e5304dc7e4011efa216b1d71e6e1362-20240929
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
X-CID-O-INFO: VERSION:1.1.38,REQID:a1873692-1cab-4d11-90dd-6781657c63a3,IP:20,
	URL:0,TC:0,Content:-5,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,AC
	TION:release,TS:-15
X-CID-INFO: VERSION:1.1.38,REQID:a1873692-1cab-4d11-90dd-6781657c63a3,IP:20,UR
	L:0,TC:0,Content:-5,EDM:-25,RT:0,SF:-5,FILE:0,BULK:0,RULE:EDM_GE969F26,ACT
	ION:release,TS:-15
X-CID-META: VersionHash:82c5f88,CLOUDID:9f26f61a18d8ab6964f1d72f88df218d,BulkI
	D:2409291648241PIMWRBG,BulkQuantity:1,Recheck:0,SF:19|45|66|25|17|102,TC:n
	il,Content:0,EDM:1,IP:-2,URL:11|1,File:nil,RT:nil,Bulk:40,QS:nil,BEC:nil,C
	OL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI,TF_CID_SPAM_ULN,
	TF_CID_SPAM_SNR
X-UUID: 4e5304dc7e4011efa216b1d71e6e1362-20240929
X-User: liuhuan01@kylinos.cn
Received: from localhost.localdomain [(123.149.251.210)] by mailgw.kylinos.cn
	(envelope-from <liuhuan01@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1239341808; Sun, 29 Sep 2024 16:53:32 +0800
From: liuhuan01@kylinos.cn
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	cmaiolino@redhat.com,
	david@fromorbit.com,
	liuh <liuhuan01@kylinos.cn>
Subject: [PATCH v3] xfs_db: make sure agblocks is valid to prevent corruption
Date: Sun, 29 Sep 2024 16:53:18 +0800
Message-Id: <20240929085317.31545-1-liuhuan01@kylinos.cn>
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

So, try to get agblocks from agf/agi 0, if agf/agi 0 length match, use it as agblocks.
If failed use the default geometry to calc agblocks.

Signed-off-by: liuh <liuhuan01@kylinos.cn>
---
 db/Makefile |   2 +-
 db/init.c   | 142 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 143 insertions(+), 1 deletion(-)

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
index cea25ae5..167bc777 100644
--- a/db/init.c
+++ b/db/init.c
@@ -38,6 +38,138 @@ usage(void)
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
+	fprintf(stderr, "Attempting to guess AG length from device geometry. This may not work.\n");
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
+
+	if (*agsize >= XFS_MIN_AG_BLOCKS && *agsize <= XFS_MAX_AG_BLOCKS)
+		fprintf(stderr, "Guessed AG length is %lu blocks.\n", *agsize);
+}
+
+static xfs_agblock_t
+xfs_get_agblock_from_agf(struct xfs_mount *mp)
+{
+	xfs_agblock_t agblocks = NULLAGBLOCK;
+	int error;
+	struct xfs_buf *bp;
+	struct xfs_agf *agf;
+
+	error = -libxfs_buf_read_uncached(mp->m_ddev_targp,
+			XFS_AGF_DADDR(mp), 1, 0, &bp, NULL);
+	if (error) {
+		fprintf(stderr, "AGF 0 length recovery failed\n");
+		return NULLAGBLOCK;
+	}
+
+	agf = bp->b_addr;
+	if (be32_to_cpu(agf->agf_magicnum) == XFS_AGF_MAGIC)
+		agblocks = be32_to_cpu(agf->agf_length);
+
+	libxfs_buf_relse(bp);
+
+	if (agblocks != NULLAGBLOCK)
+		fprintf(stderr, "AGF 0 length %u blocks found.\n", agblocks);
+	else
+		fprintf(stderr, "AGF 0 length recovery failed.\n");
+
+	return agblocks;
+}
+
+static xfs_agblock_t
+xfs_get_agblock_from_agi(struct xfs_mount *mp)
+{
+	xfs_agblock_t agblocks = NULLAGBLOCK;
+	int error;
+	struct xfs_buf *bp;
+	struct xfs_agi *agi;
+
+	error = -libxfs_buf_read_uncached(mp->m_ddev_targp,
+			XFS_AGI_DADDR(mp), 1, 0, &bp, NULL);
+	if (error) {
+		fprintf(stderr, "AGI 0 length recovery failed\n");
+		return NULLAGBLOCK;
+	}
+
+
+	agi = bp->b_addr;
+	if (be32_to_cpu(agi->agi_magicnum) == XFS_AGI_MAGIC)
+		agblocks = be32_to_cpu(agi->agi_length);
+
+	libxfs_buf_relse(bp);
+
+	if (agblocks != NULLAGBLOCK)
+		fprintf(stderr, "AGI 0 length %u blocks found.\n", agblocks);
+	else
+		fprintf(stderr, "AGI 0 length recovery failed.\n");
+
+	return agblocks;
+}
+
+/*
+ * Try to get it from agf/agi length when primary superblock agblocks damaged.
+ * If agf matchs agi length, use it as agblocks, otherwise use the default geometry
+ * to calc agblocks
+ */
+static xfs_agblock_t
+xfs_try_get_agblocks(struct xfs_mount *mp, struct libxfs_init *x)
+{
+	xfs_agblock_t agblocks = NULLAGBLOCK;
+	xfs_agblock_t agblocks_agf, agblocks_agi;
+	uint64_t agsize, agcount;
+
+	fprintf(stderr, "Attempting recovery from AGF/AGI 0 metadata...\n");
+
+	agblocks_agf = xfs_get_agblock_from_agf(mp);
+	agblocks_agi = xfs_get_agblock_from_agi(mp);
+
+	if (agblocks_agf == agblocks_agi && agblocks_agf >= XFS_MIN_AG_BLOCKS && agblocks_agf <= XFS_MAX_AG_BLOCKS) {
+		fprintf(stderr, "AGF/AGI 0 length matches.\n");
+		fprintf(stderr, "Using %u blocks for superblock agblocks\n", agblocks_agf);
+		return agblocks_agf;
+	}
+
+	/* use default geometry to calc agblocks/agcount */
+	xfs_guess_default_ag_geometry(&agsize, &agcount, x);
+
+	/* choose the agblocks among agf/agi length and agsize */
+	if (agblocks_agf == agsize && agsize >= XFS_MIN_AG_BLOCKS && agsize <= XFS_MAX_AG_BLOCKS) {
+		fprintf(stderr, "Guessed AG matchs AGF length\n");
+		agblocks = agsize;
+	} else if (agblocks_agi == agsize && agsize >= XFS_MIN_AG_BLOCKS && agsize <= XFS_MAX_AG_BLOCKS) {
+		fprintf(stderr, "Guessed AG matchs AGI length\n");
+		agblocks = agsize;
+	} else if (agsize >= XFS_MIN_AG_BLOCKS && agsize <= XFS_MAX_AG_BLOCKS) {
+		fprintf(stderr, "Guessed AG does not match AGF/AGI 0 length.\n");
+		agblocks =  agsize;
+	} else {
+		fprintf(stderr, "_(%s: device too small to hold a valid XFS filesystem)", progname);
+		exit(1);
+	}
+
+	fprintf(stderr, "Using %u blocks for superblock agblocks.\n", agblocks);
+
+	return agblocks;
+}
+
 static void
 init(
 	int		argc,
@@ -129,6 +261,16 @@ init(
 		}
 	}
 
+	/* If sb_agblocks was damaged, try to get agblocks */
+	if (sbp->sb_agblocks < XFS_MIN_AG_BLOCKS || sbp->sb_agblocks > XFS_MAX_AG_BLOCKS) {
+		xfs_agblock_t agblocks;
+
+		fprintf(stderr, "Out of bounds superblock agblocks (%u) found.\n", sbp->sb_agblocks);
+
+		agblocks = xfs_try_get_agblocks(&xmount, &x);
+		sbp->sb_agblocks = agblocks;
+	}
+
 	agcount = sbp->sb_agcount;
 	mp = libxfs_mount(&xmount, sbp, &x, LIBXFS_MOUNT_DEBUGGER);
 	if (!mp) {
-- 
2.43.0

