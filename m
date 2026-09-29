Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF662848BE;
	Tue, 29 Sep 2026 01:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790644778; cv=none; b=r5Wjr/wji5sWiUGQ09S1QDNSUbxF9r4V92lnzr930xeMHzFb8IoP/4gNoiGV+NAcibgP4COYi6O1xQIVfNrCX8eMYu1CenxF/RTD9l7piOAJ/o3NkD4m8cmEye1zSmMJqeP2l3n3iBe3ZroWnYBmizx3f1tce1BRVEdW4LPJa/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790644778; c=relaxed/simple;
	bh=NcIK8eDUgBiiHeHkUwrVDBJPwT+sahnN9L6M2Na/nAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DRBJjdRDhvJQnfRwEZKLDu9FmB4DepnJd4rS+rBX+q+uwD969QC+2+lOt6rMiy0NE4eNHUdVuK7g2N5OwzQJRHsVbtatw/d0xVCZ8kLdGREmsSoWR1aFuYYdf2N3ySd5pRERaGQkXA1e0w8whL6LSjKAh4hxHctxnNx64hs1XI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ElpAskgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ElpAskgV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 26C0A1F000FF;
	Tue, 29 Sep 2026 01:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790644777;
	bh=v8AQHcuJlIdJ2XobFF5jUXw8iM4gqEW3E9Lh4xH8DAM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ElpAskgVGcC/ITPLz9HvE6eD5ifis3kbTWWacpvsXLh0eTzz/49MIlvuGyv8hxss3
	 FOaT4MVHvuFyrU8uvjcYkSFWXKXcnvZ0H3rQTksRUk2PH3Gq+4LrVGTRRuxmKOt360
	 6qZ/0vCm9sv2iCY4L6upywVGIAb0XHBkYgh5JjIncUShu6ZPqQJ1jmPDIVvRM+EMHQ
	 aisD5jmmZA/6RS0s2g9TYwb04WnFLFd9NpobA8m/qJcdg8ESys3CDH9GP+0r+mKgLa
	 Lxcx212FZV/G+fqWsQulfC+w1D1ES92xjR9+RMLBOFz5lexI4w7PSNPjxkJRbjlqHj
	 Za0pwNMOmL+TA==
Date: Mon, 28 Sep 2026 18:19:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 17/21] xfs: verify data checksums during media
 verification
Message-ID: <20260929011936.GY2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-18-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-18-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:49AM +0200, Christoph Hellwig wrote:
> Wire up reading and verifying data checksums during media verification.
> This is very similar to the file read path in that it kicks of an async
> read for the checksum buffer before reading the data, and then validating
> once both are read in.
> 
> To support this, split the per-read logic in xfs_verify_media into a
> separate helpers for the data checksums vs no checksum cases.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_verify_media.c | 131 +++++++++++++++++++++++++++++++-------
>  1 file changed, 107 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
> index 71f4d6c832a9..46a19405c9e5 100644
> --- a/fs/xfs/xfs_verify_media.c
> +++ b/fs/xfs/xfs_verify_media.c
> @@ -22,6 +22,7 @@
>  #include "xfs_rtrmap_btree.h"
>  #include "xfs_health.h"
>  #include "xfs_healthmon.h"
> +#include "xfs_rtcsum.h"
>  #include "xfs_trace.h"
>  #include "xfs_verify_media.h"
>  
> @@ -261,6 +262,95 @@ xfs_verify_media_error(
>  	}
>  }
>  
> +static int
> +xfs_submit_verify_bio(
> +	struct xfs_mount	*mp,
> +	struct xfs_verify_media	*me,
> +	struct xfs_buftarg	*btp,
> +	struct folio		*folio,
> +	xfs_daddr_t		*daddr,
> +	uint64_t		*bbcount)
> +{
> +	unsigned int		bio_bbcount;
> +	int			error;
> +
> +	bio_bbcount = min(*bbcount, folio_size(folio) >> SECTOR_SHIFT);
> +	error = bdev_rw_virt(btp->bt_bdev, *daddr, folio_address(folio),
> +			bio_bbcount << SECTOR_SHIFT,
> +			REQ_OP_READ);
> +	if (error) {
> +		xfs_verify_media_error(mp, me, btp, *daddr, bio_bbcount, error);
> +		return 1;
> +	}
> +
> +	*daddr += bio_bbcount;
> +	*bbcount -= bio_bbcount;
> +	return 0;
> +}
> +
> +static int
> +xfs_submit_verify_bio_csum(

What's the return value convention here?  1 for media error, 0 for
success, or negative errno if we failed to issue the read?

> +	struct xfs_mount	*mp,
> +	struct xfs_verify_media	*me,
> +	struct xfs_buftarg	*btp,
> +	struct folio		*folio,
> +	xfs_daddr_t		*daddr,
> +	uint64_t		*bbcount)
> +{
> +	struct xfs_buf		*csum_bp = NULL;
> +	unsigned int		bio_bbcount;
> +	struct bvec_iter	saved_iter;
> +	xfs_fsblock_t		bno, end;
> +	xfs_filblks_t		len;
> +	struct bio		bio;
> +	struct bio_vec		bv;
> +	int			error;
> +
> +	bno = xfs_daddr_to_rtb(mp, *daddr);
> +	end = xfs_daddr_to_rtb(mp, *daddr + *bbcount);

It occurs to me that xfs_daddr_to_rtb rounds its argument down.  So if
you pass in daddr==0 and bbcount==2, you'll get bno==end==0 and do no
verification.  I would hope that callers won't pass in parameters like
that, but who knows?

So I think this should be:

	end = xfs_daddr_to_rtb(mp,
			*daddr + *bbcount + XFS_FSB_TO_BB(mp, 1) - 1);

Which I admit is a bit gross.

--D

> +	len = min(end - bno, XFS_B_TO_FSBT(mp, folio_size(folio)));
> +	len = min(len, xfs_rtcsum_max_len(mp, bno));
> +
> +	error = xfs_rtcsum_read_async(mp, bno, &csum_bp);
> +	if (error)
> +		return error;
> +
> +	*daddr = xfs_rtb_to_daddr(mp, bno);
> +	bio_bbcount = XFS_FSB_TO_BB(mp, len);
> +
> +	bio_init(&bio, btp->bt_bdev, &bv, 1, REQ_OP_READ);
> +	bio.bi_iter.bi_sector = *daddr;
> +	bio_add_folio_nofail(&bio, folio,
> +			min(bio_bbcount << SECTOR_SHIFT, folio_size(folio)), 0);
> +	saved_iter = bio.bi_iter;
> +
> +	error = submit_bio_wait(&bio);
> +	if (error)
> +		goto out_media_error;
> +
> +	error = xfs_buf_read_async_wait(csum_bp);
> +	if (error)
> +		goto out_buf_rele;
> +
> +	error = xfs_csum_verify(mp, &bio, &saved_iter,
> +			csum_bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno,
> +			false);
> +	if (error)
> +		goto out_media_error;
> +
> +	*daddr += bio_bbcount;
> +	*bbcount -= bio_bbcount;
> +
> +out_buf_rele:
> +	xfs_buf_rele(csum_bp);
> +	bio_uninit(&bio);
> +	return error;
> +out_media_error:
> +	xfs_verify_media_error(mp, me, btp, *daddr, bio_bbcount, error);
> +	error = 1;
> +	goto out_buf_rele;
> +}
> +
>  /* Verify the media of an xfs device by submitting read requests to the disk. */
>  static int
>  xfs_verify_media(
> @@ -310,18 +400,13 @@ xfs_verify_media(
>  		return 0;
>  
>  	/*
> -	 * There are three ranges involved here:
> -	 *
> -	 *  - [me->me_start_daddr, me->me_end_daddr) is the range that the
> -	 *    user wants to verify.  end_daddr can be beyond the end of the
> -	 *    disk; we'll constrain it to the end if necessary.
> +	 * [me->me_start_daddr, me->me_end_daddr) is the range that the user
> +	 * wants to verify.  end_daddr can be beyond the end of the disk; we'll
> +	 * constrain it to the end if necessary.
>  	 *
> -	 *  - [daddr, me->me_end_daddr) is the range that we have not yet
> -	 *    verified.  We update daddr after each successful read.
> -	 *    me->me_start_daddr is set to daddr before returning.
> -	 *
> -	 *  - [daddr, daddr + bio_bbcount) is the range that we're currently
> -	 *    verifying.
> +	 * [daddr, me->me_end_daddr) is the range that we have not yet verified.
> +	 * We update daddr after each successful read.  me->me_start_daddr is
> +	 * set to daddr before returning.
>  	 */
>  	daddr = me->me_start_daddr;
>  	bbcount = min_t(sector_t, me->me_end_daddr, btp->bt_nr_sectors) -
> @@ -334,22 +419,20 @@ xfs_verify_media(
>  	trace_xfs_verify_media(mp, me, btp->bt_dev, daddr, bbcount, folio);
>  
>  	for (;;) {
> -		unsigned int	bio_bbcount;
> -
> -		bio_bbcount = min(bbcount, folio_size(folio) >> SECTOR_SHIFT);
> -		error = bdev_rw_virt(btp->bt_bdev, daddr, folio_address(folio),
> -				bio_bbcount << SECTOR_SHIFT,
> -				REQ_OP_READ);
> +		if (IS_ENABLED(CONFIG_XFS_RT) &&
> +		    me->me_dev == XFS_DEV_RT &&
> +		    xfs_has_rtcsum(mp)) {
> +			error = xfs_submit_verify_bio_csum(mp, me, btp, folio,
> +					&daddr, &bbcount);
> +		} else {
> +			error = xfs_submit_verify_bio(mp, me, btp, folio,
> +					&daddr, &bbcount);
> +		}
>  		if (error) {
> -			xfs_verify_media_error(mp, me, btp, daddr, bio_bbcount,
> -					error);
> -			error = 0;
> +			if (error == 1)
> +				error = 0;
>  			break;
>  		}
> -
> -		daddr += bio_bbcount;
> -		bbcount -= bio_bbcount;
> -
>  		if (bbcount == 0)
>  			break;
>  
> -- 
> 2.53.0
> 
> 
