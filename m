Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10ED8215F42
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 18:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757962480; cv=none; b=lAs/hz5DGKyOKP+S9emU+V58P9AZf0A+fClP13Ng6E82qMRFzb6hoK5EhDysE/ITREi+bXuzzGkHeeY0Lg/NgTJ+lmrxmehivPhNvbg/x9JXViTk2S4+rrbpdfifYv+uBOGhTs0XoQM9gIWTlxVCw+QVksub0LlzgAFqokv+7yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757962480; c=relaxed/simple;
	bh=so0oDykOxVs7yOl9sXde4xQ7CmD7j0jnuigDuzxjCvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ek8iEOTjpX36+okO9uBfjiuIIAHABKQgifgVQj77IHcT9Cyvu8OoIKRXeFaULEVXdKek/8LvfE4vXh3Jq/sAlNGkFlmAnWyxaLq1t3MgVk5vpbxu5cB7+X5JWpaPUYxT8LA3igVYZpE/sMy7tzWFqMJiGPdPMdN1RYkseh83jCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVTTlg25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVTTlg25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9136CC4CEF1;
	Mon, 15 Sep 2025 18:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757962479;
	bh=so0oDykOxVs7yOl9sXde4xQ7CmD7j0jnuigDuzxjCvQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZVTTlg25L7MqjOxN0JVqwJVkIcZ1AXW8/G/vOBXg6bP2yz+5O5VgumqR0/e2mAGe5
	 h8t8bIW9FYmNmSwTl2H4W+0aHjTSKKr7rb8Hf/Rwk8DCftI+NJQIHgG7OpVSOsBlr8
	 96+zQ5LRLjaVyezHQRhYp4oQFetPZdfbQoNA8KcktSsJrzxJvHcUK6eNwbUznOcac/
	 wkVuJCGQa64Pc3e2O7g2a8dlzCy6V8TNMoxbfhjNuTwzbXiJglXu6nMYTqhwNYrn3l
	 HBeKhOOfZ+5EQis85Pe0SrUYde/BdX5tM5qHvKGHUYcFuEWHZNLp3MGAiPMBxAxrGj
	 yZkYyXP/fOrpQ==
Date: Mon, 15 Sep 2025 11:54:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: remove xfs_errortag_set
Message-ID: <20250915185439.GU8096@frogsfrogsfrogs>
References: <20250915133104.161037-1-hch@lst.de>
 <20250915133104.161037-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915133104.161037-3-hch@lst.de>

On Mon, Sep 15, 2025 at 06:30:38AM -0700, Christoph Hellwig wrote:
> xfs_errortag_set is only called by xfs_errortag_attr_store, , which does
> not need to validate the error tag, because it can only be called on
> valid error tags that had a sysfs attribute registered.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense too
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_error.c | 29 ++++++-----------------------
>  fs/xfs/xfs_error.h |  3 ---
>  2 files changed, 6 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 45a43e47ce92..fac35ff3da65 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -93,21 +93,18 @@ xfs_errortag_attr_store(
>  	size_t			count)
>  {
>  	struct xfs_mount	*mp = to_mp(kobject);
> -	struct xfs_errortag_attr *xfs_attr = to_attr(attr);
> +	unsigned int		error_tag = to_attr(attr)->tag;
>  	int			ret;
> -	unsigned int		val;
>  
>  	if (strcmp(buf, "default") == 0) {
> -		val = xfs_errortag_random_default[xfs_attr->tag];
> +		mp->m_errortag[error_tag] =
> +			xfs_errortag_random_default[error_tag];
>  	} else {
> -		ret = kstrtouint(buf, 0, &val);
> +		ret = kstrtouint(buf, 0, &mp->m_errortag[error_tag]);
>  		if (ret)
>  			return ret;
>  	}
>  
> -	ret = xfs_errortag_set(mp, xfs_attr->tag, val);
> -	if (ret)
> -		return ret;
>  	return count;
>  }
>  
> @@ -325,19 +322,6 @@ xfs_errortag_test(
>  	return true;
>  }
>  
> -int
> -xfs_errortag_set(
> -	struct xfs_mount	*mp,
> -	unsigned int		error_tag,
> -	unsigned int		tag_value)
> -{
> -	if (!xfs_errortag_valid(error_tag))
> -		return -EINVAL;
> -
> -	mp->m_errortag[error_tag] = tag_value;
> -	return 0;
> -}
> -
>  int
>  xfs_errortag_add(
>  	struct xfs_mount	*mp,
> @@ -347,9 +331,8 @@ xfs_errortag_add(
>  
>  	if (!xfs_errortag_valid(error_tag))
>  		return -EINVAL;
> -
> -	return xfs_errortag_set(mp, error_tag,
> -			xfs_errortag_random_default[error_tag]);
> +	mp->m_errortag[error_tag] = xfs_errortag_random_default[error_tag];
> +	return 0;
>  }
>  
>  int
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 3aeb03001acf..fd60a008f9d2 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -58,8 +58,6 @@ bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
>  		mdelay((mp)->m_errortag[(tag)]); \
>  	} while (0)
>  
> -extern int xfs_errortag_set(struct xfs_mount *mp, unsigned int error_tag,
> -		unsigned int tag_value);
>  extern int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
>  extern int xfs_errortag_clearall(struct xfs_mount *mp);
>  #else
> @@ -67,7 +65,6 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp);
>  #define xfs_errortag_del(mp)
>  #define XFS_TEST_ERROR(expr, mp, tag)		(expr)
>  #define XFS_ERRORTAG_DELAY(mp, tag)		((void)0)
> -#define xfs_errortag_set(mp, tag, val)		(ENOSYS)
>  #define xfs_errortag_add(mp, tag)		(ENOSYS)
>  #define xfs_errortag_clearall(mp)		(ENOSYS)
>  #endif /* DEBUG */
> -- 
> 2.47.2
> 
> 
