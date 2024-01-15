Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1CC1B7EC
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 23:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="n5e+Z1QQ"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d4a2526a7eso50544985ad.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 15:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705359681; x=1705964481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XTU7Fr08s4rUxky9Yys2MV8QifwgSoaYIdZvg8gWTFY=;
        b=n5e+Z1QQxOzHKqhzwrZ/VvsXBn1VpG/jFTH2lEWurwTpUFS6Sh/jnmqgFIzhKMfFEx
         zMsOFicRf6gbMtqPCw9U9lmky+42ggexmvUoaiJC2rALZ9CPh+P2Z0n7+thtx39jiKle
         YHO1FF0PagWpndP2vqrlbO1W6y1CA8qUBovO+WstbePB0pj5Lb1VHbURW0FzviJgL/YL
         3beq/6cUl88ik5nP1lKBcgoZQ6gVOsGIdATUJDDEMqDlo9TXsrw+5HCYnGhtQnDhwlUA
         SQHJrbCrzGDsEi1IRUcZjGz+Ks6SAkEj/OMMcUhtqL208f65zcmKldzPupX9e4T2mcBm
         TO6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705359681; x=1705964481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XTU7Fr08s4rUxky9Yys2MV8QifwgSoaYIdZvg8gWTFY=;
        b=mhjd+xR6cJvYN+5vJ1csMSzw9sZqr9TjbuVdiRskDGWqdufDz4vPqfO2ontMVeqiJH
         P9nlvHYvmAHe00V+YxAUrYSzVskCKcX5qzRAiwPsDipYWv+WS8xzIjbZZbkxEkrHPGC0
         29a3WLGGx+cnhbCFk8ItueUgZuH/sZFVp21mLQANf66ZMkaXRobTzRFmEeOrfg8q0DKJ
         ZMQYl7zopBDO7v5ztDReH15rMExKFHpyLL1yUR/LRYJ1xaXsRX1vieFivBI08OjACO5Z
         DXLjk/RZqABnXlJHUmOWiUHOa2VOWezwMusHDG9ZR9jXhbtS4OZQ7hqK8xnrLqH3xroJ
         hKHw==
X-Gm-Message-State: AOJu0Yw/04D8toWVZ3eXZTFhSllD6+XL5W/6bos+1T+nKleH+F9xJvP/
	9Tb3h3T07dvlyz6quO2dJK43O/IyWlaOespCkdywgHPL4tw=
X-Google-Smtp-Source: AGHT+IGNiHk1RuGG1sc4v4L0zJg68Gv9p9I32eJCDEJ/+w/GY8Au5JZTtLDF5HjZXmrnuOPcXmWQew==
X-Received: by 2002:a17:902:c78b:b0:1d4:1bcc:416a with SMTP id w11-20020a170902c78b00b001d41bcc416amr2727232pla.30.1705359681657;
        Mon, 15 Jan 2024 15:01:21 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id jj7-20020a170903048700b001d472670a30sm8176436plb.162.2024.01.15.15.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 15:01:18 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rPVxE-00AtKR-0v;
	Tue, 16 Jan 2024 10:01:15 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rPVxD-0000000H8g6-3Een;
	Tue, 16 Jan 2024 10:01:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 10/12] xfs: place the CIL under nofs allocation context
Date: Tue, 16 Jan 2024 09:59:48 +1100
Message-ID: <20240115230113.4080105-11-david@fromorbit.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240115230113.4080105-1-david@fromorbit.com>
References: <20240115230113.4080105-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

This is core code that needs to run in low memory conditions and
can be triggered from memory reclaim. While it runs in a workqueue,
it really shouldn't be recursing back into the filesystem during
any memory allocation it needs to function.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 815a2181004c..8c3b09777006 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -100,7 +100,7 @@ xlog_cil_ctx_alloc(void)
 {
 	struct xfs_cil_ctx	*ctx;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_NOFS | __GFP_NOFAIL);
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents.extent_list);
 	INIT_LIST_HEAD(&ctx->log_items);
@@ -1116,11 +1116,18 @@ xlog_cil_cleanup_whiteouts(
  * same sequence twice.  If we get a race between multiple pushes for the same
  * sequence they will block on the first one and then abort, hence avoiding
  * needless pushes.
+ *
+ * This runs from a workqueue so it does not inherent any specific memory
+ * allocation context. However, we do not want to block on memory reclaim
+ * recursing back into the filesystem because this push may have been triggered
+ * by memory reclaim itself. Hence we really need to run under full GFP_NOFS
+ * contraints here.
  */
 static void
 xlog_cil_push_work(
 	struct work_struct	*work)
 {
+	unsigned int		nofs_flags = memalloc_nofs_save();
 	struct xfs_cil_ctx	*ctx =
 		container_of(work, struct xfs_cil_ctx, push_work);
 	struct xfs_cil		*cil = ctx->cil;
@@ -1334,12 +1341,14 @@ xlog_cil_push_work(
 	spin_unlock(&log->l_icloglock);
 	xlog_cil_cleanup_whiteouts(&whiteouts);
 	xfs_log_ticket_ungrant(log, ticket);
+	memalloc_nofs_restore(nofs_flags);
 	return;
 
 out_skip:
 	up_write(&cil->xc_ctx_lock);
 	xfs_log_ticket_put(new_ctx->ticket);
 	kfree(new_ctx);
+	memalloc_nofs_restore(nofs_flags);
 	return;
 
 out_abort_free_ticket:
@@ -1348,6 +1357,7 @@ xlog_cil_push_work(
 	if (!ctx->commit_iclog) {
 		xfs_log_ticket_ungrant(log, ctx->ticket);
 		xlog_cil_committed(ctx);
+		memalloc_nofs_restore(nofs_flags);
 		return;
 	}
 	spin_lock(&log->l_icloglock);
@@ -1356,6 +1366,7 @@ xlog_cil_push_work(
 	/* Not safe to reference ctx now! */
 	spin_unlock(&log->l_icloglock);
 	xfs_log_ticket_ungrant(log, ticket);
+	memalloc_nofs_restore(nofs_flags);
 }
 
 /*
-- 
2.43.0

