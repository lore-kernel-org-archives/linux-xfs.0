Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222B834107D;
	Thu,  2 Jul 2026 16:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010621; cv=none; b=DGaggSmOajOkm3z/XwptxRFfxyUusINrRtf1HBBExbgmT9Y1KbsPYBEoikgoxbsHrBH8fdDR+OSc5mbAZ5u/biUKVv/tnTcRcYv7jSHAV/LQj2XUMpGP+doOG6AgPOs0eoRY/cMfkW9hfxjRiMpNm6hniFDJ4NU0q59lWw7qsrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010621; c=relaxed/simple;
	bh=aIq0GUMqrqOA7uFPzTb/p2Y0XWNGC5ceusxZM7/+eYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s9dVKTxJ8UNq7lajEZsgs/TxGBqGnwIgfv4Xz4sP2m7bCat5pHyRJ9oK6/gB33RqK75E56hnWnTJ6wNfhmyVtpaKLXRyEIA9DAfqMTbi6R0ZGmcmPzaXDdiu+XEOG+rdmSqeFCdUHH5c7cTrhAl11Cbv9N3ZWYV+R/a2yljoNHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPd1V5ZZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPd1V5ZZ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AB1411F00A3A;
	Thu,  2 Jul 2026 16:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783010619;
	bh=4pVWD7v3vJw5/oa17/aFW3VXoWIlbvxLUmoLsWawJ/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lPd1V5ZZjjYJiVfz2np7JTQVPxcMoGEAf82kszXzEFFtkEwe01KQKBwnxZI/GRSHL
	 GrAdOKKM/cGUglwS72KEHLRHB9eGrzdrqTza5RdpEEUYpbf/ZzdJ+bU3awUOF13RPr
	 Qp2GZKceTl+6JkzN8oiVoH49t36RVAtHOEKB0r1HdpJk53agPrCzUzEeOIw241wa3s
	 hMxqlby/46sxR29KP5l6TXH1Pw2Jn6d3DfUB7dw5eyKzvjmtk4G2/VkGjUYuTohp+2
	 qAkJ0toyIlMsYl1l3nPb5SMT9MvdW5w4ODX7mBWKAfgM28BxnuJZGv4lZPcf/YiJNA
	 BHsyMBKW+7Oaw==
Date: Thu, 2 Jul 2026 09:43:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
Message-ID: <20260702164339.GI9392@frogsfrogsfrogs>
References: <20260701000949.1666714-1-joannelkoong@gmail.com>
 <20260701000949.1666714-3-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701000949.1666714-3-joannelkoong@gmail.com>

On Tue, Jun 30, 2026 at 05:09:17PM -0700, Joanne Koong wrote:
> Convert xfs iomap_ops to the new ->iomap_next() callback. This uses the
> iomap_process() helper, which finishes the previous mapping if needed
> and produces the next one. No functional changes are intended.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/xfs/xfs_file.c  |  4 +-
>  fs/xfs/xfs_iomap.c | 96 +++++++++++++++++++++++++++++++++++++++++-----
>  2 files changed, 88 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 845a97c9b063..7f8bef1a9954 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -857,9 +857,9 @@ xfs_file_dio_write_atomic(
>  			NULL, 0);
>  
>  	/*
> -	 * The retry mechanism is based on the ->iomap_begin method returning
> +	 * The retry mechanism is based on the ->iomap_next method returning
>  	 * -ENOPROTOOPT, which would be when the REQ_ATOMIC-based write is not
> -	 * possible. The REQ_ATOMIC-based method typically not be possible if
> +	 * possible. The REQ_ATOMIC-based method is typically not possible if
>  	 * the write spans multiple extents or the disk blocks are misaligned.
>  	 */
>  	if (ret == -ENOPROTOOPT && dops == &xfs_direct_write_iomap_ops) {
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 225c3de88d03..4fa1a5c985db 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1037,8 +1037,18 @@ xfs_direct_write_iomap_begin(
>  	return error;
>  }
>  
> +static int
> +xfs_direct_write_iomap_next(
> +	const struct iomap_iter *iter,
> +	struct iomap		*iomap,
> +	struct iomap		*srcmap)

<unvarnished brainstream ahead>

Now that I see the callsites, I think the "next" name could use some
bikeshedding <cough>.  The purpose of this function is either

(a) to look up the first mapping to start iterating;
(b) to release whatever resources were attached during the current
    iteration and look up the next mapping to continue iterating; or
(c) to decide that it's time to stop iterating.

From that it seems obvious to me that xfs_direct_write_iomap_next yields
iomaps for iteration.  In Python those are called generator functions;
in Rust they're called objects that implement the Iterator trait (or
iterators for short).

How about s/iomap_next/iomap_iter/ ?

Then this function would be called xfs_direct_write_iomap_iter, which
IMO is a closer description of what the function does, which is to say
iterates iomaps for direct writes.

(Yes, my brain might be polluted with thinking that "iomap next" refers
to a major shift, in the sense of "linux next". :P)

> +{
> +	return iomap_process(iter, iomap, srcmap, xfs_direct_write_iomap_begin,
> +			NULL);

But then "iomap_iter" sets up a new problem: should iomap_process have a
new name that goes along with that?  iomap_iter is already taken for the
legacy path.  If we were emulating python I'd suggest iomap_iter_yield
but this is C so we get to reinvent everything from scratch so who
knows.

--D

> +}
> +
>  const struct iomap_ops xfs_direct_write_iomap_ops = {
> -	.iomap_begin		= xfs_direct_write_iomap_begin,
> +	.iomap_next		= xfs_direct_write_iomap_next,

>  };
>  
>  #ifdef CONFIG_XFS_RT
> @@ -1089,8 +1099,18 @@ xfs_zoned_direct_write_iomap_begin(
>  	return 0;
>  }
>  
> +static int
> +xfs_zoned_direct_write_iomap_next(
> +	const struct iomap_iter *iter,
> +	struct iomap		*iomap,
> +	struct iomap		*srcmap)
> +{
> +	return iomap_process(iter, iomap, srcmap,
> +			xfs_zoned_direct_write_iomap_begin, NULL);
> +}
> +
>  const struct iomap_ops xfs_zoned_direct_write_iomap_ops = {
> -	.iomap_begin		= xfs_zoned_direct_write_iomap_begin,
> +	.iomap_next		= xfs_zoned_direct_write_iomap_next,
>  };
>  #endif /* CONFIG_XFS_RT */
>  
> @@ -1274,8 +1294,18 @@ xfs_atomic_write_cow_iomap_begin(
>  	return error;
>  }
>  
> +static int
> +xfs_atomic_write_cow_iomap_next(
> +	const struct iomap_iter *iter,
> +	struct iomap		*iomap,
> +	struct iomap		*srcmap)
> +{
> +	return iomap_process(iter, iomap, srcmap,
> +			xfs_atomic_write_cow_iomap_begin, NULL);
> +}
> +
>  const struct iomap_ops xfs_atomic_write_cow_iomap_ops = {
> -	.iomap_begin		= xfs_atomic_write_cow_iomap_begin,
> +	.iomap_next		= xfs_atomic_write_cow_iomap_next,
>  };
>  
>  static int
> @@ -1298,9 +1328,18 @@ xfs_dax_write_iomap_end(
>  	return xfs_reflink_end_cow(ip, pos, written);
>  }
>  
> +static int
> +xfs_dax_write_iomap_next(
> +	const struct iomap_iter *iter,
> +	struct iomap		*iomap,
> +	struct iomap		*srcmap)
> +{
> +	return iomap_process(iter, iomap, srcmap, xfs_direct_write_iomap_begin,
> +			xfs_dax_write_iomap_end);
> +}
> +
>  const struct iomap_ops xfs_dax_write_iomap_ops = {
> -	.iomap_begin	= xfs_direct_write_iomap_begin,
> -	.iomap_end	= xfs_dax_write_iomap_end,
> +	.iomap_next	= xfs_dax_write_iomap_next,
>  };
>  
>  /*
> @@ -2168,9 +2207,19 @@ xfs_buffered_write_iomap_end(
>  	return 0;
>  }
>  
> +static int
> +xfs_buffered_write_iomap_next(
> +	const struct iomap_iter *iter,
> +	struct iomap		*iomap,
> +	struct iomap		*srcmap)
> +{
> +	return iomap_process(iter, iomap, srcmap,
> +			xfs_buffered_write_iomap_begin,
> +			xfs_buffered_write_iomap_end);
> +}
> +
>  const struct iomap_ops xfs_buffered_write_iomap_ops = {
> -	.iomap_begin		= xfs_buffered_write_iomap_begin,
> -	.iomap_end		= xfs_buffered_write_iomap_end,
> +	.iomap_next		= xfs_buffered_write_iomap_next,
>  };
>  
>  static int
> @@ -2214,8 +2263,17 @@ xfs_read_iomap_begin(
>  				 shared ? IOMAP_F_SHARED : 0, seq);
>  }
>  
> +static int
> +xfs_read_iomap_next(
> +	const struct iomap_iter *iter,
> +	struct iomap		*iomap,
> +	struct iomap		*srcmap)
> +{
> +	return iomap_process(iter, iomap, srcmap, xfs_read_iomap_begin, NULL);
> +}
> +
>  const struct iomap_ops xfs_read_iomap_ops = {
> -	.iomap_begin		= xfs_read_iomap_begin,
> +	.iomap_next		= xfs_read_iomap_next,
>  };
>  
>  static int
> @@ -2302,8 +2360,17 @@ xfs_seek_iomap_begin(
>  	return error;
>  }
>  
> +static int
> +xfs_seek_iomap_next(
> +	const struct iomap_iter *iter,
> +	struct iomap		*iomap,
> +	struct iomap		*srcmap)
> +{
> +	return iomap_process(iter, iomap, srcmap, xfs_seek_iomap_begin, NULL);
> +}
> +
>  const struct iomap_ops xfs_seek_iomap_ops = {
> -	.iomap_begin		= xfs_seek_iomap_begin,
> +	.iomap_next		= xfs_seek_iomap_next,
>  };
>  
>  static int
> @@ -2349,8 +2416,17 @@ xfs_xattr_iomap_begin(
>  	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_XATTR, seq);
>  }
>  
> +static int
> +xfs_xattr_iomap_next(
> +	const struct iomap_iter *iter,
> +	struct iomap		*iomap,
> +	struct iomap		*srcmap)
> +{
> +	return iomap_process(iter, iomap, srcmap, xfs_xattr_iomap_begin, NULL);
> +}
> +
>  const struct iomap_ops xfs_xattr_iomap_ops = {
> -	.iomap_begin		= xfs_xattr_iomap_begin,
> +	.iomap_next		= xfs_xattr_iomap_next,
>  };
>  
>  int
> -- 
> 2.52.0
> 
> 
