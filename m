Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F997E76D;
	Tue, 26 Nov 2024 05:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732599723; cv=none; b=OqK9E3M4zfIme993VlGw4VTjLinW74dIdaShOpD5MIjy8EicvyJQO0V+x+SeF/ISQEG6xIsSxZx8AePAG/c27z76MwAg/g9q7lGMzH5xvHsSjBRvCuB9Yvutf7Irvr9Cfe+giU9BbJwHC+SEtZe6iif/SI2GRB0PEmMwTV1oSxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732599723; c=relaxed/simple;
	bh=IVGnr7k0q7pdXldrzXw0Q0PhMzDRdGzfV3lKIp+a+Vs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BLqeLybAlecliGFVv1iWsuHL9/fN8ZZvNMnJuL3bmEBb7TUD8MqiOs6DPGlwbhjsfPjWjKholHo7rfFOIp9FIRIL7FxqJ+IZFgB0sMY0P/KSyAb+lahiF17R/B6QkFu1DIFY1EZuzowSkNZFtnd1znGI7SkvUhxKxMRTFkOscKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nGL5s05H; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nGL5s05H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=B7qBF9KnC0fqwlljZJedn+Yv9YFdAyI9xC8RHX7xaCk=; b=nGL5s05HIu6LMTCkMrPhnFLmXE
	KkKsY3WXTZlvwU73quomamHCVAlki9CxuKPzlsvdmRSVfePze6RgShK0OnX6UPJQ1RoGxYzWub3q1
	MKmy+UCT1bRRatCfkCuZQBiF8Wtuy/JYmHFT0wrjgfHgrbG6vcUHgXlid7b6KwFM0zZckp+VqwSIw
	3FJWQfkhRmZlBl4hS3OqgZIlVyj2IWOncHMs3opb2quJP2IIeyUqGpKlYhRaOoaHRQKEEJj4P2dyZ
	Bqim3rtEes5/YRn3V9qS+tmWLsqgheihc+FGCD6DTS5pijV/4y/5xeQajMrJ7fb/rtd8urj9DdkPy
	/Xlh3FmA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tFoKn-00000009gho-3LxN;
	Tue, 26 Nov 2024 05:42:01 +0000
Date: Mon, 25 Nov 2024 21:42:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/21] xfs: attach dquot buffer to dquot log item buffer
Message-ID: <Z0VfqfmpQXYxZqdb@infradead.org>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
 <173258398142.4032920.11501045442848686733.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173258398142.4032920.11501045442848686733.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 25, 2024 at 05:29:55PM -0800, Darrick J. Wong wrote:
> +	spin_lock(&qlip->qli_lock);
> +	if (qlip->qli_item.li_buf) {
> +		bp = qlip->qli_item.li_buf;
> +		qlip->qli_item.li_buf = NULL;
> +	}
> +	spin_unlock(&qlip->qli_lock);
> +	if (bp)
> +		xfs_buf_rele(bp);

> +	spin_lock(&qlip->qli_lock);
> +	if (!qlip->qli_dirty) {
> +		bp = lip->li_buf;
> +		lip->li_buf = NULL;
> +	}
> +	spin_unlock(&qlip->qli_lock);
> +	if (bp)
> +		xfs_buf_rele(bp);

Should this move into a common helper and always use either the
buf or dirty check instead of mixing them?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
