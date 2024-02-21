Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7886FC8
	for <linux-xfs@vger.kernel.org>; Wed, 21 Feb 2024 02:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708481786; cv=none; b=Ya4RwC4VuGrBQ91pRhjVzM+fP1+7dJ0dEYFo71ntL01LX8Z7jj7YpyVOr7330DhBU3/FLWVIYfp1UKZhZtuGgbJuV6LiFvX3QYTKohPwOTBbkUtxvxaIkEEuW5O+YHZSJpZ3WvlHkP4j8s4IPAgoqxP0UJKOOIfSGN75hfve06Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708481786; c=relaxed/simple;
	bh=pRw2Lt66zwd/Q0H9PLAciWvFzvC9LaZyJA2WvVM9pK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LucD309ebtegpBMW9CQHz0fdKm7jUlfkztp5s0CuSaIlyhtdzY8R21go2OBcaWXrQ7hDT6X+4aTukWU+RE8UwlU/w076YP1UcGc045GipgoZeuTXL0S40oxAOAtF2POtP99TEQpiEsB60jIwtI/JQFcIL/3d/BcfFhrkysT7ZuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RYE2r8gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RYE2r8gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219F2C433C7;
	Wed, 21 Feb 2024 02:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708481786;
	bh=pRw2Lt66zwd/Q0H9PLAciWvFzvC9LaZyJA2WvVM9pK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RYE2r8guFHrxz3x2GAC4aN23PtxiUxmKGqfeY4LHGZVWZqyLBUcpbIILkttkqIfwj
	 PkyIbt9FEpuCAx5ugvq3jjrCNJRZl1M9luEjqSYBWUhIWqHyBGA3QTCs13g6rtoWyI
	 i6P+hgx0sXtEDcINklLxg06Uhbn+tEfzc8NISPbVIOepsoNDOXjD2wVwzd30YPHolC
	 OU9k1I76ZRzFfX9hb6RqCrqLFkGFCI4kQnatoEbDZ2vgHuApCICAm+pfHU/o27pKEA
	 AKx7XTQr0tOE67tYeojLL4ifJNO5glEStvru9b3yOHuvWi9jASPy+B/X6b0EqFjPFK
	 SH9n9ZzOXugsA==
Date: Tue, 20 Feb 2024 18:16:25 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, chandan.babu@oracle.com
Subject: Re: [PATCH] xfs: fix SEEK_HOLE/DATA for regions with active COW
 extents
Message-ID: <20240221021625.GC616564@frogsfrogsfrogs>
References: <20240220224928.3356-1-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220224928.3356-1-david@fromorbit.com>

On Wed, Feb 21, 2024 at 09:49:28AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> A data corruption problem was reported by CoreOS image builders
> when using reflink based disk image copies and then converting
> them to qcow2 images. The converted images failed the conversion
> verification step, and it was isolated down to the fact that
> qemu-img uses SEEK_HOLE/SEEK_DATA to find the data it is supposed to
> copy.
> 
> The reproducer allowed me to isolate the issue down to a region of
> the file that had overlapping data and COW fork extents, and the
> problem was that the COW fork extent was being reported in it's
> entirity by xfs_seek_iomap_begin() and so skipping over the real
> data fork extents in that range.
> 
> This was somewhat hidden by the fact that 'xfs_bmap -vvp' reported
> all the extents correctly, and reading the file completely (i.e. not
> using seek to skip holes) would map the file correctly and all the
> correct data extents are read. Hence the problem is isolated to just
> the xfs_seek_iomap_begin() implementation.
> 
> Instrumentation with trace_printk made the problem obvious: we are
> passing the wrong length to xfs_trim_extent() in
> xfs_seek_iomap_begin(). We are passing the end_fsb, not the
> maximum length of the extent we want to trim the map too. Hence the
> COW extent map never gets trimmed to the start of the next data fork
> extent, and so the seek code treats the entire COW fork extent as
> unwritten and skips entirely over the data fork extents in that
> range.
> 
> Link: https://github.com/coreos/coreos-assembler/issues/3728
> Fixes: 60271ab79d40 ("xfs: fix SEEK_DATA for speculative COW fork preallocation")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_iomap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 18c8f168b153..055cdec2e9ad 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1323,7 +1323,7 @@ xfs_seek_iomap_begin(
>  	if (cow_fsb != NULLFILEOFF && cow_fsb <= offset_fsb) {
>  		if (data_fsb < cow_fsb + cmap.br_blockcount)
>  			end_fsb = min(end_fsb, data_fsb);
> -		xfs_trim_extent(&cmap, offset_fsb, end_fsb);
> +		xfs_trim_extent(&cmap, offset_fsb, end_fsb - offset_fsb);

Doh.  Is there a reproducer we can hammer into a fstests regression test?
Sure would be nice if the type system actually caught things like this
for us.

Anyway thanks for fixing this,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
>  		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
>  				IOMAP_F_SHARED, seq);
> @@ -1348,7 +1348,7 @@ xfs_seek_iomap_begin(
>  	imap.br_state = XFS_EXT_NORM;
>  done:
>  	seq = xfs_iomap_inode_sequence(ip, 0);
> -	xfs_trim_extent(&imap, offset_fsb, end_fsb);
> +	xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
>  	error = xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
>  out_unlock:
>  	xfs_iunlock(ip, lockmode);
> -- 
> 2.43.0
> 
> 
