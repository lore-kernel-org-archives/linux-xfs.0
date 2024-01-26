Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5C31B943;
	Fri, 26 Jan 2024 13:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706276134; cv=none; b=qUcIoVc3J5AV5hvGGFX1upf62pfexlva4cg7YJp0EPs9CFrZPa4omIwXCg9CKbCRO2cIkdi2FBYPKqmiWUV6rWVdtxgO9puZyqoAR6DMMa2jhvK95vldc+HzvbRd3MtVxJj6w1hBvy6c6ifhoTJQPq5EFUMdtzKQ8bqRsHbZQ18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706276134; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rqNC63FefuuJm/p+dK3fhA2iP5Z3U/AGUtHGLi/suHiwwmAZAv4pjs5CJmKXJHRP3vP6s39wWrPCTYTQ14ZuX1uhvK4hp2GkItadCO/iSDWq1kzakhJ4rzzr7FQt9nkASwO8Z7IHTF315OSgM5K0XG4ReP9bCu4oHzdE6z5N6Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QYb0Ul5k; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QYb0Ul5k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=QYb0Ul5kKWCOJWyrXb/F/LIS1R
	Wf+6djfjn/a5B64yaI1ocfrOe737a+4jwV4kigI7BDBjQfUBQYy5tasiezLH7ViSeQVGvpWnOx9d2
	akHvar2WK6zpphBxTTyrtUyJ77YSkN1hY4B7qpDl0oAUB1Fj6US71aJu4jjUCxxVtwXxMKtM5eRiA
	Mc5YToPrNwC3kkFhDjNLotDeeSuEDab0Ukk9iZ62DRv6tsa5SQ0rqNrH0cCmibm+jaTT0tr3B5/DI
	o4A+66O6HjcCV1yjsGPzxmgKR+mNObjgC7nPsbKXjs9dfONNVPCUaXSIwgThfBnU1ZDNZtbvLAwWh
	j4moY2bQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTMMm-00000004Drb-2nbl;
	Fri, 26 Jan 2024 13:35:32 +0000
Date: Fri, 26 Jan 2024 05:35:32 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: zlang@redhat.com, guan@eryu.me, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs/503: test metadump obfuscation, not
 progressbars
Message-ID: <ZbO1JC0MAnpcYifh@infradead.org>
References: <170620924356.3283496.1996184171093691313.stgit@frogsfrogsfrogs>
 <170620924464.3283496.16784489077157560763.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170620924464.3283496.16784489077157560763.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
