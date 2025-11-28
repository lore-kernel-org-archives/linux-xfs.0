Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B29024BD1A
	for <linux-xfs@vger.kernel.org>; Fri, 28 Nov 2025 06:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764311464; cv=none; b=UJPMzGfj+9vZDhCkHLFS+K9bqaSEfqVIuzxl7jW8KigI+3oklRp4SVLB6UvHVxupZ79u+kAB7BRhSsThV+ACC1kzVc8cS/pT27woVbQLBZ6lLnSVqBMfBhLiGEpMyQfn7yoO6PFat4cjMiaXp0tWVFA/RaNqp5MX15eVPwkaOQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764311464; c=relaxed/simple;
	bh=rWdY3hRUg4qH5ZDTROFLpmbyQGH16MpuOx6PNTdb6kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcbDvaxdq9zPfi+J5MHNp+NWndwufd76hbUUDRQr/SMGWKGlcIF4fqiZDgeE6pIOqN36fEhmjnOIN1nnJtOzVrCAithX9VPkpCrLerzK4u5uz6Ax1qtzFjQDw3rehMOUf52NYPLg0MIJOVHUVFsH52K0XTyGZySUzrVxC2IT9UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aVlJYRJB; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aVlJYRJB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=izh83ouqmMlN2ruIztcq6kQETiyvtG9RIIqvgxzQH64=; b=aVlJYRJBHsDp5zhRPlotdDhYBO
	rM/bM25+/EYZhPq+5VQA6R2haV3gTFXEaQYnBF2GofmZOKyv6cRqcfxFqx8VaFq1fEIOLoCZBL7Ta
	38l1PAkoNhbfpsuODUAk3AD2YjCMWWRltfJ3wBE7Qi7ZJOR+Q4wkIZAzGdrdODPcqrMKOSSq/Rtaf
	QvTkMF+RCU6hKsIrzlPAQ+YQNSabrO9fzYHvO7fUXqGSgsFdOB/ofDEHiCAD2S+7/9TUfodKjBN40
	I/LxWJxHSYi1r7ViAtinjqKvurjdXdSr2pZw9/tbnprq3SGZF8S1Ri5gCxQZqCeknWnP9u9qkVGa4
	Y/jbZi5g==;
Received: from [185.58.53.186] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOs0U-000000002ba-0ejE;
	Fri, 28 Nov 2025 06:31:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 07/25] logprint: split per-type helpers out of xlog_print_trans_buffer
Date: Fri, 28 Nov 2025 07:29:44 +0100
Message-ID: <20251128063007.1495036-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128063007.1495036-1-hch@lst.de>
References: <20251128063007.1495036-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a new helper for each special cased buffer type.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 logprint/log_misc.c | 360 +++++++++++++++++++++++++-------------------
 1 file changed, 205 insertions(+), 155 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index 48611c746bea..a47b955c4204 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -222,6 +222,205 @@ xlog_print_trans_header(
 	return 0;
 }
 
+static void
+xlog_print_sb_buf(
+	struct xlog_op_header	*ophdr,
+	void			*ptr)
+{
+	struct xfs_dsb		*dsb = ptr;
+
+	printf(_("SUPER BLOCK Buffer: "));
+	if (be32_to_cpu(ophdr->oh_len) < 4 * 8) {
+		printf(_("Out of space\n"));
+		return;
+	}
+
+	printf("\n");
+	printf(_("icount: %llu  ifree: %llu  "),
+		(unsigned long long)get_unaligned_be64(&dsb->sb_icount),
+		(unsigned long long)get_unaligned_be64(&dsb->sb_ifree));
+	printf(_("fdblks: %llu  frext: %llu\n"),
+		(unsigned long long)get_unaligned_be64(&dsb->sb_fdblocks),
+		(unsigned long long)get_unaligned_be64(&dsb->sb_frextents));
+}
+
+static bool
+xlog_print_agi_buf(
+	struct xlog_op_header	*ophdr,
+	void			*ptr)
+{
+	int			bucket, col, buckets;
+	struct xfs_agi		agi;
+
+	/* memmove because ptr may not be 8-byte aligned */
+	memmove(&agi, ptr, sizeof(agi));
+
+	printf(_("AGI Buffer: XAGI  "));
+
+	/*
+	 * v4 filesystems only contain the fields before the uuid.
+	 *
+	 * Even v5 filesystems don't log any field beneath it. That means that
+	 * the size that is logged is almost always going to be smaller than the
+	 * structure itself.  Hence we need to make sure that the buffer
+	 * contains all the data we want to print rather than just check against
+	 * the structure size.
+	 */
+	if (be32_to_cpu(ophdr->oh_len) <
+	    offsetof(xfs_agi_t, agi_uuid) -
+	    XFS_AGI_UNLINKED_BUCKETS * sizeof(xfs_agino_t)) {
+		printf(_("out of space\n"));
+		return true;
+	}
+
+	printf("\n");
+	printf(_("ver: %d  "),
+		be32_to_cpu(agi.agi_versionnum));
+	printf(_("seq#: %d  len: %d  cnt: %d  root: %d\n"),
+		be32_to_cpu(agi.agi_seqno),
+		be32_to_cpu(agi.agi_length),
+		be32_to_cpu(agi.agi_count),
+		be32_to_cpu(agi.agi_root));
+	printf(_("level: %d  free#: 0x%x  newino: 0x%x\n"),
+		be32_to_cpu(agi.agi_level),
+		be32_to_cpu(agi.agi_freecount),
+		be32_to_cpu(agi.agi_newino));
+	if (be32_to_cpu(ophdr->oh_len) == 128) {
+		buckets = 17;
+	} else if (be32_to_cpu(ophdr->oh_len) == 256) {
+		buckets = 32 + 17;
+	} else {
+		if (ophdr->oh_flags & XLOG_CONTINUE_TRANS) {
+			printf(_("AGI unlinked data skipped "));
+			printf(_("(CONTINUE set, no space)\n"));
+			return false;
+		}
+		buckets = XFS_AGI_UNLINKED_BUCKETS;
+	}
+
+	for (bucket = 0; bucket < buckets;) {
+		printf(_("bucket[%d - %d]: "), bucket, bucket + 3);
+		for (col = 0; col < 4; col++, bucket++) {
+			if (bucket < buckets) {
+				printf("0x%x ",
+					be32_to_cpu(agi.agi_unlinked[bucket]));
+			}
+		}
+		printf("\n");
+	}
+
+	return true;
+}
+
+static void
+xlog_print_agf_buf(
+	struct xlog_op_header	*ophdr,
+	void			*ptr)
+{
+	struct xfs_agf		agf;
+
+	/* memmove because ptr may not be 8-byte aligned */
+	memmove(&agf, ptr, sizeof(agf));
+
+	printf(_("AGF Buffer: XAGF  "));
+
+	/*
+	 * v4 filesystems only contain the fields before the uuid.
+	 *
+	 * Even v5 filesystems don't log any field beneath it. That means that
+	 * the size that is logged is almost always going to be smaller than the
+	 * structure itself.  Hence we need to make sure that the buffer
+	 * contains all the data we want to print rather than just check against
+	 * the structure size.
+	 */
+	if (be32_to_cpu(ophdr->oh_len) < offsetof(xfs_agf_t, agf_uuid)) {
+		printf(_("Out of space\n"));
+		return;
+	}
+
+	printf("\n");
+	printf(_("ver: %d  seq#: %d  len: %d  \n"),
+		be32_to_cpu(agf.agf_versionnum),
+		be32_to_cpu(agf.agf_seqno),
+		be32_to_cpu(agf.agf_length));
+	printf(_("root BNO: %d  CNT: %d\n"),
+		be32_to_cpu(agf.agf_bno_root),
+		be32_to_cpu(agf.agf_cnt_root));
+	printf(_("level BNO: %d  CNT: %d\n"),
+		be32_to_cpu(agf.agf_bno_level),
+		be32_to_cpu(agf.agf_cnt_level));
+	printf(_("1st: %d  last: %d  cnt: %d  freeblks: %d  longest: %d\n"),
+		be32_to_cpu(agf.agf_flfirst),
+		be32_to_cpu(agf.agf_fllast),
+		be32_to_cpu(agf.agf_flcount),
+		be32_to_cpu(agf.agf_freeblks),
+		be32_to_cpu(agf.agf_longest));
+}
+
+static void
+xlog_print_dquot_buf(
+	struct xlog_op_header	*ophdr,
+	void			*ptr)
+{
+	struct xfs_disk_dquot	dq;
+
+	/* memmove because ptr may not be 8-byte aligned */
+	memmove(&dq, ptr, sizeof(dq));
+
+	printf(_("DQUOT Buffer: DQ  "));
+	if (be32_to_cpu(ophdr->oh_len) < sizeof(struct xfs_disk_dquot)) {
+		printf(_("Out of space\n"));
+		return;
+	}
+
+	printf("\n");
+	printf(_("ver: %d  flags: 0x%x  id: %d  \n"),
+		dq.d_version,
+		dq.d_type,
+		be32_to_cpu(dq.d_id));
+	printf(_("blk limits  hard: %llu  soft: %llu\n"),
+		(unsigned long long)be64_to_cpu(dq.d_blk_hardlimit),
+		(unsigned long long)be64_to_cpu(dq.d_blk_softlimit));
+	printf(_("blk  count: %llu  warns: %d  timer: %d\n"),
+		(unsigned long long) be64_to_cpu(dq.d_bcount),
+		(int) be16_to_cpu(dq.d_bwarns),
+		be32_to_cpu(dq.d_btimer));
+	printf(_("ino limits  hard: %llu  soft: %llu\n"),
+		(unsigned long long)be64_to_cpu(dq.d_ino_hardlimit),
+		(unsigned long long)be64_to_cpu(dq.d_ino_softlimit));
+	printf(_("ino  count: %llu  warns: %d  timer: %d\n"),
+		(unsigned long long)be64_to_cpu(dq.d_icount),
+		(int) be16_to_cpu(dq.d_iwarns),
+		be32_to_cpu(dq.d_itimer));
+}
+
+static void
+xlog_print_buf_data(
+	struct xlog_op_header	*ophdr,
+	void			*ptr)
+{
+
+	uint			*dp = ptr;
+	int			nums = be32_to_cpu(ophdr->oh_len) >> 2;
+	int			byte = 0;
+
+	printf(_("BUF DATA\n"));
+
+	if (!print_data)
+		return;
+
+	while (byte < nums) {
+		if ((byte % 8) == 0)
+			printf("%2x ", byte);
+		printf("%8x ", *dp);
+		dp++;
+		byte++;
+		if ((byte % 8) == 0)
+			printf("\n");
+	}
+	printf("\n");
+}
+
 static int
 xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 {
@@ -229,7 +428,6 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
     xlog_op_header_t	 *head = NULL;
     int			 num, skip;
     int			 super_block = 0;
-    int			 bucket, col, buckets;
     int64_t			 blkno;
     xfs_buf_log_format_t lbuf;
     int			 size, blen, map_size, struct_size;
@@ -283,165 +481,17 @@ xlog_print_trans_buffer(char **ptr, int len, int *i, int num_ops)
 	head = (xlog_op_header_t *)*ptr;
 	xlog_print_op_header(head, *i, ptr);
 	if (super_block) {
-		printf(_("SUPER BLOCK Buffer: "));
-		if (be32_to_cpu(head->oh_len) < 4*8) {
-			printf(_("Out of space\n"));
-		} else {
-			struct xfs_dsb	*dsb = (struct xfs_dsb *) *ptr;
-
-			printf("\n");
-			printf(_("icount: %llu  ifree: %llu  "),
-			       (unsigned long long) get_unaligned_be64(&dsb->sb_icount),
-			       (unsigned long long) get_unaligned_be64(&dsb->sb_ifree));
-			printf(_("fdblks: %llu  frext: %llu\n"),
-			       (unsigned long long) get_unaligned_be64(&dsb->sb_fdblocks),
-			       (unsigned long long) get_unaligned_be64(&dsb->sb_frextents));
-		}
+		xlog_print_sb_buf(head, *ptr);
 		super_block = 0;
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGI_MAGIC) {
-  	  	struct xfs_agi	*agi, agi_s;
-
-		/* memmove because *ptr may not be 8-byte aligned */
-		agi = &agi_s;
-		memmove(agi, *ptr, sizeof(struct xfs_agi));
-		printf(_("AGI Buffer: XAGI  "));
-		/*
-		 * v4 filesystems only contain the fields before the uuid.
-		 * Even v5 filesystems don't log any field beneath it. That
-		 * means that the size that is logged is almost always going to
-		 * be smaller than the structure itself. Hence we need to make
-		 * sure that the buffer contains all the data we want to print
-		 * rather than just check against the structure size.
-		 */
-		if (be32_to_cpu(head->oh_len) < offsetof(xfs_agi_t, agi_uuid) -
-				XFS_AGI_UNLINKED_BUCKETS*sizeof(xfs_agino_t)) {
-			printf(_("out of space\n"));
-		} else {
-			printf("\n");
-			printf(_("ver: %d  "),
-				be32_to_cpu(agi->agi_versionnum));
-			printf(_("seq#: %d  len: %d  cnt: %d  root: %d\n"),
-				be32_to_cpu(agi->agi_seqno),
-				be32_to_cpu(agi->agi_length),
-				be32_to_cpu(agi->agi_count),
-				be32_to_cpu(agi->agi_root));
-			printf(_("level: %d  free#: 0x%x  newino: 0x%x\n"),
-				be32_to_cpu(agi->agi_level),
-				be32_to_cpu(agi->agi_freecount),
-				be32_to_cpu(agi->agi_newino));
-			if (be32_to_cpu(head->oh_len) == 128) {
-				buckets = 17;
-			} else if (be32_to_cpu(head->oh_len) == 256) {
-				buckets = 32 + 17;
-			} else {
-				if (head->oh_flags & XLOG_CONTINUE_TRANS) {
-					printf(_("AGI unlinked data skipped "));
-					printf(_("(CONTINUE set, no space)\n"));
-					continue;
-				}
-				buckets = XFS_AGI_UNLINKED_BUCKETS;
-			}
-			for (bucket = 0; bucket < buckets;) {
-				printf(_("bucket[%d - %d]: "), bucket, bucket+3);
-				for (col = 0; col < 4; col++, bucket++) {
-					if (bucket < buckets) {
-						printf("0x%x ",
-			be32_to_cpu(agi->agi_unlinked[bucket]));
-					}
-				}
-				printf("\n");
-			}
-		}
+		if (!xlog_print_agi_buf(head, *ptr))
+			continue;
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_AGF_MAGIC) {
-    		struct xfs_agf	*agf, agf_s;
-
-		/* memmove because *ptr may not be 8-byte aligned */
-		agf = &agf_s;
-		memmove(agf, *ptr, sizeof(struct xfs_agf));
-		printf(_("AGF Buffer: XAGF  "));
-		/*
-		 * v4 filesystems only contain the fields before the uuid.
-		 * Even v5 filesystems don't log any field beneath it. That
-		 * means that the size that is logged is almost always going to
-		 * be smaller than the structure itself. Hence we need to make
-		 * sure that the buffer contains all the data we want to print
-		 * rather than just check against the structure size.
-		 */
-		if (be32_to_cpu(head->oh_len) < offsetof(xfs_agf_t, agf_uuid)) {
-			printf(_("Out of space\n"));
-		} else {
-			printf("\n");
-			printf(_("ver: %d  seq#: %d  len: %d  \n"),
-				be32_to_cpu(agf->agf_versionnum),
-				be32_to_cpu(agf->agf_seqno),
-				be32_to_cpu(agf->agf_length));
-			printf(_("root BNO: %d  CNT: %d\n"),
-				be32_to_cpu(agf->agf_bno_root),
-				be32_to_cpu(agf->agf_cnt_root));
-			printf(_("level BNO: %d  CNT: %d\n"),
-				be32_to_cpu(agf->agf_bno_level),
-				be32_to_cpu(agf->agf_cnt_level));
-			printf(_("1st: %d  last: %d  cnt: %d  "
-			       "freeblks: %d  longest: %d\n"),
-				be32_to_cpu(agf->agf_flfirst),
-				be32_to_cpu(agf->agf_fllast),
-				be32_to_cpu(agf->agf_flcount),
-				be32_to_cpu(agf->agf_freeblks),
-				be32_to_cpu(agf->agf_longest));
-		}
+		xlog_print_agf_buf(head, *ptr);
 	} else if (be32_to_cpu(*(__be32 *)(*ptr)) == XFS_DQUOT_MAGIC) {
-		struct xfs_disk_dquot *dq, dq_s;
-
-		/* memmove because *ptr may not be 8-byte aligned */
-		dq = &dq_s;
-		memmove(dq, *ptr, sizeof(struct xfs_disk_dquot));
-		printf(_("DQUOT Buffer: DQ  "));
-		if (be32_to_cpu(head->oh_len) <
-				sizeof(struct xfs_disk_dquot)) {
-			printf(_("Out of space\n"));
-		}
-		else {
-			printf("\n");
-			printf(_("ver: %d  flags: 0x%x  id: %d  \n"),
-				dq->d_version, dq->d_type,
-				be32_to_cpu(dq->d_id));
-			printf(_("blk limits  hard: %llu  soft: %llu\n"),
-			       (unsigned long long)
-				       be64_to_cpu(dq->d_blk_hardlimit),
-			       (unsigned long long)
-				       be64_to_cpu(dq->d_blk_softlimit));
-			printf(_("blk  count: %llu  warns: %d  timer: %d\n"),
-			       (unsigned long long) be64_to_cpu(dq->d_bcount),
-			       (int) be16_to_cpu(dq->d_bwarns),
-				be32_to_cpu(dq->d_btimer));
-			printf(_("ino limits  hard: %llu  soft: %llu\n"),
-			       (unsigned long long)
-				       be64_to_cpu(dq->d_ino_hardlimit),
-			       (unsigned long long)
-				       be64_to_cpu(dq->d_ino_softlimit));
-			printf(_("ino  count: %llu  warns: %d  timer: %d\n"),
-			       (unsigned long long) be64_to_cpu(dq->d_icount),
-			       (int) be16_to_cpu(dq->d_iwarns),
-				be32_to_cpu(dq->d_itimer));
-		}
+		xlog_print_dquot_buf(head, *ptr);
 	} else {
-		printf(_("BUF DATA\n"));
-		if (print_data) {
-			uint *dp  = (uint *)*ptr;
-			int  nums = be32_to_cpu(head->oh_len) >> 2;
-			int  byte = 0;
-
-			while (byte < nums) {
-				if ((byte % 8) == 0)
-					printf("%2x ", byte);
-				printf("%8x ", *dp);
-				dp++;
-				byte++;
-				if ((byte % 8) == 0)
-					printf("\n");
-			}
-			printf("\n");
-		}
+		xlog_print_buf_data(head, *ptr);
 	}
 	*ptr += be32_to_cpu(head->oh_len);
     }
-- 
2.47.3

