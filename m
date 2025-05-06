Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C17A223DF8
	for <linux-xfs@vger.kernel.org>; Tue,  6 May 2025 04:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746507523; cv=none; b=ThFQZ8iiIph1AC+GCKbL/4x/WqsbixyW7MQYuadxihiueSSjf0TOqsP1zv8Q7MG4/qiudgIllMlxnRdGlS//zxI53DQobXsN55lNpTnJUZ6BxOyTCdVIWAuyfMUDi+akTFhGfucFwSo5RVojeq+0T5a70qWhjw0N6nmX8bjzl2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746507523; c=relaxed/simple;
	bh=QElOfhtMCIYJsqy6J5WGZIDjcfIRYxkHw4J7UkkJBhw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EPkn301IH5rtrTzCsJtu41M+m4YuJWwoval+fRmFhZiLwU7Y3H4WQQJngU/WaZqeevHeTJTtQhDzAghwJQGWkBdZ/bWP92mj/wUNt0mUhcZEk6/qWt9ylYjuDxFf+ZbWZljAPL6dh2qGqTNVuHv4C6qRjmnZHnwrSdFLoOhP9Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HD6/ywbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HD6/ywbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F242DC4CEE4;
	Tue,  6 May 2025 04:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746507523;
	bh=QElOfhtMCIYJsqy6J5WGZIDjcfIRYxkHw4J7UkkJBhw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HD6/ywbcCXP8yMjDWzNOwqLFAUtFepnqWH/RK+AiGHhIaYEIpA20PkYu87IHpaJcv
	 wCItcXyYyWLtT34X2uAmtwdaT6gaF1XFOQTzL1cbWFU5OQEJJNCTjcKgF6jcA7jDaP
	 hwItVOi7zAFGYz6D5s+curjftYHLks4CyKPMh+vtde5p2l4UL2I0oemuMQYzAZ8gQa
	 rqgEGIj/a5Iss/SKPgmZShzuB0/71XnvRFjpL4n2Xfnd1TxxlEjAHfQG5+atVTBLfU
	 Cmyn5lw+4JJNITHl9ZBySB+3VM+M5BjmNpKlq/vkekdRx1KwrRYU5Vuf/44an9Ma6J
	 T9ZG+2yHRtdxg==
Date: Mon, 5 May 2025 21:58:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Wengang Wang <wen.gang.wang@oracle.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: free up mp->m_free[0].count in error case
Message-ID: <20250506045842.GC25675@frogsfrogsfrogs>
References: <20250505233549.93974-1-wen.gang.wang@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250505233549.93974-1-wen.gang.wang@oracle.com>

On Mon, May 05, 2025 at 04:35:49PM -0700, Wengang Wang wrote:
> In xfs_init_percpu_counters(), memory for mp->m_free[0].count wasn't freed
> in error case. Free it up in this patch.
> 
> Signed-off-by: Wengang Wang <wen.gang.wang@oracle.com>

Yeah, that looks like a leak.

Fixes: 712bae96631852 ("xfs: generalize the freespace and reserved blocks handling")
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b2dd0c0bf509..3be041647ec1 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1149,7 +1149,7 @@ xfs_init_percpu_counters(
>  	return 0;
>  
>  free_freecounters:
> -	while (--i > 0)
> +	while (--i >= 0)
>  		percpu_counter_destroy(&mp->m_free[i].count);
>  	percpu_counter_destroy(&mp->m_delalloc_rtextents);
>  free_delalloc:
> -- 
> 2.39.5 (Apple Git-154)
> 
> 
