Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A21384224;
	Mon, 12 Oct 2026 13:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810999; cv=none; b=KjHv2LHH55Wyig/kG5lyTX7MDkd7q6nfCbrqW5Ytps0Z4pUIE43UA2rDsu125sgU/sNGHY3QdqjkQ7Z+1RkX0gl2vf5qF1zNdvFP8pCdxlxyfVlI16J3uo9TkyDrGrl8Sna9DZbPJhRtFR+9lJajJoBd9rC7POdFCh6oqwKqA24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810999; c=relaxed/simple;
	bh=8GP3osIW4MGAJLR9U7oBmHbasuyUQXGAuCbg1kO/UWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mmq917G0bb4eldiUvIgM1C/fXArMOF4+RLpPpBESRtbhVqKS3zLI/i5w7nQiT1fF5j8fJY6hhjZAum8IyRULyoy6QydoLVZpX+fKkb0msx9fTZa+6Dr+cBUHlivKm2Qm4orCDtp8FZ2uC570aIQrQqbPBT4tm4+GmKVasLPOXfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Il1dO5Ee; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Il1dO5Ee"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RrVBCCac48g8x8zncavMzGpZ1ViuMUnLx4SyBiz3udU=; b=Il1dO5Eem3Nl3o2WFLM/vUfNm2
	9m6Bnz+d9dPsE976U+DyEuVXo3AUYzBLWtld/Xjr4/xr+4LBKw2GbH4eol2WPntjCm6yAarnfqRww
	sUVZ1GrSejfmNug84Fftv33x6sYGrHEMDkFQpOqG+h12pYgAA2RzqQW7SPFeicUBxSlxaGEtU52jI
	uIUWgv22pm1va8yWyJkH0pBHRvBS+Y6oKxMM8XwhcYIopByD3AuD0RbibvseYpvVpyiTqZp/1LAjh
	MUI5kwds7E6pXDEGPN+Qknj0/7fwOdGfuKSO0EMZPxJL3fZ6t3ia/fbAg0t7PDsdxSbxLSxqnbiZ0
	RK4VBnvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFtN-0000000AXkf-3wTm;
	Mon, 12 Oct 2026 13:16:37 +0000
Date: Mon, 12 Oct 2026 06:16:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/12] xfs: rescan the AGs if incore delalloc counter is
 negative
Message-ID: <aszdtdNDmnOSHSQT@infradead.org>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
 <179178065859.1058822.2001240285823845729.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065859.1058822.2001240285823845729.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 11, 2026 at 10:59:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM complains that percpu_counter_sum can return a negative number but
> we instead misinterpret that into a huge unsigned value and do bad
> things to fdblocks.  It shouldn't do that, so let's add a retry loop and
> an attempt to freeze the filesystem to (hopefully) zero out the incore
> delalloc counter.  It probably won't work, but at least failing the
> repair beats doing the wrong thing.

I wonder how we could even end up with a negative value here, given
that we should not see live changes.  I.e. might it make more sense
to just treat the theoretical negative values as 0 instead of a never
exercises retry path?

