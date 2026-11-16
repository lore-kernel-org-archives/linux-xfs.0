Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794871052;
	b=qUOL9lF5KGoSwxb5mZw/brzTicfunXlhHgHnUwzyx+hrainzU6lH5mhrIDIfx89kcwbY
	 z9X0xv86NGEoYCLKUKySVWzlUwrryOT/uC9Mz3cyyaOuJsh4ehYLwDn/4prBS2w9jgpd2
	 UtsggWWaUUI6w7ODaAUV8932gtWYwnD5zVJTQlX1Xm3P4gjeyrvyDfrE0+PvdEvL9t5Oq
	 NHEscIF1u9FXl0AtcHHz7hmPF29BUzoO7kHwFrQcp9BOVbqABLnGU7IHjPc7OqO9yp6JQ
	 jWVaKWLtC58rZwlfFa3cm1d+W//PMHakDPPejYfEGPIPJ0T7Yg/TU9VGDd0YZEJhJIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794871052;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=zNgP1OYAQxv13bTV/PhGDAf28ID/3rSANZZpoaPRcMo=;
	b=vbjGRRSprP/TUJ6b2qM5tx2O/fsy2tvZ8ETFxL7U6X9t1f3CZ/RqBiOP4PZHjj4PUKcT
	 kX21ckMyVZyLhp5/K3tRyD/WUSkUsScY7h0TzqDA+8lJPK0V1No/rsVSwVVmdUY2HVaZe
	 PtTt8b78cflINSlKBC1+N1n+cdkk86F9g0hD8BXmOwagR6ggMXc27hImo/7JdezL77OX0
	 Z5X2eC+dgnW368oi0zDzVnYY46gz+gQuGUBZ/E5rl/6jmEJiTuUnAN+FR7kquXBLrOl6e
	 eo7KcRjBVeCRDLc1mXRyR9A5cKxpMkKNVQrEb1d7Ny14f5x1JiYxrl5VBNYI8UoY+6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KQkP5u8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D56606A31C
	for <linux-xfs@vger.kernel.org>; Mon, 16 Nov 2026 23:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KQkP5u8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1C11F000C7;
	Mon, 16 Nov 2026 23:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794871052;
	bh=zNgP1OYAQxv13bTV/PhGDAf28ID/3rSANZZpoaPRcMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KQkP5u8FZV2gD0LAns9zxznen0QJV3T5tIZm0OdKiULu9xtNzp++6CJW12I4KP8qN
	 100QuQIoasDEyxEHXhGdXvCAX2WrrypV1hQHCWLfoa2G2dpq3Ip4eqAdOMqgD5JnJP
	 nCNlzfICbaeNyILNNaYHrBRXhyCI7c5LIgQg/K2Enfl8Dc4Cz96qSo5BwlK0wYP7Vj
	 Cx0OAIQNXMJDkfrxTqT2Kx71o7J7SVMMrAid9BOPyN1MZnNLjetp/XXBQJmS4hP1PQ
	 NLGBGM0d17aOzt3paFeQJA15LoD/pI7yaab68x6qrCglx+ocTQ2ZF+acFVEKAUxG00
	 PWgDr2Ga2hoRA==
From: Dave Chinner <dgc@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org
Subject: [PATCH 14/59] xfs: track transaction header decode state explicitly
Date: Tue, 17 Nov 2026 10:14:31 +1100
Message-ID: <20261116231707.3625263-15-dgc@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261116231707.3625263-1-dgc@kernel.org>
References: <20261116231707.3625263-1-dgc@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recovery decides whether an incoming op record is part of the transaction
header by checking whether the transaction item queue is empty. That is an
indirect signal. It only works because no item is added until the header is
complete.

Add an explicit flag to the recovery transaction. It is set once the header
has been fully assembled, at the same point the first item is added. Use it to
route op records instead of the item queue state. There is no functional
change.

Assisted-by: LLM
Signed-off-by: Dave Chinner <dgc@kernel.org>
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
index 494bf5ebfa7b..c50f85757216 100644
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

