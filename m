Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D02F402448;
	Tue, 26 May 2026 14:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779807233; cv=none; b=HNXq2TONAnvFItYiz73ZyqMGScFXgl1lET4OhbMhxkS9e5uQxd0L4qXUqM3qxAJ3WpzX999ocRKJ923fBSbjiiS/yS2nGYsiTzVVthR6px7L/697Isn3URmh7/lbmAzZvBGuqT/zlZes16ghvX+6S9crHwZLe2L1GPQUuW/Dgb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779807233; c=relaxed/simple;
	bh=bFtd3jI+Wd4FnmnroVOoO/xRfa3eqqObSPvil8NLI80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UtXwM5O1ax7NypfKlyTFws8ZspuG7hWjeiAw20Jh4qaKOlq66f7+uOZUmIoYd7O7pplnlUZghy+LmNhGzIbH/itHbBTWg7TR1GlwzurT9nVFA2MyRs77iJanw/pyqco7LiG0YdPt5dmQkNOh5IObQO0i/a0lWi7Zhhr7h0WnC1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O0X2okWA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O0X2okWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41041F000E9;
	Tue, 26 May 2026 14:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779807232;
	bh=50m+ukftv0VYRbpeZJbDQbP9W6hgAOLsjBFXUN4+Rc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O0X2okWAsirjN6DdsCXCjVAtR8lMaQpSYJJw9gThgr3m4hAmscBjYKh887yRSPGf2
	 5Sj/QcjmC8QY0EOlmVBL5RwBLuFyUg18YxcPsgydfY/abEkzLLxL8Vm0i4PkcGEqDX
	 4p7EE9ukuWHlsNxw9scibC7GwZgYODIZY3OdwsVXF2ReyC0HM9i4crx6SWAycWZejl
	 DrU4KUXTOQaSDUY+/EUGK4LLZyDY2D2I8C0EumoGcCE2jPk3KdGNJK/T+GlOOSqpak
	 21qctonrBCVGGfqJDm913fL+TYTI+LgnASmhDmW6sCySRM+F8LDFH0kxjTRJjLUG8l
	 d/8dll70NCMiw==
Date: Tue, 26 May 2026 16:53:48 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Yingjie Gao <gaoyingjie@uniontech.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: fix rtgroup cleanup in CoW fork repair
Message-ID: <ahWzvgOLcXKTLyPq@nidhogg.toxiclabs.cc>
References: <20260526123243.1078867-1-gaoyingjie@uniontech.com>
 <20260526123243.1078867-3-gaoyingjie@uniontech.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526123243.1078867-3-gaoyingjie@uniontech.com>

On Tue, May 26, 2026 at 08:32:43PM +0800, Yingjie Gao wrote:
> The realtime CoW fork repair scan initializes scrub rtgroup state
> before it checks whether the whole mapping should be rebuilt.  That
> state includes realtime btree cursors, rtgroup locks, and an extra
> sr->rtg reference.
> 
> If marking the full mapping fails in the force-rebuild path, the code
> jumps directly to out_rtg.  That only drops the local rtgroup reference
> and skips the scrub rtgroup cleanup, leaving the cursors, lock, and
> sr->rtg reference behind.
> 
> Jump to out_sr instead so this error path matches the other failures
> after xrep_rtgroup_init().
> 
> Fixes: fd97fe111208 ("xfs: fix CoW forks for realtime files")
> Signed-off-by: Yingjie Gao <gaoyingjie@uniontech.com>
> ---
>  fs/xfs/scrub/cow_repair.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
> index bc3838bac71a..bff25cf74e29 100644
> --- a/fs/xfs/scrub/cow_repair.c
> +++ b/fs/xfs/scrub/cow_repair.c
> @@ -389,7 +389,7 @@ xrep_cow_find_bad_rt(
>  		error = xrep_cow_mark_file_range(xc, xc->irec.br_startblock,
>  				xc->irec.br_blockcount);
>  		if (error)
> -			goto out_rtg;
> +			goto out_sr;

Ditto for this patch.

>  	}
>  
>  out_sr:
> -- 
> 2.20.1
> 
> 
