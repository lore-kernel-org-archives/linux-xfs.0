Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976C639E6CA
	for <linux-xfs@vger.kernel.org>; Tue, 24 Feb 2026 13:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771941593; cv=none; b=K/nnbkfj0hVJuJRrRUP0ygZj/8EB+51HFJG+9gTrleqE4cWqkItrFwd77zmOmjahq9XozIAdAnD58Ix3Wx3xSNzxMVrUFJgW3+D915sgBm5WkyWKMDBXRhpk1jvxcKiEZOskcefE8aLLMslJc4CsbHWgL6Nn1deKTcTgLg9yyiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771941593; c=relaxed/simple;
	bh=FBxnKV8kJr/LukM8pzwQc7zZ56V3QGXClu1nE05wspQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUHt6ChEmw0Gz4/oWqFVZ/Tgy2tW8bn+/xEa+6/TyPgJGCGRx+7nhc/Uzdte1RMX6uO03wV4Z4mAI1QY5oLoDX1xHyI5kQ3WDGGSlBM4RUtchFDpwBZDctFx2VLspfrnS0Nff7AO1/MBeDmw3HLity1haSxuuGuoi3zW2edAKVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QXOYNxK8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QXOYNxK8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8wTNtNW+tq3ODqiJwB0fze/ARStJtqNXWXhjeZgmUWs=; b=QXOYNxK8TjnuSpNg5WBRkW5SJq
	mD0RoDG6I4v15Ji6fkTVoI01LqGRecyAwT+iT73Rlc8AM0+73G6wCuZvzAaQouJeE+QzszWvdWNpZ
	foz24TUyb9oVOkymLFWQRFUU4AtZZQXYpfGe8YfD1sIUBeJfVBUAJ2s4mmcbIAIro++u8QsTyz8+S
	Nwbq1sUOiAPR4+PU1tTsFI37FVI8DGx7GNlX2behvpy+3LQE+dDMkM8l4ZpgieMm16Xx2+r2z4jnf
	AlwbdHeZ4UX4qK5Sf/ybH6nQKydVeib4xM8IU5xWD4lsU5j1GDwnzRyho8dYkpDaYiBf9wLPbrYMb
	qZWS3uwg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vuswx-00000002Ald-0RJw;
	Tue, 24 Feb 2026 13:59:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: cleanup inode counter stats
Date: Tue, 24 Feb 2026 05:59:35 -0800
Message-ID: <20260224135942.364932-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224135942.364932-1-hch@lst.de>
References: <20260224135942.364932-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Most of them are unused, so mark them as such.  Give the remaining ones
names that match their use instead of the historic IRIX ones based on
vnodes.  Note that the names are purely internal to the XFS code, the
user interface is based on section names and arrays of counters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c |  6 +++---
 fs/xfs/xfs_stats.c  | 10 +++++-----
 fs/xfs/xfs_stats.h  | 16 ++++++++--------
 fs/xfs/xfs_super.c  |  4 ++--
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index dbaab4ae709f..f76c6decdaa3 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -106,7 +106,7 @@ xfs_inode_alloc(
 	mapping_set_folio_min_order(VFS_I(ip)->i_mapping,
 				    M_IGEO(mp)->min_folio_order);
 
-	XFS_STATS_INC(mp, vn_active);
+	XFS_STATS_INC(mp, xs_inodes_active);
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(ip->i_ino == 0);
 
@@ -172,7 +172,7 @@ __xfs_inode_free(
 	/* asserts to verify all state is correct here */
 	ASSERT(atomic_read(&ip->i_pincount) == 0);
 	ASSERT(!ip->i_itemp || list_empty(&ip->i_itemp->ili_item.li_bio_list));
-	XFS_STATS_DEC(ip->i_mount, vn_active);
+	XFS_STATS_DEC(ip->i_mount, xs_inodes_active);
 
 	call_rcu(&VFS_I(ip)->i_rcu, xfs_inode_free_callback);
 }
@@ -2234,7 +2234,7 @@ xfs_inode_mark_reclaimable(
 	struct xfs_mount	*mp = ip->i_mount;
 	bool			need_inactive;
 
-	XFS_STATS_INC(mp, vn_reclaim);
+	XFS_STATS_INC(mp, xs_inode_mark_reclaimable);
 
 	/*
 	 * We should never get here with any of the reclaim flags already set.
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 017db0361cd8..bc4a5d6dc795 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -42,7 +42,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "xstrat",		xfsstats_offset(xs_write_calls)	},
 		{ "rw",			xfsstats_offset(xs_attr_get)	},
 		{ "attr",		xfsstats_offset(xs_iflush_count)},
-		{ "icluster",		xfsstats_offset(vn_active)	},
+		{ "icluster",		xfsstats_offset(xs_inodes_active) },
 		{ "vnodes",		xfsstats_offset(xb_get)		},
 		{ "buf",		xfsstats_offset(xs_abtb_2)	},
 		{ "abtb2",		xfsstats_offset(xs_abtc_2)	},
@@ -100,15 +100,15 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 void xfs_stats_clearall(struct xfsstats __percpu *stats)
 {
 	int		c;
-	uint32_t	vn_active;
+	uint32_t	xs_inodes_active;
 
 	xfs_notice(NULL, "Clearing xfsstats");
 	for_each_possible_cpu(c) {
 		preempt_disable();
-		/* save vn_active, it's a universal truth! */
-		vn_active = per_cpu_ptr(stats, c)->s.vn_active;
+		/* save xs_inodes_active, it's a universal truth! */
+		xs_inodes_active = per_cpu_ptr(stats, c)->s.xs_inodes_active;
 		memset(per_cpu_ptr(stats, c), 0, sizeof(*stats));
-		per_cpu_ptr(stats, c)->s.vn_active = vn_active;
+		per_cpu_ptr(stats, c)->s.xs_inodes_active = xs_inodes_active;
 		preempt_enable();
 	}
 }
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 153d2381d0a8..64bc0cc18126 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -100,14 +100,14 @@ struct __xfsstats {
 	uint32_t		xs_iflush_count;
 	uint32_t		xs_icluster_flushcnt;
 	uint32_t		xs_icluster_flushinode;
-	uint32_t		vn_active;	/* # vnodes not on free lists */
-	uint32_t		vn_alloc;	/* # times vn_alloc called */
-	uint32_t		vn_get;		/* # times vn_get called */
-	uint32_t		vn_hold;	/* # times vn_hold called */
-	uint32_t		vn_rele;	/* # times vn_rele called */
-	uint32_t		vn_reclaim;	/* # times vn_reclaim called */
-	uint32_t		vn_remove;	/* # times vn_remove called */
-	uint32_t		vn_free;	/* # times vn_free called */
+	uint32_t		xs_inodes_active;
+	uint32_t		__unused_vn_alloc;
+	uint32_t		__unused_vn_get;
+	uint32_t		__unused_vn_hold;
+	uint32_t		xs_inode_destroy;
+	uint32_t		xs_inode_destroy2; /* same as xs_inode_destroy */
+	uint32_t		xs_inode_mark_reclaimable;
+	uint32_t		__unused_vn_free;
 	uint32_t		xb_get;
 	uint32_t		xb_create;
 	uint32_t		xb_get_locked;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8586f044a14b..28f700cd3942 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -712,8 +712,8 @@ xfs_fs_destroy_inode(
 	trace_xfs_destroy_inode(ip);
 
 	ASSERT(!rwsem_is_locked(&inode->i_rwsem));
-	XFS_STATS_INC(ip->i_mount, vn_rele);
-	XFS_STATS_INC(ip->i_mount, vn_remove);
+	XFS_STATS_INC(ip->i_mount, xs_inode_destroy);
+	XFS_STATS_INC(ip->i_mount, xs_inode_destroy2);
 	xfs_inode_mark_reclaimable(ip);
 }
 
-- 
2.47.3

