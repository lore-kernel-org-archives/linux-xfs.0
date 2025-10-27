Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12092C3769
	for <linux-xfs@vger.kernel.org>; Mon, 27 Oct 2025 07:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761548801; cv=none; b=joGc3CDR5hFev3k0bw2eJPrGYp8zqLN0I7R7iTZVwe3VuTBFJ5Q+aFyPO52GbOUWbpWx54BLlndN0Gzb+vpZnZU+WVdpBLlLgvPDq2Cd/w2Dqff4KwLvYZV0oTd8jx3UY+2IW5mYBOLWNIMAyteTSyxIFU+20/soGXJm4wSJDE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761548801; c=relaxed/simple;
	bh=ygjP+0hXKozuPlWiH+CdghGrQ7dOpMe9UhbZQu/cmwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tah4Nkvh1r5pQPZI8b3ANbpvhwvMYcPh+tHoT3FtmvkjIjOGwvTXrE+4ax1cumB12d4VkBnVcHhgGRcTQriZgOsvPFytLY7OzZSt5T6mb3BCXzeKo3fT/jwTbbesLIXHskV2SIwjhpVw/M4UqMEfAULli+rXg1jVtIuyY/qYT18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L0oddVpd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L0oddVpd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=I3KUQNkkYwoPMA3lHjZxhkMfGCFDHC++zLeJi/4ViX4=; b=L0oddVpdK3BQvAXQlM7nkb1ePg
	fFu0nzx0YECXDJTcfjUxeoT0664MUqSeHBiUwDl6ozybtdG3H29TBsuSN4Augx60St+92B6iaST0/
	T5ZT1yLsw+gnO/BeNPzq4uuCSwpQNiXeUC/y63dcTCYp6HnZDbHTWQY9MW/BnTkMc4/5xCbIIsYhB
	8BLz4GmTsMFk7dJnQy/DxsGI3habeQDppjT+IiiWWG2Edo0gWJfPruTuSleLJ57jS6WiVwAgAEnm/
	GE4rXCQlksLK/TddnyYW42IrHZxi6wwbCARIR+JQep66+x65uiqEzv7tkKxfkwRPgDf7qpYMODY3q
	aIncxvzg==;
Received: from [62.218.44.66] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDHJO-0000000DFiv-3pR3;
	Mon, 27 Oct 2025 07:06:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH 9/9] xfs: remove the xlog_in_core_t typedef
Date: Mon, 27 Oct 2025 08:05:56 +0100
Message-ID: <20251027070610.729960-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251027070610.729960-1-hch@lst.de>
References: <20251027070610.729960-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Switch the few remaining users to use the underlying struct directly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_log.c      | 18 +++++++++---------
 fs/xfs/xfs_log_priv.h |  6 +++---
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 47a8e74c8c5c..a311385b23d8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1368,8 +1368,8 @@ xlog_alloc_log(
 	int			num_bblks)
 {
 	struct xlog		*log;
-	xlog_in_core_t		**iclogp;
-	xlog_in_core_t		*iclog, *prev_iclog=NULL;
+	struct xlog_in_core	**iclogp;
+	struct xlog_in_core	*iclog, *prev_iclog = NULL;
 	int			i;
 	int			error = -ENOMEM;
 	uint			log2_size = 0;
@@ -1813,10 +1813,10 @@ xlog_sync(
  */
 STATIC void
 xlog_dealloc_log(
-	struct xlog	*log)
+	struct xlog		*log)
 {
-	xlog_in_core_t	*iclog, *next_iclog;
-	int		i;
+	struct xlog_in_core	*iclog, *next_iclog;
+	int			i;
 
 	/*
 	 * Destroy the CIL after waiting for iclog IO completion because an
@@ -3293,7 +3293,7 @@ xlog_verify_iclog(
 	int			count)
 {
 	struct xlog_rec_header	*rhead = iclog->ic_header;
-	xlog_in_core_t		*icptr;
+	struct xlog_in_core	*icptr;
 	void			*base_ptr, *ptr;
 	ptrdiff_t		field_offset;
 	uint8_t			clientid;
@@ -3481,11 +3481,10 @@ xlog_force_shutdown(
 
 STATIC int
 xlog_iclogs_empty(
-	struct xlog	*log)
+	struct xlog		*log)
 {
-	xlog_in_core_t	*iclog;
+	struct xlog_in_core	*iclog = log->l_iclog;
 
-	iclog = log->l_iclog;
 	do {
 		/* endianness does not matter here, zero is zero in
 		 * any language.
@@ -3494,6 +3493,7 @@ xlog_iclogs_empty(
 			return 0;
 		iclog = iclog->ic_next;
 	} while (iclog != log->l_iclog);
+
 	return 1;
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 17733ba7f251..0fe59f0525aa 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -181,7 +181,7 @@ struct xlog_ticket {
  * We'll put all the read-only and l_icloglock fields in the first cacheline,
  * and move everything else out to subsequent cachelines.
  */
-typedef struct xlog_in_core {
+struct xlog_in_core {
 	wait_queue_head_t	ic_force_wait;
 	wait_queue_head_t	ic_write_wait;
 	struct xlog_in_core	*ic_next;
@@ -204,7 +204,7 @@ typedef struct xlog_in_core {
 	struct work_struct	ic_end_io_work;
 	struct bio		ic_bio;
 	struct bio_vec		ic_bvec[];
-} xlog_in_core_t;
+};
 
 /*
  * The CIL context is used to aggregate per-transaction details as well be
@@ -418,7 +418,7 @@ struct xlog {
 						/* waiting for iclog flush */
 	int			l_covered_state;/* state of "covering disk
 						 * log entries" */
-	xlog_in_core_t		*l_iclog;       /* head log queue	*/
+	struct xlog_in_core	*l_iclog;       /* head log queue	*/
 	spinlock_t		l_icloglock;    /* grab to change iclog state */
 	int			l_curr_cycle;   /* Cycle number of log writes */
 	int			l_prev_cycle;   /* Cycle number before last
-- 
2.47.3

