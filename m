Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B2130274D;
	Thu, 15 Oct 2026 14:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075089; cv=none; b=M4GGDgrP6XvZxSG8ekre+1NJmYMvKddTMLk6QD+RyRVHopyQlvb6OckDoP+4Gy6nVlY290mZeWHdhGWrOlkA7U+UdKbN3TiNvMgvW/9dpvF80+7iRN6ZCbuFL0skTRLQzgDFNWxddDZqD7uJWpaE6ZC1xZj/57HCIn9EZv8o5VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075089; c=relaxed/simple;
	bh=RHMdOPbRXNN/vnIf1OyuOt1EVeisCNeiyQ97BSqvj1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PY/B6xCbDpRDQd74hTfjKkXFv0ldE1BQ9lekCk4h+n6Fk95awoySr9c1kipZ/ZBFKJm8sxymzKwvwu8NhRPc7rS/s9uQk8NlsyTF2q/1JdGs0ViNjItdDWvq4/AOaq9uRRQxuKEHh06mO5sFsPu+LZL+ylJ9ihu8+HVudYMggnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RJ8aEj8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RJ8aEj8Y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 850281F000C4;
	Thu, 15 Oct 2026 14:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075087;
	bh=tNDJWGJTpeF7yeDPvV10PQ4IQPwZQsBesVCOPEnYuxU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RJ8aEj8Yejha5/g5/reSgJ1SmNWZSTQsYcGlcn9e2sZGFvlpowmk56YbvjiCgNb9k
	 W9a3OJtNOgNv6ppz9P/lF0fUteicwmaX36CSQZ9TKcGEyQmUvjpJXgaBjV7VVdW11f
	 75JwUBCsnC7/31JLmHAYk3tEp8rHuq/J1V4Hvf7F6oDt/cFJYcWwQ4v/64PpqgsxF7
	 586SoDfuXRA8E0VaYLHeSM+BpLOs0h+T8ncls5bFs7y6hQgGvoFeQ7MSwZEYTTzjXQ
	 vvnW9HFK/HtuCHMZX0H2uljRFchsBnxjHzyr3OFPeUrUZG7dDhnT1b5+m7JkHWZeKU
	 pOv+5X5AJajDg==
Date: Thu, 15 Oct 2026 07:38:07 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Binbin Deng <18983559317@163.com>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v1] xfs: set healthmon mount cookie before publishing it
Message-ID: <20261015143807.GN2705364@frogsfrogsfrogs>
References: <20261015080225.45215-1-18983559317@163.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015080225.45215-1-18983559317@163.com>

On Thu, Oct 15, 2026 at 04:02:25PM +0800, Binbin Deng wrote:
> xfs_ioc_health_monitor() allocates the healthmon object with kzalloc(), so
> mount_cookie starts as zero.  zero is also DETACHED_MOUNT_COOKIE, but
> xfs_healthmon_attach() publishes hm through mp->m_healthmon before storing
> the mount cookie.  A concurrent reporter can therefore acquire hm from
> xfs_healthmon_get(), see the detached cookie in xfs_healthmon_push(), and
> drop the event even though the monitor is being attached.
> 
> This is reachable by racing XFS_IOC_HEALTH_MONITOR with an operation
> that reports a health event, such as a filesystem shutdown.  Initialize
> the mount cookie before making hm visible through the RCU pointer so
> reporters always observe an attached monitor.
> 
> Found during a static-analysis-assisted audit: candidate sites were
> surfaced by a Coccinelle rule, and the reader/writer paths were
> confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
> not observed at runtime; it is identified by code inspection only.
> 
> Fixes: a48373e7d35a ("xfs: start creating infrastructure for health monitoring")
> Cc: stable@vger.kernel.org

Cc: <stable@vger.kernel.org> # v7.0

> Signed-off-by: Binbin Deng <18983559317@163.com>

Yes, we should set the mount cookie before exposing hm to the world.
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_healthmon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
> index 2bdd747f1ead..05d6f0494139 100644
> --- a/fs/xfs/xfs_healthmon.c
> +++ b/fs/xfs/xfs_healthmon.c
> @@ -114,8 +114,8 @@ xfs_healthmon_attach(
>  	}
>  
>  	refcount_inc(&hm->ref);
> -	rcu_assign_pointer(mp->m_healthmon, hm);
>  	hm->mount_cookie = (uintptr_t)mp->m_super;
> +	rcu_assign_pointer(mp->m_healthmon, hm);
>  	spin_unlock(&xfs_healthmon_lock);
>  
>  	return 0;
> -- 
> 2.43.0
> 
> 
