Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2362F3E3C41;
	Wed, 10 Jun 2026 12:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781093584; cv=none; b=SbVlR8Salxb5fmBIq0jyegowtIBEW2WaTZvQjmGoo7B/n0L8jPFRXK/LWG1bwNDXu/RF3VlgSfMXzLscf8ncCRd2AaikHVQjpQuk1nFvCZrYENOzrj7HbcjhXZbCpgZwXbIpVDV45vBF1kWQVqxsEs1jZURa+qq4NRBHX2W1gdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781093584; c=relaxed/simple;
	bh=qu/NzbpdA5Jsxcr5jI5sdBO7bmiKwOkZ23LNvWm5nC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PLXZCjNks+NjPwmsYI+As5LqRXANngchb994pxAMyox4dbRV0YIiT3WEmm5ZAg6j2Ip0mHBMDwJPeTKHqZiqDR4k0sjWP5Wrke5M8Ksi3/2DoMTeRJkyCzryPQAhknMPXUTj8SJGwmX1svb//Cy77ELH9H/k0esiV6JvR+gIXKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A8j3Fmbz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A8j3Fmbz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lWFWjst6tGsnRoFyw82B3vNup9f+bPVuHxGe9upR2J8=; b=A8j3Fmbzx+/DI8VwiXcVDyprP0
	vnJ5+RApYJuC3W4CVaAgAOlM8s7XmxeMm4eBiFxZB4VcNnssqp3junc33ACpKPJ1Y0AVrk9QIVWhu
	9d8flbmPk490OSpBxEg3NOedp3m+49z5sG/vjEdPk7Ru0ksUl7xIQmmKb1+Hsbvj3nkfzKV73KxY5
	g/Qrp8Oa+gKXCGM5qdU1qE3iaygVkJDQlIxOHt5kHoFDDGYkvScg46X6vDtkPHWD/jdlY0rvSvEUI
	kMUT3TE13QwCxfu7yaMcUyJ1DM8MXiuNHSTCCVbkUsffWhId8KR/aprSDc0BdywHrz27TgMPuf+S8
	bxufPU8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXHnl-00000007chx-0DcQ;
	Wed, 10 Jun 2026 12:12:57 +0000
Date: Wed, 10 Jun 2026 05:12:57 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mikhail Lobanov <m.lobanov@rosa.ru>
Cc: cem@kernel.org, djwong@kernel.org, david@fromorbit.com,
	hch@infradead.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v4 1/2] xfs: skip inode inactivation on a shut down mount
Message-ID: <ailUyXryJh3gFZJR@infradead.org>
References: <20260607183026.37700-1-m.lobanov@rosa.ru>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260607183026.37700-1-m.lobanov@rosa.ru>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Jun 07, 2026 at 09:30:25PM +0300, Mikhail Lobanov wrote:
> v4: brace both branches of the if/else.  Without CONFIG_XFS_QUOTA
>     xfs_qm_dqdetach() expands to nothing, leaving the else with an empty
>     body, which trips -Wempty-body on a W=1 build (i386-allnoconfig,
>     reported by the kernel test robot).

We should really turn these stubs from macros into inlines, but..

> @@ -1940,10 +1940,26 @@ static int
>  xfs_inodegc_inactivate(
>  	struct xfs_inode	*ip)
>  {
> -	int			error;
> +	int			error = 0;
> 
>  	trace_xfs_inode_inactivating(ip);
> -	error = xfs_inactive(ip);
> +
> +	/*
> +	 * If the filesystem has been shut down - for example a mount that
> +	 * failed after background inactivation was enabled - do not
> +	 * inactivate the inode.  Inactivation modifies persistent metadata,
> +	 * its transactions cannot complete on a shut down mount, and the
> +	 * subsystems it relies on (e.g. quota, mp->m_quotainfo) may not be
> +	 * set up.  Drop any attached dquots and make the inode reclaimable,
> +	 * the same way xfs_inode_mark_reclaimable() does when it sends an
> +	 * inode straight to reclaim.
> +	 */
> +	if (!xfs_is_shutdown(ip->i_mount)) {
> +		error = xfs_inactive(ip);
> +	} else {
> +		/* Going straight to reclaim, so drop the dquots. */
> +		xfs_qm_dqdetach(ip);
> +	}

It might be easier to just move the shutdown check and xfs_qm_dqdetach
cal into the beginning of xfs_inactive as:

	if (xfs_is_shutdown(mp)
		goto out;

after initializing mp at declaration time at the top of the function.

But this is also still missing my other comment:  xfs_qm_dqdetach
will still cause a NULL pointer dereference if quotas haven't been
set up yet or torn down already.  So we'll probably want another
patch to exist early in xfs_qm_dqdetach for that case.

