Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED97B1DAC81
	for <linux-xfs@vger.kernel.org>; Wed,  5 Feb 2025 21:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738789701; cv=none; b=tnTBOu1UZPIDWMQf0KWDRFDtDWbBFTM6P+VEZqgYLPCAmwaiAAwrzWYpdWokqWKWxtmLjTNd/bz6FTSvKmsMqUK9XkDNJOYdLAki6VODCHFl0DFRBYSHnNhkKe2A7R8E4zADPlRlOj2J8xlhWB0e9UlaN+0I1IxM9BzqUeh1T24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738789701; c=relaxed/simple;
	bh=7zMIula4ZZk2Nld/KtfeNMJzLibNye9bCucFP60U/Rs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lij5/yIImIc+EE+TIwd3AjFEjul4xtUs/7byup7nrbXxli89v8VAOqaUs/RrD0CyMfL6t7+D0Zd4WRfXpZVqYq2U5j9vtVOdF7y/53W8vOuXArW8OlHleG6yDL/522WZQsZPJDjnCcRpG85zxd1W1kiTLne7wac9Z9SP5/ss+Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=lHSEBLFw; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="lHSEBLFw"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2ee9a780de4so197391a91.3
        for <linux-xfs@vger.kernel.org>; Wed, 05 Feb 2025 13:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738789698; x=1739394498; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3FeaigpjY4Cq4IKCT8DoDgC3FsX/z24sdMawiy09k78=;
        b=lHSEBLFw1B0QC51SShG2J/JqPp8esCL3QJEzJqtdgQoit4P/YLupwU9c8/Uo6351nN
         X0E815QirdbNIT8DNY/GTM9nfxLefVyRlUlpQkFQyT6Y2+tcX3hS420mHitQaUd6jyIH
         rSHYql560MsiXEwuRxVfHE0eucEfP3mtV3UDaJC1F2TvvNXTYu0Obz2Sums0mN33MN6r
         hT/y2TeGEI0nZZBqZKvYYM/Qw6eYPKn8XKsfVjM9AS+WgDwvVXhyYon8XXHu3Rt3ZCb5
         XSg0iV0yPGdBHDkSdC9+DiS88Q3Oc8q1GlJOYkCx9GYYLhfC6UsgJ7C910i9wIZ581MR
         ufLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738789698; x=1739394498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3FeaigpjY4Cq4IKCT8DoDgC3FsX/z24sdMawiy09k78=;
        b=d4UUrqPsGeQMA2fYu6JYXRHc1Oo3KlW1V7vbjobKV+i4NsAyEKqpwWrJDmUzquy2BQ
         1WP1fQGg92Nf6mWVmpxbbQFBZ5hBDoTIMtwRfj5TCrdIiCMhDI3oh9UFyN3hxzRSwQeo
         yEXYyn9c20Jc9TO0eg6+AUu87/Y5dVd9a0Epz1mFFkZAZw/PGBkqcakcL9Hk9YTs9RCv
         zdewDpQ4drCUFugOOxd6ziPbflfiij50sGnhHRY+TIia6cYWeuzJoL9dfE10KhLkXrZB
         aIjAEiiaeiJiDD/xCaEwW7D91R4EJJVyPDnjD5RCMW9t7DfjzXEvAmQPBiv0iKRnuRDD
         4jGQ==
X-Forwarded-Encrypted: i=1; AJvYcCX88hEWr3MeoV/XC2qlNU/IQIW1UWs6Vcn3IjV7AfTBEY6fzXetg0hajS+KmTtw9yW4pfc+8dHdkmo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZDdDKHeof9TDt30kaQu5NHEDv8p9Z10mlCeXpKgOE8Arf6Gt4
	h4VaBHjPYzW//I1Tl5S+WTkzjotDipqxnCfHNkmE5XOWqjKXgqVWMtDUTtv+vZmvePFBTpZD8ci
	P
X-Gm-Gg: ASbGncsNmOVZhqUh5ysyJDdp/8digHrDSHu/AhmjbFqPLRkffS21INuisceWqp07IoL
	Fr3kcvERGBUDbszFWddBNtgPi3x4kWhXDNiEpVqqWQBlXF4jQTuUycAKU/u9i71VUNsQlUdACeR
	LsOhgTZMjwHc43ag4B3vLuYIggsW2Q8zjPrDpfHDU62Sj99L8ZcAOAMjl+IVCuTbpAutFqCXlJi
	ISuLeKWHS0JkbUnWIIr+rtZv3PrpJsLkvdZHttfs8LVwPHRWxvt0kvbC527MxULvdCaH09zfPnP
	CCjbhJIFp10RXuqAAspdMsJ2c0OuFPXOESgCjfIzC56QrtJ/QmI8TUj/uNXIgssitig=
X-Google-Smtp-Source: AGHT+IHAoPu2e0YEEqRf2PZaYqDcd7uJ34Mu9ma2YgSKpOeUG3xCouHEhUwmU8X5tsEP8MBIgvSuow==
X-Received: by 2002:a05:6a00:3991:b0:728:e2cc:bfd6 with SMTP id d2e1a72fcca58-730351dd5d3mr6730846b3a.18.1738789697651;
        Wed, 05 Feb 2025 13:08:17 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe631bfa5sm12901050b3a.9.2025.02.05.13.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2025 13:08:17 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfmd4-0000000F5nz-2700;
	Thu, 06 Feb 2025 08:08:14 +1100
Date: Thu, 6 Feb 2025 08:08:14 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Zorro Lang <zlang@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: flush inodegc before swapon
Message-ID: <Z6PTPoYfyn-1-hHr@dread.disaster.area>
References: <20250205162813.2249154-1-hch@lst.de>
 <20250205162813.2249154-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205162813.2249154-2-hch@lst.de>

On Wed, Feb 05, 2025 at 05:28:00PM +0100, Christoph Hellwig wrote:
> Fix the brand new xfstest that tries to swapon on a recently unshared
> file and use the chance to document the other bit of magic in this
> function.

You haven't documented the magic at all - I have no clue what the
bug being fixed is nor how adding an inodegc flush fixes anything
to do with swap file activation....

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 69b8c2d1937d..c792297aa0a3 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -21,6 +21,7 @@
>  #include "xfs_error.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_rtgroup.h"
> +#include "xfs_icache.h"
>  
>  struct xfs_writepage_ctx {
>  	struct iomap_writepage_ctx ctx;
> @@ -685,7 +686,22 @@ xfs_iomap_swapfile_activate(
>  	struct file			*swap_file,
>  	sector_t			*span)
>  {
> -	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;
> +	struct xfs_inode		*ip = XFS_I(file_inode(swap_file));
> +
> +	/*
> +	 * Ensure inode GC has finished to remove unmapped extents, as the
> +	 * reflink bit is only cleared once all previously shared extents
> +	 * are unmapped.  Otherwise swapon could incorrectly fail on a
> +	 * very recently unshare file.
> +	 */
> +	xfs_inodegc_flush(ip->i_mount);

The comment doesn't explains what this actually fixes. Inodes that
are processed by inodegc *must* be unreferenced by the VFS, so it
is not clear exactly what this is actually doing.

I'm guessing that the test in question is doing something like this:

	file2 = clone(file1)
	unlink(file1)
	swapon(file2)

and so the swap file activation is racing with the background
inactivation and extent removal of file1?

But in that case, the extents are being removed from file1, and at
no time does that remove the reflink bit on file2. i.e. even if the
inactivation of file1 results in all the extents in file2 no longer
being shared, that only results in refcountbt updates and it does
not get propagated back to file2's inode. i.e. file2 will still be
marked as a reflink file containing shared extents.

So I'm kinda clueless as to what this change is actually
doing/fixing because the comments and commit message do not describe
the bug that is being fixed, nor how the change fixes that bug.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
