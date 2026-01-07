Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2C126E6F4
	for <linux-xfs@vger.kernel.org>; Wed,  7 Jan 2026 06:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767766411; cv=none; b=npe1pIhHLP9HDsCm0l9f4RHOvJ32Xj/7u3Q/OlpaYFL54OrIlPWvjJHWTjYoH0mMf/Zng4oeqwiTkvHj9gmYa1X9vdX5a5EonKsK3A//cNMxopd1pcbR144c97VHJwfvuD5RYzgR5yTSMLnoZh38BNwdbm/nRDwMGuVyL48fa44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767766411; c=relaxed/simple;
	bh=7lPusn1AQTjOvUmgnuXzzGPrNh4H7ShvjeO8qWjRugs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dZAjnEXgxFEtkhy9nXgBCyyK7cUm2O2NFrtcMgBEwTz+85+jrZhJ5sggIX2FI2uOpp3+LRlpHELhNMmlgyrh68IN1hv/+h/ynxsGNbUQyZP6FXtpZVsPZ7TJ1YuOzQUcnDgNxWA3AXvMgaqZjkUSmv+zVHRJT8OSD5//p2/hBA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nJ1NUjZa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nJ1NUjZa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I0sbLsVI/G+gVA93hCOPPvX6dTGrXDeVrBmhCMiBL+s=; b=nJ1NUjZaukB6kqT4KGJzJykej3
	Hlmc4X+0R/Ky+yowfU3CNnKluF0Ugma0EUA5RTHL0UX8JQhtqBmpDe26Shu3dxFREbJP19WyqXX07
	NLfjn53ZQRatCdF9UnP/MguV8VxQiwzSthpWBHB4JmujZY6qIKrwCEdthlyp77DHqXn8dd46WbRL+
	L0P9f1UYDKRi9d+ZSX0Z+7yAolsm/FIdPzjx87A90GzAXnL3dzb7iD3u0Wc6MRAs1rLMb4RkV/AZg
	fjqcCPFMaQ7DRxrMxHEJ7YmaHEFTCUnGzndXp4xIJebBzXHn4bgLGpIYOMmNRhBIGLb0oZMa9UdbM
	QpMVZhPw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdMnR-0000000ECeu-2Udg;
	Wed, 07 Jan 2026 06:13:29 +0000
Date: Tue, 6 Jan 2026 22:13:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs_logprint: print log data to the screen in
 host-endian order
Message-ID: <aV35idJuT2MZdpv_@infradead.org>
References: <20260106185337.GK191501@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106185337.GK191501@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 06, 2026 at 10:53:37AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't make support have to byteswap u32 values when they're digging
> through broken logs on x86 systems.  Also make it more obvious which
> column is the offset and which are the byte(s).

I like the new output style.  But this might break existing setups
(or old users :)).  So maybe make this conditional on a command line
option instead?

