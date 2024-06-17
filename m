Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA742BD18
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 06:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718606770; cv=none; b=S8NvtRVkwB+G+BZJXDUZU94S63+S83mNnSAkL3xCnk4nyzjYONNXoXkrgaFwbVcNJ0+WjDF6IS3mV18IiJOqVCgs66WNanIxB9CbpUCjv0KDJ1e87Y/azVCm6zP3yj2tV6gGEcglFoa+xJhkhi0yS9HPxaGfMEmhlYKMyTA2WhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718606770; c=relaxed/simple;
	bh=87FF+m3GG8Gp2zLvvXhEK2OmLBDR3JhAf9GZiGZFp0w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L4cwa3qpT6Vg1bTqQxK8Eke3p/VvuwNwOOOly7Uj+bBsBKjB6HyHL39es2if7GLZUMRrafIiuUWwjM15aVv+5wcOMT9NFlxTStM20Bik+PAlYB1Ehyjzw0xLwbR/5Uu3VMQmtXt3Dcpaf+Cg4S8jD7MR3BsZKT2WZRWyztqfEVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 147E768B05; Mon, 17 Jun 2024 08:46:04 +0200 (CEST)
Date: Mon, 17 Jun 2024 08:46:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, "Darrick J. Wong" <djwong@kernel.org>,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: don't treat append-only files as having
 preallocations
Message-ID: <20240617064603.GA18484@lst.de>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs> <171821431777.3202459.4876836906447539030.stgit@frogsfrogsfrogs> <ZmqLyfdH5KGzSYDY@dread.disaster.area> <20240613082855.GA22403@lst.de> <Zm/DoN5npLCd+Y/n@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zm/DoN5npLCd+Y/n@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 17, 2024 at 03:03:28PM +1000, Dave Chinner wrote:
> > That case should be covered by the XFS_IDIRTY_RELEASE, at least
> > except for O_SYNC workloads. 
> 
> Ah, so I fixed the problem independently 7 or 8 years later to fix
> Linux NFS server performance issues. Ok, that makes removing the
> flag less bad, but I still don't see the harm in keeping it there
> given that behaviour has existed for the past 20 years....

I'm really kinda worried about these unaccounted preallocations lingering
around basically forever.  Note that in current mainline there actually
is a path removing them more or less accidentally when there are
delalloc blocks in a can_free_eofblocks path with force == true,
but that's going away with the next patch.

