Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59251B7EA
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 23:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="KMUiIR2m"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-28ddd807e4bso2323009a91.3
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 15:01:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705359681; x=1705964481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tgxEN+dxuPsIPQ/X2jxskuPK8v7LK84zp/ZH+sCdiJw=;
        b=KMUiIR2mM6K4oYgwNLz5/r9E2V5txK/xSZkC/Gvd432M/5pvtefipDhNpiPPBfNNCc
         tK9hk5xszEZ5yCAU6DZQ10+qbgALP8emdzNn2rCVoKipOzX4yynxoEGki8i2qquiIcjN
         xRUVZ7GsVQVZD45ebe4U00AaI5rC1lNkwbnZforJrhsWdh9pMmUvd1SmAnxNT04T3Zxy
         N89RvIGhUNvpH+UE249wkiyI+lo/VI4Of9UpMFtKWyezu2Dv5inPvDVeM7boSTzUDnBP
         5CR/7BI+3uhkv8GweuC+FfxQpsn52ZrPu2oGCmRI/+D4s5JTJ9BYBvavK42hS6pOxwnT
         Jidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705359681; x=1705964481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tgxEN+dxuPsIPQ/X2jxskuPK8v7LK84zp/ZH+sCdiJw=;
        b=KCrDxqmMlWD6wSqf9saODuqp6mjBrQxXa2TajG5SS8j8rXiOX2i7jQyRnFIrGqSzJL
         AUqOdTSZshkmtBfXLAZGYVHZ99UZ7gmySB2De02+UmnaIxXU0rbxuNR+eZQtHsVfSvtn
         cVL+vmB2ayjmmbCK12xiH9L6pqZAjuf3QF7BnkP7YwvrgQAJjaJIZI3HciDhk//zKYGI
         rouGQVlZkOg/OFpa8Q8MWSPTAf3AsFJASp8rGdrrjoN3g49GVLNzFG5YcOKDgno+Tzuv
         C+O+5Z9yz6jgenwdCzvH3jcEKfPo0K3jZe9e8/AQbDi35MEFaWLVG/tosi0IxVtKZRCG
         AdBA==
X-Gm-Message-State: AOJu0YxCa400HydQCxto4SJW0V0bJ6ny7ZeQZwiZvW1g+fUtkBoRuLnK
	busliU26N7lfiyLmPEU7DBaGXXU5/dygB4E4wGE+wppR460=
X-Google-Smtp-Source: AGHT+IGzpNwsKNu7NVgPnlnsyEIybtI/t9LRuDCZhvbpZAVN6r4/IhKNwivF+6D2KG20ozQ0wahSCw==
X-Received: by 2002:a17:90a:e01:b0:28d:2cee:119e with SMTP id v1-20020a17090a0e0100b0028d2cee119emr3549236pje.39.1705359681331;
        Mon, 15 Jan 2024 15:01:21 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id sh2-20020a17090b524200b0028dfdfc9a8esm8737391pjb.37.2024.01.15.15.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 15:01:18 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rPVxE-00AtKZ-1D;
	Tue, 16 Jan 2024 10:01:15 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rPVxD-0000000H8gH-3WIC;
	Tue, 16 Jan 2024 10:01:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 12/12] xfs: use xfs_defer_alloc a bit more
Date: Tue, 16 Jan 2024 09:59:50 +1100
Message-ID: <20240115230113.4080105-13-david@fromorbit.com>
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

Noticed by inspection, simple factoring allows the same allocation
routine to be used for both transaction and recovery contexts.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_defer.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 8ae4401f6810..6ed3a5fda081 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -819,7 +819,7 @@ xfs_defer_can_append(
 /* Create a new pending item at the end of the transaction list. */
 static inline struct xfs_defer_pending *
 xfs_defer_alloc(
-	struct xfs_trans		*tp,
+	struct list_head		*dfops,
 	const struct xfs_defer_op_type	*ops)
 {
 	struct xfs_defer_pending	*dfp;
@@ -828,7 +828,7 @@ xfs_defer_alloc(
 			GFP_KERNEL | __GFP_NOFAIL);
 	dfp->dfp_ops = ops;
 	INIT_LIST_HEAD(&dfp->dfp_work);
-	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
+	list_add_tail(&dfp->dfp_list, dfops);
 
 	return dfp;
 }
@@ -846,7 +846,7 @@ xfs_defer_add(
 
 	dfp = xfs_defer_find_last(tp, ops);
 	if (!dfp || !xfs_defer_can_append(dfp, ops))
-		dfp = xfs_defer_alloc(tp, ops);
+		dfp = xfs_defer_alloc(&tp->t_dfops, ops);
 
 	xfs_defer_add_item(dfp, li);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
@@ -870,7 +870,7 @@ xfs_defer_add_barrier(
 	if (dfp)
 		return;
 
-	xfs_defer_alloc(tp, &xfs_barrier_defer_type);
+	xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
 
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
 }
@@ -885,14 +885,9 @@ xfs_defer_start_recovery(
 	struct list_head		*r_dfops,
 	const struct xfs_defer_op_type	*ops)
 {
-	struct xfs_defer_pending	*dfp;
+	struct xfs_defer_pending	*dfp = xfs_defer_alloc(r_dfops, ops);
 
-	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
-			GFP_KERNEL | __GFP_NOFAIL);
-	dfp->dfp_ops = ops;
 	dfp->dfp_intent = lip;
-	INIT_LIST_HEAD(&dfp->dfp_work);
-	list_add_tail(&dfp->dfp_list, r_dfops);
 }
 
 /*
-- 
2.43.0

