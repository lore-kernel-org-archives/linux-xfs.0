Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681D7639
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 07:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718868125; cv=none; b=mcioS6x5OMmO9f1vgLPe5vw4diZeklcH60+hs1CkkOIz5bwUl8qGX8diK8ES9zG9bOmlsNZ4ulPPf7WFzDy/1D/0I55pJjOsz2swZ5GqOIFk0FyGZP3DXQ7DpBQ58QFSYawPxHi5Q045sYUqEIKlnP4O484+S79TjCNFOV0eBIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718868125; c=relaxed/simple;
	bh=7qUQfR0v5+MKtQcvIZ5Oici1b50SxjLDGHkdcT1hbFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPdKyEgx+Mgct8q4eTa9Qf6zZrpxZtrvjcP+pEEpKBsXGar2HIXp6DKGaaD+AZsO9PbfVvOczM5D5Fn2GbHvXREQEfk9RqX03UjHoXUJBcelF9a93PhAn80nPP3czalw5SMPBP/gDOcyzwsrQKEdRexg/yyuaOwDhcVLfOR5okQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q0x+vQtG; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q0x+vQtG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zctmHu6Okd4YMSirlzAVygl3zsJVUtmYpw6crZL4imw=; b=q0x+vQtGoSjgBBy1O3Q4AD2smb
	j2TsD3P8GlwvAMq2go2yvPPz1XgO+fMzwYIqQNs8665ro/lWQ1r11FswLx+ojOUfLYgXBTUMwuJ9Q
	+uxdGctQl5EfWpo0L9dr0NwFPM6xRrj0z+5f0k3OSDUkRiWolVJzjZu8DQcxzUST/M5vB3W+a8xQv
	WDSREtM6pGIW5H9I9B0+a3H5VxecfryY2y0QvB4BcrkreqqVGzl11FhXqX2JOSMiTw0dc0zKnJayl
	Gl1zosrK9oYrZeU5Urv9Y794nrUqQMemMGCwL71cVkePgyBwEEl4dk8j3hTc4AOtb29SCmqW2PhX7
	sexa3qRw==;
Received: from 2a02-8389-2341-5b80-3a9c-dc0d-9615-f1ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3a9c:dc0d:9615:f1ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKC7P-00000003xa5-2iIA;
	Thu, 20 Jun 2024 07:22:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 05/11] xfs: ensure log tail is always up to date
Date: Thu, 20 Jun 2024 09:21:22 +0200
Message-ID: <20240620072146.530267-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240620072146.530267-1-hch@lst.de>
References: <20240620072146.530267-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Dave Chinner <dchinner@redhat.com>

Whenever we write an iclog, we call xlog_assign_tail_lsn() to update
the current tail before we write it into the iclog header. This
means we have to take the AIL lock on every iclog write just to
check if the tail of the log has moved.

This doesn't avoid races with log tail updates - the log tail could
move immediately after we assign the tail to the iclog header and
hence by the time the iclog reaches stable storage the tail LSN has
moved forward in memory. Hence the log tail LSN in the iclog header
is really just a point in time snapshot of the current state of the
AIL.

With this in mind, if we simply update the in memory log->l_tail_lsn
every time it changes in the AIL, there is no need to update the in
memory value when we are writing it into an iclog - it will already
be up-to-date in memory and checking the AIL again will not change
this. Hence xlog_state_release_iclog() does not need to check the
AIL to update the tail lsn and can just sample it directly without
needing to take the AIL lock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c       |  5 ++---
 fs/xfs/xfs_trans_ail.c | 17 +++++++++++++++--
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 235fcf6dc4eeb5..ae22f361627fe4 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -530,7 +530,6 @@ xlog_state_release_iclog(
 	struct xlog_in_core	*iclog,
 	struct xlog_ticket	*ticket)
 {
-	xfs_lsn_t		tail_lsn;
 	bool			last_ref;
 
 	lockdep_assert_held(&log->l_icloglock);
@@ -545,8 +544,8 @@ xlog_state_release_iclog(
 	if ((iclog->ic_state == XLOG_STATE_WANT_SYNC ||
 	     (iclog->ic_flags & XLOG_ICL_NEED_FUA)) &&
 	    !iclog->ic_header.h_tail_lsn) {
-		tail_lsn = xlog_assign_tail_lsn(log->l_mp);
-		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
+		iclog->ic_header.h_tail_lsn =
+				cpu_to_be64(atomic64_read(&log->l_tail_lsn));
 	}
 
 	last_ref = atomic_dec_and_test(&iclog->ic_refcnt);
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 26d4d9b3e35789..7d6ccd21aae2e5 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -720,6 +720,13 @@ xfs_ail_push_all_sync(
 	finish_wait(&ailp->ail_empty, &wait);
 }
 
+/*
+ * Callers should pass the original tail lsn so that we can detect if the tail
+ * has moved as a result of the operation that was performed. If the caller
+ * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
+ * "did the tail LSN change?" checks. If the caller wants to avoid a tail update
+ * (e.g. it knows the tail did not change) it should pass an @old_lsn of 0.
+ */
 void
 xfs_ail_update_finish(
 	struct xfs_ail		*ailp,
@@ -804,10 +811,16 @@ xfs_trans_ail_update_bulk(
 
 	/*
 	 * If this is the first insert, wake up the push daemon so it can
-	 * actively scan for items to push.
+	 * actively scan for items to push. We also need to do a log tail
+	 * LSN update to ensure that it is correctly tracked by the log, so
+	 * set the tail_lsn to NULLCOMMITLSN so that xfs_ail_update_finish()
+	 * will see that the tail lsn has changed and will update the tail
+	 * appropriately.
 	 */
-	if (!mlip)
+	if (!mlip) {
 		wake_up_process(ailp->ail_task);
+		tail_lsn = NULLCOMMITLSN;
+	}
 
 	xfs_ail_update_finish(ailp, tail_lsn);
 }
-- 
2.43.0

