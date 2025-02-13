Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2D226E141
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 22:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739484644; cv=none; b=J5n2yD3sUsossTrWBZHLyQYeLOht9CxSPR5sk3PZiC391KAda0O71VEzIpiUoVi5aI7DhNZpkUv409wytvTaRU3lcvq2kwdplTSairG7wnAs/hSAL5UU2IR42HBukQ1I3S5dkvSuu1kQlWTrhV1b/Ei3DikJVjx08+BhHgQxoE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739484644; c=relaxed/simple;
	bh=ynNGsGwn0TwhTTwasYsKGvJVrKEKGSGRzoYMtiE82NA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pmbs+DhCiRoS9hp6wZFOmiaubaI+ZhgpuV/p1OeSG4TayVOEoQ6EJ6CUf9/kKY+juyZ3QEZqoB6j39wYSMHG+Y5IL1vkghqN3pmlscKFBCRflESuDn38X5ZL4gc3yB5+aCfWeY90/SWSbEe496XPOFJEV2910kWwv4h8avT9QbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qVquryF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qVquryF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E06D7C4CEE2;
	Thu, 13 Feb 2025 22:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739484643;
	bh=ynNGsGwn0TwhTTwasYsKGvJVrKEKGSGRzoYMtiE82NA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qVquryF2Q4k+8WxKcHrpvKbhVMQWEggqHVEPQttbi5I7NhmXf8q+jC2YID2PaMS5A
	 3HVSiNy0yEHF/Sjh51LBCxVDaIPlBdm856sHdZ7zhXWzPIX5xcw6oEfGBPB71Jymgu
	 lNcGcwsNxeeCNg2npzrGnIRtD567FwoSvCduK8v6zvmKiXIzDL7ZolpjMOj4UC8fpY
	 p9qkkiT+PYeBJyokdUiaFaKAiGr+QkSXvMvkiXCGKMuSLfnA16v5CGrKKkcwxHwEdJ
	 Aq2foId3nqJjVLc5lGJwOE7PSxmiLh2DnHqJ+wEFxxpnzILEBWg/Kk98/74gCoe6e5
	 6peHfzaFNCbfw==
Date: Thu, 13 Feb 2025 14:10:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/43] xfs: implement zoned garbage collection
Message-ID: <20250213221043.GV21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-25-hch@lst.de>
 <20250207183350.GB21808@frogsfrogsfrogs>
 <20250213052221.GE17582@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213052221.GE17582@lst.de>

On Thu, Feb 13, 2025 at 06:22:21AM +0100, Christoph Hellwig wrote:
> On Fri, Feb 07, 2025 at 10:33:50AM -0800, Darrick J. Wong wrote:
> > > +	spin_lock_init(&zi->zi_used_buckets_lock);
> > > +	for (i = 0; i < XFS_ZONE_USED_BUCKETS; i++) {
> > > +		zi->zi_used_bucket_bitmap[i] =
> > > +				bitmap_zalloc(mp->m_sb.sb_rgcount, GFP_KERNEL);
> > 
> > I wonder how long until this becomes a scalability problem, on my device
> > with 131k zones, this is a 16k contiguous allocation.
> 
> This should probably be a kvmalloc allocation, I'll see if we want
> to open code it or add a new helper.  16k should be fine at mount
> time, but the devices aren't going get smaller in the next years.

Well I guess if it /is/ a problem we can always reuse the xbitmap32
code. :)

> > > +		return false;
> > > +
> > > +	xfs_info(mp, "reclaiming zone %d, used: %u/%u, bucket: %u",
> > > +		rtg_rgno(victim_rtg), rtg_rmap(victim_rtg)->i_used_blocks,
> > > +		rtg_blocks(victim_rtg), bucket);
> > 
> > Tracepoint?
> > 
> > > +	trace_xfs_zone_reclaim(victim_rtg);
> 
> Here :), but yes, the printk is probably too noisy for the default
> build even if it's really useful for debugging.

<nod>
--D
