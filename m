Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B6A226197
	for <linux-xfs@vger.kernel.org>; Tue, 10 Dec 2024 05:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733809330; cv=none; b=Ef8QHzeivhWkJK+x1MtlghAPYR0vIJOBEpmA+8URjmF7aAhWUZh/DbcU5JSsPI3NKgorICFBe/OGBQR35im2kjQY3tB0NyC5M2bt4OSbIYEaxJIOO/LQXP7/EV2JYNd1rwZF1loJ2gF960hkBBfGyz/nMQVSUlzLfkY1j/0Nzws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733809330; c=relaxed/simple;
	bh=qt73i6smRbh18sCRtlxAzGWOX0o/p4eoGLFH8l4Z7iY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J8VF0r+qQSS4rI4yA+qYs6g4mrASb1t32DPck9TxhQtpJVXRs4dU+MaSdrlPjYZVEW24yfKtRDNjkDVOGgXeWwvTBUkbfsU2GY9bN1uXkN48ddJvp2aCOeKhhux7ZxupkFPvtCixJF/MXTGLNxyxixdiIDGBoekhogLuHA0uZaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ffTbe2nQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ffTbe2nQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z1hKEfycFaVdfvKeb0TkT43Ro7W04x8wlrdFlTn+v9s=; b=ffTbe2nQG2QClolyzzyqXgWuzn
	mKaWqEXqDuPSI4nmELHmzqN4e5FY7axBU9TNOPtPnjnc2itaM6or3aEalM42/QvPArclVHLP4+nub
	zefySnID4/vCD+ihpj5WULqDdBtH/OhmIEUC6QLxGSFM2azKTc2giBdjVLf+OE5uGPFML+fGmzobh
	xyBYp088nkEQpNHpCG0bF6LiWcl/NQR6zSXT81fWPEBfqAjVrQ+Fevl7tbRC+qP+i1aCJJ5jYSk70
	EaIZzNSPyVSL1M4XiC+wRuDfvlQ1LzlDThdhcc2nzjwnW+aMW5JlBN5TaJqDSIbWkgYQka0WxNTFs
	QRU4mZYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tKt0a-0000000AIdf-1vqa;
	Tue, 10 Dec 2024 05:42:08 +0000
Date: Mon, 9 Dec 2024 21:42:08 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/50] xfs_db: support changing the label and uuid of rt
 superblocks
Message-ID: <Z1fUsP8hMfDnJ6Fz@infradead.org>
References: <173352751867.126362.1763344829761562977.stgit@frogsfrogsfrogs>
 <173352752388.126362.13051985148596315963.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173352752388.126362.13051985148596315963.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 06, 2024 at 04:12:31PM -0800, Darrick J. Wong wrote:
>u +	struct xfs_mount	*mp)
> +{
> +	int			error;
> +
> +	if (!xfs_has_rtsb(mp) || !xfs_has_realtime(mp))

Nit: I would have expected the checks to be reversed just from a reading
flow perspective:

	if (!xfs_has_realtime(mp) || !xfs_has_rtsb(mp))

But in the end it does not matter.

Reviewed-by: Christoph Hellwig <hch@lst.de>

