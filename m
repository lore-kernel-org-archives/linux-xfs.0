Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBA21DFD8;
	Fri, 12 Jul 2024 15:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720798695; cv=none; b=lDPU9UJOF1nsoJXNBb24B/D7+h0gGgFPYEpRJZ4jvY9l8Bn3bWTISy965aU2sl+FN4Monb+4zdy/sPygThO/wxA0LaIJSyA56AlyXR5pvzV5DFT7BHcK2aWmslXlXiEfi4zhw/C4O9SWU14E3bzjuGfeHde2VVCJlKO4i5R/qSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720798695; c=relaxed/simple;
	bh=1KLkBrxJhU94J1oJ8QlEfQxRuaQbC0LvMrk36vYkIPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0WdwgKFE+4j3HtHmKeDMtRk/oC0bzUmsKOWOPJoCbJjTdJmxTYW7GbZuNGbjWWtoPHKOiPoWJJeCcj0M/4gXUxeLDAbOqgVLUju5IvALO8vI6BKIlynZ7UQwXdnvzs840Yyx5DqcUMnJySgTTYacHWnCkWEHwY2PaE7MdLE32M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imgo5Lps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imgo5Lps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B34EC32782;
	Fri, 12 Jul 2024 15:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720798694;
	bh=1KLkBrxJhU94J1oJ8QlEfQxRuaQbC0LvMrk36vYkIPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=imgo5LpsjXPYkgPNt9ON6+HSH4xoNd4sMg//+aWWseds00Hjg6Hb6ZI0BJQXf9wSS
	 kEnFuUxiFkWgDuksvLr2Cq15wwA69wHsD2vGiKSKxDICZJBsF1+a+pok9fIQ1Ps/sn
	 ngXHXMv+De8m+Ivsuojh+1muDwnTdEw3IT66T3SuCQjdT+vUme9lPuMTLZbLsLCWnW
	 2C5Wdd6Aj2+RB0t3vVPEEt/GeopTCyF6yRlrWlRg1BUJXtzeEhgDLdEa7ClRZRMwW7
	 INiYGUIqcYLK8JgoQilr2KZURoEGphUSw4gtmwrU6JqtTnH3kQAc0ADXbMIe58EdCN
	 7Qg6t38scJGUQ==
Date: Fri, 12 Jul 2024 08:38:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Long Li <leo.lilong@huawei.com>
Cc: zlang@redhat.com, linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 1/2] xfs/016: fix test fail when head equal to
 near_end_min
Message-ID: <20240712153814.GT612460@frogsfrogsfrogs>
References: <20240712064716.3385793-1-leo.lilong@huawei.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240712064716.3385793-1-leo.lilong@huawei.com>

On Fri, Jul 12, 2024 at 02:47:15PM +0800, Long Li wrote:
> xfs/016 checks for corruption in the log when it wraps. It looks for a log
> head that is at or above the minimum log size. If the final position of
> the log head equals near_end_min, the test will fail. Under these
> conditions, we should let the test continue.
> 
> Signed-off-by: Long Li <leo.lilong@huawei.com>
> ---
>  tests/xfs/016 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/xfs/016 b/tests/xfs/016
> index 6337bb1f..335a2d61 100755
> --- a/tests/xfs/016
> +++ b/tests/xfs/016
> @@ -239,7 +239,7 @@ while [ $head -lt $near_end_min ]; do
>  	head=$(_log_head)
>  done
>  
> -[ $head -gt $near_end_min -a $head -lt $log_size_bb ] || \
> +[ $head -ge $near_end_min -a $head -lt $log_size_bb ] || \

Heh, that's quite the coincidence!

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>      _fail "!!! unexpected near end log position $head"
>  
>  # Step 4: Try to wrap the log, checking for corruption with each advance.
> -- 
> 2.39.2
> 
> 
