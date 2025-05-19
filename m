Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABBA284B5B;
	Mon, 19 May 2025 15:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747667335; cv=none; b=kVp8oC/Olmljnpy07f0zRaWnIv2ekpRwLqjJLqxfWTZYRUPRQST15I07Looia3JhC3ZL1Q2LhsF66BirTdKIY4nfFdYOH89de0/nlmOUJTMOaYz3G6tKKsr4UFOxduX/6qZWAsa/q7MUfAU+9TaoN6v1cEJya9n0B367yBIVVwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747667335; c=relaxed/simple;
	bh=odbA1yE0koqxZpsOmdJo0+7/jyyMyxWVwF9ryDV5+Zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgHba/+TV6pAJQAuTj8vNb4XQXU08t12NlVyF76fjGtcnaIrR4rGY01KmVp4WI3HKQQj95ygMETWEmxmHnKGFridBD8rNcee52qAqgvxqPsEZlmyLGb6sq5fKACLiJVmvSOkwaP6GmQp7NIGEPNmfJ+WIxvrLPMShJSpOzC9KI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RV/GkRNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RV/GkRNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FCEC4CEEF;
	Mon, 19 May 2025 15:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747667335;
	bh=odbA1yE0koqxZpsOmdJo0+7/jyyMyxWVwF9ryDV5+Zc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RV/GkRNUdHIRjUPbzrpF27OhxaK2xNzjgkFOvBOUixbK0sW/lLC4SpFMlZK+SxNdz
	 YNlgzf+GsRHI/OL8iLz+u0dI8CAxFUmUj0pQNFMpxA3pzHsaOk65tzjNzBnAD3QZVe
	 yb3I+xQO+k1bveK28HCfIXo7p+5gL/AIo7FMEoyLzzX9hOtEygC4ZS/J6MHc+XqUBa
	 GPtXrCMJQXxuQAZ5c1+Gmib2hpFUa+knSO5P+xRkv4nEDIQomq3iWUhtPziSPDRwt+
	 50iHCSPV8KDCdSXXTaEHhwfRpjhEaOQbMm2gEUOutFbrjiOM+eV/fqCv5Ml5TWaxtU
	 gT9KCv1phPvDQ==
Date: Mon, 19 May 2025 08:08:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zizhi Wo <wozizhi@huawei.com>
Cc: cem@kernel.org, dchinner@redhat.com, osandov@fb.com,
	john.g.garry@oracle.com, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, yangerkun@huawei.com,
	leo.lilong@huawei.com
Subject: Re: [PATCH] xfs: Remove unnecessary checks in functions related to
 xfs_fsmap
Message-ID: <20250519150854.GB9705@frogsfrogsfrogs>
References: <20250517074341.3841468-1-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250517074341.3841468-1-wozizhi@huawei.com>

On Sat, May 17, 2025 at 03:43:41PM +0800, Zizhi Wo wrote:
> From: Zizhi Wo <wozizhi@huaweicloud.com>
> 
> In __xfs_getfsmap_datadev(), if "pag_agno(pag) == end_ag", we don't need
> to check the result of query_fn(), because there won't be another iteration
> of the loop anyway. Also, both before and after the change, info->group
> will eventually be set to NULL and the reference count of xfs_group will
> also be decremented before exiting the iteration.
> 
> The same logic applies to other similar functions as well, so related
> cleanup operations are performed together.
> 
> Signed-off-by: Zizhi Wo <wozizhi@huaweicloud.com>
> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> ---
>  fs/xfs/xfs_fsmap.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index 414b27a86458..792282aa8a29 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -579,8 +579,6 @@ __xfs_getfsmap_datadev(
>  		if (pag_agno(pag) == end_ag) {
>  			info->last = true;
>  			error = query_fn(tp, info, &bt_cur, priv);
> -			if (error)
> -				break;

Removing these statements make the error path harder to follow.  Before,
it was explicit that an error breaks out of the loop body.  Now you have
to look upwards to the while loop conditional and reason about what
xfs_perag_next_range does when pag-> agno == end_ag to determine that
the loop terminates.

This also leaves a tripping point for anyone who wants to add another
statement into this here if body because now they have to recognize that
they need to re-add the "if (error) break;" statements that you're now
taking out.

You also don't claim any reduction in generated machine code size or
execution speed, which means all the programmers end up having to
perform extra reasoning when reading this code for ... what?  Zero gain?

Please stop sending overly narrowly focused "optimizations" that make
life harder for all of us.

NAK.

--D

>  		}
>  		info->group = NULL;
>  	}
> @@ -813,8 +811,6 @@ xfs_getfsmap_rtdev_rtbitmap(
>  			info->last = true;
>  			error = xfs_getfsmap_rtdev_rtbitmap_helper(rtg, tp,
>  					&ahigh, info);
> -			if (error)
> -				break;
>  		}
>  
>  		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
> @@ -1018,8 +1014,6 @@ xfs_getfsmap_rtdev_rmapbt(
>  			info->last = true;
>  			error = xfs_getfsmap_rtdev_rmapbt_helper(bt_cur,
>  					&info->high, info);
> -			if (error)
> -				break;
>  		}
>  		info->group = NULL;
>  	}
> -- 
> 2.39.2
> 
> 
