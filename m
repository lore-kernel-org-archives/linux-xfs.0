Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F096847F76D
	for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2026 13:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791381088; cv=none; b=hpfaXQItwsv6hdoms6CAjGOWR0cPL7bnYbGTeATtnnPgZvbSSOx8Rl56RiXKSRmDPAnP8+vtcp87rBvNE9mRu41dVfJfYVpAZMSrxqQ+U4y4d4DbXuMc3JJdPCkXSuNJmnkusEznMtIgb+CC1EQ4+B2sxIzK1g7grXX/MNPDoh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791381088; c=relaxed/simple;
	bh=agqKL7XUeXrap4p9r3UAKRzX5u8Y+5Q3Wadv66sVuPY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ko2nMabJlgz2OYxb3quzzYaDhLOlWGFMuyLjAsy9iD++NGsn5XzdHjB1hMlQomgw4xbKKZPfZ61TcgpJlYOT8IYRC11pj1QBIh0/gK1GUorhk7aAv7ovolQYjvlxnnwkPg5hqHrgxJJTeWJ7J291+JA61HH6X8ntKUVfKrd6Q6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jMDxk67a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jMDxk67a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N1AGj0V2VkDNSwq7uuLI78Sw5P1jJPvioF0JW00r57k=; b=jMDxk67aBODVIly912Dy1j4QRz
	att7U8ZuDSZitR25pUPZimjApkEVDGC61Vu3MPNIhHDgm14NqAJU29Tq7K9nM8XdSMUj9sh91lspd
	BXYM1KVFq4hU2rWNNLZZ1wog5ULlR0HNJZBhKkds/iJk7Nliyzq+8JZ09+hfbxxn49QPt0pQRPtdN
	2euboAmCVcy8KfZwde+BSrZs1ccMBpz3Yp4RCiFyOnry+SEomtNOO3wqQ1umORCWqlr/0rd8CO+Ap
	QyfJyu/fjmlcgDVAgkzo1t0Wdb2JSz+Ccs3/lpyLFXvtE1hERDRPKeL9h0IbEkmurRYqTR16V9DC/
	iOAz8/rg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xES3B-00000002YzB-0frr;
	Wed, 07 Oct 2026 13:51:17 +0000
Date: Wed, 7 Oct 2026 06:51:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org
Subject: Re: [PATCH 3/3] xfs: re-use refcount scrub/repair code for rtrefcount
Message-ID: <asZOVQfQU3TpEBgv@infradead.org>
References: <20261002211038.2139655-1-sandeen@redhat.com>
 <20261002211038.2139655-4-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002211038.2139655-4-sandeen@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 02, 2026 at 04:08:11PM -0500, Eric Sandeen wrote:
> Some code in scrub/rtrefcount.c is copied from scrub/refcount.c; it
> differs only in function & structure names and a couple types and
> macros, which share the same underlying types and values.
> 
> Similarly for code in fs/xfs/scrub/[rt]refcount_repair.c
> 
> Export the refcount versions, use them for rtrefcount scrubbing,

Not really an export fortunately :)

> eliminate the copies, and add build-time asserts so that the type/value
> matches mentioned above do not drift.

>  5 files changed, 72 insertions(+), 316 deletions(-)

Nice code savings!

Looks good modulo the commit log nitpick:

Reviewed-by: Christoph Hellwig <hch@lst.de>
