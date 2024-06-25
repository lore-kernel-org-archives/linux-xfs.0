Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C0E17D8A7;
	Tue, 25 Jun 2024 18:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719340139; cv=none; b=tZImAM8RFzb9FccDLdNBeWgA2j4sqv8gOhzpk3QURQt5sX7nZN0y8J5dqcn2WLadxPoKq8B0m1bGlwB3bxM71uGy+SfaAKT028pFelgHpp3YgYeKTq8w+X0olWjhjv8HkBKaDW3cX0zgncK+h8cw7oELJPjkfjA5WPXOlzLbSTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719340139; c=relaxed/simple;
	bh=C8y82fOMeodkebb5Q/oa65GJnn2jX/fvLuZPBh4C8DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wvcqd7xYSqaFwhkY4QEbKBsBShZHQqD3wYP/s9ggg0s5TF88Z6lsIr3qaGUXrSWqXhEp7PTXV5l7F6POnRJAX98mY6Ip22Wm5qCufxxzsSDmWGJSka4usutPp8/ujQo5RQ2RJlTCZX/3ymFi6MxUStafLbEzjlrdCuwnNGqmK8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AE07WouT; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AE07WouT"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7067108f2cdso2561050b3a.1;
        Tue, 25 Jun 2024 11:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719340137; x=1719944937; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LY9j5G3fdq5ypXEAkvCyErpGrL2adF9ZVg+3QvAwK7M=;
        b=AE07WouTY3zaVUh47VKJfFNYbJinOOgqe3jJ01HGdYFj/sFHVFq+9ti3WcSZ0CTJ/b
         c5jv8zPqm38LBxN37SkCF/lCCW5QaxzV+t9jWcckFsGaacldwSmFGGi6cQv+xm1XBWdH
         fx1BtKeO1AIvFQ9PdvlWhvzm3wS48cL9LiJt8Z9tchwA/AM/UoxYgBUr+iVopUnoCrg3
         LNzxZh2pOb7Nwvierv7A+4iq55+BI2nbhrvJpfopMxLi1C5pr36kkF6GmUs6CtpQUkDW
         xp/d7JttIQI5PDJPEOdWC0oZ63/kD+28UdvOC9Ag3Z8rjSsQK+F8JuQRAtUmIa19QCXN
         +iaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719340137; x=1719944937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LY9j5G3fdq5ypXEAkvCyErpGrL2adF9ZVg+3QvAwK7M=;
        b=UMPOEloHrri1o99K3/8HfQCLMmJLtWhc+jW10CxtstWlm0eyInx8yBmR9lyeS14oyL
         iUp5bphXpowXTkrMy3lPM6uNvOviOtTERNjb4Sai4nXecOuNjxGvUs/ugIjCjJlRusy/
         0T/QbY8RKr1hkCLFi51HtV1NisgioAekg6Y4ZzOuLIdARP/0n0L9+GANWjtdFAp4BaW5
         hSXVUvjr3Lx5+qvcXFYP7+RIfbLFFGBRbGPQnr5xcKDFQU67gRjSZ46ES4e8GBXgVxdr
         +LxafU5dwNngQUktOJqGMbf6xYytkf27O9dFRivJfSdaRTSmbczGxm/YH9L+qKJEfnMb
         KQcg==
X-Forwarded-Encrypted: i=1; AJvYcCVwAZwcAlRJ69pdXqK0W9/KGg9+etPq8Si5yB0emv5I6DwtpoyVx92jAZ8AXFtHuMFFoyY/NfhDl8MeTruJ3D/Q3BqtZYKE/gqBYCFKlO0fOdnSlR8qsiil8P/g9J6o2WeQE8xihyjs
X-Gm-Message-State: AOJu0Yw4Icozo+PWGRoMov6ZttdrFdzC+6VxpsGRJrLASBtpaVLUjGox
	9iYMixmJmR4GRWTyhR74hA6T0BzaIj6PHLDjA5YZQ6GBkrh4gZ6J
X-Google-Smtp-Source: AGHT+IH+U0eGKB3cCWWMo974S+/lA7WfcUT133b1Kt3yAVeScqse5Q9wrlKa4xYQmVnewo2ePxaWbg==
X-Received: by 2002:a05:6a20:551f:b0:1bd:24f6:576 with SMTP id adf61e73a8af0-1bd24f60623mr1754005637.48.1719340136800;
        Tue, 25 Jun 2024 11:28:56 -0700 (PDT)
Received: from localhost.localdomain ([43.135.72.207])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb320917sm84690555ad.75.2024.06.25.11.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 11:28:56 -0700 (PDT)
From: alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To: chandan.babu@oracle.com,
	djwong@kernel.org
Cc: david@fromorbit.com,
	hch@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	alexjlzheng@tencent.com
Subject: [PATCH xfs v2 2/2] xfs: make xfs_log_iovec independent from xfs_log_vec and free it early
Date: Wed, 26 Jun 2024 02:28:42 +0800
Message-ID: <20240625182842.1038809-3-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.41.1
In-Reply-To: <20240625182842.1038809-1-alexjlzheng@tencent.com>
References: <20240625182842.1038809-1-alexjlzheng@tencent.com>
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

Because xfs_log_iovec dominates most of the memory usage of the
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
 fs/xfs/xfs_log_cil.c | 33 ++++++++++++++++++++-------------
 3 files changed, 28 insertions(+), 15 deletions(-)

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
index 9cc10acf7bcd..035fda96bfcc 100644
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
@@ -42,6 +45,7 @@ static inline void
 xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
 		int data_len)
 {
+	struct xfs_log_iovec	*lvec = lv->lv_iovecp;
 	struct xlog_op_header	*oph = vec->i_addr;
 	int			len;
 
@@ -71,7 +75,7 @@ xlog_finish_iovec(struct xfs_log_vec *lv, struct xfs_log_iovec *vec,
 	vec->i_len = len;
 
 	/* Catch buffer overruns */
-	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lv + lv->lv_size);
+	ASSERT((void *)lv->lv_buf + lv->lv_bytes <= (void *)lvec + lv->lv_size);
 }
 
 /*
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f51cbc6405c1..7cc9ed0aa14a 100644
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
@@ -339,18 +339,24 @@ xlog_cil_alloc_shadow_bufs(
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
@@ -366,9 +372,9 @@ xlog_cil_alloc_shadow_bufs(
 		lv->lv_niovecs = niovecs;
 
 		/* The allocated data region lies beyond the iovec region */
-		lv->lv_buf = (char *)lv + xlog_cil_iovec_space(niovecs);
+		lv->lv_buf = (char *)lv->lv_iovecp +
+				xlog_cil_iovec_space(niovecs);
 	}
-
 }
 
 /*
@@ -502,7 +508,7 @@ xlog_cil_insert_format_items(
 			/* reset the lv buffer information for new formatting */
 			lv->lv_buf_len = 0;
 			lv->lv_bytes = 0;
-			lv->lv_buf = (char *)lv +
+			lv->lv_buf = (char *)lv->lv_iovecp +
 					xlog_cil_iovec_space(lv->lv_niovecs);
 		} else {
 			/* switch to shadow buffer! */
@@ -703,7 +709,7 @@ xlog_cil_free_logvec(
 	while (!list_empty(lv_chain)) {
 		lv = list_first_entry(lv_chain, struct xfs_log_vec, lv_list);
 		list_del_init(&lv->lv_list);
-		kvfree(lv);
+		kmem_cache_free(xfs_log_vec_cache, lv);
 	}
 }
 
@@ -1544,7 +1550,8 @@ xlog_cil_process_intents(
 		set_bit(XFS_LI_WHITEOUT, &ilip->li_flags);
 		trace_xfs_cil_whiteout_mark(ilip);
 		len += ilip->li_lv->lv_bytes;
-		kvfree(ilip->li_lv);
+		kvfree(ilip->li_lv->lv_iovecp);
+		kmem_cache_free(xfs_log_vec_cache, ilip->li_lv);
 		ilip->li_lv = NULL;
 
 		xfs_trans_del_item(lip);
-- 
2.39.3

