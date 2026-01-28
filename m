Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C8929E10F
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 11:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769598513; cv=none; b=bP6bshvZztwyqQBdfViXB/KIb2D+5iIxsPe2+ZRJ0kBOovK6sa7JMJ6NcJ7fJ0t4S29F5c24p2WE1fYfXYrnwwdp7kvz0YeQhvOyDUCmXaVk6lYgniGKPUOiXWJRQJOTjT4L0MyFPE7bLa6NRUOJtiOew7HJuepGkcq6VCbTeb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769598513; c=relaxed/simple;
	bh=0ZX4yb/5kkhuEKnRoAxBBb5EB3MRb0KSnFmFjeTIQ60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mtOo/O6iFm1oisbzpqaLza4AQAlxU0Ib52aMtXYdbgsNb5D2d4HeIkFqpzoYZot0EXrr7cUdYUBUbnNlOPlSU2KNw/R1sGxRHfaIVJpKV54YwehzPDojlAWdqYxzYLLTE0SG6k97OBdjfXk1nON/alDPXUhB+LbyU2jh0cSUBMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MUr5bgzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MUr5bgzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C26C19421;
	Wed, 28 Jan 2026 11:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769598513;
	bh=0ZX4yb/5kkhuEKnRoAxBBb5EB3MRb0KSnFmFjeTIQ60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MUr5bgzT4s56LBUgxCcIe1OaemwYpV43zeZSMMtTY/nWQ4DSLEIZVsK1nI7y0Lqfm
	 pwnH83kg0nJDfvstjK6X2YK1Ux6s5xRcHYIkPx+pdinxiAg9eT5dNQMPEfJSyJkcHF
	 zw9vvPR6gKey+KSKX0iuYYnFhQuAXzRTiZz1dV8pkKZOEh8KOq48NNCDtCGdqUd32Y
	 G34JCk87tOKjLDOM9EmiuIFNvD8gpDWQmN293MQlim4Yr7sl7xLNg53W++lN/54gtU
	 T5jacIH21BU8N03bcyTWKyGJNVCWMOX/mtY2PPoPbXVvuLbkQW4Ivc5N3/tCURGvHO
	 +B/S09HzHRcKw==
Date: Wed, 28 Jan 2026 12:08:29 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/10] xfs: don't validate error tags in the I/O path
Message-ID: <aXnuJVtn1z1EmtJd@nidhogg.toxiclabs.cc>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-4-hch@lst.de>

On Tue, Jan 27, 2026 at 05:05:43PM +0100, Christoph Hellwig wrote:
> We can trust XFS developers enough to not pass random stuff to
> XFS_ERROR_TEST/DELAY.  Open code the validity check in xfs_errortag_add,
> which is the only place that receives unvalidated error tag values from
> user space, and drop the now pointless xfs_errortag_enabled helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_errortag.h |  2 +-
>  fs/xfs/xfs_error.c           | 38 ++++++++++--------------------------
>  fs/xfs/xfs_error.h           |  2 +-
>  3 files changed, 12 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_errortag.h b/fs/xfs/libxfs/xfs_errortag.h
> index 57e47077c75a..b7d98471684b 100644
> --- a/fs/xfs/libxfs/xfs_errortag.h
> +++ b/fs/xfs/libxfs/xfs_errortag.h
> @@ -53,7 +53,7 @@
>   * Drop-writes support removed because write error handling cannot trash
>   * pre-existing delalloc extents in any useful way anymore. We retain the
>   * definition so that we can reject it as an invalid value in
> - * xfs_errortag_valid().
> + * xfs_errortag_add().

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>   */
>  #define XFS_ERRTAG_DROP_WRITES				28
>  #define XFS_ERRTAG_LOG_BAD_CRC				29
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index dfa4abf9fd1a..52a1d51126e3 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -125,30 +125,6 @@ xfs_errortag_del(
>  	xfs_sysfs_del(&mp->m_errortag_kobj);
>  }
>  
> -static bool
> -xfs_errortag_valid(
> -	unsigned int		error_tag)
> -{
> -	if (error_tag >= XFS_ERRTAG_MAX)
> -		return false;
> -
> -	/* Error out removed injection types */
> -	if (error_tag == XFS_ERRTAG_DROP_WRITES)
> -		return false;
> -	return true;
> -}
> -
> -bool
> -xfs_errortag_enabled(
> -	struct xfs_mount	*mp,
> -	unsigned int		tag)
> -{
> -	if (!xfs_errortag_valid(tag))
> -		return false;
> -
> -	return mp->m_errortag[tag] != 0;
> -}
> -
>  bool
>  xfs_errortag_test(
>  	struct xfs_mount	*mp,
> @@ -158,9 +134,6 @@ xfs_errortag_test(
>  {
>  	unsigned int		randfactor;
>  
> -	if (!xfs_errortag_valid(error_tag))
> -		return false;
> -
>  	randfactor = mp->m_errortag[error_tag];
>  	if (!randfactor || get_random_u32_below(randfactor))
>  		return false;
> @@ -178,8 +151,17 @@ xfs_errortag_add(
>  {
>  	BUILD_BUG_ON(ARRAY_SIZE(xfs_errortag_random_default) != XFS_ERRTAG_MAX);
>  
> -	if (!xfs_errortag_valid(error_tag))
> +	if (error_tag >= XFS_ERRTAG_MAX)
> +		return -EINVAL;
> +
> +	/* Error out removed injection types */
> +	switch (error_tag) {
> +	case XFS_ERRTAG_DROP_WRITES:
>  		return -EINVAL;
> +	default:
> +		break;
> +	}
> +
>  	mp->m_errortag[error_tag] = xfs_errortag_random_default[error_tag];
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 3a78c8dfaec8..ec22546a8ca8 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -44,7 +44,7 @@ bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
>  #define XFS_ERRORTAG_DELAY(mp, tag)		\
>  	do { \
>  		might_sleep(); \
> -		if (!xfs_errortag_enabled((mp), (tag))) \
> +		if (!mp->m_errortag[tag]) \
>  			break; \
>  		xfs_warn_ratelimited((mp), \
>  "Injecting %ums delay at file %s, line %d, on filesystem \"%s\"", \
> -- 
> 2.47.3
> 
> 
