Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D11433AC
	for <linux-xfs@vger.kernel.org>; Mon, 16 Jun 2025 08:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750060963; cv=none; b=oOMWfIthJ8izAADd6VNjmqY4XDn8F8Pct/neIEl6xEapE1RRsSS2E84FHYziKarDLgoPUgKlt4j6seHEmP+5H0ThbLyt+JIEDS4lmQTGLXdpYJjChnrcl224+uedicoLSw2Yn3OBB5xzB88pKlE5SPE6YMTmWKQHCdgqpLKkGgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750060963; c=relaxed/simple;
	bh=yqblgMlta/EmQP4oL2w6WPLT5Il2FZEHImBiqYv21FQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bp/rZPplXzO4hh45HACVuu459FMNiPvDg4EIDdYzHNNE+hCeJAlw3GZJSGZfA1z2UB5fatq2UlvCArC9pqsGcGlxqCTqizXFSaLCIgjfq03Gt1UNt8GcF3E7mTvvuTyqgWmF+Wi8Sbkm8r7PEzWvrHA6hK90eNDsfH9j/aJsS3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TslHGqI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TslHGqI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6A3C4CEEE;
	Mon, 16 Jun 2025 08:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750060962;
	bh=yqblgMlta/EmQP4oL2w6WPLT5Il2FZEHImBiqYv21FQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TslHGqI0+9sSteZZQ83GL0+XNnwg3jgf3Eq/oUGkPRqCj8GqI4HhXFHNsYj38dBvX
	 6e5tEjB0E+2z1/ijzzu97N4s9La8sutRC1lHDa3TVJQ93Y9sHEFKmXsXnSoo1EFHaB
	 cL/SdjPSo0IctlKwMhA10b1v95q3khVygy6U9cTrWRnPKS85L84FvUMphoEKS1sEMf
	 1tJDm6QxRnXUMMw0WsN82oqv545u06Wc4LDpo1GbuwnR206kmSC46UikMs8+uCoNU7
	 asfAnzgneYxZ/QPSvFv6ChhKoJUluiRMyuwUqoNVjb3M8eDXKc6OSQtxJCh+vQUOap
	 oCqZPuiGBVMvg==
Date: Mon, 16 Jun 2025 10:02:38 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, Hans Holmberg <Hans.Holmberg@wdc.com>
Subject: Re: [PATCH 4/4] xfs: move xfs_submit_zoned_bio a bit
Message-ID: <y5fc26teupvhmyjwhfdp35boddu6cl4v4n7ydgg3ddq6jin3lp@zfucicwnlwvh>
References: <20250605061638.993152-1-hch@lst.de>
 <HjP_LoqLwGY-DwUa0FFHHrjvi8oH-HNSn1ppjzOP0VEnPnxETLVUOU-24HbLI7ZF5QWQfolcpKja_r4Qkga1Qw==@protonmail.internalid>
 <20250605061638.993152-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250605061638.993152-5-hch@lst.de>

On Thu, Jun 05, 2025 at 08:16:30AM +0200, Christoph Hellwig wrote:
> Commit f3e2e53823b9 ("xfs: add inode to zone caching for data placement")
> add the new code right between xfs_submit_zoned_bio and
> xfs_zone_alloc_and_submit which implement the main zoned write path.
> Move xfs_submit_zoned_bio down to keep it together again.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_zone_alloc.c | 40 ++++++++++++++++++++--------------------
>  1 file changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index 0de6f64b3169..01315ed75502 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -777,26 +777,6 @@ xfs_mark_rtg_boundary(
>  		ioend->io_flags |= IOMAP_IOEND_BOUNDARY;
>  }
> 
> -static void
> -xfs_submit_zoned_bio(
> -	struct iomap_ioend	*ioend,
> -	struct xfs_open_zone	*oz,
> -	bool			is_seq)
> -{
> -	ioend->io_bio.bi_iter.bi_sector = ioend->io_sector;
> -	ioend->io_private = oz;
> -	atomic_inc(&oz->oz_ref); /* for xfs_zoned_end_io */
> -
> -	if (is_seq) {
> -		ioend->io_bio.bi_opf &= ~REQ_OP_WRITE;
> -		ioend->io_bio.bi_opf |= REQ_OP_ZONE_APPEND;
> -	} else {
> -		xfs_mark_rtg_boundary(ioend);
> -	}
> -
> -	submit_bio(&ioend->io_bio);
> -}
> -
>  /*
>   * Cache the last zone written to for an inode so that it is considered first
>   * for subsequent writes.
> @@ -891,6 +871,26 @@ xfs_zone_cache_create_association(
>  	xfs_mru_cache_insert(mp->m_zone_cache, ip->i_ino, &item->mru);
>  }
> 
> +static void
> +xfs_submit_zoned_bio(
> +	struct iomap_ioend	*ioend,
> +	struct xfs_open_zone	*oz,
> +	bool			is_seq)
> +{
> +	ioend->io_bio.bi_iter.bi_sector = ioend->io_sector;
> +	ioend->io_private = oz;
> +	atomic_inc(&oz->oz_ref); /* for xfs_zoned_end_io */
> +
> +	if (is_seq) {
> +		ioend->io_bio.bi_opf &= ~REQ_OP_WRITE;
> +		ioend->io_bio.bi_opf |= REQ_OP_ZONE_APPEND;
> +	} else {
> +		xfs_mark_rtg_boundary(ioend);
> +	}
> +
> +	submit_bio(&ioend->io_bio);
> +}
> +
>  void
>  xfs_zone_alloc_and_submit(
>  	struct iomap_ioend	*ioend,
> --
> 2.47.2
> 
> 
