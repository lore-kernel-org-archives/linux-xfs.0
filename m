Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF06E1DDA2D
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881056; cv=none; b=qJV9wPRiNy7Hf/IKh624olr7gqKYghdIyZMByF5mTuzLrk/8aZqymBTZoVNbV9kfxJZaP5T/CtdmfHib/+aFhAmLl1J3kjgpI/FlKDEW6u5CdXXWdariZWB9Bmzs5GSUIeWI67a33bmhPWH/Nd/UdUZ33FIQVSYEZF1M/rA8gtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881056; c=relaxed/simple;
	bh=T7Wjg00+8Zlz88Jf6nNBEN9QXIiwlKpVlYrKOVduqn0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D8olOIeqRuwVeA8u8tedMVLjJ5iOCjHFzoSXfvvjlYzooM4x/sFUt0C5dVVSX3REFNwhgX24yR/YjwodMtXEUA37wNVp2it8Zxc7z/c7IiU/9cD5v43WaqQHIUBlAVSHWD5m2W7WlTqMyXz9RlzN7KoYnCMljetPz6S1hxiZR80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nzMibIXz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nzMibIXz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27991C4CEDD;
	Thu,  6 Feb 2025 22:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881055;
	bh=T7Wjg00+8Zlz88Jf6nNBEN9QXIiwlKpVlYrKOVduqn0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nzMibIXzYUk9y6/ET1kmMlVzcwrvTfhQf1A/dABa1PEq/rzTS0MD7/NutOTs/qFV4
	 gK1ElpA0RhtXi0+k6Aqgy/OlWBDPneVGoB0HRunGKz7f60qm6roRruGAcTsKSDVWnj
	 Pkh5mTxLskXxHvyB27zADlqj+hd3OOTjbn4p2Qbq15+GeNLsJ5roYf+6kPT8hvbk/f
	 FNFLAPw1KIAa+9lJY9L156lQhTfO3MUAWR+PmAwH5blpNks7bnUq/NXoqNeKX3ybwZ
	 L2eqrF/4h/1T7gcgEG26VvXv/KnfeO2VtsNM2h83tqr73NjBMBE32nC5jy91+t30G/
	 RDkvbNokXeUUw==
Date: Thu, 06 Feb 2025 14:30:54 -0800
Subject: [PATCH 01/17] libxfs: unmap xmbuf pages to avoid disaster
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086075.2738568.9520704150703509751.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
References: <173888086034.2738568.15125078367450007162.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

It turns out that there's a maximum mappings count, so we need to be
smartish about not overflowing that with too many xmbuf buffers.  This
needs to be a global value because high-agcount filesystems will create
a large number of xmbuf caches but this is a process-global limit.

Cc: <linux-xfs@vger.kernel.org> # v6.9.0
Fixes: 124b388dac17f5 ("libxfs: support in-memory buffer cache targets")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 include/cache.h  |    6 +++
 libxfs/buf_mem.c |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/cache.c   |   11 ++++++
 3 files changed, 115 insertions(+), 4 deletions(-)


diff --git a/include/cache.h b/include/cache.h
index 334ad26309e26d..279bf717ba335f 100644
--- a/include/cache.h
+++ b/include/cache.h
@@ -64,6 +64,8 @@ typedef unsigned int (*cache_node_hash_t)(cache_key_t, unsigned int,
 					  unsigned int);
 typedef int (*cache_node_compare_t)(struct cache_node *, cache_key_t);
 typedef unsigned int (*cache_bulk_relse_t)(struct cache *, struct list_head *);
+typedef int (*cache_node_get_t)(struct cache_node *);
+typedef void (*cache_node_put_t)(struct cache_node *);
 
 struct cache_operations {
 	cache_node_hash_t	hash;
@@ -72,6 +74,8 @@ struct cache_operations {
 	cache_node_relse_t	relse;
 	cache_node_compare_t	compare;
 	cache_bulk_relse_t	bulkrelse;	/* optional */
+	cache_node_get_t	get;		/* optional */
+	cache_node_put_t	put;		/* optional */
 };
 
 struct cache_hash {
@@ -107,6 +111,8 @@ struct cache {
 	cache_node_relse_t	relse;		/* memory free function */
 	cache_node_compare_t	compare;	/* comparison routine */
 	cache_bulk_relse_t	bulkrelse;	/* bulk release routine */
+	cache_node_get_t	get;		/* prepare cache node after get */
+	cache_node_put_t	put;		/* prepare to put cache node */
 	unsigned int		c_hashsize;	/* hash bucket count */
 	unsigned int		c_hashshift;	/* hash key shift */
 	struct cache_hash	*c_hash;	/* hash table buckets */
diff --git a/libxfs/buf_mem.c b/libxfs/buf_mem.c
index e5b91d3cfe0486..16cb038ba10e2a 100644
--- a/libxfs/buf_mem.c
+++ b/libxfs/buf_mem.c
@@ -34,6 +34,36 @@
 unsigned int	XMBUF_BLOCKSIZE;
 unsigned int	XMBUF_BLOCKSHIFT;
 
+long		xmbuf_max_mappings;
+static atomic_t	xmbuf_mappings;
+bool		xmbuf_unmap_early = false;
+
+static long
+get_max_mmap_count(void)
+{
+	char	buffer[64];
+	char	*p = NULL;
+	long	ret = -1;
+	FILE	*file;
+
+	file = fopen("/proc/sys/vm/max_map_count", "r");
+	if (!file)
+		return -1;
+
+	while (fgets(buffer, sizeof(buffer), file)) {
+		errno = 0;
+		ret = strtol(buffer, &p, 0);
+		if (errno || p == buffer)
+			continue;
+
+		/* only take half the maximum mmap count so others can use it */
+		ret /= 2;
+		break;
+	}
+	fclose(file);
+	return ret;
+}
+
 void
 xmbuf_libinit(void)
 {
@@ -45,6 +75,14 @@ xmbuf_libinit(void)
 
 	XMBUF_BLOCKSIZE = ret;
 	XMBUF_BLOCKSHIFT = libxfs_highbit32(XMBUF_BLOCKSIZE);
+
+	/*
+	 * Figure out how many mmaps we will use simultaneously.  Pick a low
+	 * default if we can't query procfs.
+	 */
+	xmbuf_max_mappings = get_max_mmap_count();
+	if (xmbuf_max_mappings < 0)
+		xmbuf_max_mappings = 1024;
 }
 
 /* Allocate a new cache node (aka a xfs_buf) */
@@ -105,7 +143,8 @@ xmbuf_cache_relse(
 	struct xfs_buf		*bp;
 
 	bp = container_of(node, struct xfs_buf, b_node);
-	xmbuf_unmap_page(bp);
+	if (bp->b_addr)
+		xmbuf_unmap_page(bp);
 	kmem_cache_free(xfs_buf_cache, bp);
 }
 
@@ -129,13 +168,50 @@ xmbuf_cache_bulkrelse(
 	return count;
 }
 
+static int
+xmbuf_cache_node_get(
+	struct cache_node	*node)
+{
+	struct xfs_buf		*bp =
+		container_of(node, struct xfs_buf, b_node);
+	int			error;
+
+	if (bp->b_addr != NULL)
+		return 0;
+
+	error = xmbuf_map_page(bp);
+	if (error) {
+		fprintf(stderr,
+ _("%s: %s can't mmap %u bytes at xfile offset %llu: %s\n"),
+				progname, __FUNCTION__, BBTOB(bp->b_length),
+				(unsigned long long)xfs_buf_daddr(bp),
+				strerror(error));
+		return error;
+	}
+
+	return 0;
+}
+
+static void
+xmbuf_cache_node_put(
+	struct cache_node	*node)
+{
+	struct xfs_buf		*bp =
+		container_of(node, struct xfs_buf, b_node);
+
+	if (xmbuf_unmap_early)
+		xmbuf_unmap_page(bp);
+}
+
 static struct cache_operations xmbuf_bcache_operations = {
 	.hash		= libxfs_bhash,
 	.alloc		= xmbuf_cache_alloc,
 	.flush		= xmbuf_cache_flush,
 	.relse		= xmbuf_cache_relse,
 	.compare	= libxfs_bcompare,
-	.bulkrelse	= xmbuf_cache_bulkrelse
+	.bulkrelse	= xmbuf_cache_bulkrelse,
+	.get		= xmbuf_cache_node_get,
+	.put		= xmbuf_cache_node_put,
 };
 
 /*
@@ -216,8 +292,24 @@ xmbuf_map_page(
 	pos = xfile->partition_pos + BBTOB(xfs_buf_daddr(bp));
 	p = mmap(NULL, BBTOB(bp->b_length), PROT_READ | PROT_WRITE, MAP_SHARED,
 			xfile->fcb->fd, pos);
-	if (p == MAP_FAILED)
-		return -errno;
+	if (p == MAP_FAILED) {
+		if (errno == ENOMEM && !xmbuf_unmap_early) {
+#ifdef DEBUG
+			fprintf(stderr, "xmbuf could not make mappings!\n");
+#endif
+			xmbuf_unmap_early = true;
+		}
+		return errno;
+	}
+
+	if (!xmbuf_unmap_early &&
+	    atomic_inc_return(&xmbuf_mappings) > xmbuf_max_mappings) {
+#ifdef DEBUG
+		fprintf(stderr, _("xmbuf hit too many mappings (%ld)!\n",
+					xmbuf_max_mappings);
+#endif
+		xmbuf_unmap_early = true;
+	}
 
 	bp->b_addr = p;
 	bp->b_flags |= LIBXFS_B_UPTODATE | LIBXFS_B_UNCHECKED;
@@ -230,6 +322,8 @@ void
 xmbuf_unmap_page(
 	struct xfs_buf		*bp)
 {
+	if (!xmbuf_unmap_early)
+		atomic_dec(&xmbuf_mappings);
 	munmap(bp->b_addr, BBTOB(bp->b_length));
 	bp->b_addr = NULL;
 }
diff --git a/libxfs/cache.c b/libxfs/cache.c
index 139c7c1b9e715e..af20f3854df93e 100644
--- a/libxfs/cache.c
+++ b/libxfs/cache.c
@@ -61,6 +61,8 @@ cache_init(
 	cache->compare = cache_operations->compare;
 	cache->bulkrelse = cache_operations->bulkrelse ?
 		cache_operations->bulkrelse : cache_generic_bulkrelse;
+	cache->get = cache_operations->get;
+	cache->put = cache_operations->put;
 	pthread_mutex_init(&cache->c_mutex, NULL);
 
 	for (i = 0; i < hashsize; i++) {
@@ -415,6 +417,13 @@ cache_node_get(
 			 */
 			pthread_mutex_lock(&node->cn_mutex);
 
+			if (node->cn_count == 0 && cache->get) {
+				int err = cache->get(node);
+				if (err) {
+					pthread_mutex_unlock(&node->cn_mutex);
+					goto next_object;
+				}
+			}
 			if (node->cn_count == 0) {
 				ASSERT(node->cn_priority >= 0);
 				ASSERT(!list_empty(&node->cn_mru));
@@ -503,6 +512,8 @@ cache_node_put(
 #endif
 	node->cn_count--;
 
+	if (node->cn_count == 0 && cache->put)
+		cache->put(node);
 	if (node->cn_count == 0) {
 		/* add unreferenced node to appropriate MRU for shaker */
 		mru = &cache->c_mrus[node->cn_priority];

