Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0DA4963B6;
	Thu,  8 Oct 2026 12:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791460896; cv=none; b=SKMX4ayIj4mLzRf/kToC7ZmWPpcjoVSGgHIJ+OE3T1jpadh9uVVHPVYMSihPn/C5PPhYPlWJ7xZluYy7uA+p521pgh2XS+8/FiDOrgg8/t60jKowCyEDKGoBRES6/bmVlGFytxBu2p6T3GyR1PopLHl+bmndXwAvcicj4p+EiWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791460896; c=relaxed/simple;
	bh=4jNKL7Y/67T1Y1ll3VhPdFJabzfMttBC1v0LQR+Vn7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DzBUg/9Y6BLtqBqKCmEu8h2kCCnF3yRG45tqeVXVBAU7v2yRBrfuTMdAf70tRzespbRkFEGQvRpUtf4O7/rrOvTdIkbF9jIenpXQuiGa4pNYPVK1iYv6kC89WRP5TCqqFo85eMeo/eLKzOf1k2qPe66cTBG2G1HdWgFMdNymskw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=hR30RAdW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hR30RAdW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C5dU0+2ucB6uMs2/m1a4pVMu01Q686+9G/ZBosr5Zh4=; b=hR30RAdWwmrhwwFuVX9k9hxt6B
	lte6BYXXC351NoXMucDIZyizaY3P+EAHw5eTsozJEBuHR7VCDDp94NK1GTrHPOdMfUEgWzEVRrDpE
	oiksJxe5d9fAk+TOM6d0h6FbHHhoj4wRsglpuPwurL6dSxY9Y0SYv/5EfAur939hAlOMQDLL+b2xX
	ZJvaxo3Q/ISV2FVtvXeiExqBJ2CT4RNPzCRc2C5qMjQ+AIGqVlS1iB/0Jr77VjuuJF2j78NP0OYGi
	J2OcE5THDcUaRtg8IRbnjOl5tivlIz8SERvVCy0TTpCSE/9xoAYyBEIIYxkiSqIzLG3lSaA5ZMysC
	QiLHviVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xEmoZ-00000004JTR-1Oxx;
	Thu, 08 Oct 2026 12:01:35 +0000
Date: Thu, 8 Oct 2026 05:01:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/12] xfs: reject absurdly large xattr value lengths in
 xchk_xattr_actor
Message-ID: <aseGH-de9LBN-0vH@infradead.org>
References: <179141521177.2728617.11116041790027402666.stgit@frogsfrogsfrogs>
 <179141521450.2728617.8405627225983917643.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179141521450.2728617.8405627225983917643.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 07, 2026 at 10:57:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM suggests that we shouldn't try to allocate absurdly large buffers
> for xattr value checks because that will push reclaim very hard, never
> succeed, and is pointless because nobody can create xattrs that large.
> Since the xattr repair code ignores values larger than XATTR_SIZE_MAX,
> we can flag the corruption and return early.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

