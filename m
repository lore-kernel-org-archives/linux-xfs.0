Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933E11A38C3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 21:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714513405; cv=none; b=JykFG3kNLKvibfJlS15EaJz2rW40MhjRKgooBkcl/PupYKf4Y1A4A6plc9Ano0/6othjUE9V/dFpy8RgONcQ1Q2XJva5oUtZTtM9j4v5qvQKvcIYoSiuboZnfX+fBpMQZO4G2uRL4RXvkBHlOtjL2YHOTWcf361ZlGNsL2KAgFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714513405; c=relaxed/simple;
	bh=H3FSFouIxtB4ofki67N3RjS53Sh9PG62I/ROxeRgfnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDTRpJ7Y9gw/+h1jLk6Ajaj2ygs3uaUu8M+j5azKxMFuPuYdGl/odNkWaZMR3aHRo1yXUmq8Cur0L0iaBl/0mrLNTHFtVu4Zh9ngHLi0efnLFTD/jeevBBCKYil4evigg3N8TQtIY6WhyhWwa+RUb9v/Y2XO0IvvqFLarxSh27k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=MPbw4gnw; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="MPbw4gnw"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1e4bf0b3e06so62022765ad.1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 14:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714513403; x=1715118203; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SRUumqYRZzYSye4QLCBGaVNc5xsSsbTzxyasdpw3caA=;
        b=MPbw4gnwy4q72mLxUVYIGgXK15X04L1N8F7jxVL/dDAFqT6YltXI5wFt41uAwAo6h6
         HnsVV5C57Vogf3RE5Y4etyEGXa0F/K1qR0awOhjhKM97mDa3zBeV6oZOgTT5gvrrQase
         g2k3tkw0WLgHLALpMMr1axi2FK/ATR6QclSz36c8SqTsjStAUQDZQJmRNf52x6vxNWDZ
         8JBwZVpMW5SJTM4IZjwWnC6DPYPms751Wc7RJtTVBwRh8Zt/uJSCA8h/c1GASiSh35Z2
         B19O45V5uP5eg+8Poqr5U5Vsc1z66bwRe+ngjsFJEPCyy5INhtoiACP4on/CF+SYjaD/
         mWlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714513403; x=1715118203;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SRUumqYRZzYSye4QLCBGaVNc5xsSsbTzxyasdpw3caA=;
        b=dH4cwW8dMfbfHX3z3OuhglAMfPCgCVOmb55E8rzegpmv1T9VHua0Co53BFqRcJUSpt
         UiqtSJP/3ozc+S2FHaQURJADR4v+FDLoEq9aaYHqYPh+P6jaW/RA3AdjVrO42Bq+wDEi
         Byr83C4RD1eaY6oxYBKpbqNKSsFfdgadfKEsh1FGonOZyzpqJyDVGR9FYcVg0eXFFFIZ
         2Lct+rhUzdnNR9YHp/ZaSmHqBg1WzQ8AKWlFQhrxbRfRRcb9IkVLPbLueJIVtNwNBVm9
         KQOwBbBCfzCYwVZzqO/c5kqw3Ms5O8VP+JBh/0Pvas8pWxPx3W5e/rIclp8WYGxdjdUg
         tAuA==
X-Forwarded-Encrypted: i=1; AJvYcCX/P0KCBrrMCswL/g/tq2oWVhlVD+5ApTtAHRXCSyCLMReE57Oggj4mkFfY9d34vS1cBMNZ15s1Ai7UFVU7KlJsHCQijLAGa2+s
X-Gm-Message-State: AOJu0YwBHmbdNQIvWGd5lGOW3ThYyUAQ9M9gLPYyxkqnyNXryYy3yJDh
	PCl56mhlB+px8DD/f0a1DHVAiH2D1V8dFMbbXxBBp6E68MSz3T+L1Pr5dX8F/u8=
X-Google-Smtp-Source: AGHT+IGbyuK0ELxib3kTMhtErC3PMkRahmtKTHGGM1pfDhGg88CwTRvwESqOygMt1PhDRCe+uwhWoQ==
X-Received: by 2002:a17:90a:6509:b0:2b1:50ba:2683 with SMTP id i9-20020a17090a650900b002b150ba2683mr833899pjj.21.1714513402457;
        Tue, 30 Apr 2024 14:43:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id gd19-20020a17090b0fd300b002a4736f3566sm1068766pjb.0.2024.04.30.14.43.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Apr 2024 14:43:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s1vFu-00Ge33-0Z;
	Wed, 01 May 2024 07:43:18 +1000
Date: Wed, 1 May 2024 07:43:18 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: simplify iext overflow checking and upgrade
Message-ID: <ZjFl9uwKzRUrigTI@dread.disaster.area>
References: <20240430125602.1776108-1-hch@lst.de>
 <20240430125602.1776108-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430125602.1776108-4-hch@lst.de>

On Tue, Apr 30, 2024 at 02:56:02PM +0200, Christoph Hellwig wrote:
> Currently the calls to xfs_iext_count_may_overflow and
> xfs_iext_count_upgrade are always paired.  Merge them into a single
> function to simplify the callers and the actual check and upgrade
> logic itself.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c       |  5 +--
>  fs/xfs/libxfs/xfs_bmap.c       |  5 +--
>  fs/xfs/libxfs/xfs_inode_fork.c | 57 +++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_inode_fork.h |  6 ++--
>  fs/xfs/xfs_bmap_item.c         |  4 +--
>  fs/xfs/xfs_bmap_util.c         | 24 +++-----------
>  fs/xfs/xfs_dquot.c             |  5 +--
>  fs/xfs/xfs_iomap.c             |  9 ++----
>  fs/xfs/xfs_reflink.c           |  9 ++----
>  fs/xfs/xfs_rtalloc.c           |  5 +--
>  10 files changed, 41 insertions(+), 88 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1c2a27fce08a9d..ded92ccefe9f6d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1050,11 +1050,8 @@ xfs_attr_set(
>  		return error;
>  
>  	if (op != XFS_ATTRUPDATE_REMOVE || xfs_inode_hasattr(dp)) {
> -		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> +		error = xfs_iext_count_ensure(args->trans, dp, XFS_ATTR_FORK,
>  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> -		if (error == -EFBIG)
> -			error = xfs_iext_count_upgrade(args->trans, dp,
> -					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 6053f5e5c71eec..3debd0d561b812 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4621,11 +4621,8 @@ xfs_bmapi_convert_delalloc(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	error = xfs_iext_count_may_overflow(ip, whichfork,
> +	error = xfs_iext_count_ensure(tp, ip, whichfork,
>  			XFS_IEXT_ADD_NOSPLIT_CNT);
> -	if (error == -EFBIG)
> -		error = xfs_iext_count_upgrade(tp, ip,
> -				XFS_IEXT_ADD_NOSPLIT_CNT);
>  	if (error)
>  		goto out_trans_cancel;
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 7d660a9739090a..82e670dd1212c4 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -765,53 +765,46 @@ xfs_ifork_verify_local_attr(
>  	return 0;
>  }
>  
> +/*
> + * Check if the inode fork supports adding nr_to_add more extents.
> + *
> + * If it doesn't but we can upgrade it to large extent counters, do the upgrade.
> + * If we can't upgrade or are already using big counters but still can't fit the
> + * additional extents, return -EFBIG.
> + */
>  int
> -xfs_iext_count_may_overflow(
> +xfs_iext_count_ensure(

Everything looks fine, but the name isn't very good. What, exactly,
is this function ensuring about the iext count?  The function is
extending the iext count if needed, so to me the function name
should reflect what it actually does.

xfs_iext_count_extend() seems like a much better name - it tells the
reader what the code is actually doing (i.e. we may have to extend
the iext count before performing this operation) and it makes it
obvious when it is done out of place....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
