Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30EA3E1239;
	Mon, 13 Apr 2026 18:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776103239; cv=none; b=jEXy9ESdj50VzMvP0E4qRmljr3evfsdYXJrosRwtVmiBp0ONVRq9hkwfb4kT+jy5hMpEimrMN8rcGOaGq5heXmKMnlUu8AHfJ6P1Yn3BB6ehmYEr465zoksVGcAAnhEsegBiNEwP23RjDFBnAaurKO2QcaGQNXaJiOU4bXjP7LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776103239; c=relaxed/simple;
	bh=ZmYyOMOasDraWj7LpohGrq7rMPDCMu3DZ39d84t1dnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Be2XpavwCbhsZLjsw0t7wLt3oT1zilQ5NLusVMgATSU2zDgtfEWPCYPPHTW9Cu7QaRpDG62BhCEBdQgsNr7b9Nzmq8VXpAAikLo7QMOTSyW16QkLQ1Ny0yg/1CWzxPpNGvHbqcuVoO5B+qstBIUZ3X3HI2vkhNuZCm5dMKmNxMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pDFGy+uW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pDFGy+uW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD499C2BCAF;
	Mon, 13 Apr 2026 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776103238;
	bh=ZmYyOMOasDraWj7LpohGrq7rMPDCMu3DZ39d84t1dnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pDFGy+uWA1nmF2HVWRre7yQGB4fjlReSflgfXboy2oJcBnXlUQ79i0ETjaBZagB/K
	 7KT4h/34if6MomEPHxqTBU8Jd4mO2sIl/0wKGcUIEiE9bbxxzI9WNZmX/uSms0dPOe
	 mnoMuZ2X73eccE6VSnJYI8r/28e3dBrq9k0TJb7EchriOLZgevXhP8PEb+gt0Tw3+H
	 Hq88WkQxtfU16iGOOTZ0MEpLUMLivYFfQbjX7KAdtVLEUN8SvaCOqfOPdYfw3lIhr3
	 7DMgtDVd1ImQ+V/YUKsW9kKVMjaAQqSxaWw0V5OyrOQBKRWGdvqLn9Dr0wMrT2bzR2
	 soxwGRgIv7kDA==
Date: Mon, 13 Apr 2026 11:00:38 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dgc@kernel.org>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] xfs: check directory data block header padding in
 scrub
Message-ID: <20260413180038.GN1048989@frogsfrogsfrogs>
References: <20260411142411.72194-5-ytohnuki@amazon.com>
 <20260411142411.72194-8-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260411142411.72194-8-ytohnuki@amazon.com>

On Sat, Apr 11, 2026 at 03:24:15PM +0100, Yuto Ohnuki wrote:
> Add the missing scrub check for the pad field in directory data block
> headers. Old kernels may have written non-zero padding without issue,
> and the write path now self-heals stale padding on modification. Flag
> non-zero padding as an optimization opportunity (preen) rather than
> corruption.
> 
> Add xchk_fblock_set_preen helper for reporting file fork block issues
> that could be optimized. The trace event xchk_fblock_preen already
> exists.
> 
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> ---
>  fs/xfs/scrub/common.c | 11 +++++++++++
>  fs/xfs/scrub/common.h |  2 ++
>  fs/xfs/scrub/dir.c    |  7 ++++++-
>  3 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
> index 20e63069088b..3d40cb0b2496 100644
> --- a/fs/xfs/scrub/common.c
> +++ b/fs/xfs/scrub/common.c
> @@ -251,6 +251,17 @@ xchk_ino_set_preen(
>  	trace_xchk_ino_preen(sc, ino, __return_address);
>  }
>  
> +/* Record a block indexed by a file fork that could be optimized. */
> +void
> +xchk_fblock_set_preen(
> +	struct xfs_scrub        *sc,
> +	int                     whichfork,
> +	xfs_fileoff_t           offset)
> +{
> +	sc->sm->sm_flags |= XFS_SCRUB_OFLAG_PREEN;
> +	trace_xchk_fblock_preen(sc, whichfork, offset, __return_address);
> +}
> +
>  /* Record something being wrong with the filesystem primary superblock. */
>  void
>  xchk_set_corrupt(
> diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
> index f2ecc68538f0..b494d747c008 100644
> --- a/fs/xfs/scrub/common.h
> +++ b/fs/xfs/scrub/common.h
> @@ -25,6 +25,8 @@ bool xchk_fblock_xref_process_error(struct xfs_scrub *sc,
>  void xchk_block_set_preen(struct xfs_scrub *sc,
>  		struct xfs_buf *bp);
>  void xchk_ino_set_preen(struct xfs_scrub *sc, xfs_ino_t ino);
> +void xchk_fblock_set_preen(struct xfs_scrub *sc,
> +		int whichfork, xfs_fileoff_t offset);
>  
>  void xchk_set_corrupt(struct xfs_scrub *sc);
>  void xchk_block_set_corrupt(struct xfs_scrub *sc,
> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index e09724cd3725..09715a4aa154 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -492,7 +492,12 @@ xchk_directory_data_bestfree(
>  		goto out;
>  	xchk_buffer_recheck(sc, bp);
>  
> -	/* XXX: Check xfs_dir3_data_hdr.pad is zero once we start setting it. */
> +	if (xfs_has_crc(sc->mp)) {
> +		struct xfs_dir3_data_hdr    *hdr3 = bp->b_addr;
> +
> +		if (hdr3->pad)
> +			xchk_fblock_set_preen(sc, XFS_DATA_FORK, lblk);

Looks good!  Thanks for patching this hole :)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	}
>  
>  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
>  		goto out_buf;
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
