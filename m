Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D1433C9
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 00:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728953249; cv=none; b=Qt5ftxUbwcbV8DI8EVpCou4sDX8ARksTXXmYFEURR4ukOWTLeAlx8Nghq+fins6w7Xeo6QBABzI0g0p2NEs1x/748nyowbHBLdBPL7YX30JTsjOTF6zKWdVKw7CyrMwo7Xtbou4fsC3wbSfzhxKFJlDJgp/dQAa45l8K99hHElQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728953249; c=relaxed/simple;
	bh=D7753Qt13w5dTrVVqH9pIjGDWstO9W/nS32GJVjwxiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G3yoFrwp7H3bQr10FJsyLl8x8BohDURq/hUGWXJkWALjFBb686CD/ztJsHYWPmmaqJGGywUnTftPbD0F4R0Qu34KN5utC9Y4DTaSViqQ7D9JmQGf/7i0tcWatpBTe+BfAcvIw7ZXe5zJQ9Wo+zOK7GsDIFrg3D0dEWnHRZJCWw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OpxdFadJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OpxdFadJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D32FC4CEC3;
	Tue, 15 Oct 2024 00:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728953249;
	bh=D7753Qt13w5dTrVVqH9pIjGDWstO9W/nS32GJVjwxiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OpxdFadJi0XKNdrzs18ueXFpH0+aG6E1CZgwLoLxVMIxDq693o0oSAPffsks+NQ5Z
	 nE6i7M1sAuvdHHlWI29sh+kJVZWNmZ/3g4/Difbe2nF4Ho3gTIMLlRFj+OFGsketHn
	 0b8Vw61K3/pP5x5bdGW6pdD5whVuAIgsbEFvLuhKwv6eg/t/enkLt8MGP1drchyzGZ
	 x0JD11Jsoi38d3GmIG4bhGRXa93XHkF7Jaz5iZ7dXsWI3VslAkCvCVebuSm3WYDlUA
	 xaW5amjmcNvIZ48J+JDgIUzmXBPMiWSivMw/ibgGJHaMy3n3cMfkf5fC3UPXMyNxUa
	 +09jRzXljevWA==
Date: Mon, 14 Oct 2024 17:47:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/6] xfs: fix chown with rt quota
Message-ID: <20241015004728.GM21853@frogsfrogsfrogs>
References: <172860645659.4180109.14821543026500028245.stgit@frogsfrogsfrogs>
 <172860645695.4180109.15774707176031680844.stgit@frogsfrogsfrogs>
 <ZwzVMxg-Z0qtuL2v@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwzVMxg-Z0qtuL2v@infradead.org>

On Mon, Oct 14, 2024 at 01:24:19AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 10, 2024 at 06:12:21PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Make chown's quota adjustments work with realtime files.
> 
> Maybe explain how you made it work here?


> > @@ -1393,18 +1393,17 @@ xfs_qm_dqusage_adjust(
> >  
> >  	ASSERT(ip->i_delayed_blks == 0);
> >  
> > +	lock_mode = xfs_ilock_data_map_shared(ip);
> >  	if (XFS_IS_REALTIME_INODE(ip)) {
> > -		struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, XFS_DATA_FORK);
> > -
> >  		error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
> > -		if (error)
> > +		if (error) {
> > +			xfs_iunlock(ip, lock_mode);
> >  			goto error0;
> > -
> > -		xfs_bmap_count_leaves(ifp, &rtblks);
> > +		}
> 
> So this obviously was missing locking :)

Yep.  Luckily you could never mount with rt+quota before, so there
weren't any corruption complaints.  I guess that's one way to get to
zero bugs. :P

> >  	}
> > -
> > -	nblks = (xfs_qcnt_t)ip->i_nblocks - rtblks;
> > +	xfs_inode_count_blocks(tp, ip, &nblks, &rtblks);
> >  	xfs_iflags_clear(ip, XFS_IQUOTAUNCHECKED);
> > +	xfs_iunlock(ip, lock_mode);
> 
> But this now also forces lockign for !rt file systems, I guess
> we don't really care about an extra ilock roundtrip in chown,
> though.

Well, it's needed for correctness because you have to distinguish data
and rtblocks usage to keep the accounting correct.  The only way to do
that is to walk the data fork mappings, which means ILOCK.

> The changes itself look good, but a useful commit log would be nice:

xfs: fix chown with rt quota

Make chown's quota adjustments work with realtime files.  This is mostly
a matter of calling xfs_inode_count_blocks on a given file to figure out
the number of blocks allocated to the data device and to the realtime
device, and using those quantities to update the quota accounting when
the id changes.  Delayed allocation reservations are moved from the old
dquot's incore reservation to the new dquot's incore reservation.

Note that there was a missing ILOCK bug in xfs_qm_dqusage_adjust that we
must fix before calling xfs_iread_extents.  Prior to 2.6.37 the locking
was correct, but then someone removed the ILOCK as part of a cleanup.
Nobody noticed because nowhere in the git history have we ever supported
rt+quota so nobody can use this.

I'm leaving git breadcrumbs in case anyone is desperate enough to try to
backport the rtquota code to old kernels.

Not-Cc: <stable@vger.kernel.org> # v2.6.37
Fixes: 52fda114249578 ("xfs: simplify xfs_qm_dqusage_adjust")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>

> Reviewed-by: Christoph Hellwig <hch@lst.de>

Heh, thanks. :)

--D
