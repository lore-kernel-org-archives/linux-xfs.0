Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08A2146594;
	Wed, 26 Jun 2024 04:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719377365; cv=none; b=h5Uk/i/vr8PsyUKI9cKkqCtfANJRhuqhB/u7SxmHzbKPEDjvD9KJ9x2X1IixO7qzDI7kt/tVYcWgSgcPQYdR6r9SJofgOK+qblSnMWcahx3Q0nGHLiuaXWjdodOwUTO/dkzKRb3FqsMhay2qh31KF/ZRuNp1BKG16MI06BA/rmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719377365; c=relaxed/simple;
	bh=/XkjArAHiE322CiZMPfObHlgW/RMCAiRCRH8Nl5ZAKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJ4qyMJWK7yU3qWEpjaeOJbXdO1I2xXlSIxtaMzTrT2U1bGp5oaAw7tFk67C6Q6/x1Q8+4zc7Ywtj536Oppnnb8AjXhLPE7Dsxvi+Vt31cRKR/iPkrqwyWPP5T4XoABvbceVgjg3BdDATfE0v2tG4GmP9fJI0XTW+ehmsrf5zD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TqHWnqDV; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TqHWnqDV"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-706524adf91so3705933b3a.2;
        Tue, 25 Jun 2024 21:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719377363; x=1719982163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ia+y2XUAKkEsHnpapl/NzpJUhlN1+pwNiWutjUJDqO0=;
        b=TqHWnqDVoZGNBmKqqpHS//XkhM07oTsXNXA3gbg9zeq4Mm0jMaqgirAqx7ZWtTOWVB
         6KNSUZ3dMWsGDspNHRGAySJZcGIuKLObePfV8WXjrefQFGdmkopxZObBsuuNXkqhbvBA
         r1zlqNCGAUCzPylb9euMChmgXOzSNZlL6lAbfHvp8vmHEK9YtM4ZJcEqYc1aqblSuOdQ
         b/m78e28764K2Mg5Uk+2hiyF3iBOOk7x1vNiQA9A7DfuD44ZHmMoXuMsI4aM7XQkIY9x
         jDlK6wlaHsEshrfCi9ywtr8gp4Y2tBs0YrhPbsNg2j1Ei3CobiAlG1pqkLW1c+kaLTK5
         DraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719377363; x=1719982163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ia+y2XUAKkEsHnpapl/NzpJUhlN1+pwNiWutjUJDqO0=;
        b=lnMdIIfN+YZ0wphpbC6uVuA6bkiOVyB0r8Ax8X/nog9hGxOV5/VXarg/16pkGh2Mv8
         nvOa4+k4PmJtSutwsWCxoBTmMt6ImuhbNaLWuyZKRip8BB7M+kuXJdQQyMMfluCo2Oiv
         dD/ZMFyHLo5e6UZFNhen7ndZ77dqxIp1bulOM7pggPxJ3CZGuRPUjaUM3sxRFDOBapEy
         efhXXf+pUHvm4lIKS0cIGf+HPtgFxkVf2ldaScuG2e3Z7ixDD6Q+z8yoE97hrtuHA8EH
         AU2t8fbkWDfoSIUCcnNDdzjY7ajEER3Vbd6FvbLgjIA6iA8Jt6NErO3Y+drolk2Tpv+H
         3vTQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2IZJqbXQAP3cHmp6NnoKPTdX+5+aJBbbSlC+hvNt+Ef9mdQubaOdRBydUgVFy/QnGhdwxBjiLK3N9PoYwyAESXOlhJFkfD9mftVzs4Fr2Kr7VxXkN322CmSvlf/3RCjTx/Fdr8mdq
X-Gm-Message-State: AOJu0YzRluMiUSrp5AxJY7kn/qdpxHnaNwY++2Qnc+DOZ8q+5aJ32Bd5
	46ltYWJab3V6Pg8vD3cYD3tRZCws8gPqVwur7IHGVFrvO5EyTHbV
X-Google-Smtp-Source: AGHT+IG/Bc1GoIWJ4CRmWuShWLy3jlZ9nXyWeWJ/Jq01pYg/5sulphJkFgE6i6mRtCwngJip3uO6Sg==
X-Received: by 2002:a05:6a20:1a01:b0:1bd:3a8:dd42 with SMTP id adf61e73a8af0-1bd03a8e020mr7913893637.44.1719377363068;
        Tue, 25 Jun 2024 21:49:23 -0700 (PDT)
Received: from localhost.localdomain ([43.135.72.207])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb321a8esm90110685ad.96.2024.06.25.21.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 21:49:22 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: david@fromorbit.com,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	alexjlzheng@tencent.com
Subject: [PATCH v3 2/2] xfs: make xfs_log_iovec independent from xfs_log_vec and free it early
Date: Wed, 26 Jun 2024 12:49:09 +0800
Message-ID: <20240626044909.15060-3-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <20240626044909.15060-1-alexjlzheng@tencent.com>
References: <20240626044909.15060-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jinliang Zheng <alexjlzheng@tencent.com>

When the contents of the xfs_log_vec/xfs_log_iovec combination are
written to iclog, xfs_log_iovec loses its meaning in continuing to exist
in memory, because iclog already has a copy of its contents. We only
need to keep xfs_log_vec that takes up very little memory to find the
xfs_log_item that needs to be added to AIL after we flush the iclog into
the disk log space.

Because xfs_log_iovec dominates most of the memory in the
xfs_log_vec/xfs_log_iovec combination, retaining xfs_log_iovec until
iclog is flushed into the disk log space and releasing together with
xfs_log_vec is a significant waste of memory.

This patch separates the memory of xfs_log_iovec from that of
xfs_log_vec, and releases the memory of xfs_log_iovec in advance to save
memory.

Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
---
 fs/xfs/xfs_log.c     |  2 ++
 fs/xfs/xfs_log.h     |  8 ++++++--
 fs/xfs/xfs_log_cil.c | 34 ++++++++++++++++++++--------------
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 49e676061f2f..84a01ce61c96 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2527,6 +2527,8 @@ xlog_write(
 			xlog_write_full(lv, ticket, iclog, &log_offset,
 					 &len, &record_cnt, &data_cnt);
 		}
+		if (lv->lv_flags & XFS_LOG_VEC_DYNAMIC)
+			kvfree(lv->lv_iovecp);
 	}
 	ASSERT(len == 0);
 
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index 9cc10acf7bcd..7d0ae93e9e79 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_LOG_H__
 #define __XFS_LOG_H__
 
+#define XFS_LOG_VEC_DYNAMIC	(1 << 0)
+
 struct xfs_cil_ctx;
 
 struct xfs_log_vec {
@@ -17,7 +19,8 @@ struct xfs_log_vec {
 	char			*lv_buf;	/* formatted buffer */
 	int			lv_bytes;	/* accounted space in buffer */
 	int			lv_buf_len;	/* aligned size of buffer */
-	int			lv_size;	/* size of allocated lv */
+	int			lv_size;	/* size of allocated iovecp + buf */
+	int			lv_flags;	/* lv flags */
 };
 
 extern struct kmem_cache *xfs_log_vec_cache;
@@ -71,7 +74,8 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
 	vec->i_len = len;
 
 	/* Catch buffer overruns */
-	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lv + lv->lv_size);
+	ASSERT((void *)lv->lv_buf + lv->lv_bytes <=
+	       (void *)lv->lv_iovecp + lv->lv_size);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f51cbc6405c1..0175bd68590a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -219,8 +219,7 @@ static inline int
 xlog_cil_iovec_space(
 	uint	niovecs)
 {
-	return round_up((sizeof(struct xfs_log_vec) +
-					niovecs * sizeof(struct xfs_log_iovec)),
+	return round_up(niovecs * sizeof(struct xfs_log_iovec),
 			sizeof(uint64_t));
 }
 
@@ -279,6 +278,7 @@ xlog_cil_alloc_shadow_bufs(
 
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		struct xfs_log_vec *lv;
+		struct xfs_log_iovec *lvec;
 		int	niovecs = 0;
 		int	nbytes = 0;
 		int	buf_size;
@@ -330,8 +330,8 @@ xlog_cil_alloc_shadow_bufs(
 		 * if we have no shadow buffer, or it is too small, we need to
 		 * reallocate it.
 		 */
-		if (!lip->li_lv_shadow ||
-		    buf_size > lip->li_lv_shadow->lv_size) {
+		lv = lip->li_lv_shadow;
+		if (!lv || buf_size > lv->lv_size) {
 			/*
 			 * We free and allocate here as a realloc would copy
 			 * unnecessary data. We don't use kvzalloc() for the
@@ -339,22 +339,27 @@ xlog_cil_alloc_shadow_bufs(
 			 * the buffer, only the log vector header and the iovec
 			 * storage.
 			 */
-			kvfree(lip->li_lv_shadow);
-			lv = xlog_kvmalloc(buf_size);
+			if (lv)
+				kvfree(lv->lv_iovecp);
+			else
+				lv = kmem_cache_alloc(xfs_log_vec_cache,
+						GFP_KERNEL | __GFP_NOFAIL);
 
-			memset(lv, 0, xlog_cil_iovec_space(niovecs));
+			memset(lv, 0, sizeof(struct xfs_log_vec));
+			lvec = xlog_kvmalloc(buf_size);
+			memset(lvec, 0, xlog_cil_iovec_space(niovecs));
 
+			lv->lv_flags |= XFS_LOG_VEC_DYNAMIC;
 			INIT_LIST_HEAD(&lv->lv_list);
 			lv->lv_item = lip;
 			lv->lv_size = buf_size;
 			if (ordered)
 				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
 			else
-				lv->lv_iovecp = (struct xfs_log_iovec *)&lv[1];
+				lv->lv_iovecp = lvec;
 			lip->li_lv_shadow = lv;
 		} else {
 			/* same or smaller, optimise common overwrite case */
-			lv = lip->li_lv_shadow;
 			if (ordered)
 				lv->lv_buf_len = XFS_LOG_VEC_ORDERED;
 			else
@@ -366,9 +371,9 @@ xlog_cil_alloc_shadow_bufs(
 		lv->lv_niovecs = niovecs;
 
 		/* The allocated data region lies beyond the iovec region */
-		lv->lv_buf = (char *)lv + xlog_cil_iovec_space(niovecs);
+		lv->lv_buf = (char *)lv->lv_iovecp +
+				xlog_cil_iovec_space(niovecs);
 	}
-
 }
 
 /*
@@ -502,7 +507,7 @@ xlog_cil_insert_format_items(
 			/* reset the lv buffer information for new formatting */
 			lv->lv_buf_len = 0;
 			lv->lv_bytes = 0;
-			lv->lv_buf = (char *)lv +
+			lv->lv_buf = (char *)lv->lv_iovecp +
 					xlog_cil_iovec_space(lv->lv_niovecs);
 		} else {
 			/* switch to shadow buffer! */
@@ -703,7 +708,7 @@ xlog_cil_free_logvec(
 	while (!list_empty(lv_chain)) {
 		lv = list_first_entry(lv_chain, struct xfs_log_vec, lv_list);
 		list_del_init(&lv->lv_list);
-		kvfree(lv);
+		kmem_cache_free(xfs_log_vec_cache, lv);
 	}
 }
 
@@ -1544,7 +1549,8 @@ xlog_cil_process_intents(
 		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
 		trace_xfs_cil_whiteout_mark(ilip);
 		len += ilip->li_lv->lv_bytes;
-		kvfree(ilip->li_lv);
+		kvfree(ilip->li_lv->lv_iovecp);
+		kmem_cache_free(xfs_log_vec_cache, ilip->li_lv);
 		ilip->li_lv = NULL;
 
 		xfs_trans_del_item(lip);
-- 
2.41.1

