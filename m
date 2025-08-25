Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BCC20CCCA;
	Mon, 25 Aug 2025 15:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756136056; cv=none; b=XOrFOuwpNogyyJ48u+9B7V/GChdpZotUG+icowR8V7SwadkcykLnCH3svX+fb6MkPvGvee6OuSzFK8qkkTXwgZzPeA4lr1ipJ4U5pVkC9XyLndd0BJVuikEo8auvi5bvCory9PGc3daIuRhSm9T1L3prbkkGmw6Gm4ue7jmOwgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756136056; c=relaxed/simple;
	bh=4+sW98FhnFSiNqmMc921IXHqV+hyfMi7VOVwRD1qkaU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ft68FKfbL8Cdd8lhen7DCnykvr4O+eD/QyMfFVUtHz34pULjZKCx4EjLnKxSPfGEfnh7U0v7yqcrMlEuzNfcuCtFMtWm50COiEU/+Xk55z4B+nm8JrF7K0LBbRo94sZsRcakumFXeObmXYZ9J9SBC7Hc69iOU761Juu8Xzkq8S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fT+R2MRZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fT+R2MRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B46AC4CEED;
	Mon, 25 Aug 2025 15:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756136056;
	bh=4+sW98FhnFSiNqmMc921IXHqV+hyfMi7VOVwRD1qkaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fT+R2MRZWfJ2cPsJCZfV/wH65kp9ESOtSCM9cTRts7wt4Wc5wwczrDakK2eMNzwz5
	 CDsxWyD4eqSzgoDtBPhzT+cxi1G/C50tRq9I3Ry29chagWVyJXO5xDCi/6qeFPdblS
	 sMh73Qn5L/+Gzw+7VBneMzE4yr4F/SGq8HZh5jDdmdBC9QvJRd4mhiDF7AV2/wdUI6
	 5dyU/x3lijFbkfjWQSl23HrsV6D23WvFNSGbOhRMQG9gKrGevsM0ohj3QxPEXW9bND
	 IOWfJtUhb6o8bFpDgomJIlG7eM5iLBWNjSvMoTdObXKttaAUfse/uKQ0VQVY9pR3m4
	 QSk2ENxJ/K6DQ==
Date: Mon, 25 Aug 2025 08:34:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Donald Douwsma <ddouwsma@redhat.com>,
	Dave Chinner <dchinner@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: do not propagate ENODATA disk errors into xattr code
Message-ID: <20250825153414.GC812310@frogsfrogsfrogs>
References: <a896ce2b-1c3b-4298-a90c-c2c0e18de4cb@redhat.com>
 <20250822152137.GE7965@frogsfrogsfrogs>
 <aKwW2gEnQdIdDONk@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKwW2gEnQdIdDONk@infradead.org>

On Mon, Aug 25, 2025 at 12:55:06AM -0700, Christoph Hellwig wrote:
> On Fri, Aug 22, 2025 at 08:21:37AM -0700, Darrick J. Wong wrote:
> > We only flag corruptions for these two error codes, but ENODATA from the
> > block layer means "critical medium error".  I take that to mean the
> > media has permanently lost whatever was persisted there, right?
> 
> It can also be a write error.  But yes, it's what EIO indidcates in
> general.  Which is why I really think we should be doing something like
> the patch below.  But as I don't have the time to fully shephed this
> I'm not trying to block this hack, even if I think the issue will
> continue to byte us in the future.

Yes, it's a bit of a problem, whose issues we'll need to nibble on all
over the place to fix all the weird issues before issuing the customary
patchbomb for gluttinous consumption on fsdevel. <cough>

> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f9ef3b2a332a..0252faf038aa 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1290,6 +1290,22 @@ xfs_bwrite(
>  	return error;
>  }
>  
> +static int
> +xfs_buf_bio_status(
> +	struct bio		*bio)
> +{
> +	switch (bio->bi_status) {
> +	case BLK_STS_OK:
> +		return 0;
> +	case BLK_STS_NOSPC:
> +		return -ENOSPC;
> +	case BLK_STS_OFFLINE:
> +		return -ENODEV;
> +	default:
> +		return -EIO;

Well as I pointed out earlier, one interesting "quality" of the current
behavior is that online fsck captures the ENODATA and turns that into a
metadata corruption report.  I'd like to keep that behavior.

> +	}
> +}
> +
>  static void
>  xfs_buf_bio_end_io(
>  	struct bio		*bio)
> @@ -1297,7 +1313,7 @@ xfs_buf_bio_end_io(
>  	struct xfs_buf		*bp = bio->bi_private;
>  
>  	if (bio->bi_status)
> -		xfs_buf_ioerror(bp, blk_status_to_errno(bio->bi_status));
> +		xfs_buf_ioerror(bp, xfs_buf_bio_status(bio));

I think you'd also want to wrap all the submit_bio_wait here too, right?

Hrm, only discard bios, log writes, and zonegc use that function.  Maybe
not?  I think a failed log write takes down the system no matter what
error code, nobody cares about failing discard, and I think zonegc write
failures just lead to the gc ... aborting?

--D

>  	else if ((bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
>  		 XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
>  		xfs_buf_ioerror(bp, -EIO);
> 
