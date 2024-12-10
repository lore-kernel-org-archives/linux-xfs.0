Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DB9226186
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 06:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733810418; cv=none; b=hDsM7tLWW0/C63h1KYpQSVUbIhofv2weeXmv37Ezg7wOKOEWy3XkMp0NqG86UwxOBYGAFlUN0J2bLo9Vsm+kv7M2cknHSwNseZriu4y9nVBm5pKhXhCmM9rJlNwD3Wfz6cuAsU/aaND10MA0UL2PkAgyDLdhLKcMHlNSNSQhp+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733810418; c=relaxed/simple;
	bh=TCoDUMONtuSAxKAghJFKo12VWkjHKQc/0KqkDq66xTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pc63UkdkQZZnfSfWvj963hrgJK1o20K8uVsaQa283Yakp1HDaOMILVli3Vs4t2k3LrHTKmWuJA1+9HdNQc6zW+kHZxjx9U7IHbB+4jSczbwKazwCOyo2ZWE2JtNiKMXnpvJo24ZK2H39e+U1KPG4HcH7fkB006XW4BJSbYFzcF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=irYS+7i3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="irYS+7i3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ovHyFCzYzHcEM+umAZQ2My77DxeHneJT7UoLO2BwhKU=; b=irYS+7i3794ALwO67FKbQ0DwsT
	NJUWa3VI4gg3C57WQrAlX4kyobCTCZD+ytUmv/HN0t2Z9TPv8ZTDNkTpmORyhDOli7Zj6MDzYM5OC
	P1kxd1EqHoYVaTAEIqM1YUkZB/4MoI21y0o7N4nxlnKX5OWtMrFzxlvlkbcQsTu5l9g4oaaLBZn2V
	bOpciElEihBv7bx5DmCekLIZrduKUYBhh2kXwY1+ZF56m4dpMbWQHyAhKDGcrTCtVUm+Drvv07Fiv
	3h0gtLDwah8EBcP12pt8MHVC9ngAtK6S50740h5nT+OSS5Ery1GwuNgxOWMS4I64Vsdg4KupBHtm9
	v7G4K5RA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKtI8-0000000ALXy-2T8e;
	Tue, 10 Dec 2024 06:00:16 +0000
Date: Mon, 9 Dec 2024 22:00:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 42/50] xfs_io: display rt group in verbose fsmap output
Message-ID: <Z1fY8Bir7RXwTMOB@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752587.126362.15499339908546372305.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752587.126362.15499339908546372305.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

> +		} else if (p->fmr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
> +			agno = p->fmr_physical / bperrtg;
> +			agoff = p->fmr_physical - (agno * bperrtg);

This second calculation seems awfully complicated vs the simple:

			agoff = p->fmr_physical % bperrtg;

Any reason for that except for copy and pasting the AG version?

> +		} else if (p->fmr_device == xfs_rt_dev && fsgeo->rgcount > 0) {
> +			agno = p->fmr_physical / bperrtg;
> +			agoff = p->fmr_physical - (agno * bperrtg);

Also a little annoying that all this is duplicated, but that also seems
to be based off the AG version.

So while this could all look a little nicer, the changes themselves
looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
