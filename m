Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2998D42064
	for <linux-xfs@vger.kernel.org>; Fri, 14 Jun 2024 05:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718343072; cv=none; b=gN3BtVPr40FvqtAd2xM++KNk+/KGVwITZaXB/q7V6Ahy3UM6EMGqWc8cO6bzol7/ewNDuO0KwOYKgioHsti2Hrv8Cx9NTSYNL7c8DlVQOBm241S2TZVrIIfwWm4dxwFWtMAZqfEtzeR+5Opb4T861dsn7mzS1eHb5/xtMjoaow8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718343072; c=relaxed/simple;
	bh=kFlmaDT6YbCcZ2EBo6mz9ont4anrTlcL7InTihQyiko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LnM3DD4aLN7Sn68XN158TTJbFBvfebAJ8R40FcjJjley33FWqMtEclglA545Eq1A+mz73KSIFeBpQyENOyKfbDh7aqIPYc8vzqrLEAChTLqkvbSFVriGwL0NZiW/rBgp5AD0tYNHMxhDd19olaFLUWd/RccvPYHjmbm4UrC9ADs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B226668C4E; Fri, 14 Jun 2024 07:30:59 +0200 (CEST)
Date: Fri, 14 Jun 2024 07:30:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandanbabu@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: restrict when we try to align cow fork
 delalloc to cowextsz hints
Message-ID: <20240614053059.GA9786@lst.de>
References: <171821431745.3202459.12391135011047294097.stgit@frogsfrogsfrogs> <171821431812.3202459.13352462937816171357.stgit@frogsfrogsfrogs> <20240613050613.GC17048@lst.de> <20240614041310.GG6125@frogsfrogsfrogs> <20240614044155.GA9084@lst.de> <20240614052705.GC6147@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614052705.GC6147@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 13, 2024 at 10:27:05PM -0700, Darrick J. Wong wrote:
> > +	 * Unlike the data fork, the CoW cancellation functions will free all
> > +	 * the reservations at inactivation, so we don't require that every
> > +	 * delalloc reservation have a dirty pagecache.
> > +	 *
> > +	 * XXX(hch): I can't see where we actually require dirty pagecache
> > +	 * for speculative data fork preallocations.  What am I missing?
> 
> IIRC a delalloc reservation in the data fork that isn't backing a dirty
> page will just sit there in the data fork and never get reclaimed.
> There's no writeback to turn it into an unwritten -> written extent.
> The blockgc functions won't (can't?) walk the pagecache to find clean
> regions that could be torn down.  xfs destroy_inode just asserts on any
> reservations that it finds.

blockgc doesn't walk the page cache at all.  It just calls
xfs_free_eofblocks which simply drops all extents after i_size.

If it didn't do that we'd be in trouble because there never is any dirty
page cache past roundup(i_size, PAGE_SIZE).

