Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19283B6366;
	Mon, 13 Apr 2026 17:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776102975; cv=none; b=kzXo+4/ue65UV1r7WVYm34th2vUvoQyTMgq5tKYTLxxx/Z54olwjyLl+dNOjhOHlyhloTdD6C17HV4Rd7VnrI03ZGXo+pRSLGejwWGIYSxc6ZYJBg6qbfueALyVrVdJB3gkdGqxEzqBTQzCzgwd66jFWqqCrOzaiuA22g9TWcTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776102975; c=relaxed/simple;
	bh=I8Yd9OpvtxDFPLTcvefc4/thrRCr/nf9Qk4ZCxtOLtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A5vJ8nJqMq/pfNz9dYkgc1f776z4eZzZa2KFUFQuPtuQ/Mf+HJ8HaME7mFI2+Y21Dj/00VzWGGiPCYMtqgAsojOeveXWapuIjNq8/H/mkMWa4xtDwHUtfxgNUmGx+ZN23I7U14vPlSmERW/Nxz3/Ylf8Mme7/Fmb07m0yvYTXug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D6yNwodG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D6yNwodG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D616C2BCAF;
	Mon, 13 Apr 2026 17:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776102974;
	bh=I8Yd9OpvtxDFPLTcvefc4/thrRCr/nf9Qk4ZCxtOLtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D6yNwodGmaXnMvU5G7SfFuEbvmBakCG9iAf/idUcr3gfVZN7N2VdAwD1Uq/9EVtwW
	 0++W+OjnS5J0WiTlDVIhzyQ3mzmcqfu2lU+aRUHDeBRPWF1q4jeOPpow5c3/4ZPUvm
	 dT2daGC4xDS/WJ3G/wpDwjjvEd3F1bei1Htcjb5auWmQaUqxXAIDTQS55OFNzr2Rx4
	 pExUpmz1B6HlnzRWlFqS4lKA9P1sZ7FIb8K84XxgOqo7GKE8i6pvs9rNqRYygV9fCD
	 jBq1rSP1NfCuugZedQhoEyrlsLMWRXGS3q2EDnF3ZZHNgIt3crlWDopzZ4zMBUspNC
	 ny1+wm7wjtetA==
Date: Mon, 13 Apr 2026 10:56:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dgc@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] xfs: zero entire directory data block header
 region at init
Message-ID: <20260413175614.GL1048989@frogsfrogsfrogs>
References: <20260411142411.72194-5-ytohnuki@amazon.com>
 <20260411142411.72194-6-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260411142411.72194-6-ytohnuki@amazon.com>

On Sat, Apr 11, 2026 at 03:24:13PM +0100, Yuto Ohnuki wrote:
> xfs_dir3_data_init currently zeroes only the xfs_dir3_blk_hdr portion of
> the directory data block header, then manually initializes the bestfree
> entries in a loop. This leaves the pad field in xfs_dir3_data_hdr
> uninitialized and requires explicit zeroing of each bestfree slot.
> 
> Zero the entire header region (geo->data_entry_offset bytes)
> unconditionally before setting individual fields. This covers all
> current and future header fields, all padding (implicit and explicit),
> and the bestfree array, so the manual zeroing loop for bestfree can be
> removed.
> 
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>

Seems reasonable to me to zero the entire head including the bestfree
areas.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 80ba94f51e5c..35ff119aa84b 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -728,7 +728,6 @@ xfs_dir3_data_init(
>  	struct xfs_dir2_data_unused	*dup;
>  	struct xfs_dir2_data_free 	*bf;
>  	int				error;
> -	int				i;
>  
>  	/*
>  	 * Get the buffer set up for the block.
> @@ -741,13 +740,16 @@ xfs_dir3_data_init(
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_DATA_BUF);
>  
>  	/*
> -	 * Initialize the header.
> +	 * Initialize the whole directory header region to zero
> +	 * so that all padding, bestfree entries, and any
> +	 * future header fields are clean.
>  	 */
>  	hdr = bp->b_addr;
> +	memset(hdr, 0, geo->data_entry_offset);
> +
>  	if (xfs_has_crc(mp)) {
>  		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
>  
> -		memset(hdr3, 0, sizeof(*hdr3));
>  		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
>  		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
>  		hdr3->owner = cpu_to_be64(args->owner);
> @@ -759,10 +761,6 @@ xfs_dir3_data_init(
>  	bf = xfs_dir2_data_bestfree_p(mp, hdr);
>  	bf[0].offset = cpu_to_be16(geo->data_entry_offset);
>  	bf[0].length = cpu_to_be16(geo->blksize - geo->data_entry_offset);
> -	for (i = 1; i < XFS_DIR2_DATA_FD_COUNT; i++) {
> -		bf[i].length = 0;
> -		bf[i].offset = 0;
> -	}
>  
>  	/*
>  	 * Set up an unused entry for the block's body.
> -- 
> 2.50.1
> 
> 
> 
> 
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembourg, R.C.S. Luxembourg B186284
> 
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlington Road, Dublin 4, Ireland, branch registration number 908705
> 
> 
> 
> 
