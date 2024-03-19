Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5DD5EE8D
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 22:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710888844; cv=none; b=og3zebNAurvHeMEbiEJQeeIu3oAVfqyf2+CPO2P3ZRLFXWivch/FckCuKJiThQdQ7X3/kPynvirmL6h6UyBiuWBd5/9x6xaa0wgFnjwekBKdtaC1RR4E4h5JD5R7mmrqXrok324sYSkzQAphZ2mOxmSJSv07d+qXgBwDQHUgCnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710888844; c=relaxed/simple;
	bh=E9jcPNKeocEjhqG33uGab+BmKe0DslE4IV7cMk4Uah4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZT8xEcQXXpkJV9dYIJZq55Dl8w2YXDi7qIlUV3zT0ebz5bZYBPo4ggIbL87vMm7VLn28BrY2aSjnBuVEH/vlNzbqZVMM1gHfqsu6ToQYWR35v8Rd+7HVFEQehCjGl54CDjgiVmrmt48YmxZVckLB/fMdNjaWAWyIAmONkd1Lc5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1+kI/aC9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1+kI/aC9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=69eQkDuRVMF/MwVB4i01N/HavuFYuQMm3YnTyTGHduw=; b=1+kI/aC986XGucnwrpvLJ/PJy6
	COTlc5xKJ/asr83++iCv+B//uM0S45UqsrmQLIzm/272NFub7xo8qidpyCcMVdTLKrfifn5wZZW1c
	+8tuyfAE2806FLMocLyRZxjYfrW6bhYI4OKk5TR/ZjgMSWJdr9kKyQJXn/DbuPRhX9jHM3Z9fBX/0
	fcGBme4IC55icm0+h97k2VO7IFUpOhLPviHbYhvbYG8fyMSoIMEX3ekC2ydWRvoq6Pk8UT9djj2tL
	FB3yPftoVZoT4VO/peVvQtEEePbnMB+Q/q5JimqSou9c0ZMKSR8I+3ggHbR3/SFNaVQjMjuBuBIfE
	RQvbAshg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmiLK-0000000EWf7-0uJX;
	Tue, 19 Mar 2024 22:54:02 +0000
Date: Tue, 19 Mar 2024 15:54:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: detect partial buffer recovery operations
Message-ID: <ZfoXihIirJ1PZrs5@infradead.org>
References: <20240319021547.3483050-1-david@fromorbit.com>
 <20240319021547.3483050-5-david@fromorbit.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319021547.3483050-5-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +static bool
> +xlog_recovery_is_dir_buf(
> +	struct xfs_buf_log_format	*buf_f)
> +{
> +	switch (xfs_blft_from_flags(buf_f)) {
> +	case XFS_BLFT_DIR_BLOCK_BUF:
> +	case XFS_BLFT_DIR_DATA_BUF:
> +	case XFS_BLFT_DIR_FREE_BUF:
> +	case XFS_BLFT_DIR_LEAF1_BUF:
> +	case XFS_BLFT_DIR_LEAFN_BUF:
> +	case XFS_BLFT_DA_NODE_BUF:

XFS_BLFT_DA_NODE_BUF can also be a non-directory buffer.  Maybe this
should be named something like xlog_recover_maybe_is_partial_dabuf?

> +		error = bp->b_error;
>  		goto out_release;
>  	}
>  
> +

This adds a spurious new line.

Otherwise this looks good to me, but the lack over verifiation for these
multi-buffer recoveries really scares me..

