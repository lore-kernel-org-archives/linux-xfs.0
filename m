Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B44BC2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N8T4cDhW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0515EC433C7;
	Sun, 31 Dec 2023 22:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060936;
	bh=2XflNXwGPxbdfbMnsQDNXO92rFikpTWv3XkNFHtjmRc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=N8T4cDhW+AVfMD5vYFsDOkhF9ipLSPEy6Czln/zdayggG1NSRTQCrXn1TMF0qo4Cn
	 0yn3v0moeBXjD/w/5AEMIN0m9To+40E3/JK6WwD7UAWNNhxMFntQwJEiylJDNf5Fph
	 XO+njrgujyiytZubGEh/v+sZIuE0q7w6FQDj9fttMKY1L5ukbqTYrt7z4VM6byLIpp
	 ULmOuRbG98kou3AGXIBVgkay/Waf4PTlX4flVQMbMbg4OueJbOwVItKdgKEhsyEnQX
	 HVGdNDRxNCnrkDtM6gMoIKVbwPrO3+jcmA46jG9pL8DzGTeG7eXvmvSLgyFGdvsoA0
	 rOhR/g2eI+TmA==
Date: Sun, 31 Dec 2023 14:15:35 -0800
Subject: [PATCH 04/10] xfs: teach buftargs to maintain their own buffer
 hashtable
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992836.1794490.16423627618318729843.stgit@frogsfrogsfrogs>
In-Reply-To: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
References: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
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

Currently, cached buffers are indexed by per-AG hashtables.  This works
great for the data device, but won't work for in-memory btrees.  Make it
so that buftargs can index buffers too.

We accomplish this by hoisting the rhashtable and its lock into a
separate xfs_buf_cache structure and reworking various functions to use
it.  Next, we introduce to the buftarg a new XFS_BUFTARG_SELF_CACHED
flag to indicate that the buftarg's cache is active (vs. the per-ag
cache for the regular filesystem).

Finally, make it so that each xfs_buf points to its cache if there is
one.  This is how we distinguish uncached buffers from now on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h |    4 ++--
 libxfs/xfs_ag.c      |    6 +++---
 libxfs/xfs_ag.h      |    4 +---
 3 files changed, 6 insertions(+), 8 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 89e55dda511..9310752a9b2 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -546,8 +546,8 @@ unsigned int hweight8(unsigned int w);
 unsigned int hweight32(unsigned int w);
 unsigned int hweight64(__u64 w);
 
-static inline int xfs_buf_hash_init(struct xfs_perag *pag) { return 0; }
-static inline void xfs_buf_hash_destroy(struct xfs_perag *pag) { }
+#define xfs_buf_cache_init(bch)		(0)
+#define xfs_buf_cache_destroy(bch)	((void)0)
 
 static inline int xfs_iunlink_init(struct xfs_perag *pag) { return 0; }
 static inline void xfs_iunlink_destroy(struct xfs_perag *pag) { }
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 28a340d1122..8e40026436a 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -262,7 +262,7 @@ xfs_free_perag(
 		xfs_defer_drain_free(&pag->pag_intents_drain);
 
 		cancel_delayed_work_sync(&pag->pag_blockgc_work);
-		xfs_buf_hash_destroy(pag);
+		xfs_buf_cache_destroy(&pag->pag_bcache);
 
 		/* drop the mount's active reference */
 		xfs_perag_rele(pag);
@@ -392,7 +392,7 @@ xfs_initialize_perag(
 		pag->pagb_tree = RB_ROOT;
 #endif /* __KERNEL__ */
 
-		error = xfs_buf_hash_init(pag);
+		error = xfs_buf_cache_init(&pag->pag_bcache);
 		if (error)
 			goto out_remove_pag;
 
@@ -432,7 +432,7 @@ xfs_initialize_perag(
 		pag = radix_tree_delete(&mp->m_perag_tree, index);
 		if (!pag)
 			break;
-		xfs_buf_hash_destroy(pag);
+		xfs_buf_cache_destroy(&pag->pag_bcache);
 		xfs_defer_drain_free(&pag->pag_intents_drain);
 		kmem_free(pag);
 	}
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 67c3260ee78..fe5852873b8 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -104,9 +104,7 @@ struct xfs_perag {
 	int		pag_ici_reclaimable;	/* reclaimable inodes */
 	unsigned long	pag_ici_reclaim_cursor;	/* reclaim restart point */
 
-	/* buffer cache index */
-	spinlock_t	pag_buf_lock;	/* lock for pag_buf_hash */
-	struct rhashtable pag_buf_hash;
+	struct xfs_buf_cache	pag_bcache;
 
 	/* background prealloc block trimming */
 	struct delayed_work	pag_blockgc_work;

