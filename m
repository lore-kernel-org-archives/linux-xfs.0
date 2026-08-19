Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175DC3090CD;
	Wed, 19 Aug 2026 06:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787120663; cv=none; b=hbuuklI/drb+Uc9xij0drHT2X2Pm6oPXHWMyAQ6nWB93NhC4byjklp0tdXGdNMor9q3cSbSO8sXzhjvAgdFsp3UbzKPSWCtD+V4JtthvA1VVY0s2A0/qiO4Ns+II3iuHQZ2BwR8ANO7GzNti+Gvrrm5zYFfQeFehtMueJmIRjoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787120663; c=relaxed/simple;
	bh=QY4KwCBtz5kyrsfvbnUV6qAmoXhqruSNhX/S2QN2qzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SKHAYNGz8NT0rU+GVowfshNeYlqMDzfMUX/GrjVPpHbjuaKofL2ZdpbSIj+0bKOaondwhUnP97mKWOAJk+xYa0tg63nQevUlmw+PPxmUjAgenRrRFXg/xpTozorbf+waesE/eOcw6Y+iFIy3Zos4xHDMrbLSuZIpEk7Weall5jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2OiPQ1N0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2OiPQ1N0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+iWxKeg4D+xiM01ljFocJbjBQ6je/Gz4bMLfcfic/m0=; b=2OiPQ1N0R77pO/f6d5P2LFf5CR
	TzuwT61Yz6klp7JLOakDCildZ5t00gsN7TlCGNolUDp6TTNiZEn/pQ8sAwnNZSi9XMcMxI/f0gIQk
	1AoJMCD/6o8tfHZCSiJd0J2KZyM6RK/q9lhYjHePNXcnmKB+MH1AvZqHuUG4kA6ai45tPwc6yp7IE
	hra4W4e8ATnu9HkdmNGG1HiONi4D7VE1WrTOGZYp/no7Q+hFPcpta+ENJRrOzIj40DyCSDUzc5LG0
	c4671FeAb8C0qrq58waNHECSrxGLpiZIbedHWLYdClOJK3wMyFitOwaBjQAa8YEMfXT39ru2r0ezD
	Bew/fhuw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wwZin-0000000961i-2GQx;
	Wed, 19 Aug 2026 06:24:21 +0000
Date: Tue, 18 Aug 2026 23:24:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: don't modify file attributes or poke fsnotify
 for dry runs
Message-ID: <aoVMFaHJoBl-xYAb@infradead.org>
References: <178659861838.833922.2269351780488724470.stgit@frogsfrogsfrogs>
 <178659861983.833922.10991178975977666480.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178659861983.833922.10991178975977666480.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 12, 2026 at 10:26:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that a dry run shouldn't poke fsnotify because we don't
> actually change the files.  I noticed that we also shouldn't be removing
> file privileges when doing a dry run.

> +++ b/fs/xfs/xfs_exchrange.c
> @@ -701,6 +701,9 @@ xfs_exchrange_contents(
>  	if (error)
>  		goto out_unlock;
>  
> +	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
> +		goto out_unlock;
> +
>  	/*
>  	 * Finish the exchange by removing special file privileges like any
>  	 * other file write would do.  This may involve turning on support for

This just skip removing the privileges.  I guess the commit mentions
this on the side, but this is probably the important part, so my
emphasis it?  It would also seem easier to move the check into
xfs_exchange_range_finish next to the code that it guards.

> @@ -783,6 +786,9 @@ xfs_exchange_range(
>  	if (ret)
>  		return ret;
>  
> +	if (fxr->flags & XFS_EXCHANGE_RANGE_DRY_RUN)
> +		return 0;
> +
>  	fsnotify_modify(fxr->file1);
>  	if (fxr->file2 != fxr->file1)
>  		fsnotify_modify(fxr->file2);

Move the fsnotify calls into an if statement instead of the
early return?

