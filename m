Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49F633DB;
	Sat, 15 Mar 2025 18:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742063435; cv=none; b=HcV9IrlJ4bGkrnLWbMM2PZGEnrQO+NQ6Z36QCvl1OZRmW0D6E83Mdl5hReJxYDNU7tEcXxCX7NRKmezhEwUtNXozSfeTeCfJ/tlVbjg0SlMW+mRZmCbgMZz6ysDfyiLtkOovkCpzrdkxdD3oZET5QDLEwjnLNMYKut2BQTOkm4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742063435; c=relaxed/simple;
	bh=n0VZr42FD5sIJ161uouF9eSw//32TJ5ZIYjRsCS9nkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KDA9+joGf+aCCZAr5gUGmbDH9GLrbwIjqN6KE0eP1TqqCG7uIAi9dVJQYzEBTaEDpOZoNiUplftEtsMiO+23kcoHrIUTw+FlMYHKH8N8Psw81il442eDHsq4WOoudvpDp7wiyunWELxM1zixkxzxjczH7r9vOG1d88+VfOFw5ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TEku9Lf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TEku9Lf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34C4C4CEE5;
	Sat, 15 Mar 2025 18:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742063435;
	bh=n0VZr42FD5sIJ161uouF9eSw//32TJ5ZIYjRsCS9nkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TEku9Lf7PVEsgamRVNhDlXlC5UHh9MO0CMQUrrt+EFkmqs0kZBpJlXGZctr1qeqap
	 LMkdSzBNTMNBa3wJOU4Nrx3yofjxOB4iDo9Lg0yQ5sRhE+EM2snVwq00iry6upRHIS
	 gsez3De5kyhUpdRLOv4HcM/Ml1V59cwMN6w6TqEeUEhGeqHtDNeKNMlWalX2rB3C4t
	 S3rO7eJObbPZUPfRbjXoEO7dwSGXn5dHEYTZ5J1t//Hjmq8D+HG3j+8yYWtVMRc5rg
	 x0Chxz7923mXHhIQbcSpIxgbNoqYwkJSlC5wLIB47hwtgl47k1CH4VP0nNdcuadgNd
	 vYtIkyklbz+pQ==
Date: Sat, 15 Mar 2025 11:30:35 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: long.yunjian@zte.com.cn
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	mou.yi@zte.com.cn, zhang.xianwei8@zte.com.cn,
	ouyang.maochun@zte.com.cn, jiang.xuexin@zte.com.cn,
	lv.mengzhao@zte.com.cn, xu.lifeng1@zte.com.cn,
	yang.yang29@zte.com.cn
Subject: Re: [PATCH v2] xfs: Fix spelling mistake "drity" -> "dirty"
Message-ID: <20250315183035.GA2803749@frogsfrogsfrogs>
References: <20250315143216175uf7xlZ4jkOfP5o3oxuM4z@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250315143216175uf7xlZ4jkOfP5o3oxuM4z@zte.com.cn>

On Sat, Mar 15, 2025 at 02:32:16PM +0800, long.yunjian@zte.com.cn wrote:
> From: Zhang Xianwei <zhang.xianwei8@zte.com.cn>
> 
> There is a spelling mistake in fs/xfs/xfs_log.c. Fix it.
> 
> Signed-off-by: Zhang Xianwei <zhang.xianwei8@zte.com.cn>

Looks ok,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> v1 -> v2
> fix the format of this patch
>  fs/xfs/xfs_log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f8851ff835de..ba700785759a 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2887,7 +2887,7 @@ xlog_force_and_check_iclog(
>   *
>   *	1. the current iclog is active and has no data; the previous iclog
>   *		is in the active or dirty state.
> - *	2. the current iclog is drity, and the previous iclog is in the
> + *	2. the current iclog is dirty, and the previous iclog is in the
>   *		active or dirty state.
>   *
>   * We may sleep if:
> -- 
> 2.27.0
> 
