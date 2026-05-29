Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B1535E1A0
	for <linux-xfs@vger.kernel.org>; Fri, 29 May 2026 10:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780049356; cv=none; b=Ogld6qkvGLPAXACtPk/9NDzSQxJtOkwJcDLtr3PTFC9GV6pNnt/C/zOPKFb8dmRK7+3HnTmDMbTlILVCJ0wioTggrtLXTeTEXP2k+gitPGDpMR9/FoG9yvR7p8I/nvptE3CjJbKhZKVC7fjZeNXlIpmlnlQkcijtxvW1GunlAJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780049356; c=relaxed/simple;
	bh=EPMTwiDOXVylEPAhKvUmE+FpfLCEUQ+PEeHd11itXH0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EsPis+5KLMYvlPj6lfCFxkQbYEtDVhhpRWnH1xlx89S9eSmZhzMsWFXvY5eicT0stWLPyeFQCVcDgzxaz4Yu8w9h+pTfnefYYJdrMjKcHGBXvUAlhutya8g7mx5/EU6+UfSgWth0EQxQXCuigjotzmis9TvGsO2JEryR1zmOYYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UUXnRWcH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UUXnRWcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728AF1F00893;
	Fri, 29 May 2026 10:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780049352;
	bh=KULO0aBhWZHCd1YmF1l1nDlieQ3OtWCmHPFgJvyHzKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UUXnRWcHEwxT0eFDwpjGL3eimr3jjSXg4Qp+OaAbdlKoZTOI4suwzA2x0t/vSANEu
	 q3GW6Cr2HJDPJXXdDjUoQR6WFzduKn3ioQGJPvWNsH+t5LMVm/8YrbRD84j6VEkW74
	 sB4OsNgTqj3Gjs+2JQLn4xEmSz7o/H4nQHaAGg0EWeWw7QiH4t6wK+FROrILtSm3Y+
	 SloO1ikIrdrSs2qcTm+seFI++O0+XxLarkui2WXlGMUHmdveoqDGgf/J8yYRRtke+k
	 FwePr2KTbF7SoGgK/0rivDBx+YxaTxMozpS26VCpcPNnHehC2L1rRlTp9EgymqEnnr
	 rHoRYZqJO1Nww==
Date: Fri, 29 May 2026 12:09:08 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the call to xfs_buf_reverify in
 xfs_trans_read_buf_map
Message-ID: <ahlltC242JMoTBeZ@nidhogg.toxiclabs.cc>
References: <20260529054404.2720366-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260529054404.2720366-1-hch@lst.de>

On Fri, May 29, 2026 at 07:43:58AM +0200, Christoph Hellwig wrote:
> xfs_trans_read_buf_map asserts bp->b_ops is non-NULL just before
> calling xfs_buf_reverify which is a no-op if bp->b_ops is set, making the
> call dead code ever since it as added in commit 1aff5696f3e0 ("xfs: always
> assign buffer verifiers when one is provided").
> 
> Remove the useless call, mark xfs_buf_reverify static and clean up the
> branch dealing with a buffer attached to the transaction in a bit by
> deduplicating and keeping together the asserts and removing the bip
> variable only used once outside of asserts and tracing.

Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c       |  2 +-
>  fs/xfs/xfs_buf.h       |  1 -
>  fs/xfs/xfs_trans_buf.c | 39 ++++-----------------------------------
>  3 files changed, 5 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 0cea458f1353..3ce12fe1c307 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -623,7 +623,7 @@ _xfs_buf_read(
>   * type.  If repair can't establish that, the buffer will be left in memory
>   * with NULL buffer ops.
>   */
> -int
> +static int
>  xfs_buf_reverify(
>  	struct xfs_buf		*bp,
>  	const struct xfs_buf_ops *ops)
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index bf39d89f0f6d..b3cd1c7029f1 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -365,7 +365,6 @@ int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize,
>  
>  #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
>  
> -int xfs_buf_reverify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
>  bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
>  bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
>  
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 95db73a37e57..7e17b93fe9ad 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -234,7 +234,6 @@ xfs_trans_read_buf_map(
>  	const struct xfs_buf_ops *ops)
>  {
>  	struct xfs_buf		*bp = NULL;
> -	struct xfs_buf_log_item	*bip;
>  	int			error;
>  
>  	*bpp = NULL;
> @@ -251,9 +250,10 @@ xfs_trans_read_buf_map(
>  	if (bp) {
>  		ASSERT(xfs_buf_islocked(bp));
>  		ASSERT(bp->b_transp == tp);
> -		ASSERT(bp->b_log_item != NULL);
>  		ASSERT(!bp->b_error);
>  		ASSERT(bp->b_flags & XBF_DONE);
> +		ASSERT(atomic_read(&bp->b_log_item->bli_refcount) > 0);
> +		ASSERT(bp->b_ops);
>  
>  		/*
>  		 * We never locked this buf ourselves, so we shouldn't
> @@ -264,39 +264,8 @@ xfs_trans_read_buf_map(
>  			return -EIO;
>  		}
>  
> -		/*
> -		 * Check if the caller is trying to read a buffer that is
> -		 * already attached to the transaction yet has no buffer ops
> -		 * assigned.  Ops are usually attached when the buffer is
> -		 * attached to the transaction, or by the read caller if
> -		 * special circumstances.  That didn't happen, which is not
> -		 * how this is supposed to go.
> -		 *
> -		 * If the buffer passes verification we'll let this go, but if
> -		 * not we have to shut down.  Let the transaction cleanup code
> -		 * release this buffer when it kills the tranaction.
> -		 */
> -		ASSERT(bp->b_ops != NULL);
> -		error = xfs_buf_reverify(bp, ops);
> -		if (error) {
> -			xfs_buf_ioerror_alert(bp, __return_address);
> -
> -			if (tp->t_flags & XFS_TRANS_DIRTY)
> -				xfs_force_shutdown(tp->t_mountp,
> -						SHUTDOWN_META_IO_ERROR);
> -
> -			/* bad CRC means corrupted metadata */
> -			if (error == -EFSBADCRC)
> -				error = -EFSCORRUPTED;
> -			return error;
> -		}
> -
> -		bip = bp->b_log_item;
> -		bip->bli_recur++;
> -
> -		ASSERT(atomic_read(&bip->bli_refcount) > 0);
> -		trace_xfs_trans_read_buf_recur(bip);
> -		ASSERT(bp->b_ops != NULL || ops == NULL);
> +		bp->b_log_item->bli_recur++;
> +		trace_xfs_trans_read_buf_recur(bp->b_log_item);
>  		*bpp = bp;
>  		return 0;
>  	}
> -- 
> 2.53.0
> 
> 
