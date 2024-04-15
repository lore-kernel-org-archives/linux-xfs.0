Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A47B101F2
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 10:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713177118; cv=none; b=mo21uAo0+92HW7btTA7oRl7Ni/oK4659jW2JE0waVP2uOpMt4ZjUm8CzWFYPEeufEi2AspSJajf0/+luFrKl9kwf/hVakzP+8LhALhZVpBVxlZAALGqcbsexMyUtetVwvzWxyS4sAfniwATtp2qC+25Xq5CbI4Bg+tjh6E5hE88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713177118; c=relaxed/simple;
	bh=A4ySGqOI5HPbQMvU8+IZdzZLtFNc4Fvo8RmIagPOR5g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lEG+ecb0esS5/k3MPQlRzA21NvB1ajlXZ4LjKz7usNO4i+T0LLRBXvv4mjJTFjqT/wVtNsueUzBBkhAx8dKAX/U0slHunEgSKLexmB+BpMoBkt1lXDRifNONGHb0zMADlSTuASBF1fLrDzk6uzygOn8yCt5RPvR/diRCQh6KxzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nzxAPWwk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nzxAPWwk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=A4ySGqOI5HPbQMvU8+IZdzZLtFNc4Fvo8RmIagPOR5g=; b=nzxAPWwke/QPow5Uwz2mNX4IoG
	CCWPkWgA6CsislfGttiQt8ocT1DGkCjMg0GwcZIlxM1UfnKABPcoD0oonaVeM7FMPNDKoWJlhvdVq
	4tP0hVb9Nkpu0iXTPmcQs0SJOOx2vrCLGHz3QAQd2z5/wWR3pgMhywVj8hq1OJ+adF9gUWydHEb1r
	KxW9LK97JyhWkI53bajn5CWc+5V5MaxfMqWAM4ASpFWl+mfIbDmFT8OOhz1DA1jdJRBSw+Fv7pKA2
	0VderqZNcTenvueGSq8jmaI5I1Ifkf+Kgm+A5nCiPP30qXjJhVPqi1UaSfhMuDL0SmV5o2BnifpHB
	7thSUZVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwJcy-00000007sMp-2HdZ;
	Mon, 15 Apr 2024 10:31:56 +0000
Date: Mon, 15 Apr 2024 03:31:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] bring back RT delalloc support
Message-ID: <Zh0CHF5Fl3mqaSvV@infradead.org>
References: <Zgv_B07xhnE-pl6x@infradead.org>
 <877cgz3rmt.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877cgz3rmt.fsf@debian-BULLSEYE-live-builder-AMD64>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Apr 15, 2024 at 02:11:16PM +0530, Chandan Babu R wrote:
> Christoph, The tag "xfs-realtime-delalloc-2024-04-02" is missing your
> Signed-of-by

Tags aren't suppsoed to have signoffs.

>
> . Also, could you please rebase your patches on top of v6.9-rc4? I
> start applying patches for the next merge window on top of x.y-rc4.

Sure.

