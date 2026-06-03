Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2935F3FD142;
	Wed,  3 Jun 2026 21:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780520893; cv=none; b=fKrqcpBK/DopjAx9Mdt1rpiVzQoI7l7NIuKI1ykxr1Xa7mVxcp0tScieGTugL5/nJTxNxd8y4vGHBu518RzMjg4fY4CkKstaO9Z30DAfbaj0W1ujsLoKGEU7sJfHxrWRR+8T3Juz8MJO911B9fT+0NBxLt18FHKDHTjlOBC9lE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780520893; c=relaxed/simple;
	bh=81YjhO6sJptn103zaa/GHzXrEYjQEnLqDL6jQGTaW5w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gtp9XXu2mvyBsZ89AG2b4gLC9qSloszgKqdH62659504E1fOSqeT5Yl1qg/EOYiBfj5LJBDStNArlJYB0dGMaycFOZTCvYrk//FT7qc/Rw4TJVtYWe6/yMIF+Zm0OVJAVzCyPfSl5AxxXvZI52uk/bCVlU6ke/TP7XNB9iKK9vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWZ5d08l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWZ5d08l"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BD2B61F00893;
	Wed,  3 Jun 2026 21:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780520891;
	bh=d1y5xR1TOZhVmoNd5URCb1SUNKzdjP5k9fc9fKL9T2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IWZ5d08la4EV+5GSf8PVrG8/4KnBHj2oPhVf2Lb1nAr8sYVS4NyJ7oJ1IPT8EqXzN
	 1pQQJ9vtkWFPrJc6nLnFNQ/hjk0HegpWKHOQBT/z6XP2PsfmQu8UO08zyA0/bWHwOk
	 MAjw2hxIKZ8bqfIqo/Xe8eHEnxaZopfA59Y7jX5S9bjZrmpWDsQlMCow+MzZYjPbnm
	 UEcdGEFiWXs4YshwyFjg3j+vDAnYL+zupnzAmdCbqruU54dYoh+HbWRbRYNX/6KwEe
	 xoy9Uki5KtKyMzgtYUL1EjciVQ8ITcj36jmzzd1PyITNXUYaFg4flYXWmrSD3hg1lC
	 3DQKiuREXoy3w==
Date: Wed, 3 Jun 2026 14:08:11 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Alexey Nepomnyashih <sdl@nppct.ru>
Cc: Carlos Maiolino <cem@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
	Allison <achender@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix unreachable BIGTIME check in dquot flush
 validation
Message-ID: <20260603210811.GV6078@frogsfrogsfrogs>
References: <20260603204148.232530-1-sdl@nppct.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603204148.232530-1-sdl@nppct.ru>

[fix some addresses]

On Wed, Jun 03, 2026 at 08:41:47PM +0000, Alexey Nepomnyashih wrote:
> The dqp->q_id == 0 check inside the XFS_DQTYPE_BIGTIME block is
> unreachable because root dquots return successfully earlier. Reject root
> dquots with XFS_DQTYPE_BIGTIME before that early return, preserving the
> intended validation and removing the unreachable condition.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 4ea1ff3b4968 ("xfs: widen ondisk quota expiration timestamps to handle y2038+")
> Cc: stable@vger.kernel.org # v5.10+
> Signed-off-by: Alexey Nepomnyashih <sdl@nppct.ru>

Yeah, that looks like a screwup...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_dquot.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 69e9bc588c8b..c311f61d9554 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1216,6 +1216,14 @@ xfs_qm_dqflush_check(
>  	    type != XFS_DQTYPE_PROJ)
>  		return __this_address;
>  
> +	/* bigtime flag should never be set on root dquots */
> +	if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
> +		if (!xfs_has_bigtime(dqp->q_mount))
> +			return __this_address;
> +		if (dqp->q_id == 0)
> +			return __this_address;
> +	}
> +
>  	if (dqp->q_id == 0)
>  		return NULL;
>  
> @@ -1231,14 +1239,6 @@ xfs_qm_dqflush_check(
>  	    !dqp->q_rtb.timer)
>  		return __this_address;
>  
> -	/* bigtime flag should never be set on root dquots */
> -	if (dqp->q_type & XFS_DQTYPE_BIGTIME) {
> -		if (!xfs_has_bigtime(dqp->q_mount))
> -			return __this_address;
> -		if (dqp->q_id == 0)
> -			return __this_address;
> -	}
> -
>  	return NULL;
>  }
>  
> -- 
> 2.43.0
> 
> 
