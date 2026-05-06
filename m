Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6ED330D3B
	for <linux-xfs@vger.kernel.org>; Wed,  6 May 2026 01:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778032699; cv=none; b=cYNdgHE+2q7x+Uu23RvEQDbTmPPswjYi8quyd7FhBkmEQHUUIQZpzsVrZSSpEfLiu47tDkGKsniM7AItb56drmokKFkEAQ8ltPkVZscJe+3TqgYr4X6a5hJAsqJ+KyGbItsND7ONiFW31zB0/EDPJT7fPg82GvlqD84fGO+UT1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778032699; c=relaxed/simple;
	bh=rcO8ulmpbGQPNdB0TxJC3VEZhpZpvPlJtBi+4co/aSI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZS4HXG3mlFp+P6XNr5IAO00bl9932DiRS2JMgf5pOQsngO4jnvuMJKt3Bf2TwKbeOUL4AXptleAAFQm4bUTzvuArgcGMCLu5HnXUF7joubNcO1xbMl59ZJUpHjl6T1qVroDJRybaUEC/t/uuQnFlts8az65Vqp2MJs+tfn8SwUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X2aEiLN2; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X2aEiLN2"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-364eef1891dso3208788a91.1
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2026 18:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778032697; x=1778637497; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M9jHxAmQy2++8b+vISsxRivYL9TXnk3IUz05Xn3+dAg=;
        b=X2aEiLN2Mps8DzYDwaLCcqdGsif4IHHi7CgAaxWennIuiEVUjRJNwENTa7qU+sXBf/
         XEJj/1uIjeU5NAnJGLt05xBTTE27roDX+6OESr27a1ywqdqnPzqKup+5U+HnL/wCfFSf
         WxUHYtRq2SFcbd7xOC+WmMnd6+wXqSHNi/sVM8g3zd4oV8zUPNVJf+PkODLzgjxR1uT0
         e3qxjs902uvdL2UKr/qeMVXIOKsA3Y3ZYQvz01Wi4iPmr8wSdCQ3kmE2eTUpQd4UQ/lp
         KWbBeJED3HhRnHgkTFiN5+7T/ttim8gP7CA0CG6RRVaOaZmpcTILD/rhg0uUt7i1GJ4q
         ky4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778032697; x=1778637497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M9jHxAmQy2++8b+vISsxRivYL9TXnk3IUz05Xn3+dAg=;
        b=IspRd4tFhDLh5FIctGkXLp/yEaTfVB5gKp+K7A4omXzWFJEs4J3/f369pn2HMIV8vT
         H4kvU8HkDIfhaxbkS3lDtX49ju0x1Lppc9TJEOBQQqQtTPrf7oBR0mKw78EZcIA51ZoZ
         2weE/mFJpsBDmfxqcA5qBASfuDdWsLgt9CazMAVNJyysT2he8/yuRm0j7Z32HTHVrapN
         pyNq2hyliRyuL4PoTydbgCqDUFKXvvWUck0uylsRmQozK5GASvNYBSbsqi0DvqeGKRwT
         Ck62RRvK7QMMv2JLGHMjGD8mnxH9qotkF+wUOJXOV02jp4gbGudovVT6++To5flSPi4m
         ICSQ==
X-Gm-Message-State: AOJu0YxHaecxHvyAa+baABxU4oAq9NQQmwKmy3WIzsGCnSosmqyYhmkY
	c3x+HlVzt5L3ckgOe91s9tJ/hPZtIO/HhVtqYRtuxlCX0HyLiplDQ2/0
X-Gm-Gg: AeBDieuE/D96v2FytvGomtjKx0tnV92cPeKGXfO/9ffK1CScJ7jz7ucGCBZrL2+/HSz
	UDwm2WD3KKd3FeS2lgqi3yEgJKBy/8N8s9sTkY4wSffTlSERjwsrHkU9gpQcYb2nIcgNvyaQhhd
	5zBsbHoUZhPijjPnJ166PTsMpG7DJGAn4JctbWetVn1F9TKLRc7dlvWgzRJd45YtuS7qgEf1hvd
	cBX2qqJouHOh2369eMJVxDvqCgjntrR25ol9oIw5hHHBxZUPxMYk2Uw9FFDyI5OPbX0vIlUa5fy
	hC7GKQ4RWVXjP3913wHuX0QhNY/R10l535mEsya7Ri21EBzt0u7VeOaf3ij7nOP9hGWnjehiU7o
	Rfs8t0sk8jW9YG8YH7lFDXBUWuuZKifRkYgtgrIzBUJf/puioYs3dYiS2JRKDfii02StIR7aaob
	DWpjYoOecmYdVhBurw6YLaYPgUVeHn
X-Received: by 2002:a17:903:3c68:b0:2b2:4029:d77c with SMTP id d9443c01a7336-2ba7a207769mr13647515ad.23.1778032696822;
        Tue, 05 May 2026 18:58:16 -0700 (PDT)
Received: from localhost ([111.228.63.84])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ba7c9e0fb6sm7391095ad.40.2026.05.05.18.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 18:58:16 -0700 (PDT)
From: Cen Zhang <zzzccc427@gmail.com>
To: cem@kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baijiaju1990@gmail.com,
	Cen Zhang <zzzccc427@gmail.com>
Subject: [PATCH] xfs: snapshot current CIL sequence under xc_push_lock
Date: Wed,  6 May 2026 09:58:11 +0800
Message-Id: <20260506015811.3420895-1-zzzccc427@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

xlog_cil_force() and xlog_cil_flush() both use the current CIL
checkpoint sequence to request an immediate push.  They currently read
xc_current_sequence before xlog_cil_push_now() takes xc_push_lock.

The CIL push worker advances xc_current_sequence under xc_push_lock while
switching to a new checkpoint context.  If a current-checkpoint force reads
an old sequence and then publishes it as xc_push_seq after the worker has
moved to the next context, xlog_cil_push_work() can treat the request as a
previously pushed sequence and skip it via the push_seq < ctx->sequence
check.  That can leave the current dirty checkpoint unqueued by a
force/flush request.

Make xlog_cil_push_now() resolve push_seq == 0 to the current sequence
while holding xc_push_lock, and return the resolved sequence for tracing
and waiting.  Route xlog_cil_force() and xlog_cil_flush() through that path
so the current-sequence snapshot and xc_push_seq publication are serialized
with the context switch.

Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
---
 fs/xfs/xfs_log_cil.c  | 34 +++++++++++++++++-----------------
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index edc368938f30..6a1ced3c9314 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1707,24 +1707,25 @@ xlog_cil_push_background(
  * mechanism. Hence in this case we need to pass a flag to the push work to
  * indicate it needs to flush the commit record itself.
  */
-static void
+static xfs_csn_t
 xlog_cil_push_now(
 	struct xlog	*log,
-	xfs_lsn_t	push_seq,
+	xfs_csn_t	push_seq,
 	bool		async)
 {
 	struct xfs_cil	*cil = log->l_cilp;
 
 	if (!cil)
-		return;
-
-	ASSERT(push_seq && push_seq <= cil->xc_current_sequence);
+		return 0;
 
 	/* start on any pending background push to minimise wait time on it */
 	if (!async)
 		flush_workqueue(cil->xc_push_wq);
 
 	spin_lock(&cil->xc_push_lock);
+	if (!push_seq)
+		push_seq = cil->xc_current_sequence;
+	ASSERT(push_seq && push_seq <= cil->xc_current_sequence);
 
 	/*
 	 * If this is an async flush request, we always need to set the
@@ -1742,12 +1743,13 @@ xlog_cil_push_now(
 	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags) ||
 	    push_seq <= cil->xc_push_seq) {
 		spin_unlock(&cil->xc_push_lock);
-		return;
+		return push_seq;
 	}
 
 	cil->xc_push_seq = push_seq;
 	queue_work(cil->xc_push_wq, &cil->xc_ctx->push_work);
 	spin_unlock(&cil->xc_push_lock);
+	return push_seq;
 }
 
 bool
@@ -1880,16 +1882,16 @@ void
 xlog_cil_flush(
 	struct xlog	*log)
 {
-	xfs_csn_t	seq = log->l_cilp->xc_current_sequence;
+	struct xfs_cil	*cil = log->l_cilp;
+	xfs_csn_t	seq = xlog_cil_push_now(log, 0, true);
 
 	trace_xfs_log_force(log->l_mp, seq, _RET_IP_);
-	xlog_cil_push_now(log, seq, true);
 
 	/*
 	 * If the CIL is empty, make sure that any previous checkpoint that may
 	 * still be in an active iclog is pushed to stable storage.
 	 */
-	if (test_bit(XLOG_CIL_EMPTY, &log->l_cilp->xc_flags))
+	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
 		xfs_log_force(log->l_mp, 0);
 }
 
@@ -1911,12 +1913,7 @@ xlog_cil_force_seq(
 	struct xfs_cil		*cil = log->l_cilp;
 	struct xfs_cil_ctx	*ctx;
 	xfs_lsn_t		commit_lsn = NULLCOMMITLSN;
-
-	ASSERT(sequence <= cil->xc_current_sequence);
-
-	if (!sequence)
-		sequence = cil->xc_current_sequence;
-	trace_xfs_log_force(log->l_mp, sequence, _RET_IP_);
+	bool			traced = false;
 
 	/*
 	 * check to see if we need to force out the current context.
@@ -1924,7 +1921,11 @@ xlog_cil_force_seq(
 	 * so no need to deal with it here.
 	 */
 restart:
-	xlog_cil_push_now(log, sequence, false);
+	sequence = xlog_cil_push_now(log, sequence, false);
+	if (!traced) {
+		trace_xfs_log_force(log->l_mp, sequence, _RET_IP_);
+		traced = true;
+	}
 
 	/*
 	 * See if we can find a previous sequence still committing.
@@ -2066,4 +2067,3 @@ xlog_cil_destroy(
 	destroy_workqueue(cil->xc_push_wq);
 	kfree(cil);
 }
-
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index cf1e4ce61a8c..4ae98d3800ea 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -582,7 +582,7 @@ xfs_lsn_t xlog_cil_force_seq(struct xlog *log, xfs_csn_t sequence);
 static inline void
 xlog_cil_force(struct xlog *log)
 {
-	xlog_cil_force_seq(log, log->l_cilp->xc_current_sequence);
+	xlog_cil_force_seq(log, 0);
 }
 
 /*
