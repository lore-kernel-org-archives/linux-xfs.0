Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2634784D12
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711425131; cv=none; b=jHwfw/ZxqQ4eE48qQ3LgP+RAgPTPtHOflcL1vMULKJ9roE3ApNt68htAlvxtnnpPZA9hw+/fS/sLDfQLwxHQxMD9jp2HZx6n/IktvUTjzAhFADX7RFNXMkC30CDv0f5QprPDFI48HeJ8zLccKru4KsW3soYPkGjrhxpUrnZrVZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711425131; c=relaxed/simple;
	bh=se7C1ETqLXaSwnI5EBME9VInz/N918Nj/oTIZBFCJsI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gHGDkRHn/3bNnPqtrkigTyMlWdio1QZLmhrhr4JD0fEK8psq30BAGFZaeGAGB90SwertnSoRSEuiw3xR7SyocEpPry8P5ndYKyYQcNyYwaLvKuyYQB/sG9tHXkNpRNKHlsw+6R0hIEgCzrxzZF4jmbVeOfLy3PE5Cc09lh/uh2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u4j9W0W1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u4j9W0W1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9DAC433F1;
	Tue, 26 Mar 2024 03:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711425130;
	bh=se7C1ETqLXaSwnI5EBME9VInz/N918Nj/oTIZBFCJsI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u4j9W0W1c/7xGLLXlZwyxsrzVI85ylA5mkQKHuKLEotym8OXsK10yTXs8/vJVhNWO
	 Z3fZ/BpZAh9wOe2W7xLjPcQP65a+IpmrBFwAJFAA6zNdP4zLRwA1UhPowpsIDgxrtn
	 xiiCQ39U63VUDMplVll6bg5CF4IYn1n9raor/FL3AEWNk2+Yer4apJJ11b3aOQjaS5
	 qPEDCuu0j64Vt5xkRdw0nEFbnrvVhQa44B35721ES/Zbvvyqq+tYWPfFeNC72wgY4z
	 6wtxSqplv+ey7WZRtdlZSBiNjQOo48i76f6ihzY+72G/jxAUFOWGEbtqu4gvSdb0FP
	 E1C3cBNslaxBg==
Date: Mon, 25 Mar 2024 20:52:10 -0700
Subject: [PATCH 091/110] xfs: teach buftargs to maintain their own buffer
 hashtable
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132690.2215168.3431473743665175151.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: e7b58f7c1be20550d4f51cec6307b811e7555f52

Currently, cached buffers are indexed by per-AG hashtables.  This works
great for the data device, but won't work for in-memory btrees.  To
handle that use case, buftargs will need to be able to index buffers
independently of other data structures.

We accomplish this by hoisting the rhashtable and its lock into a
separate xfs_buf_cache structure, make the buftarg point to the
_buf_cache structure, and rework various functions to use it.  This
will enable the in-memory buftarg to come up with its own _buf_cache.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h |    4 ++--
 libxfs/xfs_ag.c      |    6 +++---
 libxfs/xfs_ag.h      |    4 +---
 3 files changed, 6 insertions(+), 8 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 0a4f686d9455..aee85c155abf 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -550,8 +550,8 @@ unsigned int hweight8(unsigned int w);
 unsigned int hweight32(unsigned int w);
 unsigned int hweight64(__u64 w);
 
-static inline int xfs_buf_hash_init(struct xfs_perag *pag) { return 0; }
-static inline void xfs_buf_hash_destroy(struct xfs_perag *pag) { }
+#define xfs_buf_cache_init(bch)		(0)
+#define xfs_buf_cache_destroy(bch)	((void)0)
 
 static inline int xfs_iunlink_init(struct xfs_perag *pag) { return 0; }
 static inline void xfs_iunlink_destroy(struct xfs_perag *pag) { }
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 389a8288e989..06a881285682 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -262,7 +262,7 @@ xfs_free_perag(
 		xfs_defer_drain_free(&pag->pag_intents_drain);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
-		xfs_buf_hash_destroy(pag);
+		xfs_buf_cache_destroy(&pag->pag_bcache);
 
 		/* drop the mount's active reference */
 		xfs_perag_rele(pag);
@@ -350,7 +350,7 @@ xfs_free_unused_perag_range(
 		spin_unlock(&mp->m_perag_lock);
 		if (!pag)
 			break;
-		xfs_buf_hash_destroy(pag);
+		xfs_buf_cache_destroy(&pag->pag_bcache);
 		xfs_defer_drain_free(&pag->pag_intents_drain);
 		kfree(pag);
 	}
@@ -417,7 +417,7 @@ xfs_initialize_perag(
 		pag->pagb_tree = RB_ROOT;
 #endif /* __KERNEL__ */
 
-		error = xfs_buf_hash_init(pag);
+		error = xfs_buf_cache_init(&pag->pag_bcache);
 		if (error)
 			goto out_remove_pag;
 
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 19eddba09894..29bfa6273dec 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -106,9 +106,7 @@ struct xfs_perag {
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
-	/* buffer cache index */
-	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
-	struct rhashtable pag_buf_hash;
+	struct xfs_buf_cache	pag_bcache;
 
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;

