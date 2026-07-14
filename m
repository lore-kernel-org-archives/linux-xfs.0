Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BEE3ECBE5
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jul 2026 07:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784015121; cv=none; b=gDlUDph7OYQsU0uxPCufRXu1wgZPtkjsoY/hSB8nah0J8d6beB51r7PDpCBl5iULNmpYp8KWJe1arcW35ZpuXkVaWjtxhy+TLL+wGBCthIro12l9/OPTWAWzMBzwSUT3a0Ns47vKysUb4wj75QZ/wn6wCWQk/AeaZFgew8Dq9/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784015121; c=relaxed/simple;
	bh=XaWC5W4cLkSmhTeL70+ngzLpeLt813kC4TgfFzbA4Eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lg+1gliLGBiq74aFjkQlKTVpW2LCufIY9s9WUYUXZ1zy52xSO7jejYAuYvs/OHh+BSgGucRIsycLd5i3EXtPXj1q2wsGQAj+HY7ntQk9GUwGvChWz+3KINFrOD3cq4XDW9Xzln32bY1ITtTQvYqVtZXMVAmWXunAUSyytXReiAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=v6waLoCc; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="v6waLoCc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ohhVRwX/twNrAhsWCeO7govDnqvAyyt7uqNKgnCegKM=; b=v6waLoCcGR44eZs/nlxGEM8nwK
	A3MVL681fszpt7V7c6jNdMpE2GH9piYaQstRqbDGn9mwdXdkUuEfmz3ZlmcXEGcY76SckkaJ7IQjR
	g5QTPOy/zTwj6u+zqYZmraW0GXwvzywU28fKCePBwKoH3cbOGJ0fedCUf43iXRxCjr4mO8hEygB2m
	uFG1l0eZrTPfsGHCyywHi7rr5CukYG5Cu62x6CbP+MF8Iu5dzMyNjSck5tC5xypBWEtumDQfQLG4o
	vUf74abygqYCTxW/r4oBJSCotu6UhVdOog9euELA22PMFzZL8Cvtw94pQ/S3jV2cJ6tPh99rL2S2T
	zBRQ5o5w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjXpH-0000000BDbB-0muE;
	Tue, 14 Jul 2026 07:45:11 +0000
Date: Tue, 14 Jul 2026 00:45:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	hch@lst.de
Subject: Re: [PATCH] xfs_scrub: fix spacemap scan for data volume
Message-ID: <alXpB8RvgRfWoto8@infradead.org>
References: <20260713155510.GD7195@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713155510.GD7195@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jul 13, 2026 at 08:55:10AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I don't know why this hunk got copied into scan_ag_rmaps on merge.  The
> original patch only touched scan_rtg_rmaps.  Get rid of this new
> inclusion because now it's broken for the data device.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

