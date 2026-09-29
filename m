Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6F3189F43;
	Tue, 29 Sep 2026 01:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790645157; cv=none; b=Qolb/o9xxDQ+Dpu6Sj+2BSOCrlE9gRRDPtrr7T/uBGcBe+j3HlOrmENcJionx6woTspjlyWS3ezVHVgOWG3pMDcNJiMMt0VKdyUCq4u4IdWevvhIC6BknxtbQuDg0B9qpTu10wZdTjYsovlASScsWovebMcn7kwVd0ltkGcIpSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790645157; c=relaxed/simple;
	bh=sW3QNzzdbnPMMKgATAO/kalo4mbexoulTzA6rHvxEp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZVyPSqeOOk74EEAq09sJYcL8iUCFn3HfnyqBKbq64VgBKFFdkoT1RlOXMWyFx3k+LL7nc9dvlytpBaccn4m0XN6dpevsW31VCuTV62h49MdrADqozczahLs/SqDFQKr7yakvmjs3jx56Boc2iCv9mAfGziXgRkAyn/SP4Zh60E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OAEnhoWE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAEnhoWE"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 614011F000FF;
	Tue, 29 Sep 2026 01:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790645156;
	bh=hz6FO8DD2hUU7CyjfxcRchmgLOV1RFtSDd6sSwXNWRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OAEnhoWE8h7WuU1bTunoCu471ooFcUH46qUNJjXLLVhaZWxLglkw2esDE/Zc0Jv+K
	 1yp92P4LcRJe3S9f4LIF2wGrJBMjLbee8a1j5ZbgNQRTn30zSvNg2tZZV2I24805Ss
	 AI6YLW5z4C1JTj4cewvzrBcuOpO3DIRwlnb1dxckeF1uzygf8Vxesh1VU4QhU8QfXv
	 6GkmDQ9vCDHp3g05ZkcOp3rTHoaBGLW4Kbhe0uG0wCUMHsuD56TiSHKgFPzMFjWzVa
	 IHM9cXG8giJq4MAlAJLC32Kg7QX4NMkXE9twCdbgmXRKy3Ll0CO9B+cV+bCBF04pZA
	 2k+04VoaRAIXA==
Date: Mon, 28 Sep 2026 18:25:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 18/21] xfs: don't try to verify checksums on empty zones
Message-ID: <20260929012555.GZ2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-19-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-19-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:50AM +0200, Christoph Hellwig wrote:
> xfs_scrub can sometimes send XFS_IOC_VERIFY_MEDIA ioctls for ranges
> that have never been written since the last zone reset, which will
> lead to checksum verification failures.

...and pointless work. :)

> Protect against this by checking that the range is valid.  If the report
> flag is set, a verification failure could lead to health reports and
> the file system being marked corrupt, so lock out zone racing reset
> completions for this case as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_verify_media.c | 44 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 41 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_verify_media.c b/fs/xfs/xfs_verify_media.c
> index 46a19405c9e5..fc739f7ffa4e 100644
> --- a/fs/xfs/xfs_verify_media.c
> +++ b/fs/xfs/xfs_verify_media.c
> @@ -25,6 +25,8 @@
>  #include "xfs_rtcsum.h"
>  #include "xfs_trace.h"
>  #include "xfs_verify_media.h"
> +#include "xfs_zone_alloc.h"
> +#include "xfs_zone_priv.h"
>  
>  #include <linux/fserror.h>
>  
> @@ -288,6 +290,43 @@ xfs_submit_verify_bio(
>  	return 0;
>  }
>  
> +static int
> +xfs_csum_verify_metafile(
> +	struct xfs_mount	*mp,
> +	struct bio		*bio,
> +	struct bvec_iter	*saved_iter,
> +	void			*csum_buf,
> +	xfs_fsblock_t		bno)
> +{
> +	struct xfs_rtgroup	*rtg;
> +	int			error = 0;
> +
> +	rtg = xfs_rtgroup_get(mp, xfs_rtb_to_rgno(mp, bno));
> +	if (!rtg)
> +		return -EFSCORRUPTED;
> +
> +	/*
> +	 * Only validate the checksums for valid data, as data never written
> +	 * will not have valid checksums.  We need to hold the ilock on the rmap
> +	 * inode to prevent freeing of blocks and thus a zone reset to happen
> +	 * underneath us.
> +	 *
> +	 * Note that this still relies on cooperating userspace, as there also
> +	 * can be blocks that were written but never recorded after an unclean
> +	 * shutdown, which this check does not catch.  It purely tries to deal
> +	 * with races vs the previous FSMAP output used by xfs_scrub.

Just a general note -- if the csum update never makes it to disk, then
the remap cannot have been written to disk either.  Therefore, fsmap
will report that as unowned space, and xfs_scrub won't try to
read-verify it, given the xfs_scrub patch you post later to only read rt
blocks for which there are rmap records.

So I think this is only a theoretical concern, right?

The code looks fine to me, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	 */
> +	xfs_ilock(rtg_rmap(rtg), XFS_ILOCK_SHARED);
> +	if (!xa_get_mark(&mp->m_groups[XG_TYPE_RTG].xa, rtg_rgno(rtg),
> +			XFS_RTG_FREE)) {
> +		error = xfs_csum_verify(mp, bio, saved_iter, csum_buf, bno,
> +				false);
> +	}
> +	xfs_iunlock(rtg_rmap(rtg), XFS_ILOCK_SHARED);
> +	xfs_rtgroup_put(rtg);
> +	return error;
> +}
> +
>  static int
>  xfs_submit_verify_bio_csum(
>  	struct xfs_mount	*mp,
> @@ -332,9 +371,8 @@ xfs_submit_verify_bio_csum(
>  	if (error)
>  		goto out_buf_rele;
>  
> -	error = xfs_csum_verify(mp, &bio, &saved_iter,
> -			csum_bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno,
> -			false);
> +	error = xfs_csum_verify_metafile(mp, &bio, &saved_iter,
> +			csum_bp->b_addr + xfs_rtb_to_rtcsumoff(mp, bno), bno);
>  	if (error)
>  		goto out_media_error;
>  
> -- 
> 2.53.0
> 
> 
