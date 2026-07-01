Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6897E42E006;
	Wed,  1 Jul 2026 10:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782903386; cv=none; b=dxGTC+Jps7Fxl5c3tHeQ9qOlY4M73RSF/7oB4e9R/4KR2jTOK9dYaCnaVK08IeVINLbfI9z5vtQ4hg1wo/kFdeUbXOvd5ZFgFHC8nL4v7aKqmxZbcaD8L4piwpFoOTMUC4f2+c68+gTv/zS0qPjQ+Rq+qG8N5NQDQKshFSdqRoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782903386; c=relaxed/simple;
	bh=0YgRz2EYq15QN6cxsAJiiNsuuP8lVSwHWipyARvEBHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJU6NwIgpZ9Mw9vHHgF0/tQzjzorypiuKFRs9XK1ZJe+e0WRkVbISZcWVk7+jcfWBL72dcAur/a5cEGfOGwf+fwpEd8plJOcPneErAlZDNA75vjs1ZYQgvDEfkHCSnpmH5HRWc0gFPacRsB/RkEgbIHLQaYQTcuBRS1f2TEGtFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4xhYEgh2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4xhYEgh2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vVvkLH8ECRou3QfKa26hp0zut4w56PIr9mtYRplDca8=; b=4xhYEgh2iCW+IM5VJZA+W/ztqI
	A7h+IbaTO2pW6mwIjujf/yUcCTLsV2zIM5R3wpyRE4xHjSXimTIFsoiPaSrG/Luj376mYMIKOH4Sd
	qHFCFK7MCT9K/+m58+difEdXKJ3auFxyWVJRD0Xi9KKu1sm76Ib38kXj2JbgDl+/ybtulmk6GX5Kg
	5Tyf+NKbwSQTh2Vc5O7L56fE83asXJw6PvQ5FWmdo1Mx7i+52RPPIK1oDVjjLZ/pV5jozkmqoLmbp
	eiA9hfT9sGMEOE8OaPaA8Zfl6sma52gVcKq65Dkgu01sDoFS8OlRTrdoaVitm0HGl0Hyi2jRrDm4f
	xVglBNWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wesc5-00000001Ni7-3mko;
	Wed, 01 Jul 2026 10:56:17 +0000
Date: Wed, 1 Jul 2026 03:56:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yousef Alhouseen <alhouseenyousef@gmail.com>
Cc: djwong@kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: zero newly allocated btree root space
Message-ID: <akTyUXMN4_I1fOaM@infradead.org>
References: <20260630100621.7173-1-alhouseenyousef@gmail.com>
 <20260630161113.GB6526@frogsfrogsfrogs>
 <CAMuQ4bXGcSf2=MVknbgt709Jkv4fgiCx9UEocSEFTDkzPY5bFg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuQ4bXGcSf2=MVknbgt709Jkv4fgiCx9UEocSEFTDkzPY5bFg@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 30, 2026 at 01:39:35PM -0700, Yousef Alhouseen wrote:
> Yes. The KMSAN report traces the allocation through
> xfs_bmap_extents_to_btree(), which calls xfs_bmap_broot_realloc(...,
> 1). With no existing root, that reaches krealloc(NULL, new_size). The
> conversion initializes the block header, first key, and end-anchored
> pointer, but does not initialize the layout/alignment gap within the
> full if_broot_bytes allocation. XFS_ILOG_DBROOT later copies that
> complete byte count into the log.
> 
> So the observed bytes are root-layout slack from the extents-to-btree
> conversion, rather than record storage that a later insertion should
> have filled.

This almost sounds like we should explicitly zero this case just for that
particular case.  Although Darrick was kinda heading in a different
direction and I don't want to start a fight here.

