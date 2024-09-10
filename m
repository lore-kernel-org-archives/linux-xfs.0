Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19444F218
	for <linux-xfs@vger.kernel.org>; Tue, 10 Sep 2024 04:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725942557; cv=none; b=vCQQMOMYwvZhCmf4Ol6DkLXgVCDMheiRH2/5xO2BtkbPSjk4zSBsLYfJj8ebtPV3aZAeFff7YLijLzhvd9WTaCjufA5RjFXFzyaSZAxWQJlgk3Sq2CKx/9GPzw6WvO/af/Ibu+E4h7l7QOgyNeYHSX3B54eXqt4evunlaqI7+1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725942557; c=relaxed/simple;
	bh=jIpi9wkMryaj2lQ/TmpFrUVbCL8BrCG11AuWi++BUVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpKb8Op0N2WyH9BIn0HG+9b4DFj0mIqYffgVmF9DlyHrVNEoHHn69femswO6jmCnV2PERjf2Osm6Q3gpTvGZXWpPN/AUVzpuLJpAHIMd3BBeMqhLkh2eWoQS6Zdf4Wz9DwAJAGSkB92imlCgMwJWlX2m67AR7mqgDyjAgd3hKdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bkLGCd4o; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bkLGCd4o"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fHzWSW9D6RgjCkLxa927Ic+d+EEnNxvXQtpxOPO75vI=; b=bkLGCd4oJ5EKytV1lxOHTtXRRm
	Dx/nyDw7vvIyrd4to2Ucwrm1b+NOcsxd90Tf9gQmocW5TVCmY8txtC0WMcfCRLju1koOlYh0kh1pT
	RLSJlWY6wkuT2bkWV0+54nWOGKUPqvcRGyTIstXlvReKfF1ifkVmQxNxONYI4325ue5XDDt6fH0WC
	62CFNkz82Ez67LSa5M3xn0DuKVUOtIFhnDCaDgWMPRzah8MjlMQRlsZV8nlRKAst4O+P+aoyTtS9p
	kgQvq92VPk/V5N8Tt8BoJcz0uv1IRklYdBj9UVvFCj0fOQtOKZRMZraniKe1hmrDxWWMjsd1RRn/8
	j2vJ8F6Q==;
Received: from ppp-2-84-49-240.home.otenet.gr ([2.84.49.240] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1snsV7-00000004D6A-2rxi;
	Tue, 10 Sep 2024 04:29:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: create perag structures as soon as possible during log recovery
Date: Tue, 10 Sep 2024 07:28:46 +0300
Message-ID: <20240910042855.3480387-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240910042855.3480387-1-hch@lst.de>
References: <20240910042855.3480387-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

An unclean log can contain both the transaction that created a new
allocation group and the first transaction that is freeing space from
it, in which case the extent free item recovery requires the perag
structure to be present.

Currently the perag structures are only created after log recovery
has completed, leading a warning and file system shutdown for the
above case.  Fix this by creating new perag structures and updating
the in-memory superblock fields as soon a buffer log item that covers
the primary super block is recovered.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_recover.h |  2 ++
 fs/xfs/xfs_buf_item_recover.c   | 16 +++++++++
 fs/xfs/xfs_log_recover.c        | 59 ++++++++++++++-------------------
 3 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 521d327e4c89ed..d0e13c84422d0a 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -165,4 +165,6 @@ void xlog_recover_intent_item(struct xlog *log, struct xfs_log_item *lip,
 int xlog_recover_finish_intent(struct xfs_trans *tp,
 		struct xfs_defer_pending *dfp);
 
+int xlog_recover_update_agcount(struct xfs_mount *mp, struct xfs_dsb *dsb);
+
 #endif	/* __XFS_LOG_RECOVER_H__ */
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 09e893cf563cb9..033821a56b6ac6 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -969,6 +969,22 @@ xlog_recover_buf_commit_pass2(
 			goto out_release;
 	} else {
 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
+
+		/*
+		 * Update the in-memory superblock and perag structures from the
+		 * primary SB buffer.
+		 *
+		 * This is required because transactions running after growf
+		 * s may require in-memory structures like the perag right after
+		 * committing the growfs transaction that created the underlying
+		 * objects.
+		 */
+		if ((xfs_blft_from_flags(buf_f) & XFS_BLFT_SB_BUF) &&
+		    xfs_buf_daddr(bp) == 0) {
+			error = xlog_recover_update_agcount(mp, bp->b_addr);
+			if (error)
+				goto out_release;
+		}
 	}
 
 	/*
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2af02b32f419c2..7d7ab146cae758 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3334,6 +3334,30 @@ xlog_do_log_recovery(
 	return error;
 }
 
+int
+xlog_recover_update_agcount(
+	struct xfs_mount		*mp,
+	struct xfs_dsb			*dsb)
+{
+	xfs_agnumber_t			old_agcount = mp->m_sb.sb_agcount;
+	int				error;
+
+	xfs_sb_from_disk(&mp->m_sb, dsb);
+	if (mp->m_sb.sb_agcount < old_agcount) {
+		xfs_alert(mp, "Shrinking AG count in log recovery");
+		return -EFSCORRUPTED;
+	}
+	mp->m_features |= xfs_sb_version_to_features(&mp->m_sb);
+	error = xfs_initialize_perag(mp, old_agcount, mp->m_sb.sb_agcount,
+			mp->m_sb.sb_dblocks, &mp->m_maxagi);
+	if (error) {
+		xfs_warn(mp, "Failed recovery per-ag init: %d", error);
+		return error;
+	}
+	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	return 0;
+}
+
 /*
  * Do the actual recovery
  */
@@ -3343,10 +3367,6 @@ xlog_do_recover(
 	xfs_daddr_t		head_blk,
 	xfs_daddr_t		tail_blk)
 {
-	struct xfs_mount	*mp = log->l_mp;
-	struct xfs_buf		*bp = mp->m_sb_bp;
-	struct xfs_sb		*sbp = &mp->m_sb;
-	xfs_agnumber_t		old_agcount = sbp->sb_agcount;
 	int			error;
 
 	trace_xfs_log_recover(log, head_blk, tail_blk);
@@ -3371,36 +3391,7 @@ xlog_do_recover(
 	 */
 	xfs_ail_assign_tail_lsn(log->l_ailp);
 
-	/*
-	 * Now that we've finished replaying all buffer and inode updates,
-	 * re-read the superblock and reverify it.
-	 */
-	xfs_buf_lock(bp);
-	xfs_buf_hold(bp);
-	error = _xfs_buf_read(bp, XBF_READ);
-	if (error) {
-		if (!xlog_is_shutdown(log)) {
-			xfs_buf_ioerror_alert(bp, __this_address);
-			ASSERT(0);
-		}
-		xfs_buf_relse(bp);
-		return error;
-	}
-
-	/* Convert superblock from on-disk format */
-	xfs_sb_from_disk(sbp, bp->b_addr);
-	xfs_buf_relse(bp);
-
-	/* re-initialise in-core superblock and geometry structures */
-	mp->m_features |= xfs_sb_version_to_features(sbp);
-	xfs_reinit_percpu_counters(mp);
-	error = xfs_initialize_perag(mp, old_agcount, sbp->sb_agcount,
-			sbp->sb_dblocks, &mp->m_maxagi);
-	if (error) {
-		xfs_warn(mp, "Failed post-recovery per-ag init: %d", error);
-		return error;
-	}
-	mp->m_alloc_set_aside = xfs_alloc_set_aside(mp);
+	xfs_reinit_percpu_counters(log->l_mp);
 
 	/* Normal transactions can now occur */
 	clear_bit(XLOG_ACTIVE_RECOVERY, &log->l_opstate);
-- 
2.45.2

