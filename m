Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCA31FA859
	for <linux-xfs@vger.kernel.org>; Mon, 15 Sep 2025 18:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757962458; cv=none; b=mwypJ5nWZIK4Bq11kHMHaT5FvCZgwKF5enHgzrwxdj+dKEMewiX3UR0eNtBG7vD7dga3mfdpT9u/bXl7mY70FVwaiu7uAoaHn1pBxi5uR+pY5NN0LA/6X8ZGx1Q3mZpBB1M5Q36SD3E6h77jAh3jWU4XcaNPiYwWSAifBrEbykA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757962458; c=relaxed/simple;
	bh=6sEPi/R5YfEmGhqDirtCu0N0+BUCU6biRO23rywnm+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JFs5Uqm7rUUvHk8hIl5u8oDvkUby8Sz3hECl2qB5H/Mkecm/G4HUfvmCmB8ZQHDJw3EYUY1Y4CkpvztkhI5BDs//OhxhMpV0JwEG9HJvGITzoA8OmN6IJRISmg4t8c2hSTkXHJAyP1MAGnlgAhoaEq/U3LTVD8gaMKO7qWfE4uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=phHW/u48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="phHW/u48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D09C4CEF1;
	Mon, 15 Sep 2025 18:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757962458;
	bh=6sEPi/R5YfEmGhqDirtCu0N0+BUCU6biRO23rywnm+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=phHW/u48kEeBsi+NvJKaByR9pqfMBvBbSpm/QccfJk6rieGUQ0hr6X6D2iWt4vExL
	 IDI0KKaO92PVm8+ZJrCynUYDXtqJrXlQokgPCa0IzEEGgulAIxg5CFRxHQBi4UUe0n
	 2dxVzqlCewFMjiM3IabhJ2q6g3U7GbKJWyOB7QPGmeGVrRQ2tsgOu7zj4zJMEtgDzK
	 fNyiYpjnpwab6jVQ7RG6mv5VKz3jkIcUynwF70FJzL6UQog5OW9eht8DtEHYiaEF39
	 ZScUAKYUSLi/+bVuNwaxjb88xaATfNUIykr2JzTi7v9yxrkC6NxfMXNJIxgECyG5xd
	 HmiHM67GBDXjQ==
Date: Mon, 15 Sep 2025 11:54:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: remove xfs_errortag_get
Message-ID: <20250915185417.GT8096@frogsfrogsfrogs>
References: <20250915133104.161037-1-hch@lst.de>
 <20250915133104.161037-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915133104.161037-2-hch@lst.de>

On Mon, Sep 15, 2025 at 06:30:37AM -0700, Christoph Hellwig wrote:
> xfs_errortag_get is only called by xfs_errortag_attr_show, which does not
> need to validate the error tag, because it can only be called on valid
> error tags that had a sysfs attribute registered.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_error.c | 16 ++--------------
>  fs/xfs/xfs_error.h |  1 -
>  2 files changed, 2 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index dbd87e137694..45a43e47ce92 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -118,10 +118,9 @@ xfs_errortag_attr_show(
>  	char			*buf)
>  {
>  	struct xfs_mount	*mp = to_mp(kobject);
> -	struct xfs_errortag_attr *xfs_attr = to_attr(attr);
> +	unsigned int		error_tag = to_attr(attr)->tag;
>  
> -	return snprintf(buf, PAGE_SIZE, "%u\n",
> -			xfs_errortag_get(mp, xfs_attr->tag));
> +	return snprintf(buf, PAGE_SIZE, "%u\n", mp->m_errortag[error_tag]);
>  }
>  
>  static const struct sysfs_ops xfs_errortag_sysfs_ops = {
> @@ -326,17 +325,6 @@ xfs_errortag_test(
>  	return true;
>  }
>  
> -int
> -xfs_errortag_get(
> -	struct xfs_mount	*mp,
> -	unsigned int		error_tag)
> -{
> -	if (!xfs_errortag_valid(error_tag))
> -		return -EINVAL;
> -
> -	return mp->m_errortag[error_tag];
> -}
> -
>  int
>  xfs_errortag_set(
>  	struct xfs_mount	*mp,
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index 0b9c5ba8a598..3aeb03001acf 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -58,7 +58,6 @@ bool xfs_errortag_enabled(struct xfs_mount *mp, unsigned int tag);
>  		mdelay((mp)->m_errortag[(tag)]); \
>  	} while (0)
>  
> -extern int xfs_errortag_get(struct xfs_mount *mp, unsigned int error_tag);
>  extern int xfs_errortag_set(struct xfs_mount *mp, unsigned int error_tag,
>  		unsigned int tag_value);
>  extern int xfs_errortag_add(struct xfs_mount *mp, unsigned int error_tag);
> -- 
> 2.47.2
> 
> 
