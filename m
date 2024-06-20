Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77C9224CE;
	Thu, 20 Jun 2024 04:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718857495; cv=none; b=ilUXTaU9PhRO4drqF0LjzyRgRzDtmEhgCATW+ltkOBQD/1F3NhPGEaYn19ppoNcSw9QFnk5lV8t3kA8WmOYCOk5Moyt1JI3Srwu/FAzcPTWPF/um2q/n2eM3yaGw5GM/i1s3G2yuGTPCu2HEu9nUNon/iAF9Lbhm9bQOw8CUSsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718857495; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fGNCf/E2aBjWa4wRcHiLDTs6RtXeGVD+qzLPEgFI88e9JjhxdpejgeFxA47zyT9vQfCrKg4tur+CZNY5OBQpu5BD2Y06irHFT7ZoPYkZaCjVgAKKz9xbG+Z7BQmY2nRod4uYU/KuJCIexFc53qk85OwIZTg6BAkWOpgU9fceUPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=i3EAp9hE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="i3EAp9hE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=i3EAp9hERcQ7MDg1PqwHD9Q9ET
	H1WMtwGccUNWMSgTBYB+Tmr7eYh0qbPERCDKo2Ub21Uak40iboYDYlzsVQ6Y9zbpqfGgxknwyGSq8
	KBiYJFkrqV0utO6kQj1mzIwtUJNePzQOgFHCHOVWfjEltYBSs59dq57XvJztQTs/fdDIjNyHEU3aK
	L4i14py2L8TA1pllQuxfxBdJwW+OxfrXLfPjE6Fg4YLAzNgkEmSW2u8ljaXWlWghRazC+8mbuwHrW
	e3JpevnNjSxGM85VAWvPRnC0qlunRvSPKR2KivXpj1GMrbPnM2PkQuAO/1WOFHza/Xp3ALONvlVnP
	u6+a1SpQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sK9Lx-00000003ZVm-28P2;
	Thu, 20 Jun 2024 04:24:53 +0000
Date: Wed, 19 Jun 2024 21:24:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, guan@eryu.me, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] swapext: make sure that we don't swap unwritten
 extents unless they're part of a rt extent(??)
Message-ID: <ZnOvFRG7o6ultFo9@infradead.org>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145451.793463.2794238931520323458.stgit@frogsfrogsfrogs>
 <ZnJ2jieRl4-B70Ux@infradead.org>
 <20240619165845.GO103034@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619165845.GO103034@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

