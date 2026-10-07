Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCF94963A5;
	Wed,  7 Oct 2026 13:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791378203; cv=none; b=bMicikXqjeCGEEEgP66LeQLzFXA5TrEFZZ8xSHkddN8bAi55NPAWLKrDckL3wcBQPQhkrUt7D6Lloq5NisR0s4gRj7pRvtyVBOUiijSo2Ovi654JBwxowF4Bt5sWeueTheDal/WPBo0yhfX3/Jy8TLGlG4X0vvYFgTaHXkMLNes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791378203; c=relaxed/simple;
	bh=Dxa65TX+R9xlWtNfvd1Fa9OTl9CBnXU67J1Ex1ZGmjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Th471aSU1udcBZpb9U13sRa5ydbrWmw6dzaY2la3m3X6D2D2OzdEgSETzbuK3yOq7CFNRhUE26+WMOdQr/S99kZ10xRqEmw4BEXJxm1U0pPc3iz2NHKwNzXgG9Ufl8DS+V0awNNhHnGcDdLHNcvMe5Jye5rnySJk8inyb7ccr/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vcvLAjfr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vcvLAjfr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J8GMn5fNilyReS0npX+1jO4nH6NPnzCUc4qMna1XsbE=; b=vcvLAjfrNE4GdxmWM/1tuqpkoO
	dr/2hqfXE3RXHczJV3zkjwsky71IwH2dJSUci/62s4N8aot66cZtxdYYWZQpxCsyepq1XE2t1KOmX
	jndLz6WIWkKkD/2HSEmEAxyqz3I9i4nsFEa9Knc2azaJA/rZ//OV5qKUAUDTYFefbU/DUOOatU8ko
	+Z1gefIwolRupWZ1gEKOYlsbyxpypBOa8tage8oWdH5dwFEoWzYs0SiX0YBpwdrXkak2ytNZ4gpPP
	ELn68dsYiirYGZQ50SXnEEEBrgn9446xOBdKzGRvsZTqha9uhIWLUXV3H8X3voqVFpKZXRuj2VPd/
	KtLxV6WA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xERIU-00000002Uyi-1Lyx;
	Wed, 07 Oct 2026 13:03:02 +0000
Date: Wed, 7 Oct 2026 06:03:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/12] xfs: flag excessive delalloc rt extents as
 corruption
Message-ID: <asZDBjPWfJDtLgHV@infradead.org>
References: <179117964931.614350.8529263328378685172.stgit@frogsfrogsfrogs>
 <179117965030.614350.6588199428729564800.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179117965030.614350.6588199428729564800.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 04, 2026 at 10:55:33PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM observed that we should not allow repairs to proceed if the count
> of delayed-allocation realtime extents exceeds the number of free rt
> extents because we can't install negative numbers into the superblock.
> It's unclear how we could end up in that state in real life, but let's
> at least complain loudly about it if we ever encounter it.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

