Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AFA3D5C2A
	for <linux-xfs@vger.kernel.org>; Mon, 20 Jul 2026 09:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784540784; cv=none; b=qdGBpO+M/aGpnAW+01D3REOqvIU0HnIeg3NLw6xSw/V5r0tHwWBHAErvvUD4RrupwrPoTGuz09XJPxyb8DTY1towbveipzPXFw3kJ0pUyyMsdgMxjOF92N6X7g+3YaFXBtuIE6K7N8B2V/bnGYBRzwGJdZAJU5p4d5tFydP9XDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784540784; c=relaxed/simple;
	bh=KjN5RHbtE3e7a78JqElZhl8cwDUVElqtXnG6LWTxwz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZ7oYHdFco+oiMn2nvFlFJ2xgUxAnfz3hmH0tnTPJgBU9qTnm3/YhZOjaKOzmsczZhAeh1HL2DBC5ypo7WoLKLKTznuRoxTDtwmce7VDGQ33WG0EokXgE4TqASjLk8RzVMsq55OoNwxHGxhno+shFnT7JXOweWo7+zPWXU49y0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=egKVqt9x; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="egKVqt9x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Q+/0B9/PKJPl80eERq2GxujnRoEZ7PKO+xn2SIHf1uw=; b=egKVqt9xND4jwEDMPF6jXWjXez
	arg1eaHFbgiRF1trqbxc5y7To+I39oAcfHTt6kCA1rCC2t0qCIskPTT4wDVw+UHLCNbsV5XOVcmjY
	xTWx3uKqsta0n0Vmjpu2TXsbyCHKygyYS2Kb4vUmFnfO+KNvcWbTPpo96TSV916psCKIqcUyusS2o
	zgBFx47n5qZ5Qk1HdvTnCDmSJqHkXTSR16hcsUJCCH6dDyzOgptCim6XswZZFp+ZCgDhraJLZWJ9q
	mSjJOSR93xgpiGxjDwlxaDXiq2G5Cu3MSKIQB1Z2HJkR4I1yPyi5LaThcgaLmenFG6wyuHiVzoMcc
	0yNpK3kA==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlkZq-00000006Mhr-1Jiq;
	Mon, 20 Jul 2026 09:46:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: improve lock annotations in the log code
Date: Mon, 20 Jul 2026 11:45:41 +0200
Message-ID: <20260720094609.2191633-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260720094609.2191633-1-hch@lst.de>
References: <20260720094609.2191633-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Improve the __acquires and __releases annotations so that the new
clang code that is a bit more picky than sparse is happy.  This involves
passing an explicit struct xlog argument in a few places because
alias analysis can't figure out it is the same lock when dereferencing
changing iclogs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 31 +++++++++++++++++++------------
 fs/xfs/xfs_log_cil.c  |  2 +-
 fs/xfs/xfs_log_priv.h |  4 ++--
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f807f8f4f705..0294ac277f35 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -470,6 +470,8 @@ xlog_state_release_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
 	struct xlog_ticket	*ticket)
+		__releases(&log->l_icloglock)
+		__acquires(&log->l_icloglock)
 {
 	bool			last_ref;
 
@@ -744,13 +746,16 @@ xfs_log_mount_cancel(
  */
 static inline int
 xlog_force_iclog(
+	struct xlog		*log,
 	struct xlog_in_core	*iclog)
+		__releases(&log->l_icloglock)
+		__acquires(&log->l_icloglock)
 {
 	atomic_inc(&iclog->ic_refcnt);
 	iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
 	if (iclog->ic_state == XLOG_STATE_ACTIVE)
-		xlog_state_switch_iclogs(iclog->ic_log, iclog, 0);
-	return xlog_state_release_iclog(iclog->ic_log, iclog, NULL);
+		xlog_state_switch_iclogs(log, iclog, 0);
+	return xlog_state_release_iclog(log, iclog, NULL);
 }
 
 /*
@@ -778,11 +783,10 @@ xlog_wait_iclog_completion(struct xlog *log)
  */
 int
 xlog_wait_on_iclog(
+	struct xlog		*log,
 	struct xlog_in_core	*iclog)
-		__releases(iclog->ic_log->l_icloglock)
+		__releases(log->l_icloglock)
 {
-	struct xlog		*log = iclog->ic_log;
-
 	trace_xlog_iclog_wait_on(iclog, _RET_IP_);
 	if (!xlog_is_shutdown(log) &&
 	    iclog->ic_state != XLOG_STATE_ACTIVE &&
@@ -879,8 +883,8 @@ xlog_unmount_write(
 
 	spin_lock(&log->l_icloglock);
 	iclog = log->l_iclog;
-	error = xlog_force_iclog(iclog);
-	xlog_wait_on_iclog(iclog);
+	error = xlog_force_iclog(log, iclog);
+	xlog_wait_on_iclog(log, iclog);
 
 	if (tic) {
 		trace_xfs_log_umount_write(log, tic);
@@ -2741,14 +2745,17 @@ xlog_state_switch_iclogs(
  */
 static int
 xlog_force_and_check_iclog(
+	struct xlog		*log,
 	struct xlog_in_core	*iclog,
 	bool			*completed)
+		__releases(&log->l_icloglock)
+		__acquires(&log->l_icloglock)
 {
 	xfs_lsn_t		lsn = be64_to_cpu(iclog->ic_header->h_lsn);
 	int			error;
 
 	*completed = false;
-	error = xlog_force_iclog(iclog);
+	error = xlog_force_iclog(log, iclog);
 	if (error)
 		return error;
 
@@ -2825,7 +2832,7 @@ xfs_log_force(
 			/* We have exclusive access to this iclog. */
 			bool	completed;
 
-			if (xlog_force_and_check_iclog(iclog, &completed))
+			if (xlog_force_and_check_iclog(log, iclog, &completed))
 				goto out_error;
 
 			if (completed)
@@ -2850,7 +2857,7 @@ xfs_log_force(
 		iclog->ic_flags |= XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA;
 
 	if (flags & XFS_LOG_SYNC)
-		return xlog_wait_on_iclog(iclog);
+		return xlog_wait_on_iclog(log, iclog);
 out_unlock:
 	spin_unlock(&log->l_icloglock);
 	return 0;
@@ -2920,7 +2927,7 @@ xlog_force_lsn(
 					&log->l_icloglock);
 			return -EAGAIN;
 		}
-		if (xlog_force_and_check_iclog(iclog, &completed))
+		if (xlog_force_and_check_iclog(log, iclog, &completed))
 			goto out_error;
 		if (log_flushed)
 			*log_flushed = 1;
@@ -2948,7 +2955,7 @@ xlog_force_lsn(
 	}
 
 	if (flags & XFS_LOG_SYNC)
-		return xlog_wait_on_iclog(iclog);
+		return xlog_wait_on_iclog(log, iclog);
 out_unlock:
 	spin_unlock(&log->l_icloglock);
 	return 0;
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 639f875a8fb2..ae1ed16aeb2f 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1556,7 +1556,7 @@ xlog_cil_push_work(
 			 * iclogs older than ic_prev. Hence we only need to wait
 			 * on the most recent older iclog here.
 			 */
-			xlog_wait_on_iclog(ctx->commit_iclog->ic_prev);
+			xlog_wait_on_iclog(log, ctx->commit_iclog->ic_prev);
 			spin_lock(&log->l_icloglock);
 		}
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index cf1e4ce61a8c..6d9673c41cdf 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -605,8 +605,8 @@ xlog_wait(
 	remove_wait_queue(wq, &wait);
 }
 
-int xlog_wait_on_iclog(struct xlog_in_core *iclog)
-		__releases(iclog->ic_log->l_icloglock);
+int xlog_wait_on_iclog(struct xlog *log, struct xlog_in_core *iclog)
+		__releases(log->l_icloglock);
 
 /* Calculate the distance between two LSNs in bytes */
 static inline uint64_t
-- 
2.53.0

