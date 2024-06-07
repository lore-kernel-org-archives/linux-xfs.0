Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081926D1B9
	for <linux-xfs@vger.kernel.org>; Fri,  7 Jun 2024 04:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717735653; cv=none; b=afganfohSlchTkfR0iXbMN6Pk1cwvGSauooGn6SmfQUGsZS4SmmufgWif7+tzp5vL2ljAtyr0R5yUBV14IiZvz8y2lkTATniujdsX2whJIcIm9SdXgGJEV+HEoxWpGgftEFe/ySC6HHOUc5te1ba4wcluf2oCVOODOn7BSC7hZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717735653; c=relaxed/simple;
	bh=zyM6DLz06/o7/aJPYriot8u7UcY00F9zzR5GV7pmbRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y9E0RkDNoS5PwZ7zaafOhuuZUBQczKdzWyS2qgwnQ9JjEe9QaXO2ZW2BL9TVR3He1ZohOqneI7OGD57UtiKNfFL/n78j9ZdeLsxwkbRyDaPRZmZkoxGxX9ZMvexRkMhmhceJENLJmil6eeVaEF7j7NtV26vuJL8k/TbETLqLJmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TgUgvYPW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TgUgvYPW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+tmO10wXkF2CaAsUT7gdcwmQxaug/3U3TcpZFtsvczk=; b=TgUgvYPWu8SqxuEZH0fFHfKC7x
	fVgGrGEPGHKy4VJf6rZ4py+o43TftQt/Gj1jkwJZ5ue5VGxS9Yvj/gPmj+vp3wA0/2RZXwQFJrcXv
	DLvlyKg9CKkZQxeOoVAlM2QsxsEcGrDyzOca487IvcIeEs+WmZNnqBNu5gHMs0r0dTjy2XCPHHoTb
	MvWJWT6nDlWU6sQLi4mQ48FuSqq3LPf5sGYUzQhWg2jukHzLSNj0CbzCGfoAr9kIkj/U9IOBWZb5J
	mQ0gehBHkLPSjWAPXF4vcLFV4G1/y4JaREjUc7dwgjTNPNoXjaKIOUv01LDIvAUSUuJMokOrq9kt5
	OJKyIo0w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFRVc-0000000COiA-2OAd;
	Fri, 07 Jun 2024 04:47:24 +0000
Date: Thu, 6 Jun 2024 21:47:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH V2] xfsprogs: remove platform_zero_range wrapper
Message-ID: <ZmKQ3JTa5Ej9I8O-@infradead.org>
References: <5c18db44-41cc-4dfd-9c52-57299d01f5c3@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c18db44-41cc-4dfd-9c52-57299d01f5c3@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jun 06, 2024 at 06:06:53PM -0500, Eric Sandeen wrote:
> only one caller after all - and simply call fallocate directly
> if we have the FALLOC_FL_ZERO_RANGE flag defined.

Given that FALLOC_FL_ZERO_RANGE was added in Linux 3.5 as lot of
other things will before before it is not defined.  So I think
we should remove that ifdef as well.

With that:

Reviewed-by: Christoph Hellwig <hch@lst.de>
