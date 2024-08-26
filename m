Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89006804
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 04:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724648204; cv=none; b=Sm2CY96WDxjHE/puDC60hMLsv3zm1Bgo2sE7F+46C6BVfXpBU5Kq2ZlGIzuFI3/GNl064VsKNjK6Y4dyifAUFAfeV7z0j/uBoyrFUiZL5jFj99azozI+5pGFq0yCKMt6BvH+skRJRQKXAHvRsc1XL0b7iSO/TPmvfZJDqmV+aRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724648204; c=relaxed/simple;
	bh=v7F2d/ir9aK4OiS4WvHG991fIGppaeKRn8ia01knjkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uUE0BOQv8ekKMbXJC+mNmkXqi15RZWxVi2aHlPtBR9zh/5Q/dfx50XoGsvsuz7XfxJKRxzaGM/W0EtkEtfYqM13VOoT1yuDZpf1igxrhDq8qXKtssvx6pBYXfB1QKPh7iR1mQuFEruAWqaEbAAObnuuHP4/tz49O0N2zOxD5qCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=pLD02bJH; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="pLD02bJH"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-70cec4aa1e4so2804105b3a.1
        for <linux-xfs@vger.kernel.org>; Sun, 25 Aug 2024 21:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724648201; x=1725253001; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tWEQOsbrt/4xcdE5n1WJeSEb4Zi6YXYF93iiMZE1Tzg=;
        b=pLD02bJH8pZzo/j4h7tr7PvSa4KZXVgFh2UJ0vNyeFu/EhEkxiSAvTP3Cjvb4lwxIt
         roAVxDXfCWA1xymmF6AyaVEaLyg0QrlGqdJ0E3nb0Ci8H4LGgf70FcytkF56bfCkFKXD
         L3em/jpnC4Uogzyo/sTYsoKEwhBzod8nAVuFu9+ltno1oW6Y2vZp5zMr9JrbajMVNs46
         tsFhrlNCVR/QEy/w4XUqmDY26P9rXi5CWgH/1XFw4GmamDTInl4p09RdCFjoUjYubf90
         v57C95LsnXZFW+Grn5osWNni2BgYKBhK2PZEYJw/qwyxcpa3Lw8hzjin6amTRgKZjEvj
         8XWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724648201; x=1725253001;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWEQOsbrt/4xcdE5n1WJeSEb4Zi6YXYF93iiMZE1Tzg=;
        b=iLbAzSPiwlzKIYH0aOqe/wKuydpAXvJdLLg8rJZDdIrTQxsOkeWcjjG1kuj1JZVgjQ
         9ABoUUJP0hoNp69Kcvx1hLAcwgNOtCgTqNSwv/pTduMRW6hZzmZrQTVSsBWCrLlkiT3K
         NDv8es2OFoajCXY/1jIosLlt6RzIwV28TFO/p0cLWMvJaFclpTRNtjPpDh2CS+iznRbW
         PZkC5dE/iEmTqjrjZHNGssW901mCJAHLjfz9Zx8R/DciUNID5FSkaRtF1tkv4Hl9dhOi
         o6mNFdLIbX08yDL4i69DqYCibQu2ld7HRwT0YJHUCYEIr1lFrc4u6WihDj5EBdyNfQCC
         HBMg==
X-Forwarded-Encrypted: i=1; AJvYcCUJHWMzu6M8NUMJwaDZ/s/34+meIQSTFSbgXn4HukATeE/Ga93aZYpxuAvItH0G+rXv0VItzzZg+8k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyyc6rgUlLzrsGBz98jVQ02Kl8iKGQ1Oy5GIlzvoKougpN9pmF7
	BhjL8NKJTG3x5E4uH3SVFl8K4RKqk/+DWTxJdbPFb2iR8IPLXm2AOa51LX1Zozw10H0U9ZudZaD
	l
X-Google-Smtp-Source: AGHT+IEACL6bLSyDjimWx3Pe66K/+n6QW8QPJvcWt5vXuLFrIsJw+E6mHYWAzsZcyhezHWH/gClQfg==
X-Received: by 2002:a05:6a00:23c1:b0:70d:2a88:a486 with SMTP id d2e1a72fcca58-71445898c71mr10682739b3a.29.1724648200573;
        Sun, 25 Aug 2024 21:56:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714343094a8sm6346710b3a.166.2024.08.25.21.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Aug 2024 21:56:40 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1siRmP-00CzHI-0F;
	Mon, 26 Aug 2024 14:56:37 +1000
Date: Mon, 26 Aug 2024 14:56:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/26] xfs: make the RT allocator rtgroup aware
Message-ID: <ZswLBVOUvwhJZInN@dread.disaster.area>
References: <172437088439.60592.14498225725916348568.stgit@frogsfrogsfrogs>
 <172437088886.60592.11418423460788700576.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172437088886.60592.11418423460788700576.stgit@frogsfrogsfrogs>

On Thu, Aug 22, 2024 at 05:26:38PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Make the allocator rtgroup aware by either picking a specific group if
> there is a hint, or loop over all groups otherwise.  A simple rotor is
> provided to pick the placement for initial allocations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_bmap.c     |   13 +++++-
>  fs/xfs/libxfs/xfs_rtbitmap.c |    6 ++-
>  fs/xfs/xfs_mount.h           |    1 
>  fs/xfs/xfs_rtalloc.c         |   98 ++++++++++++++++++++++++++++++++++++++----
>  4 files changed, 105 insertions(+), 13 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 126a0d253654a..88c62e1158ac7 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3151,8 +3151,17 @@ xfs_bmap_adjacent_valid(
>  	struct xfs_mount	*mp = ap->ip->i_mount;
>  
>  	if (XFS_IS_REALTIME_INODE(ap->ip) &&
> -	    (ap->datatype & XFS_ALLOC_USERDATA))
> -		return x < mp->m_sb.sb_rblocks;
> +	    (ap->datatype & XFS_ALLOC_USERDATA)) {
> +		if (x >= mp->m_sb.sb_rblocks)
> +			return false;
> +		if (!xfs_has_rtgroups(mp))
> +			return true;
> +
> +		return xfs_rtb_to_rgno(mp, x) == xfs_rtb_to_rgno(mp, y) &&
> +			xfs_rtb_to_rgno(mp, x) < mp->m_sb.sb_rgcount &&
> +			xfs_rtb_to_rtx(mp, x) < mp->m_sb.sb_rgextents;

WHy do we need the xfs_has_rtgroups() check here? The new rtg logic will
return true for an old school rt device here, right?

> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 3fedc552b51b0..2b57ff2687bf6 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1661,8 +1661,9 @@ xfs_rtalloc_align_minmax(
>  }
>  
>  static int
> -xfs_rtallocate(
> +xfs_rtallocate_rtg(
>  	struct xfs_trans	*tp,
> +	xfs_rgnumber_t		rgno,
>  	xfs_rtblock_t		bno_hint,
>  	xfs_rtxlen_t		minlen,
>  	xfs_rtxlen_t		maxlen,
> @@ -1682,16 +1683,33 @@ xfs_rtallocate(
>  	xfs_rtxlen_t		len = 0;
>  	int			error = 0;
>  
> -	args.rtg = xfs_rtgroup_grab(args.mp, 0);
> +	args.rtg = xfs_rtgroup_grab(args.mp, rgno);
>  	if (!args.rtg)
>  		return -ENOSPC;
>  
>  	/*
> -	 * Lock out modifications to both the RT bitmap and summary inodes.
> +	 * We need to lock out modifications to both the RT bitmap and summary
> +	 * inodes for finding free space in xfs_rtallocate_extent_{near,size}
> +	 * and join the bitmap and summary inodes for the actual allocation
> +	 * down in xfs_rtallocate_range.
> +	 *
> +	 * For RTG-enabled file system we don't want to join the inodes to the
> +	 * transaction until we are committed to allocate to allocate from this
> +	 * RTG so that only one inode of each type is locked at a time.
> +	 *
> +	 * But for pre-RTG file systems we need to already to join the bitmap
> +	 * inode to the transaction for xfs_rtpick_extent, which bumps the
> +	 * sequence number in it, so we'll have to join the inode to the
> +	 * transaction early here.
> +	 *
> +	 * This is all a bit messy, but at least the mess is contained in
> +	 * this function.
>  	 */
>  	if (!*rtlocked) {
>  		xfs_rtgroup_lock(args.rtg, XFS_RTGLOCK_BITMAP);
> -		xfs_rtgroup_trans_join(tp, args.rtg, XFS_RTGLOCK_BITMAP);
> +		if (!xfs_has_rtgroups(args.mp))
> +			xfs_rtgroup_trans_join(tp, args.rtg,
> +					XFS_RTGLOCK_BITMAP);
>  		*rtlocked = true;
>  	}
>  
> @@ -1701,7 +1719,7 @@ xfs_rtallocate(
>  	 */
>  	if (bno_hint)
>  		start = xfs_rtb_to_rtx(args.mp, bno_hint);
> -	else if (initial_user_data)
> +	else if (!xfs_has_rtgroups(args.mp) && initial_user_data)
>  		start = xfs_rtpick_extent(args.rtg, tp, maxlen);

Check initial_user_data first - we don't care if there are rtgroups
enabled if initial_user_data is not true, and we only ever allocate
initial data on an inode once...

> @@ -1741,6 +1767,53 @@ xfs_rtallocate(
>  	return error;
>  }
>  
> +static int
> +xfs_rtallocate_rtgs(
> +	struct xfs_trans	*tp,
> +	xfs_fsblock_t		bno_hint,
> +	xfs_rtxlen_t		minlen,
> +	xfs_rtxlen_t		maxlen,
> +	xfs_rtxlen_t		prod,
> +	bool			wasdel,
> +	bool			initial_user_data,
> +	xfs_rtblock_t		*bno,
> +	xfs_extlen_t		*blen)
> +{
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	xfs_rgnumber_t		start_rgno, rgno;
> +	int			error;
> +
> +	/*
> +	 * For now this just blindly iterates over the RTGs for an initial
> +	 * allocation.  We could try to keep an in-memory rtg_longest member
> +	 * to avoid the locking when just looking for big enough free space,
> +	 * but for now this keep things simple.
> +	 */
> +	if (bno_hint != NULLFSBLOCK)
> +		start_rgno = xfs_rtb_to_rgno(mp, bno_hint);
> +	else
> +		start_rgno = (atomic_inc_return(&mp->m_rtgrotor) - 1) %
> +				mp->m_sb.sb_rgcount;
> +
> +	rgno = start_rgno;
> +	do {
> +		bool		rtlocked = false;
> +
> +		error = xfs_rtallocate_rtg(tp, rgno, bno_hint, minlen, maxlen,
> +				prod, wasdel, initial_user_data, &rtlocked,
> +				bno, blen);
> +		if (error != -ENOSPC)
> +			return error;
> +		ASSERT(!rtlocked);
> +
> +		if (++rgno == mp->m_sb.sb_rgcount)
> +			rgno = 0;
> +		bno_hint = NULLFSBLOCK;
> +	} while (rgno != start_rgno);
> +
> +	return -ENOSPC;
> +}
> +
>  static int
>  xfs_rtallocate_align(
>  	struct xfs_bmalloca	*ap,
> @@ -1835,9 +1908,16 @@ xfs_bmap_rtalloc(
>  	if (xfs_bmap_adjacent(ap))
>  		bno_hint = ap->blkno;
>  
> -	error = xfs_rtallocate(ap->tp, bno_hint, raminlen, ralen, prod,
> -			ap->wasdel, initial_user_data, &rtlocked,
> -			&ap->blkno, &ap->length);
> +	if (xfs_has_rtgroups(ap->ip->i_mount)) {
> +		error = xfs_rtallocate_rtgs(ap->tp, bno_hint, raminlen, ralen,
> +				prod, ap->wasdel, initial_user_data,
> +				&ap->blkno, &ap->length);
> +	} else {
> +		error = xfs_rtallocate_rtg(ap->tp, 0, bno_hint, raminlen, ralen,
> +				prod, ap->wasdel, initial_user_data,
> +				&rtlocked, &ap->blkno, &ap->length);
> +	}

The xfs_has_rtgroups() check is unnecessary.  The iterator in
xfs_rtallocate_rtgs() will do the right thing for the
!xfs_has_rtgroups() case - it'll set start_rgno = 0 and break out
after a single call to xfs_rtallocate_rtg() with rgno = 0.

Another thing that probably should be done here is push all the
constant value calculations a couple of functions down the stack to
where they are used. Then we only need to pass two parameters down
through the rg iterator here, not 11...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
