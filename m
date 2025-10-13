Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F02B288D2
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 02:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760323392; cv=none; b=Sw7Z7IjlsWxTe2N4FaLjrC/FOf6k+vlg8KO6YGfOfJNRh7vorHT2GyrOlyyrRtJRDvL2apYfIiHmnQhsQF2PQbcYX/s1fmOuuwEcaWjRBe2FoQubeZTOZH1coZnk+LPbXTH7TWkpfeUs/USmWIVcANZNjnDnxyPhArdrdcq198Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760323392; c=relaxed/simple;
	bh=jWZrG9+SERypAWRedTswhK6v0si8dcT1Rn0KZZWBPhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4NxaxpPr0Rk/3rgI595U3UUclomBOgoa+y1qvl8tkwTPZaGH+8wh0jskUeIVnOlPOAmcO07YS7cTq7LzmTHZb/4dBzyTCxEQaFog1hkzduvudzFLxbQqQLYt8fQeej+Z/LHTxNRmOIS4J8k23GWnfU52tj1/OGQGXtcjdLfeIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=47nj3Civ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="47nj3Civ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aeygcRF6InkFpmdNTFWdkYLw5xTWmkPa6SPwckwUqbE=; b=47nj3CivmqsFPgYK/hvL64+QmB
	Eple/7VdPEHgTNNBEnSuMmDemGCbzTKbD16CyqrmyJcGLaZq8zV1GVW8PiFW308wkJGx63Wr1qj2E
	OU8BpKRGKlBCekjy4fV+y6WmtX9gbpktm5OjGwk/LlthPuUjUPpyQX8+WrNujZ7wh5Qkdbt9aYbyU
	nvSxKil64u+Q55QZew3lB97A+8d0AZwZ/zRN7Nx8vwSeYSjr75DZPL8fXSqnwWZH1iZvN+fICG+Kw
	Jfco8WtdOoefkdDighvzA9PQcKiZlfJWksm3w7tMRsFzrs3c43ffbeCaFBC1DGERbQ/9fZIH+P42N
	xus0pZSA==;
Received: from [220.85.59.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v88Wj-0000000C7IG-1CB2;
	Mon, 13 Oct 2025 02:43:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 7/9] xfs: remove the xlog_rec_header_t typedef
Date: Mon, 13 Oct 2025 11:42:11 +0900
Message-ID: <20251013024228.4109032-8-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251013024228.4109032-1-hch@lst.de>
References: <20251013024228.4109032-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

There are almost no users of the typedef left, kill it and switch the
remaining users to use the underlying struct.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h |  4 ++--
 fs/xfs/xfs_log.c               |  6 +++---
 fs/xfs/xfs_log_recover.c       | 28 ++++++++++++++--------------
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 4cb69bd285ca..908e7060428c 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -136,7 +136,7 @@ struct xlog_rec_ext_header {
 #define XLOG_REC_EXT_SIZE \
 	offsetofend(struct xlog_rec_ext_header, xh_cycle_data)
 
-typedef struct xlog_rec_header {
+struct xlog_rec_header {
 	__be32	  h_magicno;	/* log record (LR) identifier		:  4 */
 	__be32	  h_cycle;	/* write cycle of log			:  4 */
 	__be32	  h_version;	/* LR version				:  4 */
@@ -174,7 +174,7 @@ typedef struct xlog_rec_header {
 
 	__u8	  h_reserved[184];
 	struct xlog_rec_ext_header h_ext[];
-} xlog_rec_header_t;
+};
 
 #ifdef __i386__
 #define XLOG_REC_SIZE		offsetofend(struct xlog_rec_header, h_size)
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 1fe3abbd3d36..8b3b79699596 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2578,9 +2578,9 @@ xlog_state_get_iclog_space(
 	struct xlog_ticket	*ticket,
 	int			*logoffsetp)
 {
-	int		  log_offset;
-	xlog_rec_header_t *head;
-	xlog_in_core_t	  *iclog;
+	int			log_offset;
+	struct xlog_rec_header	*head;
+	struct xlog_in_core	*iclog;
 
 restart:
 	spin_lock(&log->l_icloglock);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index ef0f6efc4381..03e42c7dab56 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -190,8 +190,8 @@ xlog_bwrite(
  */
 STATIC void
 xlog_header_check_dump(
-	xfs_mount_t		*mp,
-	xlog_rec_header_t	*head)
+	struct xfs_mount		*mp,
+	struct xlog_rec_header		*head)
 {
 	xfs_debug(mp, "%s:  SB : uuid = %pU, fmt = %d",
 		__func__, &mp->m_sb.sb_uuid, XLOG_FMT);
@@ -207,8 +207,8 @@ xlog_header_check_dump(
  */
 STATIC int
 xlog_header_check_recover(
-	xfs_mount_t		*mp,
-	xlog_rec_header_t	*head)
+	struct xfs_mount	*mp,
+	struct xlog_rec_header	*head)
 {
 	ASSERT(head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM));
 
@@ -238,8 +238,8 @@ xlog_header_check_recover(
  */
 STATIC int
 xlog_header_check_mount(
-	xfs_mount_t		*mp,
-	xlog_rec_header_t	*head)
+	struct xfs_mount	*mp,
+	struct xlog_rec_header	*head)
 {
 	ASSERT(head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM));
 
@@ -400,7 +400,7 @@ xlog_find_verify_log_record(
 	xfs_daddr_t		i;
 	char			*buffer;
 	char			*offset = NULL;
-	xlog_rec_header_t	*head = NULL;
+	struct xlog_rec_header	*head = NULL;
 	int			error = 0;
 	int			smallmem = 0;
 	int			num_blks = *last_blk - start_blk;
@@ -437,7 +437,7 @@ xlog_find_verify_log_record(
 				goto out;
 		}
 
-		head = (xlog_rec_header_t *)offset;
+		head = (struct xlog_rec_header *)offset;
 
 		if (head->h_magicno == cpu_to_be32(XLOG_HEADER_MAGIC_NUM))
 			break;
@@ -1237,7 +1237,7 @@ xlog_find_tail(
 	xfs_daddr_t		*head_blk,
 	xfs_daddr_t		*tail_blk)
 {
-	xlog_rec_header_t	*rhead;
+	struct xlog_rec_header	*rhead;
 	char			*offset = NULL;
 	char			*buffer;
 	int			error;
@@ -1487,7 +1487,7 @@ xlog_add_record(
 	int			tail_cycle,
 	int			tail_block)
 {
-	xlog_rec_header_t	*recp = (xlog_rec_header_t *)buf;
+	struct xlog_rec_header	*recp = (struct xlog_rec_header *)buf;
 
 	memset(buf, 0, BBSIZE);
 	recp->h_magicno = cpu_to_be32(XLOG_HEADER_MAGIC_NUM);
@@ -2997,7 +2997,7 @@ xlog_do_recovery_pass(
 	int			pass,
 	xfs_daddr_t		*first_bad)	/* out: first bad log rec */
 {
-	xlog_rec_header_t	*rhead;
+	struct xlog_rec_header	*rhead;
 	xfs_daddr_t		blk_no, rblk_no;
 	xfs_daddr_t		rhead_blk;
 	char			*offset;
@@ -3034,7 +3034,7 @@ xlog_do_recovery_pass(
 		if (error)
 			goto bread_err1;
 
-		rhead = (xlog_rec_header_t *)offset;
+		rhead = (struct xlog_rec_header *)offset;
 
 		/*
 		 * xfsprogs has a bug where record length is based on lsunit but
@@ -3141,7 +3141,7 @@ xlog_do_recovery_pass(
 				if (error)
 					goto bread_err2;
 			}
-			rhead = (xlog_rec_header_t *)offset;
+			rhead = (struct xlog_rec_header *)offset;
 			error = xlog_valid_rec_header(log, rhead,
 					split_hblks ? blk_no : 0, h_size);
 			if (error)
@@ -3223,7 +3223,7 @@ xlog_do_recovery_pass(
 		if (error)
 			goto bread_err2;
 
-		rhead = (xlog_rec_header_t *)offset;
+		rhead = (struct xlog_rec_header *)offset;
 		error = xlog_valid_rec_header(log, rhead, blk_no, h_size);
 		if (error)
 			goto bread_err2;
-- 
2.47.3

