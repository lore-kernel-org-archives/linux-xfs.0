Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145CA1E48A
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 05:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739424147; cv=none; b=iLhRV8G7zJIzUBn/G0nIZR64+aPS78BMDNDdntciOP9bdk/IYgaZJuK20NLnm45EDdBvU+dBnLoza9/hilgbJ1ioXdIy8xV8im+CCSrPrH/lN+fNoF0BHYfrdfPeg2xjUDMkmdgOAogxKV3GT7O6+Y6LA1PwM/3aPzLzbeCP4+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739424147; c=relaxed/simple;
	bh=J2vkeQAXNtWxwPhoX790wUCD4Oxoo6Kujnfucipe8Oc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Alinn3TZSkq+UeirXLeGOfFtr7PZyLv4imQoGzMCcga6ZRtHHqFGPC4TRc0Q4EwIxu/NeCFSqo6YOxXrmLmGCC7SpcnyAcF+YU2JpA210nPKK0HTEFIi6MOByMnHUcKdbj2SMLz4W5SkzufPXZTk8V+i+x6EHYw0I9CXVi4GjDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9C92967373; Thu, 13 Feb 2025 06:22:21 +0100 (CET)
Date: Thu, 13 Feb 2025 06:22:21 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/43] xfs: implement zoned garbage collection
Message-ID: <20250213052221.GE17582@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-25-hch@lst.de> <20250207183350.GB21808@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207183350.GB21808@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 07, 2025 at 10:33:50AM -0800, Darrick J. Wong wrote:
> > +	spin_lock_init(&zi->zi_used_buckets_lock);
> > +	for (i = 0; i < XFS_ZONE_USED_BUCKETS; i++) {
> > +		zi->zi_used_bucket_bitmap[i] =
> > +				bitmap_zalloc(mp->m_sb.sb_rgcount, GFP_KERNEL);
> 
> I wonder how long until this becomes a scalability problem, on my device
> with 131k zones, this is a 16k contiguous allocation.

This should probably be a kvmalloc allocation, I'll see if we want
to open code it or add a new helper.  16k should be fine at mount
time, but the devices aren't going get smaller in the next years.

> > +		return false;
> > +
> > +	xfs_info(mp, "reclaiming zone %d, used: %u/%u, bucket: %u",
> > +		rtg_rgno(victim_rtg), rtg_rmap(victim_rtg)->i_used_blocks,
> > +		rtg_blocks(victim_rtg), bucket);
> 
> Tracepoint?
> 
> > +	trace_xfs_zone_reclaim(victim_rtg);

Here :), but yes, the printk is probably too noisy for the default
build even if it's really useful for debugging.

