Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9282EA158
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 11:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769598801; cv=none; b=O7ws5QJeAsvC6a+isvynyt+5lJE93ac4M08PhmMDtY4FZJnBefUGyu3vLSGbLOMAxgyJtQ3drQq/dgxe054l5tC2s+Cxb0NEUoYUNIyUyv05KlLEcFYvaoa2MQy0Ji9khdrIyLDmoziNMj10U92MdT6LeOZTryNrqEJJXASTPeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769598801; c=relaxed/simple;
	bh=4DmA8mBeBOhPqhZRTfXLLUigPybIGTU9msIDnciHqfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxEe0t0qi5+cmegU/ac3TWctn61pOws6rI+KXE5wH1ZT+6m8XKYktr/vRqFTtuft8P+5iC5yzXL7B+JtmbrvxvupF3yDlOQRJh0p0jjeN7MK5xXHGv8uRm3V14PfkA1CIpKiZd62MxAJAuAOmbRG0jUrn2Olgu4u9fUGp77TQP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3g6n5EU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3g6n5EU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94832C4CEF1;
	Wed, 28 Jan 2026 11:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769598800;
	bh=4DmA8mBeBOhPqhZRTfXLLUigPybIGTU9msIDnciHqfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f3g6n5EUxk8AveNqNx3vlOYZ1Lw5GqHKjIlPUKbMY+k17EAFy5o3wrOAKLqEub5Xt
	 f203nfahH1n/NIz+hPil7WSkT7REPEUdKqMSiiwPrdQHRcVrTUa8LA/NQez2Sazmfh
	 oVEZBsaPOvu5NU2O8nQNN5YpS9CHSIL23kDS9kB6UKhT9gDs0DRHM2D9yTbM4eCaZC
	 020D4gKXVTG8mBV6HwXjlN2EslHussvbdlEYY+1M+wJZiDctUXMW4XxAF1KbwYDDtP
	 xEh1zq7fFgQUzF4d5LzdfmKlGTmuoWJWtqdaLRz3zRiR7LR/IMR+HbThZC9jyNQSTv
	 /jJ23ii0zRKXA==
Date: Wed, 28 Jan 2026 12:13:16 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of
 line
Message-ID: <aXnvQjx8OxgyvDmo@nidhogg.toxiclabs.cc>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-5-hch@lst.de>

On Tue, Jan 27, 2026 at 05:05:44PM +0100, Christoph Hellwig wrote:
> Mirror what is done for the more common XFS_ERRORTAG_TEST version,
> and also only look at the error tag value once now that we can
> easily have a local variable.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_error.c | 21 +++++++++++++++++++++
>  fs/xfs/xfs_error.h | 15 +++------------
>  2 files changed, 24 insertions(+), 12 deletions(-)

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 52a1d51126e3..a6f160a4d0e9 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -144,6 +144,27 @@ xfs_errortag_test(
>  	return true;
>  }
>  
> +void
> +xfs_errortag_delay(
> +	struct xfs_mount	*mp,
> +	const char		*file,
> +	int			line,
> +	unsigned int		error_tag)
> +{
> +	unsigned int		delay = mp->m_errortag[error_tag];
> +
> +	might_sleep();
> +
> +	if (!delay)
> +		return;
> +
> +	xfs_warn_ratelimited(mp,
> +"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"",
> +		delay, file, line,
> +		mp->m_super->s_id);
> +	mdelay(delay);
> +}
> +
>  int
>  xfs_errortag_add(
>  	struct xfs_mount	*mp,
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index ec22546a8ca8..b40e7c671d2a 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -40,19 +40,10 @@ bool xfs_errortag_test(struct xfs_mount *mp, const char *file, int line,
>  		unsigned int error_tag);
>  #define XFS_TEST_ERROR(mp, tag)		\
>  	xfs_errortag_test((mp), __FILE__, __LINE__, (tag))
> -bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
> +void xfs_errortag_delay(struct xfs_mount *mp, const char *file, int line,
> +		unsigned int error_tag);
>  #define XFS_ERRORTAG_DELAY(mp, tag)		\
> -	do { \
> -		might_sleep(); \
> -		if (!mp->m_errortag[tag]) \
> -			break; \
> -		xfs_warn_ratelimited((mp), \
> -"Injecting %ums delay at file %s, line %d, on filesystem \"%s\"", \
> -				(mp)->m_errortag[(tag)], __FILE__, __LINE__, \
> -				(mp)->m_super->s_id); \
> -		mdelay((mp)->m_errortag[(tag)]); \
> -	} while (0)
> -
> +	xfs_errortag_delay((mp), __FILE__, __LINE__, (tag))
>  int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
>  int xfs_errortag_clearall(struct xfs_mount *mp);
>  #else
> -- 
> 2.47.3
> 
> 
