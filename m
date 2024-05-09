Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E16B149007
	for <linux-xfs@vger.kernel.org>; Thu,  9 May 2024 04:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715230569; cv=none; b=KpkIIRl7PQLwz/SOa4QesIt7jerRNcCCcP/wa5Qyym40lOkDlK6hLSatS/RiVGSVJncAYjLG9hgGNkGJ6HEcvzFoOM3wo0BXOaiM76gOpqMh6u16tQn7VSINjaXak11oSRzqXpz1ZD+ToN7KprWQ6xrhd0W0yKonlGK5E3uN+UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715230569; c=relaxed/simple;
	bh=U4F1pkSU7x0koYsIjDXbVwqYdZMTVF3fflePYrdZAkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RGLqOU5pQOMpXBhTG2tenVBnWk3Kl6vtJQfDIJMdTRn8UU27HhdKvplXD9NdFQxl7ieadodslraQ40nj8jCl+/fJq5c8W1f/CjEET2SS0q+IThe2uowONfRycxYAb2Ir8pu9kmqvsY7NDIidL5uQJ0naniij1Ego0GHC1umBVqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LgcumQts; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LgcumQts"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fCcHKow96sQmAkZ0L43QvKNgNEakiuWYptZHl2AxREE=; b=LgcumQtsKMjWrg3Rkvr0iloGkj
	5Tw/zRstaWf7zpSyYvTtcVJYp12RbmCkRrU3XegyaEVSPltSMI/cQaztedcj84KuZklh/2zlBIDMG
	VDkHsJ6E0o/6JAdx3sdHAQ48W8ppSsBh4wbaDyIXcut+IAARW6h0kGJioPCSXMl9QoHcziMtfvpAU
	TTFbiH2HhqSsXf4xBVqH26tTPVJNFqi1MxYAWHj/6RCsDOVSHrEyKKRmGs5hjpRyWdmU94yKbfASY
	SDfIU4YJPT4NG0fayndKtOE1yTt+20UHAkm7JBYTgTVGykIiLU1eg/ge/HdelScX0gG+umr4Xl6ZL
	9t6W1YbQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4vp9-00000000MUH-3ASt;
	Thu, 09 May 2024 04:56:07 +0000
Date: Wed, 8 May 2024 21:56:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	Linux-XFS mailing list <linux-xfs@vger.kernel.org>
Subject: Re: [BUG REPORT] Deadlock when executing xfs/708 on xfs-linux's
 for-next
Message-ID: <ZjxXZ6i_4_5BYVVK@infradead.org>
References: <87edaftvo3.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20240507222039.GB2049409@frogsfrogsfrogs>
 <20240508160933.GA360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240508160933.GA360919@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, May 08, 2024 at 09:09:33AM -0700, Darrick J. Wong wrote:
> > Do you have any odd kasan/lockdep features enabled?
> 
> Never mind that.
> 
> I /think/ I figured this out -- the xfarray_sort_scan function can
> return an error if a fatal signal has been received.  Unfortunately the
> callsites all assume that an error return means that si->folio doesn't
> point at a folio, so they don't bother calling xfarray_sort_scan_done,
> so we leak a locked page and that's what the folio_wait_bit_common is
> stuck on.

Yes, this looks a lot like it is tripping over a locked page.

