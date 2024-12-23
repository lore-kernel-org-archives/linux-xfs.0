Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDF21D6DA9
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989969; cv=none; b=R7kZl1b8jacVM2igHTedlC78W0juuGU4kDNxfZ709jLUOz4/4/4XD2nYR9TVWNk6Q+APuJ6n3cShdC69E87033MiRqAZt6gRDMKNEUbKcj6LFiHVzVckLlwZArFwNQZclUTBViUnUqpfWEidig6KdXzSvcP0IScrz7Ez23LfQNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989969; c=relaxed/simple;
	bh=tudfEeFdcnB/9VePZOyb9p/TRLHZ45upIrosIfeFcuY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qytf3bpP7ocpOO/VpccQTF8lwcv+B7fN/fqGJ3ZIJNnZyytTi0axbKQOELCLEn3qgz0z19tGb7shzFwFbeEa6z1PZ2j1pgs1a7aSLOYoBpjK9L6GDPphYi4d+zyW/dt1wwIYgTtv1d+Map77q9yeaZ1PeZCnhEQBJHF5HqJqiZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fIPxb/BH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fIPxb/BH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6735C4CED3;
	Mon, 23 Dec 2024 21:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989968;
	bh=tudfEeFdcnB/9VePZOyb9p/TRLHZ45upIrosIfeFcuY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fIPxb/BHvZOeAi6Lytnk9OwE1j/vrxhPbOwq2wT0N+ApiO8aseJjBTCg/GcsvO++6
	 QVg2HreKBlgEb29OymVyBMuE6ORTF+fRaeefzAWUvS2THfWlLLQ7lSqrQRzZ+9IewP
	 094j4dpQ6sUhHYS4/+ewn3QSoY+UnEDPAqHl8+vcb5c5iYL55uQtv8tqVv1BW8tx+I
	 CmjgGxQKbb4//vYtMo5BFKeRrOmOvddm/gakFXbnjhJ2ju0nQqXXgSGzrveRhnQCLf
	 jHeKz3qfYhBHHWeUYh+ZAXkLogS5R8CmnsHWnYjBBDvOyRokOx0giKb3+K9lfK3Hb1
	 1td0wmGvDgRYg==
Date: Mon, 23 Dec 2024 13:39:28 -0800
Subject: [PATCH 09/36] xfs: pass a pag to xfs_extent_busy_{search,reuse}
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940085.2293042.3744807243442293269.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: b6dc8c6dd2d3f230e1a554f869d6df4568a2dfbb

Replace the [mp,agno] tuple with the perag structure, which will become
more useful later.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h     |    2 +-
 libxfs/xfs_alloc.c       |    4 ++--
 libxfs/xfs_alloc_btree.c |    2 +-
 libxfs/xfs_rmap_btree.c  |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 97f5003ea53862..9505806131bc42 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -465,7 +465,7 @@ xfs_buf_readahead(
 #define XFS_EXTENT_BUSY_DISCARDED	0x01	/* undergoing a discard op. */
 #define XFS_EXTENT_BUSY_SKIP_DISCARD	0x02	/* do not discard */
 
-#define xfs_extent_busy_reuse(mp,ag,bno,len,user)	((void) 0)
+#define xfs_extent_busy_reuse(...)			((void) 0)
 /* avoid unused variable warning */
 #define xfs_extent_busy_insert(tp,pag,bno,len,flags)({ 	\
 	struct xfs_perag *__foo = pag;			\
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 19b38eaf45dd07..ed04e40856740b 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1248,7 +1248,7 @@ xfs_alloc_ag_vextent_small(
 	if (fbno == NULLAGBLOCK)
 		goto out;
 
-	xfs_extent_busy_reuse(args->mp, args->pag, fbno, 1,
+	xfs_extent_busy_reuse(args->pag, fbno, 1,
 			      (args->datatype & XFS_ALLOC_NOBUSY));
 
 	if (args->datatype & XFS_ALLOC_USERDATA) {
@@ -3610,7 +3610,7 @@ xfs_alloc_vextent_finish(
 		if (error)
 			goto out_drop_perag;
 
-		ASSERT(!xfs_extent_busy_search(mp, args->pag, args->agbno,
+		ASSERT(!xfs_extent_busy_search(args->pag, args->agbno,
 				args->len));
 	}
 
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 4a711f2463cd30..949cd18ab16a99 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -84,7 +84,7 @@ xfs_allocbt_alloc_block(
 	}
 
 	atomic64_inc(&cur->bc_mp->m_allocbt_blks);
-	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_ag.pag, bno, 1, false);
+	xfs_extent_busy_reuse(cur->bc_ag.pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index ada58e92645020..c261d6eae3bc3b 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -101,7 +101,7 @@ xfs_rmapbt_alloc_block(
 		return 0;
 	}
 
-	xfs_extent_busy_reuse(cur->bc_mp, pag, bno, 1, false);
+	xfs_extent_busy_reuse(pag, bno, 1, false);
 
 	new->s = cpu_to_be32(bno);
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);

