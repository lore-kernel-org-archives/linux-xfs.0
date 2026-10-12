Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C4035AC20;
	Mon, 12 Oct 2026 13:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810830; cv=none; b=E+cLzL5fzKmswThqIsynGnvcIrdRPpUrnwmIXi/9nJWo576yPzephTlCGszw4Gu/JnYp65ugW+D9nXIKFNSg/Ak5TPW2+67eczImq4vM22XMEF3Dn/pm7V33vuZYJrsrOBVV3A5RQ29aF46Ih85D0k9DtVbGOIlZYvh2hoqienk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810830; c=relaxed/simple;
	bh=yH4rgh5IoiXJr61bq5bt8Ie5hjeF/wenEdaftq5CrZs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/JdBFVGUth6sNs7PUuiYo0ZaAU0qENz+rgeKUK1+0qVX72W6lVicaEtBfHqz/k/FOTuA7oNiWwb7gUaklUM1H3fzZ5zxHtLMXU1kRq7hZs1Mjhg9A1TC7WnGf4zwQfnk7zN025lHZANi+uvD3zMmitja0rhEX2zB5VGBA7+HoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=h1yXF2ag; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="h1yXF2ag"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0uak5O5yFuup80mogGmluLHJXgN3f7NDtS4XAWerwKg=; b=h1yXF2agjcDFhm4baBkAj+17HQ
	zEVqspe9NOJR+hOowH+/j8oAcXDl5/NpOUIVyfMNj8XBknyPl2UFuWJJFENknfiPvcCgdHnjcy7CC
	GVzCYorUeeQkMbqGlc2xFS8wDgLq2q5HYPidROhtSYyInBNJGiA7V7LAXEhIssm7rA5Wn6v09Dy/F
	2MiEb3gupuW/syunHAT62x2+7+D7cqR+AQoHPrpwqVD7cdKnsEkRdyngf+2XMftmA+AxU0naNiIUA
	LYHd4vDcP4aYp09ooY18geFsyxPZToIG0gYXLHyeKCWJP3OLzj5Gbw/xaYVEQvgCZyOU91aRtoMyx
	q0b96Mig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFqe-0000000AXX9-42Np;
	Mon, 12 Oct 2026 13:13:48 +0000
Date: Mon, 12 Oct 2026 06:13:48 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: don't rescan ifree and icount when frozen
Message-ID: <aszdDMGTaxdlt8Gr@infradead.org>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178065837.1058822.17239797023919948602.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065837.1058822.17239797023919948602.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 11, 2026 at 10:59:23PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that it's pointless to rescan the AGs if we've already
> frozen the filesystem because there won't be any more perturbations.
> Fix this to mark the scan incomplete and exit.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
