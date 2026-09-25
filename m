Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AEA43E9FB
	for <linux-xfs@vger.kernel.org>; Fri, 25 Sep 2026 18:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790362115; cv=none; b=WzNzvo6ic2Jrl1RStAg/otSOiomkFLWZbzs1EQaPPtd2uGTdMpS7RDPMhOnn4T81shBuLJN6PHR8VbTcjIjBEqCdhYZiPVKyNS00FlCiqtLSBPcwGbZM6anefSiyHwQh/iTRraOu8Co9jrJ+t8m4GCYsnN4HRPFz1cCMy4lWLqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790362115; c=relaxed/simple;
	bh=TJ4ZmsWSmcorRmSxemQ8gkiDFFhpisGBwNX9kC3CpBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CrUAlrdl68bLQh+adzpy5tY6jlnEjkLwwvu7eKoklZPMFHm9N1ZqgxxqC5GJ+nme7UOlH8paZKtdMn0RxHTNDHHIPROn/WBjNqZNx+yhCH1j4kICKapEUXzbw6Ac3aFuAQbLapPgD+y/tWyVEwiLHaPSfPWvcAZfKhzFldRerLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WIqcU259; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WIqcU259"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790362106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R/tiz/Yo38mZNgr+TnOmOrzQM0HTpYZe8MWq23O8mtA=;
	b=WIqcU259j0XO3hAFhUgORD+o6T4yO29mLuoHxbjJtLpr3l+5cIf5y4z+Paqxfb27oH+Dzq
	hF8EvM3vtFeUdorHQR4xhCe2oUe8MHjQSPfDMH+FzTwcZ6Z/OVt5sCRznyavlW7de+SyGc
	bnILe6JIOKPZ+sxm44c+Eg2tySdrKXQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-93-wZyKZIHDMWKfwoW-x9_6YA-1; Fri,
 25 Sep 2026 14:48:24 -0400
X-MC-Unique: wZyKZIHDMWKfwoW-x9_6YA-1
X-Mimecast-MFC-AGG-ID: wZyKZIHDMWKfwoW-x9_6YA_1790362104
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA9571954226;
	Fri, 25 Sep 2026 18:48:23 +0000 (UTC)
Received: from bfoster (headnet03.pony-001.prod.iad2.dc.redhat.com [10.2.32.114])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 377DB195604E;
	Fri, 25 Sep 2026 18:48:23 +0000 (UTC)
Date: Fri, 25 Sep 2026 14:48:20 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>
Subject: Re: [PATCH v4 4/4] xfs: incorporate increased AGFL min requirement
 for minleft allocs
Message-ID: <arbB9G5cL7nHIjXa@bfoster>
References: <20260923161524.416059-1-bfoster@redhat.com>
 <20260923161524.416059-5-bfoster@redhat.com>
 <20260924011542.GH2705364@frogsfrogsfrogs>
 <arUiIxOed6Ldf8FN@bfoster>
 <20260924185620.GM2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924185620.GM2705364@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Sep 24, 2026 at 11:56:20AM -0700, Darrick J. Wong wrote:
> On Thu, Sep 24, 2026 at 09:14:11AM -0400, Brian Foster wrote:
> > On Wed, Sep 23, 2026 at 06:15:42PM -0700, Darrick J. Wong wrote:
> > > On Wed, Sep 23, 2026 at 12:15:24PM -0400, Brian Foster wrote:
> > > > Matt Fleming reports a filesystem shutdown due to inobt block
> > > > allocation failure during sparse chunk allocation. Inode creation
> > > > can involve multiple allocations in a transaction: the initial chunk
> > > > allocation and inode btree blocks via inobt record insertion. This
> > > > is expected to be safe by using the minleft parameter on the chunk
> > > > allocation to guarantee the selected AG has blocks available for
> > > > a followup inobt insertion.
> > > > 
> > > > The sequence that leads to this failure is that the alloc and inode
> > > > btrees are all full (require a full split on next insertion) and the
> > > > AG has just enough free space to satisfy a sparse chunk allocation
> > > > with minleft set (i.e. 7 blocks in this example). The chunk
> > > > allocation splits a free extent, triggers full allocbt splits, and
> > > > consumes 4 free blocks for the chunk and 4 AGFL blocks for the
> > > > btrees.
> > > > 
> > > > Next, the inobt record insertion triggers an inobt split. The AG has
> > > > enough free blocks, but the allocbt splits caused by the chunk
> > > > allocation have increased the min AGFL requirement for the AG due to
> > > > btree level increases. The AGFL requirement as calculated by
> > > > xfs_alloc_fix_freelist() is:
> > > > 
> > > > 	free + AGFL - res - minfree - minleft = avail
> > > > 
> > > > This evaluates to the following on initial chunk allocation:
> > > > 
> > > > 	2514 + 8 - 2505 - 8 - 2 = 7
> > > > 
> > > > ... and then after the chunk allocation but before the inobt block
> > > > allocation:
> > > > 
> > > > 	2510 + 4 - 2505 - 12 - 0 = -3
> > > > 
> > > > This causes the inobt alloc to fail despite minleft being set in the
> > > > first allocation. The error path cancels the dirty transaction and
> > > > shuts down the fs. The problem here is that while minleft ensures
> > > > free blocks are available for the inobt insert, it is not sufficient
> > > > to cover the increase of the AGFL min free requirement.
> > > > 
> > > > To address this, first have xfs_alloc_freelist() return both min and
> > > > max freelist values. The min value is the current AGFL requirement
> > > > and remains used for actual AGFL sizing. The max value calculates
> > > > the worst case AGFL requirement after potential allocbt splits
> > > > during the current allocation. Incorporate the max value into space
> > > > availability checks for AG selection and the longest free extent
> > > > calculation. The latter is necessary because callers like the bmap
> > > > layer can size allocation requests based on the longest free extent.
> > > > Without this, aligned allocs can end up oversized, prematurely fail,
> > > > and fall back to non-aligned to make up the difference.
> > > > 
> > > > This ensures the selected AG has enough blocks for both the caller's
> > > > minleft value and the worst case AGFL increase. In the example
> > > > above, the initial calculation now evaluates to 3 blocks available
> > > > instead of 7 and the inode allocation fails gracefully with -ENOSPC.
> > > > 
> > > > Assisted-by: LLM
> > > > Reported-by: Matt Fleming <matt@readmodwrite.com>
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > Reviewed-by: Mark Tinguely <mark.tinguely@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_alloc.c | 58 +++++++++++++++++++++++++++------------
> > > >  fs/xfs/libxfs/xfs_alloc.h |  3 +-
> > > >  fs/xfs/libxfs/xfs_bmap.c  |  6 ++--
> > > >  3 files changed, 47 insertions(+), 20 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > > index af63926cc9ee..86f74a2dfa10 100644
> > > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > > @@ -2397,31 +2397,36 @@ xfs_alloc_compute_maxlevels(
> > > >  }
> > > >  
> > > >  /*
> > > > - * Find the length of the longest extent in an AG.  The 'need' parameter
> > > > - * specifies how much space we're going to need for the AGFL and the
> > > > - * 'reserved' parameter tells us how many blocks in this AG are reserved for
> > > > + * Find the length of the longest extent in an AG. The @min_free and @max_free
> > > > + * parameters specify how much space we're going to need for the AGFL and the
> > > > + * @reserved parameter tells us how many blocks in this AG are reserved for
> > > >   * other callers.
> > > >   */
> > > >  xfs_extlen_t
> > > >  xfs_alloc_longest_free_extent(
> > > >  	struct xfs_perag	*pag,
> > > > -	xfs_extlen_t		need,
> > > > +	xfs_extlen_t		min_free,
> > > > +	xfs_extlen_t		max_free,
> > > >  	xfs_extlen_t		reserved)
> > > >  {
> > > >  	xfs_extlen_t		delta = 0;
> > > >  
> > > >  	/*
> > > > -	 * If the AGFL needs a recharge, we'll have to subtract that from the
> > > > -	 * longest extent.
> > > > +	 * If the AGFL needs a recharge, subtract that from the longest extent
> > > > +	 * because AGFL refill happens before the alloc.
> > > >  	 */
> > > > -	if (need > pag->pagf_flcount)
> > > > -		delta = need - pag->pagf_flcount;
> > > > +	if (min_free > pag->pagf_flcount)
> > > > +		delta = min_free - pag->pagf_flcount;
> > > >  
> > > >  	/*
> > > > -	 * If we cannot maintain others' reservations with space from the
> > > > -	 * not-longest freesp extents, we'll have to subtract /that/ from
> > > > -	 * the longest extent too.
> > > > +	 * Extra AGFL blocks beyond the min are reserved by ->minleft during
> > > > +	 * allocation. Similar to reserved, these blocks are not available to
> > > > +	 * this allocation. Check if we can preserve the combined total without
> > > > +	 * the longest extent. If not, deduct the necessary blocks from the
> > > > +	 * longest extent.
> > > >  	 */
> > > > +	if (max_free > min_free)
> > > > +		reserved += max_free - min_free;
> > > 
> > > Hmm.  So @min_free here is the minimum number of blocks that we have to
> > > keep on the AGFL to handle bnobt/cntbt/rmapbt btree expansions, right?
> > > And @max_free is the same, but assuming that they all increase one level
> > > in height, right?  So we're adding to @reserved the quantity of fsblocks
> > > needed to handle adding that new layer and then making the "Can this AG
> > > handle this much allocation?" decision?
> > > 
> > 
> > Yep.
> > 
> > > /me wonders if they should be called min_agfl and max_agfl,
> > > respectively, but that only makes sense if the answers to the above are
> > > all 'yes'.
> > > 
> > 
> > Do you mean within this function, or across the board? IIRC here I was
> > generally just trying to keep things consistent wrt naming (i.e. I found
> > the 'need' naming here annoyingly confusing) across the various function
> > calls, but I'm not opposed to just renaming them all to min/max_agfl or
> > whatever..
> 
> No, just here in this function.
> 

Hi Carlos,

Any chance you want to just fold in the diff below into this patch 4? If
not, let me know and I'll respin a v5 of the series. Thanks!

Brian

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 86f74a2dfa10..ae221a158764 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2397,7 +2397,7 @@ xfs_alloc_compute_maxlevels(
 }
 
 /*
- * Find the length of the longest extent in an AG. The @min_free and @max_free
+ * Find the length of the longest extent in an AG. The @min_agfl and @max_agfl
  * parameters specify how much space we're going to need for the AGFL and the
  * @reserved parameter tells us how many blocks in this AG are reserved for
  * other callers.
@@ -2405,8 +2405,8 @@ xfs_alloc_compute_maxlevels(
 xfs_extlen_t
 xfs_alloc_longest_free_extent(
 	struct xfs_perag	*pag,
-	xfs_extlen_t		min_free,
-	xfs_extlen_t		max_free,
+	xfs_extlen_t		min_agfl,
+	xfs_extlen_t		max_agfl,
 	xfs_extlen_t		reserved)
 {
 	xfs_extlen_t		delta = 0;
@@ -2415,8 +2415,8 @@ xfs_alloc_longest_free_extent(
 	 * If the AGFL needs a recharge, subtract that from the longest extent
 	 * because AGFL refill happens before the alloc.
 	 */
-	if (min_free > pag->pagf_flcount)
-		delta = min_free - pag->pagf_flcount;
+	if (min_agfl > pag->pagf_flcount)
+		delta = min_agfl - pag->pagf_flcount;
 
 	/*
 	 * Extra AGFL blocks beyond the min are reserved by ->minleft during
@@ -2425,8 +2425,8 @@ xfs_alloc_longest_free_extent(
 	 * the longest extent. If not, deduct the necessary blocks from the
 	 * longest extent.
 	 */
-	if (max_free > min_free)
-		reserved += max_free - min_free;
+	if (max_agfl > min_agfl)
+		reserved += max_agfl - min_agfl;
 	if (pag->pagf_freeblks - pag->pagf_longest < reserved)
 		delta += reserved - (pag->pagf_freeblks - pag->pagf_longest);
 

