Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3C423A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442147; cv=none; b=CQFYSYht5GTOdJYmYwOILVHURDwOEePGlBSGK7IY+fNPvhCA6BQpLLQGYs8PPHIn+Y3ZczlJR/w0vX0cbUikczIDDs5M2jPQIzuRCHI+EcS+mfB670SBhdwEV6XwPt7OsoJ4ibu7uRHYEWla1cTOvlUlKl9oQsSKoLV+kzNMYwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442147; c=relaxed/simple;
	bh=bJ/4x1bxjfwfJ78EG9j5oGdliF98M1Kpq/EX1qBFcxk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rqq7CwnqzHhGN6yqML7a+OivnLnZPiSY8RP3BxPoAqcyIxwJDu4si+Tuv1gOMV1GdVmQD9xs1IuW2PBP/TfRGLYgPuxfb+1OxwjY1nMAe3il2N/Nd9kkO3tMEnKKjlCZCOcdb/fRsb8BgEdfKDIWq8eZX117vfjEIwvMmtf2MsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PwnEoEyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PwnEoEyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188E5C2BD10;
	Mon,  3 Jun 2024 19:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442147;
	bh=bJ/4x1bxjfwfJ78EG9j5oGdliF98M1Kpq/EX1qBFcxk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PwnEoEyq3fqr1EH3PsqaZ62qvm8v30f/psbuX8aA8+wrviMmzaUg4jBRO9MiFD7cl
	 1C5NbkonVsFK2p6hbHjDUaB6TAjTS48wuw7MyEfGkU6tMaI79h5zcvR/smy/QnvXjg
	 BftdXCgQNDPIanHUU0J8lMVIrRX3e9gthRFy1R1FACxKWlLDM2sfmpiEKrHTqfRnFY
	 NCswzl+gNrB2d1temjXxUQoEEONE2GCGwmp4VlvOYelqHsQM0niCZAMAI176VMcDM0
	 YLoTW1C3vM4rFfpNrtg39xgGNJT3TAEvFsx+QRQzRavd1lhIf8KbHbhPqAyVCtdNfn
	 FECuDGozgiJDg==
Date: Mon, 03 Jun 2024 12:15:46 -0700
Subject: [PATCH 091/111] xfs: teach buftargs to maintain their own buffer
 hashtable
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040732.1443973.4118242441323129965.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/libxfs_priv.h |    4 ++--
 libxfs/xfs_ag.c      |    6 +++---
 libxfs/xfs_ag.h      |    4 +---
 3 files changed, 6 insertions(+), 8 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 0a4f686d9..aee85c155 100644
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
index 389a8288e..06a881285 100644
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
index 19eddba09..29bfa6273 100644
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

