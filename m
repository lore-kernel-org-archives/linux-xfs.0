Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D419B17758
	for <linux-xfs@vger.kernel.org>; Sun, 11 Aug 2024 08:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723366798; cv=none; b=q4GE2wDwaLX5VEr3JRe3/QF9PS6OzE35c3kheuhC5Tdd25cu5ALaOroAoEZnRfI9Xot4GObnDmaDgdpyQ/fxHWelR6prRV38oY41cfi5daHvu5YapCoAZK0XSomZHXt48M9zkiKBcoSvUjh4Qce+0wbdBMCva65u9Xh85y5uU4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723366798; c=relaxed/simple;
	bh=8d2nGjIl0poqex4hGeckoD1gBnx4yg9WYhIVGJps/LE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aWZ/zuIZxddnxQT4c8/R0XZwAiIcjdQoA2Agk35mEAo6IZbsT/ki3xCb4rJbFiaGwcl0TKfSOjvMdx9rD3qVoAukhADDPCDiMxHCdIx5Fv4eKyyujVU1GIWCFTsxQiLjDkx3mFybiuuFbMU58llsDyt1CWcYDT629DM2ZhpiLf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C449068AFE; Sun, 11 Aug 2024 10:59:52 +0200 (CEST)
Date: Sun, 11 Aug 2024 10:59:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/9] xfs: check XFS_EOFBLOCKS_RELEASED earlier in
 xfs_release_eofblocks
Message-ID: <20240811085952.GB12713@lst.de>
References: <20240808152826.3028421-1-hch@lst.de> <20240808152826.3028421-8-hch@lst.de> <ZrVOvDkhX7Mfoxy+@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrVOvDkhX7Mfoxy+@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Aug 09, 2024 at 09:03:24AM +1000, Dave Chinner wrote:
> The test and set here is racy. A long time can pass between the test
> and the setting of the flag,

The race window is much tighter due to the iolock, but if we really
care about the race here, the right fix for that is to keep a second
check for the XFS_EOFBLOCKS_RELEASED flag inside the iolock.

> so maybe this should be optimised to
> something like:
> 
> 	if (inode->i_nlink &&
> 	    (file->f_mode & FMODE_WRITE) &&
> 	    (!(ip->i_flags & XFS_EOFBLOCKS_RELEASED)) &&
> 	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> 		if (xfs_can_free_eofblocks(ip) &&
> 		    !xfs_iflags_test_and_set(ip, XFS_EOFBLOCKS_RELEASED))
> 			xfs_free_eofblocks(ip);
> 		xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> 	}

All these direct i_flags access actually are racy too (at least in
theory).  We'd probably be better off moving those over to the atomic
bitops and only using i_lock for any coordination beyond the actual
flags.  I'd rather not get into that here for now, even if it is a
worthwhile project for later.

> I do wonder, though - why do we need to hold the IOLOCK to call
> xfs_can_free_eofblocks()? The only thing that really needs
> serialisation is the xfS_bmapi_read() call, and that's done under
> the ILOCK not the IOLOCK. Sure, xfs_free_eofblocks() needs the
> IOLOCK because it's effectively a truncate w.r.t. extending writes,
> but races with extending writes while checking if we need to do that
> operation aren't really a big deal. Worst case is we take the
> lock and free the EOF blocks beyond the writes we raced with.
> 
> What am I missing here?

I think the prime part of the story is that xfs_can_free_eofblocks was
split out of xfs_free_eofblocks, which requires the iolock.  But I'm
not sure if some of the checks are a little racy without the iolock,
although I doubt it matter in practice as they are all optimizations.
I'd need to take a deeper look at this, so maybe it's worth a follow
on together with the changes in i_flags handling.

