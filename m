Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95934351C10
	for <linux-xfs@vger.kernel.org>; Fri, 24 Jul 2026 16:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784911531; cv=none; b=pqScmDsbKkjTFLABbxZwNNJwbyOfCofgW/ckFiR51hmsgK4T0XZKCNX+FTX7EN3OOXZp/2ldiJY1OTEJlG8DRhuAsNRdZyUOqNBbHcndHNX9ZVxzCj2Mu46ysY013NUnjciM2mNBghGH8N24xmslZyALmYdhi+R/c4ZD1sQq/OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784911531; c=relaxed/simple;
	bh=Lst1BXwdBWQH8ndnnDoR/vSNdB04b4tVDd6zwOFYO0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OwBcT3YllUqsMA9cWu/vm2N5uFhuwMBXsKS255OQA9r3XQEnoD8Ur56gC2tRn2I/yj4U9I0VohANQpbduphlcZR1WRm0rtL1AjuWua2s+kiP9h/h2qioAdl+g9gR2MvvCAcEGmiBNrnyYr07CZzRfOXRmLX2WSuH0TuxV4wlamw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0h4T2O4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0h4T2O4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 244C91F000E9;
	Fri, 24 Jul 2026 16:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784911530;
	bh=gSoO2oCiS1ruMTH1WBY4n9M2wkZh5yGjcAjxr48GF40=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C0h4T2O4PE/ZVwYHp2AiWhBlq4ks3zPcVmCZun1mx5JqHDo+qCk3sWk6OkeE3eeJ4
	 zoZbGzm4scet5AK1AOQlku3Wu7AA/zDGKPxmxS2WvYUSq3mgv2CrDVc+WOAaQIHG5d
	 rwRX3Tc84iN7VB2AmFeBiYL1/byeWlP/1Kt8IxiXW6t1hnGfAac3doUp06GlEtoiu9
	 TLkdrDLNH9GuqcN8xeY0l8cTtyoy2gO+3jQQeCcDhRe5ZabYFhzUNQqIWzHek+3tX8
	 mqF75GtOT59VSIPdjWcrmrbA9ySi2rhJy/GfBe6ZvHl/vdFushj5hCQWNGY5yeSsfG
	 Awh8h7S+yQvXg==
Date: Fri, 24 Jul 2026 09:45:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/12] xfs: remove spurious XBF_DONE clearing on
 readahead validation failure
Message-ID: <20260724164529.GR2901224@frogsfrogsfrogs>
References: <20260715145147.95654-1-hch@lst.de>
 <20260715145147.95654-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715145147.95654-5-hch@lst.de>

On Wed, Jul 15, 2026 at 04:50:57PM +0200, Christoph Hellwig wrote:
> Both callers of ->verify_read already do this, so don't duplicate the
> flag manipulation.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c |  8 +++-----
>  fs/xfs/libxfs/xfs_inode_buf.c | 15 ++++++++-------
>  2 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index bbada0d3cc08..4736f66e2a9a 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -252,8 +252,8 @@ xfs_dquot_buf_read_verify(
>  /*
>   * readahead errors are silent and simply leave the buffer as !done so a real
>   * read will then be run with the xfs_dquot_buf_ops verifier. See
> - * xfs_inode_buf_verify() for why we use EIO and ~XBF_DONE here rather than
> - * reporting the failure.
> + * xfs_inode_buf_verify() for why we use EIO here rather than reporting the
> + * failure.
>   */
>  static void
>  xfs_dquot_buf_readahead_verify(
> @@ -262,10 +262,8 @@ xfs_dquot_buf_readahead_verify(
>  	struct xfs_mount	*mp = bp->b_mount;
>  
>  	if (!xfs_dquot_buf_verify_crc(mp, bp, true) ||
> -	    xfs_dquot_buf_verify(mp, bp, true) != NULL) {
> +	    xfs_dquot_buf_verify(mp, bp, true) != NULL)
>  		xfs_buf_ioerror(bp, -EIO);
> -		bp->b_flags &= ~XBF_DONE;
> -	}
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 336ef843f2fe..e4c3f7b24e95 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -29,12 +29,14 @@
>   * has not had the inode cores stamped into it. Hence for readahead, the buffer
>   * may be potentially invalid.
>   *
> - * If the readahead buffer is invalid, we need to mark it with an error and
> - * clear the DONE status of the buffer so that a followup read will re-read it
> - * from disk. We don't report the error otherwise to avoid warnings during log
> - * recovery and we don't get unnecessary panics on debug kernels. We use EIO here
> - * because all we want to do is say readahead failed; there is no-one to report
> - * the error to, so this will distinguish it from a non-ra verifier failure.
> + * If the readahead buffer is invalid, we need to mark it with an error so that a
> + * followup read will re-read it from disk.
> + *
> + * We don't report the error otherwise to avoid warnings during log recovery and
> + * we don't get unnecessary panics on debug kernels.  Use EIO here because all
> + * we want to do is say readahead failed; there is no-one to report the error
> + * to, so this will distinguish it from a non-ra verifier failure.
> + *
>   * Changes to this readahead error behaviour also need to be reflected in
>   * xfs_dquot_buf_readahead_verify().
>   */
> @@ -64,7 +66,6 @@ xfs_inode_buf_verify(
>  		if (unlikely(!di_ok ||
>  				XFS_TEST_ERROR(mp, XFS_ERRTAG_ITOBP_INOTOBP))) {
>  			if (readahead) {
> -				bp->b_flags &= ~XBF_DONE;
>  				xfs_buf_ioerror(bp, -EIO);
>  				return;
>  			}
> -- 
> 2.53.0
> 
> 
