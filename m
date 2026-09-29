Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C919C380FFB;
	Tue, 29 Sep 2026 00:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790642528; cv=none; b=Z0JcpH1tjIXc8Kt9hQJkOi+PfFR+tQyzk5YCf32gIQ1mMVhQ5+ci62OuXRFeEE8cMOZ4MnXM+fZb5RaAQcZDS0yDc2Id/ZzgqM/heK4t7h1POgnIvFnKZFTEvALXk02pDY8gU/DDjyGVI+NmRsxysI3uqoX/UHfpQRs4u3OWPyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790642528; c=relaxed/simple;
	bh=TN+dWTNkw5tVWJvZ/LQPkqK7aZjBNnKvjbK9wpHKnaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jb0nwaZGOvTabcXqTI3hlEKOqlO5Z4b+wlFZ9Rl0CqTUBtvoInjb5UUOiZTDD+brkQ1RFHG8gFm59Kkoeth8qCflmIgNDCrArQVfq2Riat8tKSvRw8XvJjWfQcs+QJxyeOqZOUWW0HFbXww7irX0gawCr3W0CNPgNdNw99VK+iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mKpdmBdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mKpdmBdA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D88021F000FF;
	Tue, 29 Sep 2026 00:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790642524;
	bh=sWTCg6WnndwyA5zFuOSRQHhm/VQAWGjt82seJNjKOqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mKpdmBdA26GDr4u/2OgEUjp6UKxSE8kZRpDE3uVukfFnq5QNFR7sqvBy5hW5gffYA
	 lE+Qo7uMmArSTqnHingFxMR2tudjG6c+TiKoiJrHdoCLJD1kYTOpZKQRFZeBwdkITK
	 RG6moA5vSS1aCKjJTLHAbHk5hS/2kDdB8N+teUA/xDKFA5+13MhxpLFWX8savlqhWt
	 FP+XMP0jrsAzFJIcCwtTwn1KbmbfKaMEERV/N4tvfbKkrcB6DuiH/TZSFehyRfgiMd
	 nFkL42etkaGTUUAAKiuzwcvnJzVhu3Pycr2pW0xq+uSF6IuUfQCQLJzzlXwbU26gZ0
	 k4tj++MkXLXKQ==
Date: Mon, 28 Sep 2026 17:42:04 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/21] xfs: add support for reading with data checksums
Message-ID: <20260929004204.GV2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-15-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:46AM +0200, Christoph Hellwig wrote:
> All reads from files with data checksums have the returned iomaps for
> data blocks limited to be inside a single RT csum file block, so that
> each data read only needs to deal with a single checksum buffer.
> 
> All reads on checksummed files need to use ioends so that the checksum
> can be verified from process context.  The ioend submission path looks
> up the checksum buffer and kicks of an asynchronous read of it.  The
> completion path waits for the buffer if needed and verifies the checksum.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c  |   4 +-
>  fs/xfs/xfs_ioend.c | 108 +++++++++++++++++++++++++++++++++++++++------
>  fs/xfs/xfs_iomap.c |  23 ++++++++--
>  3 files changed, 114 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c30e688cfc9f..931795316de4 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -599,9 +599,7 @@ static inline const struct iomap_read_ops *
>  xfs_get_iomap_read_ops(
>  	const struct address_space	*mapping)
>  {
> -	struct xfs_inode		*ip = XFS_I(mapping->host);
> -
> -	if (bdev_has_integrity_csum(xfs_inode_buftarg(ip)->bt_bdev))
> +	if (mapping_stable_writes(mapping))
>  		return &xfs_iomap_read_ops;
>  	return &iomap_bio_read_ops;
>  }
> diff --git a/fs/xfs/xfs_ioend.c b/fs/xfs/xfs_ioend.c
> index 54bd0995ac29..7570a1b915c0 100644
> --- a/fs/xfs/xfs_ioend.c
> +++ b/fs/xfs/xfs_ioend.c
> @@ -14,12 +14,72 @@
>  #include "xfs_trace.h"
>  #include "xfs_bmap_util.h"
>  #include "xfs_reflink.h"
> +#include "xfs_rtcsum.h"
>  #include "xfs_zone_alloc.h"
>  #include "xfs_ioend.h"
>  #include "xfs_error.h"
>  #include "xfs_errortag.h"
>  #include <linux/bio-integrity.h>
>  
> +static bool
> +xfs_rtcsum_prepare_read(
> +	struct iomap_ioend	*ioend)
> +{
> +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_buf		*bp;
> +	int			error;
> +
> +	error = -EIO;
> +	if (WARN_ON_ONCE(ioend->io_bio.bi_iter.bi_idx))

What does this warning mean?  That we've somehow already advanced the
bvec iterator?

> +		goto fail;
> +
> +	error = xfs_rtcsum_read_async(mp,
> +			xfs_daddr_to_rtb(mp, ioend->io_sector), &bp);
> +	if (error)
> +		goto fail;
> +	ioend->io_private = bp;
> +	return true;
> +
> +fail:
> +	ioend->io_bio.bi_status = errno_to_blk_status(error);
> +	bio_endio(&ioend->io_bio);
> +	return false;
> +}
> +
> +static int
> +xfs_rtcsum_verify_ioend(
> +	struct iomap_ioend	*ioend,
> +	int			error)
> +{
> +	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	xfs_rtblock_t		bno = xfs_daddr_to_rtb(mp, ioend->io_sector);
> +	unsigned int		bsize = mp->m_sb.sb_blocksize;
> +	struct xfs_buf		*bp = ioend->io_private;
> +	struct bvec_iter	iter = {
> +		.bi_size	= roundup(ioend->io_size, bsize),
> +		.bi_offset	= ioend->io_bvec_offset,
> +	};
> +
> +	/* No bp for early xfs_rtcsum_prepare_read failures. */
> +	if (!bp)
> +		return error;

Is it possible for error to be zero here?

> +
> +	if (error)
> +		goto out_rele;
> +	error = xfs_buf_read_async_wait(bp);
> +	if (error)
> +		goto out_rele;
> +
> +	error = xfs_csum_verify(mp, &ioend->io_bio, &iter,
> +				bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno,
> +				true);

You only need two tab indent here.

> +out_rele:
> +	xfs_buf_rele(bp);
> +	return error;
> +}
> +
>  static void
>  xfs_dio_bounce_end_io(
>  	struct bio		*bio)
> @@ -30,6 +90,9 @@ xfs_dio_bounce_end_io(
>  
>  	if ((ioend->io_flags & IOMAP_IOEND_INTEGRITY) && !bio->bi_status)
>  		error = iomap_ioend_integrity_verify(ioend);
> +	if (xfs_is_rtcsum_inode(XFS_I(ioend->io_inode)))
> +		error = xfs_rtcsum_verify_ioend(ioend, error);
> +
>  	iomap_bounce_read_end_io(ioend, orig_bio, error);
>  }
>  
> @@ -39,6 +102,9 @@ xfs_bounce_submit_ioend(
>  {
>  	if (ioend->io_flags & IOMAP_IOEND_INTEGRITY)
>  		fs_bio_integrity_alloc(&ioend->io_bio);
> +	if (xfs_is_rtcsum_inode(XFS_I(ioend->io_inode)) &&
> +	    !xfs_rtcsum_prepare_read(ioend))
> +		return;
>  	ioend->io_bio.bi_end_io = xfs_dio_bounce_end_io;
>  	bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);
>  	submit_bio(&ioend->io_bio);
> @@ -108,25 +174,36 @@ xfs_end_io_read(
>  	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			error = blk_status_to_errno(bio->bi_status);
> +	bool			is_csum_error = false;
>  
>  	if (!error && (ioend->io_flags & IOMAP_IOEND_INTEGRITY)) {
>  		error = iomap_ioend_integrity_verify(ioend);
> -		if ((ioend->io_flags & IOMAP_IOEND_DIRECT) &&
> -		    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_LAZY) {
> -			/*
> -			 * We only really need to retry for guard tag errors,
> -			 * but right now we can't distinguish them from other
> -			 * (i.e, reftag) errors.
> -			 */
> -			if (error ||
> -			    XFS_TEST_ERROR(mp, XFS_ERRTAG_BOUNCE_REREAD)) {
> -				xfs_read_bounce_and_resubmit(ioend);
> -				return;
> -			}
> -		}
> +		/*
> +		 * We only really need to retry for guard tag errors, but right
> +		 * now we can't distinguish them from other (i.e, reftag) errors.
> +		 */
> +		if (error)
> +			is_csum_error = true;
>  	}
>  
> -	iomap_finish_ioends(ioend, error);
> +	if (xfs_is_rtcsum_inode(ip)) {
> +		error = xfs_rtcsum_verify_ioend(ioend, error);
> +		if (error && !bio->bi_status)
> +			is_csum_error = true;
> +	}
> +
> +	/*
> +	 * If we saw a checksum failure on a direct I/O read that uses lazy
> +	 * bouncing, resubmit the read using a bounce buffer so that we can
> +	 * guarantee this was not caused by the user corrupting the buffer.
> +	 */
> +	if ((ioend->io_flags & IOMAP_IOEND_DIRECT) &&
> +	    READ_ONCE(mp->m_read_bounce) == XFS_READ_BOUNCE_LAZY &&
> +	    (is_csum_error ||
> +	     (!error && XFS_TEST_ERROR(mp, XFS_ERRTAG_BOUNCE_REREAD))))
> +		xfs_read_bounce_and_resubmit(ioend);

Ok, so now we bounce the read on PI verification errors or fs checksum
verification errors.  Makes sense.

--D

> +	else
> +		iomap_finish_ioends(ioend, error);
>  }
>  
>  void
> @@ -148,6 +225,9 @@ xfs_ioend_submit_read(
>  		return;
>  	}
>  
> +	if (xfs_is_rtcsum_inode(ip) && !xfs_rtcsum_prepare_read(ioend))
> +		return;
> +
>  	if (ioend_flags & IOMAP_IOEND_INTEGRITY)
>  		fs_bio_integrity_alloc(bio);
>  	bio->bi_end_io = xfs_end_io_read;
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 6701be9325ef..0e4396e52809 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -32,6 +32,7 @@
>  #include "xfs_rtbitmap.h"
>  #include "xfs_icache.h"
>  #include "xfs_zone_alloc.h"
> +#include "xfs_rtcsum.h"
>  
>  #define XFS_ALLOC_ALIGN(mp, off) \
>  	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
> @@ -166,6 +167,8 @@ xfs_bmbt_to_iomap(
>  	}
>  
>  	iomap->validity_cookie = sequence_cookie;
> +	if (xfs_is_rtcsum_inode(ip))
> +		iomap->csum_shift = mp->m_rtcsum_shift;
>  	return 0;
>  }
>  
> @@ -2227,16 +2230,28 @@ xfs_read_iomap_begin(
>  		return error;
>  	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
>  			       &nimaps, 0);
> -	if (!error && ((flags & IOMAP_REPORT) || IS_DAX(inode)))
> +	if (error)
> +		goto out_unlock;
> +
> +	if ((flags & IOMAP_REPORT) || IS_DAX(inode)) {
>  		error = xfs_reflink_trim_around_shared(ip, &imap, &shared);
> +		if (error)
> +			goto out_unlock;
> +	} else if (!isnullstartblock(imap.br_startblock) &&
> +		   xfs_is_rtcsum_inode(ip)) {
> +		imap.br_blockcount = min(imap.br_blockcount,
> +				xfs_rtcsum_max_len(mp, imap.br_startblock));
> +	}
> +
>  	seq = xfs_iomap_inode_sequence(ip, shared ? IOMAP_F_SHARED : 0);
>  	xfs_iunlock(ip, lockmode);
> -
> -	if (error)
> -		return error;
>  	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
>  	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
>  				 shared ? IOMAP_F_SHARED : 0, seq);
> +
> +out_unlock:
> +	xfs_iunlock(ip, lockmode);
> +	return error;
>  }
>  
>  static DEFINE_IOMAP_ITER_NEXT(xfs_read_iomap_next, xfs_read_iomap_begin);
> -- 
> 2.53.0
> 
> 
