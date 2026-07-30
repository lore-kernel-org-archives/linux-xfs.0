Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFC235DA67;
	Thu, 30 Jul 2026 15:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426191; cv=none; b=GlgoX4/rAJz987zH0RVcwwNvByUqIdMx+f6SaVI1gN0em1k7n6+uL2kYtcO6VDHw5W9SFveGMUEMoKxesKhSopSg/3jEAZFeVuUunalV+r0mI6jhmL/TXd9neT2FwAchQbqH1jbzhOy8S1On63gQH1X9jHXr/QUbxcIxDfHjVRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426191; c=relaxed/simple;
	bh=hoZ2MooIcRR1KLzUbrNh/0dhmoEftThKB18kLgE6l7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TBHNZcAuwhA/ILFKY4WYkOJiJBQkYTrdBQXA3f9Z3yxtcqvrp3iFPCoXuvjF+kjpRdDSrZsq+YojGC+TQUwHXvNbs1lMrx3PZe969TccUkvtS8E5FuZCAgGC0Juhu6kTqUjMWAbUj5jSYtwgEVjiaH3StY2qYXNQ+xAB+jXT528=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nj8WndAT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nj8WndAT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5BB791F00A3A;
	Thu, 30 Jul 2026 15:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785426190;
	bh=V8ajVhx5Olpbz9/8qzclvjn7zgN0SBtZsqJEhp6w6Vs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Nj8WndATH+yS1nx46cJyvGPmWMnKf0F0Gx5VPFuGsJbqC0hlcTRAI0BV2Y+X9OujG
	 O7Nhsj/WtJzcUB6AWMcqH837kzujtsM1opKQExp7PcbHF5ZzH4i3W4KonH2TQPOJq7
	 6Zt2g/XSYuZjAwqZRpdXfj8l1ZWwdw5ug6qucSWTCPZcdEhwD/xD7ayLJLXCg/W0fj
	 gwP2aBlOVbBMm7qaTSzadGagj5QJaTNor6xPglhQjCZdz4Pm1ynS/3XZPGr0Ib2psD
	 /+n3PstbKBRheuSZt5j/CUhhvZTRX4N4oniWmdLHmBfh62IRvYCN2enCUmKEvxMILG
	 QF8gacN20gG0w==
Date: Thu, 30 Jul 2026 08:43:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Hongling Zeng <zenghongling@kylinos.cn>
Cc: cem@kernel.org, chandanrlinux@gmail.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, zhongling0719@126.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v3] xfs: fix heap buffer overflow in xfs_bmbt_to_bmdr
Message-ID: <20260730154309.GB3556460@frogsfrogsfrogs>
References: <20260730094824.200669-1-zenghongling@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730094824.200669-1-zenghongling@kylinos.cn>

Please take a breath and refrain from sending the same patch three times
in ninety minutes.  Figure out what you want to change, run it through
some testing, and only send it once you've stopped finding things to
tweak.

--D

On Thu, Jul 30, 2026 at 05:48:24PM +0800, Hongling Zeng wrote:
> The xfs_bmbt_to_bmdr() function converts an in-memory btree root to
> on-disk form during log recovery. It uses bb_numrecs from the source
> to determine memcpy size without validating against the destination
> fork capacity.
> 
> Current code:
>   dmxr = xfs_bmdr_maxrecs(dblocklen, 0);           // destination capacity
>   ...
>   dmxr = be16_to_cpu(dblock->bb_numrecs);          // overwrite with source value!
>   memcpy(..., * dmxr);                              // may overflow destination!
> 
> If bb_numrecs is larger than the destination fork capacity,
> memcpy writes beyond the fork buffer, causing heap overflow.
> 
> Fix by validating bb_numrecs against the destination capacity
> before using it for memcpy operations.
> 
> Cc: stable@vger.kernel.org
> Fixes: 8ea5682d0711 ("xfs: refactor log recovery item dispatch for pass2 readhead functions")
> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
> ---
> Change in v3:
> - Use dmxr for tpp calculation (on-disk format) and nrecs for memcpy (actual records)
> ---
> Change in v2:
> - Ensure memcpy operations consistently use nrecs instead of dmxr.
> ---
>  fs/xfs/libxfs/xfs_bmap_btree.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
> index 758a4b1ccf5b..a119053d67b5 100644
> --- a/fs/xfs/libxfs/xfs_bmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_bmap_btree.c
> @@ -151,6 +151,7 @@ xfs_bmbt_to_bmdr(
>  	int			dmxr;
>  	xfs_bmbt_key_t		*fkp;
>  	__be64			*fpp;
> +	int                     nrecs;
>  	xfs_bmbt_key_t		*tkp;
>  	__be64			*tpp;
>  
> @@ -167,14 +168,19 @@ xfs_bmbt_to_bmdr(
>  	ASSERT(rblock->bb_level != 0);
>  	dblock->bb_level = rblock->bb_level;
>  	dblock->bb_numrecs = rblock->bb_numrecs;
> +
> +	/* Validate record count against destination fork capacity */
> +	nrecs = be16_to_cpu(rblock->bb_numrecs);
>  	dmxr = xfs_bmdr_maxrecs(dblocklen, 0);
> +	if (nrecs > dmxr)
> +		return;
> +
>  	fkp = xfs_bmbt_key_addr(mp, rblock, 1);
>  	tkp = xfs_bmdr_key_addr(dblock, 1);
>  	fpp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, rblocklen);
>  	tpp = xfs_bmdr_ptr_addr(dblock, 1, dmxr);
> -	dmxr = be16_to_cpu(dblock->bb_numrecs);
> -	memcpy(tkp, fkp, sizeof(*fkp) * dmxr);
> -	memcpy(tpp, fpp, sizeof(*fpp) * dmxr);
> +	memcpy(tkp, fkp, sizeof(*fkp) * nrecs);
> +	memcpy(tpp, fpp, sizeof(*fpp) * nrecs);
>  }
>  
>  STATIC struct xfs_btree_cur *
> -- 
> 2.25.1
> 
> 
