Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8C010A1E
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 01:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564169; cv=none; b=BqenlCHFXVGWHR/oWrbhA16AmKfoAPNiSFJ4+AzyYjgwd2IwNar6MUJB8J87vmrvvNv5FDG4pi96PDkvhstAyoaxhtdrYo6Q/pqiIRU6RwbKSBw+0qM8HnhuM+cBrfRYYcYbxB7qzq4KhRkbkF1pqt1jTwnCNo3x39Bx1r437JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564169; c=relaxed/simple;
	bh=f98Fk9vOfPoaD8PZQHgREjIblUeD2gaORjHMoqQL7nk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=isxzhyIhMxWWaB1a/VpPNbJ2t0iMA5qc9i9/fbKhxX7sUr9KljcNdkMe0uXCSBpPJyjqJDg6h1KUB8vpqwA4OtRT4zKUaqBv/vb9A8Fri19DxgDNSzj9jMCSTauZtcPLOzLnyFi/l2b2sg6x+oIY3tI9rI6MJJQ4Q7O8cokLuQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qrKPwXOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qrKPwXOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71BA7C116C6;
	Wed, 28 Jan 2026 01:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769564169;
	bh=f98Fk9vOfPoaD8PZQHgREjIblUeD2gaORjHMoqQL7nk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qrKPwXOy8P9zSTGjoYVjFpQmMfrvPXtnGIOBNzK0LedWRTurVqkk/xYGthXzEul15
	 n+2RLDs7BrJIaNiYmw8CtaYACERb+Rf49H6fej8j3zDUCxgIBuZx0FCWw6u0v5NtE4
	 BSVO4O7jFhnR0olOrf94N9G4Q5L9itXBu+KFqRmeqrw+pOR3nH0m0MsSd+GHhQE7HQ
	 WiyEjaeli+JQX8YTZ7eRqal4GIQF4zvBrfzqKkw7jT1WeQvNgk8ILHkefx2kXDlNNj
	 dXUyAicIPfFnqVVETPPn0wwxJzEuirBgfme0SxMt8SFsUZ7M4QQ5BbF6FbRew4AFMI
	 +POSakQDW3IuQ==
Date: Tue, 27 Jan 2026 17:36:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/10] xfs: use WRITE_ONCE/READ_ONCE for m_errortag
Message-ID: <20260128013608.GE5945@frogsfrogsfrogs>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-6-hch@lst.de>

On Tue, Jan 27, 2026 at 05:05:45PM +0100, Christoph Hellwig wrote:
> There is no synchronization for updating m_errortag, which is fine as
> it's just a debug tool.  It would still be nice to fully avoid the
> theoretical case of torn values, so use WRITE_ONCE and READ_ONCE to
> access the members.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_error.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index a6f160a4d0e9..53704f1ed791 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -50,17 +50,18 @@ xfs_errortag_attr_store(
>  {
>  	struct xfs_mount	*mp = to_mp(kobject);
>  	unsigned int		error_tag = to_attr(attr)->tag;
> +	unsigned int		val;
>  	int			ret;
>  
>  	if (strcmp(buf, "default") == 0) {
> -		mp->m_errortag[error_tag] =
> -			xfs_errortag_random_default[error_tag];
> +		val = xfs_errortag_random_default[error_tag];
>  	} else {
> -		ret = kstrtouint(buf, 0, &mp->m_errortag[error_tag]);
> +		ret = kstrtouint(buf, 0, &val);
>  		if (ret)
>  			return ret;
>  	}
>  
> +	WRITE_ONCE(mp->m_errortag[error_tag], val);
>  	return count;
>  }
>  
> @@ -71,9 +72,9 @@ xfs_errortag_attr_show(
>  	char			*buf)
>  {
>  	struct xfs_mount	*mp = to_mp(kobject);
> -	unsigned int		error_tag = to_attr(attr)->tag;
>  
> -	return snprintf(buf, PAGE_SIZE, "%u\n", mp->m_errortag[error_tag]);
> +	return snprintf(buf, PAGE_SIZE, "%u\n",
> +			READ_ONCE(mp->m_errortag[to_attr(attr)->tag]));
>  }
>  
>  static const struct sysfs_ops xfs_errortag_sysfs_ops = {
> @@ -134,7 +135,7 @@ xfs_errortag_test(
>  {
>  	unsigned int		randfactor;
>  
> -	randfactor = mp->m_errortag[error_tag];
> +	randfactor = READ_ONCE(mp->m_errortag[error_tag]);
>  	if (!randfactor || get_random_u32_below(randfactor))
>  		return false;
>  
> @@ -151,7 +152,7 @@ xfs_errortag_delay(
>  	int			line,
>  	unsigned int		error_tag)
>  {
> -	unsigned int		delay = mp->m_errortag[error_tag];
> +	unsigned int		delay = READ_ONCE(mp->m_errortag[error_tag]);
>  
>  	might_sleep();
>  
> @@ -183,7 +184,8 @@ xfs_errortag_add(
>  		break;
>  	}
>  
> -	mp->m_errortag[error_tag] = xfs_errortag_random_default[error_tag];
> +	WRITE_ONCE(mp->m_errortag[error_tag],
> +		   xfs_errortag_random_default[error_tag]);
>  	return 0;
>  }
>  
> @@ -191,7 +193,10 @@ int
>  xfs_errortag_clearall(
>  	struct xfs_mount	*mp)
>  {
> -	memset(mp->m_errortag, 0, sizeof(unsigned int) * XFS_ERRTAG_MAX);
> +	unsigned int		i;
> +
> +	for (i = 0; i < XFS_ERRTAG_MAX; i++)
> +		WRITE_ONCE(mp->m_errortag[i], 0);
>  	return 0;
>  }
>  #endif /* DEBUG */
> -- 
> 2.47.3
> 
> 
