Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD388352FA2;
	Thu,  8 Jan 2026 09:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767864717; cv=none; b=JX5ajdu6NB/SxINxw75N30tp5QT61ZgtRRfW01RWc1nFoqXcWuCF5lAyKvv8HuABfe4p1X61+sslKjq+lNmw0JMvD6F9rwE3AjVLE6QoQ8+YEp0DhK3ogf2NPmEJyv6uc4CMJ8MD9+ZyUHITqARt6S/GXhs34Ka9aiwtxWz6kis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767864717; c=relaxed/simple;
	bh=oeKeDBtbJsxMuVccxt4H15KcOWa4Nm2gmiNrX9a4CP4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oDD3O41FweKTXcZAhUILmRYgZpaE7SL6HNCRL02iuz7EkIPVr5L34x3ycW+uqDeFrk24wNAhnbnjGN65OV3h9lCR+KZnCU4wwi9k2MuDJ5tDd7P+tIPUWj5jVi9ijOYIynb8ZQWTGqPgaQYC4iOPRUVy2TTz9PgDJ9IuZM0QNTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kYwP/VEp; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kYwP/VEp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lCi5oih30trQMErsg6OvdEammxa8+qV12gojfJ7yuTc=; b=kYwP/VEpnsbv8Ml8SFYUSDXi0k
	mNGrRTp9Z1GCX4EZwusk9rCF+554QRBCZDeMOEJOKBCN6AQMZbDfGaNh9Nej4OOqHiZzfMLXIYPCU
	SYXEqDi9anniObYSLSIsKsccm72Mi+1cEIsLJXrE5q4BLk+FM8sVpz8WgFlSI78rM3vN1sWiMR3dH
	u5SmPi1LWmXyE+BaSuokJGC2aqEPIERx+GviZywg9rDvnO1bMTQ5SCoS5sM7vqjpVgYpvtU5NPUKC
	mYfs7bdi3kjWeWek/19OBAOzOhrMJvPOEcuatf1hdk9BNuIZilEbn4nZ+e0vCw8zB2NdEoup4nyeb
	J8pGiV+g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdmMx-0000000GTec-0UU7;
	Thu, 08 Jan 2026 09:31:51 +0000
Date: Thu, 8 Jan 2026 01:31:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kees Cook <kees@kernel.org>
Cc: Dmitry Antipov <dmantipov@yandex.ru>, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] lib: introduce simple error-checking wrapper for
 memparse()
Message-ID: <aV95h8JyKvGkDfBw@infradead.org>
References: <20260107183614.782245-1-dmantipov@yandex.ru>
 <202601071206.87F85EF2C@keescook>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202601071206.87F85EF2C@keescook>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 07, 2026 at 12:08:54PM -0800, Kees Cook wrote:
> On Wed, Jan 07, 2026 at 09:36:13PM +0300, Dmitry Antipov wrote:
> > Introduce 'memvalue()' which uses 'memparse()' to parse a string with
> > optional memory suffix into a number and returns this number or ULLONG_MAX
> > if the number is negative or an unrecognized character was encountered.
> 
> ULLONG_MAX is a valid address, though. I don't like this as an error
> canary. How about using __must_check with 0/negative return value and
> put the parsed value into a passed-by-reference variable instead? This
> has the benefit of also performing type checking on the variable so that
> a returned value can never be truncated accidentally:
> 
> 
> int __must_check memvalue(const char *ptr, unsigned long long *addr);

That does sound pretty nice as an API.  Should addr better be an
u64 instead of unsligned long long, though?

