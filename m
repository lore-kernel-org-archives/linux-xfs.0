Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793275816;
	b=Y2weYAHjtnud1MHw7dDojAFoklymajgvX2uUWHRwM9O1cgkI6u/EIzzZdYgIRBkbdFDc
	 +Obi78XyawZPGntygxPU+AnwEZqUWJpL1cROPdm6HedJWojSHBzRAusSbUYezuCyjpU6z
	 7igbpMbg6S0uTXhVh0yP5u9KBgLhKzbxAQVsGgEXAp75gFCrcYkLkJWrJ7a/qPCBmopAA
	 f5jDXgUV/8PlsZafgWqO6u5mEjpKKnFRl5zOf6wHuwN1cyIXz86ADaWpvEuiXm2PmB+A8
	 MW5db/anbC6HwiNOUZuNFhBxdVRR7CNzFrpW/fIW2VJ7mRBtjR7XpAD7t4Z9L/zxtYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793275816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UkJiA8XZcJMShxiSNScIlxDEck2xt/Y9fca3HOybmDw=;
	b=tq2CUXFQumEJ0FaUAcKmO3bURChJqa5WcKeVtjGvLG1V94lZTVsvs9Q0dqFtLGdB+ZQq
	 k+kVXKhCt9ljEIFAW2LDQTUPNOVyjNOvcAlO+pq7v+0jtLCyTFF89CEPITT2UCYuc7Lpb
	 0HBNDp1qPtNYtPtOhvHMlfOoCvMvqeDvmyHq9vLet2NJtDy0tjoaTnU3Od1oRSeA0vemj
	 21U0y2ySdo5/JBl6eGf1ZN0TxbcxnludUXsgAOUNsZYdDpbxqRQj8//CmAdlkm8ubXNM5
	 1CMiSTT7U4YLb0pcqRCC1g3fogbg6r0mbhNAY3VTkX3n/seRfDY6zswDM69KnurenOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H9XDDqIx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DFF606A31E
	for <linux-xfs@vger.kernel.org>; Thu, 29 Oct 2026 12:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=H9XDDqIx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476741F031E1;
	Thu, 29 Oct 2026 12:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793275815;
	bh=UkJiA8XZcJMShxiSNScIlxDEck2xt/Y9fca3HOybmDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9XDDqIx+qoNdE1RoOr0XX2tZ2JcD6QhLLQVheN5D3Xz8izBoAg4c821FULZoaEZt
	 agNJ6z4t3J9n+msaTAzxxioH12u/YxfS9HGr8gXjRN58IMaPXepx8nSSdERTk2wb40
	 RBOP2vzqjrX+dICPX00CzKtBU6G8TmK0IU+V/R8RldvD9Gj6/Ffjnc2+NMP79hnq6a
	 iqnIqIbc0UuhNN3Asc/30r+VWNt5muYuUxCfLxuJcTSkClVpNmr9bIPP9mPK0H7Oo6
	 MCynHIdYsIN2YYo6mpPSvrpdDWdzpXPMQ6FFtlTHnMYjsAGZJCIxzIol3UggQNalL0
	 8FRW6fKGLzKwQ==
From: Andrey Albershteyn <aalbersh@kernel.org>
To: linux-xfs@vger.kernel.org
Cc: cem@kernel.org,
	cihan.cihan@gmail.com,
	cmaiolino@redhat.com,
	dchinner@redhat.com,
	dgc@kernel.org,
	djwong@kernel.org,
	floss@jetm.me,
	hch@lst.de,
	hemanth.selam@gmail.com,
	jiapenglin@tencent.com,
	johannes.thumshirn@wdc.com,
	kees+treewide@kernel.org,
	norbert@doyensec.com,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	yijiangshan@kylinos.cn,
	yun.zhou@windriver.com,
	zenghongling@kylinos.cn,
	Javier Tia <javier@peridio.com>
Subject: [PATCH 12/28] xfs: initialise error in xfs_defer_finish_one()
Date: Thu, 29 Oct 2026 13:06:09 +0100
Message-ID: <20261029120631.803074-13-aalbersh@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261029120631.803074-1-aalbersh@kernel.org>
References: <20261029120631.803074-1-aalbersh@kernel.org>
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

From: Javier Tia <javier@peridio.com>

Source kernel commit: 6176d21d7bd609632c5b7e87a3adb9be29ec1e72

xfs_defer_finish_one() declares error without an initialiser and only
assigns it inside the loop over dfp->dfp_work.  When that list is empty
the loop body never runs, control falls through to the "Done with the
dfp, free it" path, and the function returns an indeterminate value.

An item-less pending item reaches this through xfs_defer_add_barrier(),
which xfs_reap_ag_blocks() uses on any CONFIG_XFS_ONLINE_REPAIR kernel.
xfs_defer_finish_noroll() treats any non-EAGAIN return as fatal, so a
non-zero stack value turns a successful barrier into a
SHUTDOWN_CORRUPT_INCORE in the middle of a repair.  Zero is the correct
result: reaching the free path means the item loop drained without a
non-zero error.

Fixes: 3f3cec031099 ("xfs: force small EFIs for reaping btree extents")
Signed-off-by: Javier Tia <floss@jetm.me>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_defer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index ab1f81d8bcd2..4aa232fbd214 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -580,7 +580,7 @@ xfs_defer_finish_one(
 	const struct xfs_defer_op_type	*ops = dfp->dfp_ops;
 	struct xfs_btree_cur		*state = NULL;
 	struct list_head		*li, *n;
-	int				error;
+	int				error = 0;
 
 	trace_xfs_defer_pending_finish(tp->t_mountp, dfp);
 
-- 
2.54.0

