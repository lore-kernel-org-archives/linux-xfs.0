Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7E4A59
	for <linux-xfs@vger.kernel.org>; Sun, 26 Jan 2025 05:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737870630; cv=none; b=eB8GAm+uFRA9xJ3byTFbRc1SU9qtpvV9zmTSI4FktzhzgdIm4+KfDZGTjKcxKjVetut2YRZMJh4AVoZUjPqNrD1u1LoqUVHl/xDs7sqdMFpDXqJUEJ5lACAYAlJuVzS7g/1q/hNjFhJH5Jd5ncftZ1TD/j36hl9kNLo4PXs9Jp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737870630; c=relaxed/simple;
	bh=lb0+RdBXZ/xiMQdBLypJDBkwpIs7lhSGG4/aQkzaMd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eZQwJXAFID6eY46KKDW9tPfe0aCZKjI1agBxYKV+xR1dBs8AH+tLtcx8BPVSck7aq5YEhLNh/vSwGIg1q8qw4VCLHVrXockw81NH94l05zEtXEVc+nisz6O69Wq6ZRRr6tDbpqsb1n2HNq/BPCPkqeK1WpknGabsX2br6c0mTTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 27ACC68C4E; Sun, 26 Jan 2025 06:50:16 +0100 (CET)
Date: Sun, 26 Jan 2025 06:50:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Lai, Yi" <yi1.lai@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	yi1.lai@intel.com
Subject: Re: [PATCH 2/2] xfs: fix buffer lookup vs release race
Message-ID: <20250126055015.GA29873@lst.de>
References: <20250116060151.87164-1-hch@lst.de> <20250116060151.87164-3-hch@lst.de> <Z5SULlX2nVZIXggz@ly-workstation>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5SULlX2nVZIXggz@ly-workstation>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sat, Jan 25, 2025 at 03:35:10PM +0800, Lai, Yi wrote:
> Hi Christoph Hellwig,
> 
> Greetings!
> 
> I used Syzkaller and found that there is possible deadlock in xfs_buf_get_map in linux-next tag - next-20250121.

Oops yes.  I turns out this is fixed by the patch new in my queue,
which lead to finding the original race.  So something like the patch
below with a little more commit message language and a Fixes tag should
take care of it:

---
From 36df4ec6acdc876838ce1708e07a2d6cd1aebff2 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sun, 12 Jan 2025 07:00:04 +0100
Subject: xfs: remove xfs_buf_cache.bc_lock

xfs_buf_cache.bc_lock serializes adding buffers to and removing them from
the hashtable.  But as the rhashtable code already uses fine grained
internal locking for inserts and removals the extra protection isn't
actually required.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 20 ++++++++------------
 fs/xfs/xfs_buf.h |  1 -
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 601723135e8f..da3860d5666b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -41,8 +41,7 @@ struct kmem_cache *xfs_buf_cache;
  *
  * xfs_buf_rele:
  *	b_lock
- *	  pag_buf_lock
- *	    lru_lock
+ *	  lru_lock
  *
  * xfs_buftarg_drain_rele
  *	lru_lock
@@ -497,7 +496,6 @@ int
 xfs_buf_cache_init(
 	struct xfs_buf_cache	*bch)
 {
-	spin_lock_init(&bch->bc_lock);
 	return rhashtable_init(&bch->bc_hash, &xfs_buf_hash_params);
 }
 
@@ -647,17 +645,20 @@ xfs_buf_find_insert(
 	if (error)
 		goto out_free_buf;
 
-	spin_lock(&bch->bc_lock);
+	/* The new buffer keeps the perag reference until it is freed. */
+	new_bp->b_pag = pag;
+
+	rcu_read_lock();
 	bp = rhashtable_lookup_get_insert_fast(&bch->bc_hash,
 			&new_bp->b_rhash_head, xfs_buf_hash_params);
 	if (IS_ERR(bp)) {
+		rcu_read_unlock();
 		error = PTR_ERR(bp);
-		spin_unlock(&bch->bc_lock);
 		goto out_free_buf;
 	}
 	if (bp && xfs_buf_try_hold(bp)) {
 		/* found an existing buffer */
-		spin_unlock(&bch->bc_lock);
+		rcu_read_unlock();
 		error = xfs_buf_find_lock(bp, flags);
 		if (error)
 			xfs_buf_rele(bp);
@@ -665,10 +666,8 @@ xfs_buf_find_insert(
 			*bpp = bp;
 		goto out_free_buf;
 	}
+	rcu_read_unlock();
 
-	/* The new buffer keeps the perag reference until it is freed. */
-	new_bp->b_pag = pag;
-	spin_unlock(&bch->bc_lock);
 	*bpp = new_bp;
 	return 0;
 
@@ -1085,7 +1084,6 @@ xfs_buf_rele_cached(
 	}
 
 	/* we are asked to drop the last reference */
-	spin_lock(&bch->bc_lock);
 	__xfs_buf_ioacct_dec(bp);
 	if (!(bp->b_flags & XBF_STALE) && atomic_read(&bp->b_lru_ref)) {
 		/*
@@ -1097,7 +1095,6 @@ xfs_buf_rele_cached(
 			bp->b_state &= ~XFS_BSTATE_DISPOSE;
 		else
 			bp->b_hold--;
-		spin_unlock(&bch->bc_lock);
 	} else {
 		bp->b_hold--;
 		/*
@@ -1115,7 +1112,6 @@ xfs_buf_rele_cached(
 		ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
 		rhashtable_remove_fast(&bch->bc_hash, &bp->b_rhash_head,
 				xfs_buf_hash_params);
-		spin_unlock(&bch->bc_lock);
 		if (pag)
 			xfs_perag_put(pag);
 		freebuf = true;
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 7e73663c5d4a..3b4ed42e11c0 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -80,7 +80,6 @@ typedef unsigned int xfs_buf_flags_t;
 #define XFS_BSTATE_IN_FLIGHT	 (1 << 1)	/* I/O in flight */
 
 struct xfs_buf_cache {
-	spinlock_t		bc_lock;
 	struct rhashtable	bc_hash;
 };
 
-- 
2.45.2

