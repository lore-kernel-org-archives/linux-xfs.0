Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D835334695
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 14:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783607232; cv=none; b=iCO7aUSOEBWW/14ed4LcLyeXViBepsdJdbnxRcOt2ywIdLoA+fF3lXShKtj4OVq5uwDZoJkKBDCSQNZp6MUqyjmS5F/TzPIThQ+YnKq4Ocyz00h5uykMWTq5XKQWeFgojZNaO9RanbGE21HHIqCzMHbisIzWMvIJDVn4MzT2NOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783607232; c=relaxed/simple;
	bh=X7WeH//8dMiza6Blz6nShOM6Nu2GA3iCsR/wiICQ7LA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VvO5L7CJE7CJxmz/Sy3ZVjSrHEgztE6pI0VbRx9GeDjRJal3aW0BThfh8Dg+GHpTnK0fP3/8ePLBT8pxFxHrxpK69cPkLq1vjLqkHGayMIVq8WNE8TaEuruV83H6y8dHsCUuzcxbLK9LC5p4DELpPuyi6cnqoGZkL5hb/d2dWfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlhdugUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlhdugUg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8F3F61F000E9;
	Thu,  9 Jul 2026 14:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783607230;
	bh=tU5eEKsBMN50TR5QSGoCml8387GxB0TZeKrY66Ebjv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HlhdugUgB/XKf3FClovOEN1/76MayzdeylWSZ44eFnpjp1nQVZLjQKCJ0xHVEy+Z5
	 TomRIFmhR2AEdXnklaM5Ln03taRqK+dgm15a0fbAU9MJUdhXZe8D0r4DaixFwJ0OxY
	 81MzZw9PATr5FD+gCTk3jC4txWdCSbJwMLEpYJjGsq2KaQ6IplZdIQb09isO3VzX+J
	 T2i7FWYaenHpPRkub16x8BRS7tUm2CBvTnrZXevbe7OevcTkvJ9MBNRIk1GDeLge7X
	 q5b4SCWG+BzZ0MLvpmtDoVUW3pUN5AE4jCm/17m3Z6xZ74pFeG71HkHbghcfN9gpda
	 HxAnxhcLtjqoA==
Date: Thu, 9 Jul 2026 07:27:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org
Subject: Re: [PATCH] xfs: fix null pointer dereference in tracepoint
Message-ID: <20260709142709.GB15210@frogsfrogsfrogs>
References: <20260709094116.2025306-1-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709094116.2025306-1-aalbersh@kernel.org>

On Thu, Jul 09, 2026 at 11:41:16AM +0200, Andrey Albershteyn wrote:
> If dfp is not NULL we exit early here, when dfp is NULL it's allocated
> in xfs_defer_alloc() but not assigned. The tracepoint tries to
> dereference members of dfp struct.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>

Heh, I have a patch just like this too!  Please add:

Cc: <stable@vger.kernel.org> # v6.8
Fixes: 3f3cec031099c3 ("xfs: force small EFIs for reaping btree extents")
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_defer.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index c6909716b041..89501e8bd2f8 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -878,7 +878,7 @@ xfs_defer_add_barrier(
>  	if (dfp)
>  		return;
>  
> -	xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
> +	dfp = xfs_defer_alloc(&tp->t_dfops, &xfs_barrier_defer_type);
>  
>  	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
>  }
> -- 
> 2.54.0
> 
> 
