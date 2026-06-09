Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C0738E5D7
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2026 14:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781016897; cv=none; b=bRl2wQvVHb1g6z1Da0nppmNQ1C6K5Lle8xy3tgOqBSNz4YqINXX19YHexv8btEo6l4m+tiLQbOrCZn9ekG4sZVu6j1Yj012lUrUmpJ5fQ9bjf+5HeiOfdmkmScm1YnzUSAnichERw/CpLjH1eY8gxoa8mx7uPIfeUU+6aexG0XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781016897; c=relaxed/simple;
	bh=KNk+ctisNNRXjP6urHKBoBVQwP4hB/07eogjqx9hsX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N1VEeMD6a4othxKNe6w0O7R90bi0R6/V+uRqRGih05InkFIliDgwOUhJOLm6jp4dKIUuX7QJgO94kPq/jJrsyLx3IT8MrKqvwkNeddsptkr6K6NykEABnzia6ylyYjCpVw0gvAtP+qzaVZMvd0WXso5mmexF5kTCZlVpEvWs+bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cLW4kKgi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cLW4kKgi"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EE1851F00893;
	Tue,  9 Jun 2026 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781016895;
	bh=Ru2bBGae0GDqDvKTMY8KW8E9bT8zcAEYGp6pzdIlbjg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cLW4kKgi2Dr7iJkzsi3ZHgTk0UKFJQheG5zvZdDeABBA+e7vmL+/0pLp342968f1B
	 Mj77UBwopM+4KgSTDQ/Kd7AjYoI8qT8jmth7UF3VNiRvMaPUewhEteHuNczavKUjjG
	 0aMFkYOe+XnVX54QVCbl50T/CHRbn4BUEkB9SXsrJDIdqsV42ANCJuM7QN6XkzGD5y
	 5cwtb6VWp1aqjJSVoFKGkV52WfbPHs4g52Yxdp9wzkHYAEXZpinIjca/1H3Fu9w+MO
	 pwwYrmZjvuMyi5Gp8BcceGjubVQVb+9n2GAbNW+6Mr3OcB8UbFYHIfTbYT6Qc0dlpU
	 wwGWvAklAifpA==
Date: Tue, 9 Jun 2026 07:54:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: account newly added RTGs as free zones in growfs
Message-ID: <20260609145454.GA6078@frogsfrogsfrogs>
References: <20260609075655.1698743-1-hch@lst.de>
 <20260609075655.1698743-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260609075655.1698743-3-hch@lst.de>

On Tue, Jun 09, 2026 at 09:56:42AM +0200, Christoph Hellwig wrote:
> When growing a zoned RT section, the newly added RTGs also need to be
> tagged as free in the radix tree and add to the nr_free_zones counters.
> Call xfs_add_free_zone to do that, otherwise using up the newly added
> space will wait for free zones forever.
> 
> Fixes: 01b71e64bb87 ("xfs: support growfs on zoned file systems")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Good catch; glad there's a new fstest for it.

Cc: <stable@vger.kernel.org> # v6.15
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_rtalloc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index 153f3c378f9f..fd07c1a18615 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -933,6 +933,7 @@ xfs_growfs_rt_zoned(
>  	mp->m_features |= XFS_FEAT_REALTIME;
>  	xfs_rtrmapbt_compute_maxlevels(mp);
>  	xfs_rtrefcountbt_compute_maxlevels(mp);
> +	xfs_add_free_zone(rtg);
>  	xfs_zoned_add_available(mp, freed_rtx);
>  out_free:
>  	kfree(nmp);
> -- 
> 2.53.0
> 
> 
