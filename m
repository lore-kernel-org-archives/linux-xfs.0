Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73741B5BB
	for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 23:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="PNqQJxWU"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5cf2d73a183so3080159a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 15 Jan 2024 15:01:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705359679; x=1705964479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yIE/laHa1vtqRcUgCHUsUwlwdeFPdNrUjJJgWMWqUtM=;
        b=PNqQJxWUZJYx6QnlKSZqIsD6pi2T/CjP1Etx4iagM9wMJzkGIXkUj/K2HiBglSGCPa
         HPpewD5kSCL+BxHXBeaN8BQCKHsROdo3+14dvcPgvptR+dinSNpQ5ddItyFj6ZAOe5y2
         J6k6iM2ojXwNuOh3VbBSOQg2gwHFV0hGF02RNbk6vn+Nu2I7cbzYsMw4u7KyEsKh2A7t
         CGJMNZffF2oiKmDItRk+Yb9z1JfxC9aXMbmRptZUceZe/FRSEtGi9dbzLctbD/lXvUnm
         bGSGnh8sR8NvrPb4nt8mXLD5v2CGY4phOoCR/RmO8lEaJn7NvXaaeHyTHEEEkf73GVUe
         madQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705359679; x=1705964479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yIE/laHa1vtqRcUgCHUsUwlwdeFPdNrUjJJgWMWqUtM=;
        b=Bxocwi9dZKulqv5fl3//GsBaAcMUKQCoZWFuMVKBd1fXJhunvzPEfJgBuZBIKDzb4O
         04cRCwvwh+HHXuCl3g40bpZEbiJF3VJYFI4kRkqRgGw/TvR1OmIG3PxNURjPJJZp/TrR
         z4uPcsd+caZGYW+b7EUM8N0BHkr9Nxer/GDLGm9ED/af2t0e+XOWm3drgykjFpUTKeJD
         sQEr+nPXdNhpja+RvloSR7EE+mRfgWIwS1VIjzg9HJm5cxuzIT+jcdTCQ6cT4/2DYm76
         rBD8E2voC2WsAyZAdLjK90ZKpHsIz5vE3gdqe48WF3ED0LXp9ab1I93lsEgBWZaicqpW
         JbpQ==
X-Gm-Message-State: AOJu0Yy/EzPjR961oTa+pn/e0eOgpAm2PLYKVF43hcaBe8eBpEI+xXZe
	RPxFejtt+qSXAVaitADNfvtbYNm6xrn1tAQw8yWx0ES+jfc=
X-Google-Smtp-Source: AGHT+IGiVRblViwM/5At1Ouc6xOrw46C9ZIpYeondQKnQtgKXwfrihweFsqQ2ayKBTUncTlIU/4GWw==
X-Received: by 2002:a17:90b:30cb:b0:28d:34e5:38f4 with SMTP id hi11-20020a17090b30cb00b0028d34e538f4mr9124403pjb.43.1705359678991;
        Mon, 15 Jan 2024 15:01:18 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id t16-20020a170902e85000b001d3d8c04331sm8099180plg.64.2024.01.15.15.01.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 15:01:18 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
	by dread.disaster.area with esmtp (Exim 4.96)
	(envelope-from <dave@fromorbit.com>)
	id 1rPVxE-00AtKN-0r;
	Tue, 16 Jan 2024 10:01:15 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.97)
	(envelope-from <dave@devoid.disaster.area>)
	id 1rPVxD-0000000H8g1-36lB;
	Tue, 16 Jan 2024 10:01:15 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-xfs@vger.kernel.org
Cc: willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 09/12] xfs: place intent recovery under NOFS allocation context
Date: Tue, 16 Jan 2024 09:59:47 +1100
Message-ID: <20240115230113.4080105-10-david@fromorbit.com>
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

When recovery starts processing intents, all of the initial intent
allocations are done outside of transaction contexts. That means
they need to specifically use GFP_NOFS as we do not want memory
reclaim to attempt to run direct reclaim of filesystem objects while
we have lots of objects added into deferred operations.

Rather than use GFP_NOFS for these specific allocations, just place
the entire intent recovery process under NOFS context and we can
then just use GFP_KERNEL for these allocations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_attr_item.c     |  2 +-
 fs/xfs/xfs_bmap_item.c     |  3 ++-
 fs/xfs/xfs_log_recover.c   | 18 ++++++++++++++----
 fs/xfs/xfs_refcount_item.c |  2 +-
 fs/xfs/xfs_rmap_item.c     |  2 +-
 5 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 0bf25a2ba3b6..e14e229fc712 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -513,7 +513,7 @@ xfs_attri_recover_work(
 		return ERR_PTR(error);
 
 	attr = kzalloc(sizeof(struct xfs_attr_intent) +
-			sizeof(struct xfs_da_args), GFP_NOFS | __GFP_NOFAIL);
+			sizeof(struct xfs_da_args), GFP_KERNEL | __GFP_NOFAIL);
 	args = (struct xfs_da_args *)(attr + 1);
 
 	attr->xattri_da_args = args;
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 029a6a8d0efd..e3c58090e976 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -445,7 +445,8 @@ xfs_bui_recover_work(
 	if (error)
 		return ERR_PTR(error);
 
-	bi = kmem_cache_zalloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	bi = kmem_cache_zalloc(xfs_bmap_intent_cache,
+			GFP_KERNEL | __GFP_NOFAIL);
 	bi->bi_whichfork = (map->me_flags & XFS_BMAP_EXTENT_ATTR_FORK) ?
 			XFS_ATTR_FORK : XFS_DATA_FORK;
 	bi->bi_type = map->me_flags & XFS_BMAP_EXTENT_TYPE_MASK;
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index e9ed43a833af..8c1d260bb9e1 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3443,12 +3443,19 @@ xlog_recover(
  * part of recovery so that the root and real-time bitmap inodes can be read in
  * from disk in between the two stages.  This is necessary so that we can free
  * space in the real-time portion of the file system.
+ *
+ * We run this whole process under GFP_NOFS allocation context. We do a
+ * combination of non-transactional and transactional work, yet we really don't
+ * want to recurse into the filesystem from direct reclaim during any of this
+ * processing. This allows all the recovery code run here not to care about the
+ * memory allocation context it is running in.
  */
 int
 xlog_recover_finish(
 	struct xlog	*log)
 {
-	int	error;
+	unsigned int	nofs_flags = memalloc_nofs_save();
+	int		error;
 
 	error = xlog_recover_process_intents(log);
 	if (error) {
@@ -3462,7 +3469,7 @@ xlog_recover_finish(
 		xlog_recover_cancel_intents(log);
 		xfs_alert(log->l_mp, "Failed to recover intents");
 		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
-		return error;
+		goto out_error;
 	}
 
 	/*
@@ -3483,7 +3490,7 @@ xlog_recover_finish(
 		if (error < 0) {
 			xfs_alert(log->l_mp,
 	"Failed to clear log incompat features on recovery");
-			return error;
+			goto out_error;
 		}
 	}
 
@@ -3508,9 +3515,12 @@ xlog_recover_finish(
 		 * and AIL.
 		 */
 		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
+		goto out_error;
 	}
 
-	return 0;
+out_error:
+	memalloc_nofs_restore(nofs_flags);
+	return error;
 }
 
 void
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index d850b9685f7f..14919b33e4fe 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -425,7 +425,7 @@ xfs_cui_recover_work(
 	struct xfs_refcount_intent	*ri;
 
 	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
-			GFP_NOFS | __GFP_NOFAIL);
+			GFP_KERNEL | __GFP_NOFAIL);
 	ri->ri_type = pmap->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK;
 	ri->ri_startblock = pmap->pe_startblock;
 	ri->ri_blockcount = pmap->pe_len;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index a40b92ac81e8..e473124e29cc 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -455,7 +455,7 @@ xfs_rui_recover_work(
 {
 	struct xfs_rmap_intent		*ri;
 
-	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
+	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
 
 	switch (map->me_flags & XFS_RMAP_EXTENT_TYPE_MASK) {
 	case XFS_RMAP_EXTENT_MAP:
-- 
2.43.0

