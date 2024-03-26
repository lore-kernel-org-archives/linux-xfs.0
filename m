Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60289128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422154; cv=none; b=fn2IHN17abSLFje0UMURCRtPTUX17ky0oB8jlgtZBVS9fGzU95XTVAxSAIv08vZGUVLcxgM8IEblbcFFIT1gh5UkA1+zSeYuwevPY876rOqEXJdhPlR0ik2cHxcNfC/lca9np9VV45wJ8qQQBVTkG0qogg48PglbH218nPOBesg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422154; c=relaxed/simple;
	bh=da4jWn7T1UZ9gDbKEyV925pbFJ66uPhTW3i84zvt52E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=afYgdDX+IFrv6CczrxiSKCRifLWYOp2lRaR2xCKiRCvcoSGujExgiZVhl9hsgtbIA3hSVQ8LXCwX08+kaC7ffFR1fnQl94pUuqk/nhu6ueSqcVVVjUdJnOROolEtf9+xAZfOPZ2ymEisls/sqT7H6eXmwLMDuAZ2scJjmJbdwb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWsHimuL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWsHimuL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F495C433F1;
	Tue, 26 Mar 2024 03:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422154;
	bh=da4jWn7T1UZ9gDbKEyV925pbFJ66uPhTW3i84zvt52E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=EWsHimuLm5GelFkLBhgcQEWLV5+qQzehm6kF0xAT7PFaLcrL8dk7Zgxu7TRGKNJH4
	 l1kU/9EceqHmtxzjY/MYexVpMSSgdwWdDp27gpBncIOYiB3iMjfdk+i7VzF7yHRJ6m
	 3r7LbZO39zW1GBev8NkzCCapDmzuLr1zegoR76i0DbZodmRb/iG+XeXSDgg/D8lPvu
	 vAOX2RwQTjS4wJUUfIZAGjPGWMbIqBpuGBzLTZR2U1mcCYD+XWLeK0DV+qq7w5uQCU
	 t4SAuAcnDoad//54QDfkxdHl03vxqh2vxd95qeSzMpjKcDWiFt2GiMBGKP4eZmTohO
	 R6GW4HTOkPB+Q==
Date: Mon, 25 Mar 2024 20:02:33 -0700
Subject: [PATCH 12/13] xfs_{db,repair}: use accessor functions for summary
 info words
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126481.2211955.9218777140738482154.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
References: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Port xfs_db and xfs_repair to use get and set functions for rtsummary
words so that we can redefine the ondisk format with a specific
endianness.  Note that this requires the definition of a distinct type
for ondisk summary info words so that the compiler can perform proper
typechecking.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/check.c               |   58 +++++++++++++++++++++++++++++++++++-----------
 libxfs/libxfs_api_defs.h |    2 ++
 repair/globals.c         |    2 +-
 repair/globals.h         |    2 +-
 repair/phase6.c          |   14 +++++++++--
 repair/rt.c              |   19 ++++++++++++---
 repair/rt.h              |    2 +-
 7 files changed, 75 insertions(+), 24 deletions(-)


diff --git a/db/check.c b/db/check.c
index 6e916f335b14..103ea4022c3b 100644
--- a/db/check.c
+++ b/db/check.c
@@ -132,8 +132,8 @@ static unsigned		sbversion;
 static int		sbver_err;
 static int		serious_error;
 static int		sflag;
-static xfs_suminfo_t	*sumcompute;
-static xfs_suminfo_t	*sumfile;
+static union xfs_suminfo_raw *sumcompute;
+static union xfs_suminfo_raw *sumfile;
 static const char	*typename[] = {
 	"unknown",
 	"agf",
@@ -1704,12 +1704,20 @@ check_set_rdbmap(
 	}
 }
 
+static inline xfs_suminfo_t
+get_suminfo(
+	struct xfs_mount	*mp,
+	union xfs_suminfo_raw	*raw)
+{
+	return raw->old;
+}
+
 static void
 check_summary(void)
 {
 	xfs_rfsblock_t	bno;
-	xfs_suminfo_t	*csp;
-	xfs_suminfo_t	*fsp;
+	union xfs_suminfo_raw *csp;
+	union xfs_suminfo_raw *fsp;
 	int		log;
 
 	csp = sumcompute;
@@ -1718,12 +1726,14 @@ check_summary(void)
 		for (bno = 0;
 		     bno < mp->m_sb.sb_rbmblocks;
 		     bno++, csp++, fsp++) {
-			if (*csp != *fsp) {
+			if (csp->old != fsp->old) {
 				if (!sflag)
 					dbprintf(_("rt summary mismatch, size %d "
 						 "block %llu, file: %d, "
 						 "computed: %d\n"),
-						log, bno, *fsp, *csp);
+						log, bno,
+						get_suminfo(mp, fsp),
+						get_suminfo(mp, csp));
 				error++;
 			}
 		}
@@ -1950,8 +1960,8 @@ init(
 		inomap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**inomap));
 		words = libxfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
 				mp->m_sb.sb_rbmblocks);
-		sumfile = xcalloc(words, sizeof(xfs_suminfo_t));
-		sumcompute = xcalloc(words, sizeof(xfs_suminfo_t));
+		sumfile = xcalloc(words, sizeof(union xfs_suminfo_raw));
+		sumcompute = xcalloc(words, sizeof(union xfs_suminfo_raw));
 	}
 	nflag = sflag = tflag = verbose = optind = 0;
 	while ((c = getopt(argc, argv, "b:i:npstv")) != EOF) {
@@ -3590,6 +3600,17 @@ process_quota(
 	}
 }
 
+static inline void
+inc_sumcount(
+	struct xfs_mount	*mp,
+	union xfs_suminfo_raw	*info,
+	xfs_rtsumoff_t		index)
+{
+	union xfs_suminfo_raw	*p = info + index;
+
+	p->old++;
+}
+
 static void
 process_rtbitmap(
 	blkmap_t	*blkmap)
@@ -3669,7 +3690,7 @@ process_rtbitmap(
 					bitsperblock + (bit - start_bit);
 				log = XFS_RTBLOCKLOG(len);
 				offs = xfs_rtsumoffs(mp, log, start_bmbno);
-				sumcompute[offs]++;
+				inc_sumcount(mp, sumcompute, offs);
 				prevbit = 0;
 			}
 		}
@@ -3682,7 +3703,7 @@ process_rtbitmap(
 			(bit - start_bit);
 		log = XFS_RTBLOCKLOG(len);
 		offs = xfs_rtsumoffs(mp, log, start_bmbno);
-		sumcompute[offs]++;
+		inc_sumcount(mp, sumcompute, offs);
 	}
 	free(words);
 }
@@ -3692,12 +3713,17 @@ process_rtsummary(
 	blkmap_t	*blkmap)
 {
 	xfs_fsblock_t	bno;
-	char		*bytes;
+	union xfs_suminfo_raw *sfile = sumfile;
 	xfs_fileoff_t	sumbno;
 	int		t;
 
 	sumbno = NULLFILEOFF;
 	while ((sumbno = blkmap_next_off(blkmap, sumbno, &t)) != NULLFILEOFF) {
+		struct xfs_rtalloc_args	args = {
+			.mp		= mp,
+		};
+		union xfs_suminfo_raw	*ondisk;
+
 		bno = blkmap_get(blkmap, sumbno);
 		if (bno == NULLFSBLOCK) {
 			if (!sflag)
@@ -3710,18 +3736,22 @@ process_rtsummary(
 		push_cur();
 		set_cur(&typtab[TYP_RTSUMMARY], XFS_FSB_TO_DADDR(mp, bno),
 			blkbb, DB_RING_IGN, NULL);
-		if ((bytes = iocur_top->data) == NULL) {
+		if (!iocur_top->bp) {
 			if (!sflag)
 				dbprintf(_("can't read block %lld for rtsummary "
 					 "inode\n"),
 					(xfs_fileoff_t)sumbno);
 			error++;
 			pop_cur();
+			sfile += mp->m_blockwsize;
 			continue;
 		}
-		memcpy((char *)sumfile + sumbno * mp->m_sb.sb_blocksize, bytes,
-			mp->m_sb.sb_blocksize);
+
+		args.sumbp = iocur_top->bp;
+		ondisk = xfs_rsumblock_infoptr(&args, 0);
+		memcpy(sfile, ondisk, mp->m_sb.sb_blocksize);
 		pop_cur();
+		sfile += mp->m_blockwsize;
 	}
 }
 
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e87195cb1ac9..cee0df2479c5 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -179,6 +179,8 @@
 #define xfs_rtbitmap_setword		libxfs_rtbitmap_setword
 #define xfs_rtbitmap_wordcount		libxfs_rtbitmap_wordcount
 
+#define xfs_suminfo_add			libxfs_suminfo_add
+#define xfs_suminfo_get			libxfs_suminfo_get
 #define xfs_rtsummary_wordcount		libxfs_rtsummary_wordcount
 
 #define xfs_rtfree_extent		libxfs_rtfree_extent
diff --git a/repair/globals.c b/repair/globals.c
index 73ae9de075de..a68929bdc012 100644
--- a/repair/globals.c
+++ b/repair/globals.c
@@ -87,7 +87,7 @@ int64_t		fs_max_file_offset;
 /* realtime info */
 
 union xfs_rtword_raw	*btmcompute;
-xfs_suminfo_t	*sumcompute;
+union xfs_suminfo_raw	*sumcompute;
 
 /* inode tree records have full or partial backptr fields ? */
 
diff --git a/repair/globals.h b/repair/globals.h
index 311cf72189f3..a67e384a626e 100644
--- a/repair/globals.h
+++ b/repair/globals.h
@@ -128,7 +128,7 @@ extern int64_t		fs_max_file_offset;
 /* realtime info */
 
 extern union xfs_rtword_raw		*btmcompute;
-extern xfs_suminfo_t	*sumcompute;
+extern union xfs_suminfo_raw		*sumcompute;
 
 /* inode tree records have full or partial backptr fields ? */
 
diff --git a/repair/phase6.c b/repair/phase6.c
index 884b7c1ac2b5..0818ee1a1501 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -648,7 +648,7 @@ fill_rsumino(xfs_mount_t *mp)
 	struct xfs_buf	*bp;
 	xfs_trans_t	*tp;
 	xfs_inode_t	*ip;
-	xfs_suminfo_t	*smp;
+	union xfs_suminfo_raw *smp;
 	int		nmap;
 	int		error;
 	xfs_fileoff_t	bno;
@@ -671,6 +671,12 @@ fill_rsumino(xfs_mount_t *mp)
 	}
 
 	while (bno < end_bno)  {
+		struct xfs_rtalloc_args	args = {
+			.mp		= mp,
+			.tp		= tp,
+		};
+		union xfs_suminfo_raw	*ondisk;
+
 		/*
 		 * fill the file one block at a time
 		 */
@@ -697,11 +703,13 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 			return(1);
 		}
 
-		memmove(bp->b_addr, smp, mp->m_sb.sb_blocksize);
+		args.sumbp = bp;
+		ondisk = xfs_rsumblock_infoptr(&args, 0);
+		memcpy(ondisk, smp, mp->m_sb.sb_blocksize);
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
-		smp = (xfs_suminfo_t *)((intptr_t)smp + mp->m_sb.sb_blocksize);
+		smp += mp->m_blockwsize;
 		bno++;
 	}
 
diff --git a/repair/rt.c b/repair/rt.c
index 6ab709a000cb..9aff5a0d3d58 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -36,7 +36,7 @@ rtinit(xfs_mount_t *mp)
 
 	wordcnt = libxfs_rtsummary_wordcount(mp, mp->m_rsumlevels,
 			mp->m_sb.sb_rbmblocks);
-	sumcompute = calloc(wordcnt, sizeof(xfs_suminfo_t));
+	sumcompute = calloc(wordcnt, sizeof(union xfs_suminfo_raw));
 	if (!sumcompute)
 		do_error(
 	_("couldn't allocate memory for incore realtime summary info.\n"));
@@ -51,6 +51,17 @@ set_rtword(
 	word->old = value;
 }
 
+static inline void
+inc_sumcount(
+	struct xfs_mount	*mp,
+	union xfs_suminfo_raw	*info,
+	xfs_rtsumoff_t		index)
+{
+	union xfs_suminfo_raw	*p = info + index;
+
+	p->old++;
+}
+
 /*
  * generate the real-time bitmap and summary info based on the
  * incore realtime extent map.
@@ -59,7 +70,7 @@ int
 generate_rtinfo(
 	struct xfs_mount	*mp,
 	union xfs_rtword_raw	*words,
-	xfs_suminfo_t		*sumcompute)
+	union xfs_suminfo_raw	*sumcompute)
 {
 	xfs_rtxnum_t	extno;
 	xfs_rtxnum_t	start_ext;
@@ -105,7 +116,7 @@ generate_rtinfo(
 				len = (int) (extno - start_ext);
 				log = XFS_RTBLOCKLOG(len);
 				offs = xfs_rtsumoffs(mp, log, start_bmbno);
-				sumcompute[offs]++;
+				inc_sumcount(mp, sumcompute, offs);
 				in_extent = 0;
 			}
 
@@ -121,7 +132,7 @@ generate_rtinfo(
 		len = (int) (extno - start_ext);
 		log = XFS_RTBLOCKLOG(len);
 		offs = xfs_rtsumoffs(mp, log, start_bmbno);
-		sumcompute[offs]++;
+		inc_sumcount(mp, sumcompute, offs);
 	}
 
 	if (mp->m_sb.sb_frextents != sb_frextents) {
diff --git a/repair/rt.h b/repair/rt.h
index 3f1439300686..862695487bcd 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -12,7 +12,7 @@ void
 rtinit(xfs_mount_t		*mp);
 
 int generate_rtinfo(struct xfs_mount *mp, union xfs_rtword_raw *words,
-		xfs_suminfo_t *sumcompute);
+		union xfs_suminfo_raw *sumcompute);
 
 void check_rtbitmap(struct xfs_mount *mp);
 void check_rtsummary(struct xfs_mount *mp);

