Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6EE79E3
	for <linux-xfs@vger.kernel.org>; Fri,  5 Apr 2024 16:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712335949; cv=none; b=WUnT1A0PnB1DK5uhxGUfEn+KXIO8m0V6LMZRpL3OyvUBuFULjgz62s1TYyc8IgV/R8PeyN33Vn8tQE0QINVT0mIIJugILjH/M7Q40NLE2jG4OM6zcUozsYfGhffZXMaPW7FbDXyzuVe90C85Wf5VGE9q6LVrRO+rO2/HDIP+3o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712335949; c=relaxed/simple;
	bh=T6wYegIhApiKqQculkjhFr4QH2Kw4A3DJql80aChm34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fPeiajXvCUDHzUnAf+Wlt/u5eYz651VCthBtAfNVY2MP7Apq2vdyJo3iVZwgw25q6x4Z+r8RHdKrplmwWT82+/CUOFj21Gl7b9Glf/tMMfPqHz1i4ZNKjQAx3rcUKxfHWrHGiy2jMTRq3ZfxPj5+HXZU0iF41dHbUdNDBYEq25g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2psArZU8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2psArZU8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TMb4chBjYgUSjohbzupiUMVoJsF11SZxXENhn4j/olY=; b=2psArZU8WQnecl557wZU+9ZFEv
	sVZvpBeSKITDnXmwRbRS1/x2aVVJGSL0tMTC4T8jRvxE9V0xZ1TdVxyljIK4Of1USuH3maqp8RVdr
	Qk6YL/XbJIPZQEtPGvnrGgbSfSrdkdvN+wLlZb99lw5uZBgqdZShHa5b2aJnbdlHCHApI9dyO0OFa
	7PSVVKLvTssiskJ0EbVmCv/A3VOY7bkRvkRZgwWLODftSSRFB+t5eBORNIq8Cs3ujaoozcplYBvfe
	Rszc7ZnkCkLXgz8EYjCttAvtT5Usc6ffHY93HX2bVgcGGjO/Xife2hyhLMulrU1ZQgMFok3+fD3uS
	h7szi1ag==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rsmnj-000000085Ty-2zgO;
	Fri, 05 Apr 2024 16:52:27 +0000
Date: Fri, 5 Apr 2024 09:52:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: fix an AGI lock acquisition ordering problem in
 xrep_dinode_findmode
Message-ID: <ZhAsS4herQhLxmee@infradead.org>
References: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
 <171212151192.1535150.13198476701217286884.stgit@frogsfrogsfrogs>
 <ZhAQom2KGeUw8vpa@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhAQom2KGeUw8vpa@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Apr 05, 2024 at 07:54:26AM -0700, Christoph Hellwig wrote:
> > 
> > To address this, modify the iscan to allow trylock of the AGI buffer
> > using the flags argument to xfs_ialloc_read_agi that the previous patch
> > added.
> 
> Well, I guess we need this as a quick fix, but any scheme based on
> trylock and return is just fundamentally broken.
> 
> Same for the next one.

And if this just sounded a little frustrated it with, but it should be
counted as a grudging:

Reviewed-by: Christoph Hellwig <hch@lst.de>

for this and the next patch.

