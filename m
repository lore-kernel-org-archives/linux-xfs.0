Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAB417550
	for <linux-xfs@vger.kernel.org>; Fri, 29 Mar 2024 16:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711728870; cv=none; b=icHLg50WgvctRvDnyQGbHdYuYoLbjcoiRndwpScklhbfSJ9OdLB1OzD8mRAvQ7Ss4+AfT7vAFL0IjkoymGndGFlwp3bikj8GsfW/qrRYwFUGPKQCLHShUlyWbF/bmozbCV5FTfnH1xaQ4gx9fLL/YWZGQ8pjxpfKvGcUnEihn6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711728870; c=relaxed/simple;
	bh=Kx1feJOnGcFyKnxvBT3oOO112UB2o9A6KcSE3Fg3NVY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V1T565t/fYtF8huXg+P5ClfSwKKwqk17JNnv4BIRHU1d8zFgFqb9I/337naFeQuZNMDCJD1MwfnWHBczQCNP6yi4hhJHPE2N2nFqv4s2ZkwMmjmESq+GLpmFAjNRAjwMLi/AOXCrtGrQxe7hT+BKOw2k1nGp5954VMv7RF5+xrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JyrAyEm0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JyrAyEm0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20873C433F1;
	Fri, 29 Mar 2024 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711728870;
	bh=Kx1feJOnGcFyKnxvBT3oOO112UB2o9A6KcSE3Fg3NVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JyrAyEm0BgTD5X9b5K/r+a6oyhUb3G6zZHn2iDn9MeJNQgYOe4PkA6d+ssW9ArDmG
	 MqqCVPWuI5YUHz86C+L9dGjV3S8SkflX/ukkwRKaDEzXsHuy3b2a89bG4TUhzOkHK8
	 KxN8hEJapSU6T13F1o3c83EEd9TikhmgV0JX8CRvCwsajMs+wDvrF8YnUApa8WS8GQ
	 IeFD0bzDAoZRck5A8SeXQgCKUJX3OEOWQf6gzu+twW5dzRsk7fOe+MVf57TDxEfyGA
	 uMSYlk46TpPmZlAbZgpJIcWJZtEc1FawJqnGlsYrvtA0OU6Avqd/OthJCJz259GmQF
	 zyy8oaT2fRWng==
Date: Fri, 29 Mar 2024 09:14:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: check if_bytes under the ilock in
 xfs_reflink_end_cow_extent
Message-ID: <20240329161429.GE6390@frogsfrogsfrogs>
References: <20240328070256.2918605-1-hch@lst.de>
 <20240328070256.2918605-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240328070256.2918605-2-hch@lst.de>

On Thu, Mar 28, 2024 at 08:02:51AM +0100, Christoph Hellwig wrote:
> Accessing if_bytes without the ilock is racy.  Move the check a little
> further down into the ilock critical section.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_reflink.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 7da0e8f961d351..df632790a0a51c 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -731,12 +731,6 @@ xfs_reflink_end_cow_extent(
>  	int			nmaps;
>  	int			error;
>  
> -	/* No COW extents?  That's easy! */
> -	if (ifp->if_bytes == 0) {
> -		*offset_fsb = end_fsb;
> -		return 0;
> -	}

This unlocked access was supposed to short-circuit the case where
there's absolutely nothing in the cow fork at all, so that we don't have
to wait for a transaction and the ILOCK.  Is the unlocked access
causing problems?

> -
>  	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
>  			XFS_TRANS_RESERVE, &tp);
> @@ -751,6 +745,12 @@ xfs_reflink_end_cow_extent(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> +	/* No COW extents?  That's easy! */
> +	if (ifp->if_bytes == 0) {
> +		*offset_fsb = end_fsb;
> +		goto out_cancel;
> +	}

This is already taken care of by the clause that comes below
the end of this diff:

	/*
	 * In case of racing, overlapping AIO writes no COW extents might be
	 * left by the time I/O completes for the loser of the race.  In that
	 * case we are done.
	 */
	if (!xfs_iext_lookup_extent(ip, ifp, *offset_fsb, &icur, &got) ||
	    got.br_startoff >= end_fsb) {
		*offset_fsb = end_fsb;
		goto out_cancel;
	}

Since xfs_iext_lookup_extent will return false if the cow fork tree is
empty.

That said, I think the xfs_iext_count_may_overflow stuff is misplaced --
we should be querying the cow fork extent and bouncing out early before
we bother with checking/upgrading the nextents width.  If
xfs_iext_count_upgrade dirtied the transaction, the early bailout will
cause a shutdown.

(The iext upgrade only needs to happen after the bmapi_read.)

--D

> +
>  	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
>  			XFS_IEXT_REFLINK_END_COW_CNT);
>  	if (error == -EFBIG)
> -- 
> 2.39.2
> 
> 
