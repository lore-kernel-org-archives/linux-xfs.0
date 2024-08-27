Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F00757FC
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 04:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724733884; cv=none; b=GffQNFYcWO5WFr7xh7KaZpDp8JTvXtXJiq1/64rsY1Faab/aIRFQMVsA03+3Fs2RT07Y6/Ty4xE8kjeKxOZQHApIpHTaa1ouYqRUKx+4qT94RvwCYzCBSOvnEkaTAvO8OQ+qoe0cS4eiCfo+ig4CiT2tOijFn/S8V9ouesqK1sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724733884; c=relaxed/simple;
	bh=rT5MFjMHkwA2ITeWk4TyMBATtrSIFPKHdN3aKfk1Wsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DL2FM/fnHjrRIHCVXnFN0HovQAo2MLuX97l53rgEXl0hx0hqI4dBOxWA4JLk2DL7AgsYxtcyPx2++pwjDbXwZMiW0EwuXkHrxREf9BJSKatxqdUEcYVz5ssYKCdtZWHhFbD56JmMPKYgGnY+F0U1wzTtsssZj3tFzezwAYv6quY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2HDXDmXw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2HDXDmXw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0U8/Q9Jq4cwUCtlsBiiF/1AvQWP6Y01LPKu6tV6KigU=; b=2HDXDmXwhHlyE5uDJRRxwatVmR
	Ozw2LIXRvzSe4l+KrLPMnc3uITrKURqwunAN5g2ljE/Hi4QqwJLeP4fArglQZRk+IIq0BQ2epJYms
	+BiXWLCVCzed/ZPo0Tc8tOFpXytc52vz1D35LmgvOqTPdvKVHpl5haVTXlDwSYOLaSix6R3uSKWhJ
	ZwUKSPW1deT/oRFTacT1Ykpyu+Yn4UNlCBymaqdM8oaLFOOvz0/qjQPmALObkog+vkkBObfQ3aQAn
	X0zR/vqDALO01EQWhj1ZrmxTGf6v8Ezep6rNahyQig1m5BFh31i4pahbgUn3kXa14/iRqkwvxldY4
	8frAnaDg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sio4Q-00000009jkW-0Uu3;
	Tue, 27 Aug 2024 04:44:42 +0000
Date: Mon, 26 Aug 2024 21:44:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: create incore realtime group structures
Message-ID: <Zs1ZumDpNdxCahMW@infradead.org>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
 <ZsvEmInHRA6GVuz3@dread.disaster.area>
 <20240826191404.GC865349@frogsfrogsfrogs>
 <Zs0kfidzTGC7KACX@dread.disaster.area>
 <20240827015558.GD6082@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827015558.GD6082@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 26, 2024 at 06:55:58PM -0700, Darrick J. Wong wrote:
> The thing I *don't* know is how will this affect hch's zoned device
> support -- he's mentioned that rtgroups will eventually have both a size
> and a "capacity" to keep the zones aligned to groups, or groups aligned
> to zones, I don't remember which.  I don't know if segmenting
> br_startblock for rt mappings makes things better or worse for that.

This should be fine.  The ZNS zone capacity features where zones have
a size (LBA space allocated to it) and a capacity (LBAs that can
actually be written to) is the hardware equivalent of this.

> So ... would it theoretically make more sense to use an rhashtable here?
> Insofar as the only place that totally falls down is if you want to
> iterate tagged groups; and that's only done for AGs.

It also is an important part of garbage collection for zoned XFS, where
we'll use it on RTGs.

> > 
> > #define for_each_group(grp, gno, grpi)					\
> > 	(gno) = 0;							\
> > 	for ((grpi) = to_grpi((grpi), xfs_group_grab((grp), (gno)));	\
> > 	     (grpi) != NULL;						\
> > 	     (grpi) = to_grpi(grpi, xfs_group_next((grp), to_gi(grpi),	\
> > 					&(gno), (grp)->num_groups))
> > 
> > And now we essentially have common group infrstructure for
> > access, iteration, geometry and address verification purposes...
> 
> <nod> That's pretty much what I had drafted, albeit with different
> helper macros since I kept the for_each_{perag,rtgroup} things around
> for type safety.  Though I think for_each_perag just becomes:
> 
> #define for_each_perag(mp, agno, pag) \
> 	for_each_group((mp)->m_perags, (agno), (pag))
> 
> Right?

Btw, if we touch all of this anyway I'd drop the agno argument.
We can get the group number from the group struct (see my perag xarray
conversion series for an example where I'm doing this for the tagged
iteration).

> 
> The max rtgroup length is defined in blocks; the min is defined in rt
> extents.  I might want to bump up the minimum a bit, but I think
> Christoph should weigh in on that first -- I think his zns patchset
> currently assigns one rtgroup to each zone?  Because he was muttering
> about how 130,000x 256MB rtgroups really sucks.  Would it be very messy
> to have a minimum size of (say) 1GB?

Very messy.  I can live with a minimum of 256 MB, but no byte less :)
This is the size used by all shipping SMR hard drivers.  For ZNS SSDs
there are samples with very small zones size that are basically open
channel devices in disguise - no sane person would want them and they
don't make sense to support in XFS as they require extensive erasure
encoding and error correction.  The ZNS drives with full data integrity
support have zone sizes and capacities way over 1GB and growing.

> > and we hit those limits on 4kB block sizes at around 500,000 rtgs.
> > 
> > So do we need to support millions of rtgs? I'd say no....
> 
> ...but we might.  Christoph, how gnarly does zns support get if you have
> to be able to pack multiple SMR zones into a single rtgroup?

I thought about it, but it creates real accounting nightmares.  It's
not entirely doable, but really messy.

