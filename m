Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C92019992C
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 22:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734130366; cv=none; b=TEv+lDA/ZRZ3Il2urNa2DTpb0GVRZ8p056bBp1k7cQil+4dmMBtcSokOqngXbBs7SkKLQggAW22/st7M9cp7ezWx9wxNiqFMsS+xhxkT8H6qtzuhncU2gSL5HnFOg/s+96/hYtdP76wKnn5pHR8kOvBjv/4Dj8Rd2091VbGyVRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734130366; c=relaxed/simple;
	bh=KyKyRdOJdJXl5hNCx5IQI1dtiQfPa6tevsztqFmnwzY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M9WvnLVLHJS9uC8QgsbnaDV/tAYNuhmAFm3y/PBGNhwg9pBePdfA55D6Sqtj7Cu+HCnwNHObAnC+bR4EezSr4QrWAM10FdIy7c883Yvw9XLgk4b4UP7S1rs3npxmW98479+i3qB2oYLi98Nn9Gn6zc+mRqQIhxaWFmlpECTX/R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UzYuDBui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UzYuDBui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1486C4CED0;
	Fri, 13 Dec 2024 22:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734130365;
	bh=KyKyRdOJdJXl5hNCx5IQI1dtiQfPa6tevsztqFmnwzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UzYuDBuihlsWyks3rgyV0HZdv2FO3sm1hoT0ftuF6uwsTRF5BA2/pI3xOK9n3k3dm
	 JlfhPzIhxBU2bASKxZKttcudPFX/2EVzXVtpJYcrMPROasosyOc98zwcdBe3rnWYME
	 FguDcKQYSiWpc5jXymHt4/AhH1avU6usin1VflHCtEexxu/lH7/+vfIL4DyLikkY/4
	 DMT1LKjr8nuHa/IP5C7esiwzFmyeWseEaFZIJEzkBexikdCOpKwbN0003bRnqMvX49
	 H1EyeZ3iKaMgOKou7kqwE2JzOthqn3BTP2RLrj5bFewT8w+0rK4Ax9j9xKbp3wXqpw
	 jPEDbppX7I1sg==
Date: Fri, 13 Dec 2024 14:52:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 38/43] xfs: enable the zoned RT device feature
Message-ID: <20241213225245.GY6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-39-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-39-hch@lst.de>

On Wed, Dec 11, 2024 at 09:55:03AM +0100, Christoph Hellwig wrote:
> Enable the zoned RT device directory feature.  With this feature, RT
> groups are written sequentially and always emptied before rewriting
> the blocks.  This perfectly maps to zoned devices, but can also be
> used on conventional block devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok, though it's a bit odd that this isn't the very end of the
series.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 12979496f30a..fc56de8fe696 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -408,7 +408,8 @@ xfs_sb_has_ro_compat_feature(
>  		 XFS_SB_FEAT_INCOMPAT_NREXT64 | \
>  		 XFS_SB_FEAT_INCOMPAT_EXCHRANGE | \
>  		 XFS_SB_FEAT_INCOMPAT_PARENT | \
> -		 XFS_SB_FEAT_INCOMPAT_METADIR)
> +		 XFS_SB_FEAT_INCOMPAT_METADIR | \
> +		 XFS_SB_FEAT_INCOMPAT_ZONED)
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> -- 
> 2.45.2
> 
> 
