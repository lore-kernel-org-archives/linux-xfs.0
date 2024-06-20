Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE16639AEB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 07:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718868133; cv=none; b=qWKdp/z+TiefZOAFPmJ4UUf1KxmdWqf+v6I0flB4Nstn0WFh5li7mIvT6U5X87k7fDi0WJx8aX28N0vnbhhhERhFELsG7w+lJpfrQMJ1VMC5EjkUoEfq0ZoM+E/1X1gDLfr/TNqJLppqqS2wsEbprCYAhoxHquBJdE3PZXJMu+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718868133; c=relaxed/simple;
	bh=DgxgOIKI+nipdHXTaxRxLSvpLJoo8Brp7+SZZku+nqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MaJQE/Xc+crivu5OFrM4EXOJHBscQPWwvqFfsogmnix+apZY+gR3W4mlTIPp5uXu2DKRZpMMThStZ0CwEh8vQFKWtx476/DVdNuMeWJT68dJh31JKySbpd/SPhSpIisqfnL1Xwc+5ItbUffLIGon0ZR4bpQeUbzCGvItfXZkuCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=z6dFJ+H9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="z6dFJ+H9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=B6o/gMsIQz/QF9dF7ECx00qQqqshzCqi5DwEnSr5XTk=; b=z6dFJ+H9nXIbPvIMe9SZDDDmC8
	PLXZN7zIbjEK4cxWml2WumWPW43AwC2yVJsCmJU3sFTY3okj51ZGwSywL2isN8vVDyqk5GCxTjJhb
	WErX1BDwyT2tI9SEQLFJt60EJFK+DKiMss68fx42XV63krBNRewSod2yVJObVC2A7NMOyR+8LwB8N
	kaHbn40wTu9E1HaJXM7MApNMdaCewhCa0gYDDz5AHuVlUcYOx/u1HDojA7FcjWEprcwcgh8JvDnn5
	+rUlAZeM1nv305042hvHYgyOl1SMVESZiZbxUg/qy1EYCmyFXD083FTWSB6jMZlvnP045Z9NmuIU3
	9OPt/qxQ==;
Received: from 2a02-8389-2341-5b80-3a9c-dc0d-9615-f1ed.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3a9c:dc0d:9615:f1ed] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sKC7X-00000003xcX-0hWY;
	Thu, 20 Jun 2024 07:22:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 08/11] xfs: track log space pinned by the AIL
Date: Thu, 20 Jun 2024 09:21:25 +0200
Message-ID: <20240620072146.530267-9-hch@lst.de>
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

Currently we track space used in the log by grant heads.
These store the reserved space as a physical log location and
combine both space reserved for future use with space already used in
the log in a single variable. The amount of space consumed in the
log is then calculated as the  distance between the log tail and
the grant head.

The problem with tracking the grant head as a physical location
comes from the fact that it tracks both log cycle count and offset
into the log in bytes in a single 64 bit variable. because the cycle
count on disk is a 32 bit number, this also limits the offset into
the log to 32 bits. ANd because that is in bytes, we are limited to
being able to track only 2GB of log space in the grant head.

Hence to support larger physical logs, we need to track used space
differently in the grant head. We no longer use the grant head for
guiding AIL pushing, so the only thing it is now used for is
determining if we've run out of reservation space via the
calculation in xlog_space_left().

What we really need to do is move the grant heads away from tracking
physical space in the log. The issue here is that space consumed in
the log is not directly tracked by the current mechanism - the
space consumed in the log by grant head reservations gets returned
to the free pool by the tail of the log moving forward. i.e. the
space isn't directly tracked or calculated, but the used grant space
gets "freed" as the physical limits of the log are updated without
actually needing to update the grant heads.

Hence to move away from implicit, zero-update log space tracking we
need to explicitly track the amount of physical space the log
actually consumes separately to the in-memory reservations for
operations that will be committed to the journal. Luckily, we
already track the information we need to calculate this in the AIL
itself.

That is, the space currently consumed by the journal is the maximum
LSN that the AIL has seen minus the current log tail. As we update
both of these items dynamically as the head and tail of the log
moves, we always know exactly how much space the journal consumes.

This means that we also know exactly how much space the currently
active reservations require, and exactly how much free space we have
remaining for new reservations to be made. Most importantly, we know
what these spaces are indepedently of the physical locations of
the head and tail of the log.

Hence by separating out the physical space consumed by the journal,
we can now track reservations in the grant heads purely as a byte
count, and the log can be considered full when the tail space +
reservation space exceeds the size of the log. This means we can use
the full 64 bits of grant head space for reservation space,
completely removing the 32 bit byte count limitation on log size
that they impose.

Hence the first step in this conversion is to track and update the
"log tail space" every time the AIL tail or maximum seen LSN
changes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_cil.c   | 9 ++++++---
 fs/xfs/xfs_log_priv.h  | 1 +
 fs/xfs/xfs_trans_ail.c | 9 ++++++---
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 482955f1fa1f9f..92ccac7f905448 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -772,14 +772,17 @@ xlog_cil_ail_insert(
 	 * always be the same (as iclogs can contain multiple commit records) or
 	 * higher LSN than the current head. We do this before insertion of the
 	 * items so that log space checks during insertion will reflect the
-	 * space that this checkpoint has already consumed.
+	 * space that this checkpoint has already consumed.  We call
+	 * xfs_ail_update_finish() so that tail space and space-based wakeups
+	 * will be recalculated appropriately.
 	 */
 	ASSERT(XFS_LSN_CMP(ctx->commit_lsn, ailp->ail_head_lsn) >= 0 ||
 			aborted);
 	spin_lock(&ailp->ail_lock);
-	ailp->ail_head_lsn = ctx->commit_lsn;
 	xfs_trans_ail_cursor_last(ailp, &cur, ctx->start_lsn);
-	spin_unlock(&ailp->ail_lock);
+	ailp->ail_head_lsn = ctx->commit_lsn;
+	/* xfs_ail_update_finish() drops the ail_lock */
+	xfs_ail_update_finish(ailp, NULLCOMMITLSN);
 
 	/* unpin all the log items */
 	list_for_each_entry(lv, &ctx->lv_chain, lv_list) {
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 4b8ef926044599..2896745989795d 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -440,6 +440,7 @@ struct xlog {
 
 	struct xlog_grant_head	l_reserve_head;
 	struct xlog_grant_head	l_write_head;
+	uint64_t		l_tail_space;
 
 	struct xfs_kobj		l_kobj;
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 5f03f82c46838e..6a106a05fae017 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -736,6 +736,8 @@ __xfs_ail_assign_tail_lsn(
 	if (!tail_lsn)
 		tail_lsn = ailp->ail_head_lsn;
 
+	WRITE_ONCE(log->l_tail_space,
+			xlog_lsn_sub(log, ailp->ail_head_lsn, tail_lsn));
 	trace_xfs_log_assign_tail_lsn(log, tail_lsn);
 	atomic64_set(&log->l_tail_lsn, tail_lsn);
 }
@@ -743,9 +745,10 @@ __xfs_ail_assign_tail_lsn(
 /*
  * Callers should pass the original tail lsn so that we can detect if the tail
  * has moved as a result of the operation that was performed. If the caller
- * needs to force a tail LSN update, it should pass NULLCOMMITLSN to bypass the
- * "did the tail LSN change?" checks. If the caller wants to avoid a tail update
- * (e.g. it knows the tail did not change) it should pass an @old_lsn of 0.
+ * needs to force a tail space update, it should pass NULLCOMMITLSN to bypass
+ * the "did the tail LSN change?" checks. If the caller wants to avoid a tail
+ * update (e.g. it knows the tail did not change) it should pass an @old_lsn of
+ * 0.
  */
 void
 xfs_ail_update_finish(
-- 
2.43.0

