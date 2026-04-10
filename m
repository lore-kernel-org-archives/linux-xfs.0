Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336EA3DCDB1;
	Fri, 10 Apr 2026 16:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775839356; cv=none; b=ZT2lyXUe4p4nsR2zRcOUwQLfe4+zXvgfqF5BPB+MaPehyDBif8uTj8Q33RCP4ylUyhpw2K7xxT3CXSBxNklWRPo42QQ2GW46PfQ4q1gNjatcSHuKPqIT0coCEuk/KgS367rvMx7g4JmiWDtZBc9qKvcWHWfMxxV8drcWW/J/NEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775839356; c=relaxed/simple;
	bh=lGkDMWFw8Z9icQ4EnkIhMEjsH0TiPsXqdmPEv46tc8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQwSmd3HrN9LokwskyC0r1Gf6JPHB/vZWms4HYT2AiwxXOriG1DjwBizSuha72lzW/VWUB6Hyq7l4yw4D/ZZYh3QWtSC2mcZKqN1887ZuKmAHH5hy7OUHKXks2MYa5Ujp9bckhQLuqq6V0mEGXnkn6fS6LIzplZwvolb3LjFyrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4RzhOvT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4RzhOvT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2BAC19421;
	Fri, 10 Apr 2026 16:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775839355;
	bh=lGkDMWFw8Z9icQ4EnkIhMEjsH0TiPsXqdmPEv46tc8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a4RzhOvTXEbiiW+vJSfPZhpCkdyekIZ2Rpslt35MFLoj2np2cZl4w6yQgaDsv3jWT
	 4V7PnF4Smya+sy/1zecciTwsjqnf+hd3XuraTHK8oU5xy5YQ0dLu+B6JLVgVZY5CYW
	 BmlxMaGHX6DOM0KYLMh7SQdhklvn3oEJ3gwVDbu9E4cMiFCRNl5zY+vsHLhIMUn54Y
	 FM/zLnD6L0JSeoipnUNgeTVcUgXzF1Mxi9zhL8FBJBGUHl8oa+AO6HISXFuEWuiYwR
	 DZnB4uP97CTibnzuhRLr30wbtApEZWv6HQMfYWcAL7r1bxB9BBl5KkyPr6u6x0cS7x
	 et3D7rV5ggcOQ==
Date: Fri, 10 Apr 2026 09:42:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: alexjlzheng@gmail.com
Cc: cem@kernel.org, kees@kernel.org, alexjlzheng@tencent.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the meaningless XFS_ALLOC_FLAG_FREEING
Message-ID: <20260410164235.GT6254@frogsfrogsfrogs>
References: <20260410101106.2523665-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410101106.2523665-1-alexjlzheng@tencent.com>

On Fri, Apr 10, 2026 at 06:11:06PM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> In xfs_refcount_finish_one(), there's no need to pass
> XFS_ALLOC_FLAG_FREEING to xfs_alloc_read_agf().
> 
> So remove it.
> 
> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_refcount.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
> index 40c7f0ff6cf3..0ec6ccd8b4dc 100644
> --- a/fs/xfs/libxfs/xfs_refcount.c
> +++ b/fs/xfs/libxfs/xfs_refcount.c
> @@ -1414,8 +1414,7 @@ xfs_refcount_finish_one(
>  	if (rcur == NULL) {
>  		struct xfs_perag	*pag = to_perag(ri->ri_group);
>  
> -		error = xfs_alloc_read_agf(pag, tp,
> -				XFS_ALLOC_FLAG_FREEING, &agbp);
> +		error = xfs_alloc_read_agf(pag, tp, 0, &agbp);
>  		if (error)
>  			return error;
>  
> -- 
> 2.49.0
> 
