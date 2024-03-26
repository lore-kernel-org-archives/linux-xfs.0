Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F121292D6
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423564; cv=none; b=H8W86A3/SADHZwkJzIS27asv82XbGMCCfh02eLyibkMB8V4wNZvXVPfas6J4KizLEQ0q6zoeRfrTorW7oRpZcjTFxO/IwrCCoQmeSHD/7fK4OrgQfPWNDM4lRAs/ar41Y/6hsb8IWIh79C3veHGtBp/9WpNDxXwPzcqqReaXs58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423564; c=relaxed/simple;
	bh=beOZe5C+mTpck5TIr9K6XFr6a31qIMXK3fxegwrll1g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jTLgeAbCSD05NjD6aYObPjGNplpfulVF5CF5btyAiEeRcZ+pBYXuA41aRi8heNCpmvp0aVClfc8wSStrRNM1C+f69DA5lls3oH26ltQJQLArCDc51Pc77W3U5C2Bq6ncYB4rZC1M2jj+ZS6ZkQWXznQUdZmrC5ktTGj8QSlcs5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CxZaiRLW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CxZaiRLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F22AC433F1;
	Tue, 26 Mar 2024 03:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423564;
	bh=beOZe5C+mTpck5TIr9K6XFr6a31qIMXK3fxegwrll1g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CxZaiRLWKsYbxeAe67ASsOk2aUDQYJ+7SUiMWLki8kUTBkA2p5EGAQDdpAtHlm9z/
	 x2mVwJ8EkkqR0jL3LH/MFpCX7oBGeMllXEs4audbleDvaokzOXb08L05is0v3dvRV3
	 hHfrUa2lpaNawU6SunBKX5YwdzN/DHiIw7j+Ej+ESzNdO94+UNJzHOeOeWyg4T0H+M
	 BIf9BaO8th2pqrjt1DY4g8MjkuCcytRIFsgABOHy1O/JV8ESBbKzjyCdEjHWA877rf
	 dhM3z7zWR4JNDItEkOZAFcmUBNcrCjxKMmZb6UQy6Ag7YgFuuDsLk8Jr/IDMmgGVgL
	 CwlL1Np0EjSdQ==
Date: Mon, 25 Mar 2024 20:26:03 -0700
Subject: [PATCH 2/8] xfs_repair: slab and bag structs need to track more than
 2^32 items
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: "Darrick J. Wong" <djwong@djwong.org>, Christoph Hellwig <hch@lst.de>,
 linux-xfs@vger.kernel.org
Message-ID: <171142130384.2214793.3729469892994192371.stgit@frogsfrogsfrogs>
In-Reply-To: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
References: <171142130345.2214793.404306215329902244.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@djwong.org>

Currently, the xfs_slab data structure in xfs_repair is used to stage
incore reverse mapping and reference count records to build the ondisk
rmapbt and refcountbt during phase 5.

On a reflink filesystem, it's possible for there to be more than 2^32
forward mappings in an AG, which means that there could be more than
2^32 rmapbt records too.  Widen the size_t fields of xfs_slab to u64
accomodate this.

Similarly, the xfs_bag structure holds pointers to xfs_slab objects.
This abstraction tracks rmapbt records as we walk through the AG space
building refcount records.  It's possible for there to be more than 2^32
mappings to a piece of physical space, so we need to side the size_t
fields of xfs_bag to u64 as well.

In the next patch we'll fix all the users of these two structures; this
is merely the preparatory patch.

Signed-off-by: Darrick J. Wong <djwong@djwong.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/slab.c |   36 ++++++++++++++++++------------------
 repair/slab.h |   36 +++++++++++++++++++-----------------
 2 files changed, 37 insertions(+), 35 deletions(-)


diff --git a/repair/slab.c b/repair/slab.c
index 165f97efd29d..01bc4d426fea 100644
--- a/repair/slab.c
+++ b/repair/slab.c
@@ -41,18 +41,18 @@
 /* and cannot be larger than 128M */
 #define MAX_SLAB_SIZE		(128 * 1048576)
 struct xfs_slab_hdr {
-	size_t			sh_nr;
-	size_t			sh_inuse;	/* items in use */
+	uint32_t		sh_nr;
+	uint32_t		sh_inuse;	/* items in use */
 	struct xfs_slab_hdr	*sh_next;	/* next slab hdr */
 						/* objects follow */
 };
 
 struct xfs_slab {
-	size_t			s_item_sz;	/* item size */
-	size_t			s_nr_slabs;	/* # of slabs */
-	size_t			s_nr_items;	/* # of items */
+	uint64_t		s_nr_slabs;	/* # of slabs */
+	uint64_t		s_nr_items;	/* # of items */
 	struct xfs_slab_hdr	*s_first;	/* first slab header */
 	struct xfs_slab_hdr	*s_last;	/* last sh_next pointer */
+	size_t			s_item_sz;	/* item size */
 };
 
 /*
@@ -64,13 +64,13 @@ struct xfs_slab {
  */
 struct xfs_slab_hdr_cursor {
 	struct xfs_slab_hdr	*hdr;		/* a slab header */
-	size_t			loc;		/* where we are in the slab */
+	uint32_t		loc;		/* where we are in the slab */
 };
 
 typedef int (*xfs_slab_compare_fn)(const void *, const void *);
 
 struct xfs_slab_cursor {
-	size_t				nr;		/* # of per-slab cursors */
+	uint64_t			nr;		/* # of per-slab cursors */
 	struct xfs_slab			*slab;		/* pointer to the slab */
 	struct xfs_slab_hdr_cursor	*last_hcur;	/* last header we took from */
 	xfs_slab_compare_fn		compare_fn;	/* compare items */
@@ -83,8 +83,8 @@ struct xfs_slab_cursor {
  */
 #define MIN_BAG_SIZE	4096
 struct xfs_bag {
-	size_t			bg_nr;		/* number of pointers */
-	size_t			bg_inuse;	/* number of slots in use */
+	uint64_t		bg_nr;		/* number of pointers */
+	uint64_t		bg_inuse;	/* number of slots in use */
 	void			**bg_ptrs;	/* pointers */
 };
 #define BAG_END(bag)	(&(bag)->bg_ptrs[(bag)->bg_nr])
@@ -137,7 +137,7 @@ static void *
 slab_ptr(
 	struct xfs_slab		*slab,
 	struct xfs_slab_hdr	*hdr,
-	size_t			idx)
+	uint32_t		idx)
 {
 	char			*p;
 
@@ -155,12 +155,12 @@ slab_add(
 	struct xfs_slab		*slab,
 	void			*item)
 {
-	struct xfs_slab_hdr		*hdr;
+	struct xfs_slab_hdr	*hdr;
 	void			*p;
 
 	hdr = slab->s_last;
 	if (!hdr || hdr->sh_inuse == hdr->sh_nr) {
-		size_t n;
+		uint32_t	n;
 
 		n = (hdr ? hdr->sh_nr * 2 : MIN_SLAB_NR);
 		if (n * slab->s_item_sz > MAX_SLAB_SIZE)
@@ -308,7 +308,7 @@ peek_slab_cursor(
 	struct xfs_slab_hdr_cursor	*hcur;
 	void			*p = NULL;
 	void			*q;
-	size_t			i;
+	uint64_t		i;
 
 	cur->last_hcur = NULL;
 
@@ -370,7 +370,7 @@ pop_slab_cursor(
 /*
  * Return the number of items in the slab.
  */
-size_t
+uint64_t
 slab_count(
 	struct xfs_slab	*slab)
 {
@@ -429,7 +429,7 @@ bag_add(
 	p = &bag->bg_ptrs[bag->bg_inuse];
 	if (p == BAG_END(bag)) {
 		/* No free space, alloc more pointers */
-		size_t nr;
+		uint64_t	nr;
 
 		nr = bag->bg_nr * 2;
 		x = realloc(bag->bg_ptrs, nr * sizeof(void *));
@@ -450,7 +450,7 @@ bag_add(
 int
 bag_remove(
 	struct xfs_bag	*bag,
-	size_t		nr)
+	uint64_t	nr)
 {
 	ASSERT(nr < bag->bg_inuse);
 	memmove(&bag->bg_ptrs[nr], &bag->bg_ptrs[nr + 1],
@@ -462,7 +462,7 @@ bag_remove(
 /*
  * Return the number of items in a bag.
  */
-size_t
+uint64_t
 bag_count(
 	struct xfs_bag	*bag)
 {
@@ -475,7 +475,7 @@ bag_count(
 void *
 bag_item(
 	struct xfs_bag	*bag,
-	size_t		nr)
+	uint64_t	nr)
 {
 	if (nr >= bag->bg_inuse)
 		return NULL;
diff --git a/repair/slab.h b/repair/slab.h
index aab46ecf1f08..077b45822149 100644
--- a/repair/slab.h
+++ b/repair/slab.h
@@ -9,29 +9,31 @@
 struct xfs_slab;
 struct xfs_slab_cursor;
 
-extern int init_slab(struct xfs_slab **, size_t);
-extern void free_slab(struct xfs_slab **);
+int init_slab(struct xfs_slab **slabp, size_t item_sz);
+void free_slab(struct xfs_slab **slabp);
 
-extern int slab_add(struct xfs_slab *, void *);
-extern void qsort_slab(struct xfs_slab *, int (*)(const void *, const void *));
-extern size_t slab_count(struct xfs_slab *);
+int slab_add(struct xfs_slab *slab, void *item);
+void qsort_slab(struct xfs_slab *slab,
+		int (*compare)(const void *, const void *));
+uint64_t slab_count(struct xfs_slab *slab);
 
-extern int init_slab_cursor(struct xfs_slab *,
-	int (*)(const void *, const void *), struct xfs_slab_cursor **);
-extern void free_slab_cursor(struct xfs_slab_cursor **);
+int init_slab_cursor(struct xfs_slab *slab,
+		int (*compare)(const void *, const void *),
+		struct xfs_slab_cursor **curp);
+void free_slab_cursor(struct xfs_slab_cursor **curp);
 
-extern void *peek_slab_cursor(struct xfs_slab_cursor *);
-extern void advance_slab_cursor(struct xfs_slab_cursor *);
-extern void *pop_slab_cursor(struct xfs_slab_cursor *);
+void *peek_slab_cursor(struct xfs_slab_cursor *cur);
+void advance_slab_cursor(struct xfs_slab_cursor *cur);
+void *pop_slab_cursor(struct xfs_slab_cursor *cur);
 
 struct xfs_bag;
 
-extern int init_bag(struct xfs_bag **);
-extern void free_bag(struct xfs_bag **);
-extern int bag_add(struct xfs_bag *, void *);
-extern int bag_remove(struct xfs_bag *, size_t);
-extern size_t bag_count(struct xfs_bag *);
-extern void *bag_item(struct xfs_bag *, size_t);
+int init_bag(struct xfs_bag **bagp);
+void free_bag(struct xfs_bag **bagp);
+int bag_add(struct xfs_bag *bag, void *item);
+int bag_remove(struct xfs_bag *bag, uint64_t idx);
+uint64_t bag_count(struct xfs_bag *bag);
+void *bag_item(struct xfs_bag *bag, uint64_t idx);
 
 #define foreach_bag_ptr(bag, idx, ptr) \
 	for ((idx) = 0, (ptr) = bag_item((bag), (idx)); \

