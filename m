Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65961FBEB9
	for <linux-xfs@vger.kernel.org>; Thu, 18 Sep 2025 22:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758235748; cv=none; b=NwUxH2V721vOp4fUtUnI0N0qmSMabJbUuazc9mkgRvMnCOdaU/+mqykQbAU0Hb8CPYQmRQ2GisZuIJe+a7KPIIcU3NIi1ipyV84tL38/ej5JaIEcCsKwo1KIZbSAotTta+Qp64CnUnJk9a0PJzfc3RIm2F4X/IkC1PV9PHZm5RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758235748; c=relaxed/simple;
	bh=oKrwTna3/87II0uzwYN7KYICf+oloCMlPnU/JX9C/Ds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fGuWioBYeFkCL0sknQ2+Rr2qTY7LVLel8iqOuPBT/Y++pQxleIKfqpmN8JxWL/NFrwQWqm4wInH5OXR63F1eJUYvXwoMsAL/mfGOAZScYvhlkR+e8Mi9Fl3kixURbuRC35Cl8a91acEeQKTPoZ27f9Rf1um1iJurN5ylbdZcOzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCtnuy5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCtnuy5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF00C4CEE7;
	Thu, 18 Sep 2025 22:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758235747;
	bh=oKrwTna3/87II0uzwYN7KYICf+oloCMlPnU/JX9C/Ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TCtnuy5opKUynJg+Zmw3hQAyA0Screo6V8QU7XuqhCi3PVsNwsdCw5Ffe+nxwnqs8
	 z4gxaAElqlpXyk+Ym4Y0Dn23xZsK5QLv+/8FqXNnPbp6nHS4QZPoT5ws7j0831aR+K
	 MtBgTXkDCRZ/7QZpH+gDHLomtZyQOn56/0V47CpOzG1ac0wX7hnugpanJfoBV78yoA
	 aURA+xZgDSfqanq02aVyqOYQGfPF5Ib4dTP/O4OyZitWG4NPFTOQwKgngtF3vclgqQ
	 laEhqa4pz217jiAKBY/C9eYgFOc/6lR5TunzxTPlixn4FJzsyJJA57WsDFzHYKZ6Y2
	 dDXzQ8n7TH50A==
Date: Thu, 18 Sep 2025 15:49:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, jack@suse.cz, lherbolt@redhat.com
Subject: Re: [PATCH 1/2] xfs: rearrange code in xfs_inode_item_precommit
Message-ID: <20250918224906.GL8096@frogsfrogsfrogs>
References: <20250917222446.1329304-1-david@fromorbit.com>
 <20250917222446.1329304-2-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917222446.1329304-2-david@fromorbit.com>

On Thu, Sep 18, 2025 at 08:12:53AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are similar extsize checks and updates done inside and outside
> the inode item lock, which could all be done under a single top
> level logic branch outside the ili_lock. The COW extsize fixup can
> potentially miss updating the XFS_ILOG_CORE in ili_fsync_fields, so
> moving this code up above the ili_fsync_fields update could also be
> considered a fix.
> 
> Further, to make the next change a bit cleaner, move where we
> calculate the on-disk flag mask to after we attach the cluster
> buffer to the the inode log item.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode_item.c | 65 ++++++++++++++++++-----------------------
>  1 file changed, 29 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index afb6cadf7793..318e7c68ec72 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -131,46 +131,28 @@ xfs_inode_item_precommit(
>  	}
>  
>  	/*
> -	 * Inode verifiers do not check that the extent size hint is an integer
> -	 * multiple of the rt extent size on a directory with both rtinherit
> -	 * and extszinherit flags set.  If we're logging a directory that is
> -	 * misconfigured in this way, clear the hint.
> +	 * Inode verifiers do not check that the extent size hints are an
> +	 * integer multiple of the rt extent size on a directory with
> +	 * rtinherit flags set.  If we're logging a directory that is
> +	 * misconfigured in this way, clear the bad hints.
>  	 */
> -	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
> -	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
> -	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_extsize) > 0) {
> -		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
> -				   XFS_DIFLAG_EXTSZINHERIT);
> -		ip->i_extsize = 0;
> -		flags |= XFS_ILOG_CORE;
> +	if (ip->i_diflags & XFS_DIFLAG_RTINHERIT) {
> +		if ((ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
> +		    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_extsize) > 0) {
> +			ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
> +					   XFS_DIFLAG_EXTSZINHERIT);
> +			ip->i_extsize = 0;
> +			flags |= XFS_ILOG_CORE;
> +		}
> +		if ((ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
> +		    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_cowextsize) > 0) {
> +			ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
> +			ip->i_cowextsize = 0;
> +			flags |= XFS_ILOG_CORE;
> +		}
>  	}

Hrm, yeah, that cowextsize fixing code looks like it was merged in the
wrong place or something.  In theory it's a bug fix, but since we never
merged support for rtreflink and rtextsize > 1fsb this will never happen
in practice since rtextsize cannot change when reflink is enabled.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


>  
> -	/*
> -	 * Record the specific change for fdatasync optimisation. This allows
> -	 * fdatasync to skip log forces for inodes that are only timestamp
> -	 * dirty. Once we've processed the XFS_ILOG_IVERSION flag, convert it
> -	 * to XFS_ILOG_CORE so that the actual on-disk dirty tracking
> -	 * (ili_fields) correctly tracks that the version has changed.
> -	 */
>  	spin_lock(&iip->ili_lock);
> -	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
> -	if (flags & XFS_ILOG_IVERSION)
> -		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
> -
> -	/*
> -	 * Inode verifiers do not check that the CoW extent size hint is an
> -	 * integer multiple of the rt extent size on a directory with both
> -	 * rtinherit and cowextsize flags set.  If we're logging a directory
> -	 * that is misconfigured in this way, clear the hint.
> -	 */
> -	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
> -	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
> -	    xfs_extlen_to_rtxmod(ip->i_mount, ip->i_cowextsize) > 0) {
> -		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
> -		ip->i_cowextsize = 0;
> -		flags |= XFS_ILOG_CORE;
> -	}
> -
>  	if (!iip->ili_item.li_buf) {
>  		struct xfs_buf	*bp;
>  		int		error;
> @@ -204,6 +186,17 @@ xfs_inode_item_precommit(
>  		xfs_trans_brelse(tp, bp);
>  	}
>  
> +	/*
> +	 * Record the specific change for fdatasync optimisation. This allows
> +	 * fdatasync to skip log forces for inodes that are only timestamp
> +	 * dirty. Once we've processed the XFS_ILOG_IVERSION flag, convert it
> +	 * to XFS_ILOG_CORE so that the actual on-disk dirty tracking
> +	 * (ili_fields) correctly tracks that the version has changed.
> +	 */
> +	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
> +	if (flags & XFS_ILOG_IVERSION)
> +		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
> +
>  	/*
>  	 * Always OR in the bits from the ili_last_fields field.  This is to
>  	 * coordinate with the xfs_iflush() and xfs_buf_inode_iodone() routines
> -- 
> 2.50.1
> 
> 
