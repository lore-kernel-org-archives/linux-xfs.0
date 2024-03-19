Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D800B3C488
	for <linux-xfs@vger.kernel.org>; Tue, 19 Mar 2024 21:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710884490; cv=none; b=tH/IF6inO2XrVP23VCypyIyKZOOl4M1zJ8vtDywxINTJaq6etuUP8qJOGgPLd3O3Fchvpp+egHiPVeT9Gbjnqo8URnKC2VAlteq4K7G6WO83MLJIdEy2hlzpDM9eER7oJktOrwk7fWfiZIv5NiA1woT1uNX1+bIgyygNJcdOGok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710884490; c=relaxed/simple;
	bh=wlphI7GsSP85r6eukHNngGbYkNwl/CYGWT8mndfMIfI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5btbcRZgWMze+E1KpgveT3bSkvIaN/4etL5B8mpTHaCYrwiv7qdJ1VOD9RFANA6Qd+KX34ZXuK3t7NPPtsDA9Mo69TQuxM0T2MZwcZaqlRamwCm5tthX0ZjVm3LG+01YYE2qpk5fFtq/qR8JzbJy4u5UVxSKpRBJE9OV3ZJZeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F93pOJWP; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F93pOJWP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZbN4MgAdyMNCMj0Ulu7EKUER1uJdBGLbfEGlvnguEOc=; b=F93pOJWPMm2YlhJj1TgpVS20Ow
	sDpFG/0K2P/HYLXJ9NWPohOD7MVRD5yad2I1la4/tlIBuCYGuGYz1hwWRQUd0yUvOztt6Z1eKIICK
	srDiEb1MELs8cViYR/oP3I5HnSH/pH1GOtXV6vpLfrjukdl8Yp4zsokgq5LnZe0Xs53pc7q/jZJx0
	AJwC4PWAPsnE6OUh+WBFhpQcJ5HWE1c5GEAUqjoNc05j3ivtmISYnOHHK40RfsAI8dqAMjh4EUmVw
	6tIf+XL4X8JZps/tCrYD7SAl0ijm6mYZVN8Ud27JtR/OJwv0mWJ8STroQqvVLneWHpa0yGx54FIjN
	YYtjxhhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rmhD5-0000000EKP4-2bpM;
	Tue, 19 Mar 2024 21:41:27 +0000
Date: Tue, 19 Mar 2024 14:41:27 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/9] xfs: convert buffer cache to use high order folios
Message-ID: <ZfoGh53HyJuZ_2EG@infradead.org>
References: <20240318224715.3367463-1-david@fromorbit.com>
 <20240318224715.3367463-4-david@fromorbit.com>
 <20240319172909.GP1927156@frogsfrogsfrogs>
 <ZfoEVAxVyPxqzapN@infradead.org>
 <20240319213827.GQ1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240319213827.GQ1927156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Mar 19, 2024 at 02:38:27PM -0700, Darrick J. Wong wrote:
> 64k is the maximum xattr value size, yes.  But remote xattr value blocks
> now have block headers complete with owner/uuid/magic/etc.  Each block
> can only store $blksz-56 bytes now.  Hence that 64k value needs
> ceil(65536 / 4040) == 17 blocks on a 4k fsb filesystem.

Uggg, ok.  I thought we'd just treat remote xattrs as data and don't
add headers.  That almost asks for using vmalloc if the size is just
above a a power of two.

> Same reason.  Merkle tree blocks are $blksz by default, but storing a
> 4096 blob in the xattrs requires ceil(4096 / 4040) == 2 blocks.  Most of
> that second block is wasted.

*sad panda face*.  We should be able to come up with something
better than that..

