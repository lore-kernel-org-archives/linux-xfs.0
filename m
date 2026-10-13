Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5882D417BD2
	for <linux-xfs@vger.kernel.org>; Tue, 13 Oct 2026 06:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791871336; cv=none; b=aBYYoDakEE1jpn7VIzOelfbSLQlicP/f8+0QkCBa0eRBe6d3CE8YGCPjYzD/oea8I7+fVwzhAG3ffmt8VvV3fIf8kAW+Y/v3BzW5D6oi+LNDtwK/kCaFfV/2F4TjyM7v7Us8n0nRls/LhZvt0ZU81Akk8t7OGR2VYygujBVgjms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791871336; c=relaxed/simple;
	bh=EZuIqh03Nld/eualW3jqj0VuGO1APqOZRZ/92oq65HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHpget4y+b4KLxJBkqXH81LtnoeSLjSVtSVR36YGEMv3x52mYbq021JEO6adB8AUQ/yWKk2CJS/AvB83ulC+ighGjgAsqC7pI3+UGCZW9zVKi85XbQlBe1QPsiaxWxuFwLrWvIQAymOMxI4Gj6TXnPq94QCcI6tRwjGDXwe6jOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XRc/cWY1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XRc/cWY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6CD1F00893;
	Tue, 13 Oct 2026 06:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791871334;
	bh=BE7tDeEbWEMdkMVub36CV7IJk9YkN09cB1YMYup6xyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRc/cWY1AoPWK7UXCPoiteeHzXD80EhhKSnDkf8xWdYyAm67DHXpfVBUy7WLyrYsX
	 j9ML1OHrVt00YVDVfxRoQyWsi0ZdGA/NegNfFNB5kocazyYwm9YNE+icnQDLNBZhSS
	 SyPdV+X3NnliInP9DdwjVUVahBUYsIslB2Lwrwp9MafEFXeyFUCy2MYpmLpfQRt5e5
	 Tinqxkj9MHGLMPZ8jBdziwwk6leDRdnHlZkbGm3pJGw7wpWffgXuyB+yawdMwFEJO4
	 GrTU6aSaOh6Am7CsMJXeiN8uXAH3qputPtxRT+fj/vLLAieCR6DfV/dMMc8//mKoJ8
	 cBhZTHQAb0mWw==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 04/48] xfs: track transaction header decode state explicitly
Date: Tue, 13 Oct 2026 17:00:54 +1100
Message-ID: <20261013060204.3138690-5-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013060204.3138690-1-dgc@kernel.org>
References: <20261013060204.3138690-1-dgc@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xlog_recovery_process_trans() decides whether an incoming op record is (a
fragment of) the transaction header or a log item region by checking whether
the transaction's item queue is empty. That is an indirect signal: it
happens to be true only while the header is being assembled because no item
is added until the header is complete.

Replace it with an explicit bool r_hdr_decoded in struct xlog_recover. It is
set once the transaction header has been fully assembled in
xlog_recover_init_new_trans() - the same point at which the placeholder item
is added - and the routing check in xlog_recovery_process_trans() now tests
!r_hdr_decoded instead of list_empty(&trans->r_itemq).

r_hdr_decoded is zero-initialised to false when the transaction is allocated,
so no explicit initialisation is required. No functional change.

Changes:
- Add r_hdr_decoded to struct xlog_recover
- Set it when the transaction header is fully decoded in
  xlog_recover_init_new_trans()
- Use !r_hdr_decoded rather than an empty item queue to detect header ophdrs
  in xlog_recovery_process_trans()

Created-by-AI: Claude Opus 4.8 (1M context)

Prompt: The addition of r_hdr_decoded to replace the list_empty() check is
the second patch. [Refactor patch 2 of 4.]
---
 fs/xfs/libxfs/xfs_log_recover.h |  1 +
 fs/xfs/xfs_log_recover.c        | 24 ++++++++++++++----------
 2 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 9e712e62369c..ad73a1a6abf8 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -115,6 +115,7 @@ struct xlog_recover {
 	int			r_state;	/* not needed */
 	xfs_lsn_t		r_lsn;		/* xact lsn */
 	struct list_head	r_itemq;	/* q for items */
+	bool			r_hdr_decoded;	/* trans header fully decoded */
 };
 
 #define ITEM_TYPE(i)	(*(unsigned short *)(i)->ri_buf[0].iov_base)
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index b3e35df7a91b..d5d19769c217 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2155,15 +2155,19 @@ xlog_recover_init_new_trans(
 				sizeof(struct xfs_trans_header) - len;
 	}
 
+	memcpy(ptr, dp, len);
+
 	/*
-	 * Add an item to the transaction once the header is complete: for an
-	 * unsplit header that is this initial fragment (len == full header),
+	 * The header is complete once the full struct has been assembled: for
+	 * an unsplit header that is this initial fragment (len == full header),
 	 * and for a split header it is the continuation fragment that finishes
-	 * it.
+	 * it. Mark it decoded and add the item that subsequent log item regions
+	 * will be decoded into.
 	 */
-	if (cont || len == sizeof(struct xfs_trans_header))
+	if (cont || len == sizeof(struct xfs_trans_header)) {
+		trans->r_hdr_decoded = true;
 		xlog_recover_add_item(&trans->r_itemq);
-	memcpy(ptr, dp, len);
+	}
 	return 0;
 }
 
@@ -2319,14 +2323,14 @@ xlog_recovery_process_trans(
 		flags &= ~XLOG_CONTINUE_TRANS;
 
 	/*
-	 * An empty item queue means we are still decoding the transaction
-	 * header at the start of the transaction rather than a log item. The
-	 * header can arrive whole (flags == 0), as an initial fragment
-	 * (XLOG_CONTINUE_TRANS) or as a continuation fragment
+	 * Until the transaction header has been fully decoded we are still
+	 * assembling it at the start of the transaction rather than decoding a
+	 * log item. The header can arrive whole (flags == 0), as an initial
+	 * fragment (XLOG_CONTINUE_TRANS) or as a continuation fragment
 	 * (XLOG_WAS_CONT_TRANS); XLOG_WAS_CONT_TRANS distinguishes the
 	 * continuation.
 	 */
-	if (list_empty(&trans->r_itemq) &&
+	if (!trans->r_hdr_decoded &&
 	    (!flags || (flags & (XLOG_CONTINUE_TRANS | XLOG_WAS_CONT_TRANS)))) {
 		error = xlog_recover_init_new_trans(log, trans, dp, len,
 					flags & XLOG_WAS_CONT_TRANS);
-- 
2.55.0

