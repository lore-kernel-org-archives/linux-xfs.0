Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2F42E7BB5;
	Wed, 18 Feb 2026 22:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771452274; cv=none; b=LOOJDP9sr1QaDMNgpVZ/KfHuyCNcJI+fs8iHkADsZT17Hsg7siXNMFtLzsQhXuOI16SRp/BNLX2L0IcSVxS07ZZdBSpfmkxVHsiTFT2/PKa5nzZHUM2YXdMMSxzFrR00YYFJQqRoWEaGdpParyI1K2+6/+g6FLG7ckA0KwIHHoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771452274; c=relaxed/simple;
	bh=dJzDRaLsCgpxRL3QTwF7x3PQ4OlFTi2GusL1ZAA6frw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ut6Fr9goqbuoE2DHk7WwOEsAelgIQE8VDzdSkfHi1DMoQJUt/BcehGd6eVJS5kMqB89rc9GBOeIVwoGEWOSllDXLO13nRLJfHli3N7Omamxgv/YSG/5Hpj6sudXWFtsG0tiBi/S7LYZD2vHaXCboMUEAX+ayi9aIVlz5WSIquxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rT9ONmyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rT9ONmyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43ED7C116D0;
	Wed, 18 Feb 2026 22:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771452274;
	bh=dJzDRaLsCgpxRL3QTwF7x3PQ4OlFTi2GusL1ZAA6frw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rT9ONmyJe9P+KOY4uY4ik3640XQZQcln6Wr/8OoIAWrSKURcIpNAHB8Yu8+R7uPvF
	 mVmvRpsWGfgToVJda97QCZpvtTZdu9wOA/9aQm4N5d2Y2am/2RPjT0DLdYFyptDKje
	 5vCPpx1a9AI6s1d7quopgwUYsd7Omq+e6O2cdgKhaAD0NUiSDJ+nN39UgyUP+DaPQf
	 tYX6TllHHxvgaVGEgO6s3nO+ohw4QDElHW1+9GX/AsVO4Jw9Llb5kZ5ijjV7tpcpNB
	 bUeCMWBp48JzRJfg9gYA8lBW+jkzbficNA2rFlsk5pxGphW3MpftLfj6A4S2x6SjFt
	 woQnLcU6/tHQw==
Date: Wed, 18 Feb 2026 14:04:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 04/35] fsverity: generate and store zero-block hash
Message-ID: <20260218220433.GD6467@frogsfrogsfrogs>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-5-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-5-aalbersh@kernel.org>

On Wed, Feb 18, 2026 at 12:19:04AM +0100, Andrey Albershteyn wrote:
> Compute the hash of one filesystem block's worth of zeros. A filesystem
> implementation can decide to elide merkle tree blocks containing only
> this hash and synthesize the contents at read time.
> 
> Let's pretend that there's a file containing six data blocks and whose
> merkle tree looks roughly like this:
> 
> root
>  +--leaf0
>  |   +--data0
>  |   +--data1
>  |   `--data2
>  `--leaf1
>      +--data3
>      +--data4
>      `--data5
> 
> If data[0-2] are sparse holes, then leaf0 will contain a repeating
> sequence of @zero_digest.  Therefore, leaf0 need not be written to disk
> because its contents can be synthesized.
> 
> A subsequent xfs patch will use this to reduce the size of the merkle
> tree when dealing with sparse gold master disk images and the like.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> ---
>  fs/verity/fsverity_private.h | 3 +++
>  fs/verity/open.c             | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
> index 6e6854c19078..35636c1e2c41 100644
> --- a/fs/verity/fsverity_private.h
> +++ b/fs/verity/fsverity_private.h
> @@ -53,6 +53,9 @@ struct merkle_tree_params {
>  	u64 tree_size;			/* Merkle tree size in bytes */
>  	unsigned long tree_pages;	/* Merkle tree size in pages */
>  
> +	/* the hash of a merkle block-sized buffer of zeroes */
> +	u8 zero_digest[FS_VERITY_MAX_DIGEST_SIZE];
> +
>  	/*
>  	 * Starting block index for each tree level, ordered from leaf level (0)
>  	 * to root level ('num_levels - 1')
> diff --git a/fs/verity/open.c b/fs/verity/open.c
> index 0483db672526..94407a37aa08 100644
> --- a/fs/verity/open.c
> +++ b/fs/verity/open.c
> @@ -153,6 +153,9 @@ int fsverity_init_merkle_tree_params(struct merkle_tree_params *params,
>  		goto out_err;
>  	}
>  
> +	fsverity_hash_block(params, page_address(ZERO_PAGE(0)),
> +			    params->zero_digest);

Hrm.  At first I thought "Now that xfs supports blocksize > pagesize
you actually need to compute this with a zeroed folio."  But then I
remembered that merkle tree blocksize != filesystem blocksize.  So I
guess as long as *fsverity* doesn't support merkle tree blocksize >
pagesize then this is still ok?

--D

> +
>  	params->tree_size = offset << log_blocksize;
>  	params->tree_pages = PAGE_ALIGN(params->tree_size) >> PAGE_SHIFT;
>  	return 0;
> -- 
> 2.51.2
> 
> 
