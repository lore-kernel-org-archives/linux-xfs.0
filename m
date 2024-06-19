Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2884A1D;
	Wed, 19 Jun 2024 06:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718777487; cv=none; b=UFGJkOAr5j7W30sfxpMqhXTtVv0co9h3omcAmlLaVFCkm4DyO4qIa9xTw4iN9NtL6axWuMPWfe+BYuuXIB5o3TGdj4w3qDpheAruP/STQWfMoO4LefnSkiyyzHhkq9+gaCYxlBLMcw5z9LDFBukhNSXbqo7fCgm7XD3Mb/Dovc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718777487; c=relaxed/simple;
	bh=yF5bI8ieMNmhuRSzG/AqvI6piWafoXBQPZN0KjZOjK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OYr/+/vuqLUg8NBSOu04nszdk8i5KWovQXqsYnPuyaHPxNm7cQ5CR9Iu260sSkzHIGivCb629ivthnVyNmM3kpvv+4OPlDNi6ZatU9y4Pwsr/ximp5NQid1eqq+n0emxLyEo7/0V8a92P/vv6PWD96Lcp1bUEjuDBmi+NTQ019Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0evlT4xh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0evlT4xh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4Pu6srUuO3dKfNe/19iBwtKV89QEScPUtp9VzPhrRoU=; b=0evlT4xhGizimmTf3Ho3TmUgmW
	g0gkvskOaTIxD2okzfxu40JSWSc7NLW3jq6bag5cTmMf5VjX/tThFReiTXaQJt9M4pvHg9MIaNubR
	AvhU6mQ6JWpDZmBcMX3R4ThlBM/wvL+JntYxomP1Dn8tEa7eLVLfhrHhNVK2mbQAS3Ps0f/XQb78y
	dbxde2ps/DUnrQ9ltZhygiSIFHj+Mm3aKpYjFFCE+DYxR3E/6aQpMrUkHQx+lpM40cbLRV5mFRxS+
	XgwhFWSux6prh13+AXIPvtQYZQgp8MG+QsarLMImNiiaCtQ5YzDQTRRGVHBtmfZHoKIdYLNEfSeR2
	20Ap50lA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJoXW-000000001HP-1ygS;
	Wed, 19 Jun 2024 06:11:26 +0000
Date: Tue, 18 Jun 2024 23:11:26 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, guan@eryu.me,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/10] swapext: make sure that we don't swap unwritten
 extents unless they're part of a rt extent(??)
Message-ID: <ZnJ2jieRl4-B70Ux@infradead.org>
References: <171867145284.793463.16426642605476089750.stgit@frogsfrogsfrogs>
 <171867145451.793463.2794238931520323458.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171867145451.793463.2794238931520323458.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 17, 2024 at 05:49:21PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Can you add a commit message explaining what this test does and why
you wrote it?

