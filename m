Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE17B22097;
	Wed, 15 Apr 2026 14:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776263453; cv=none; b=u35PENjowrm8RTuEIgisXZJ2dWTsU+C30cD6R9B3Ra8uZlht09Bj0GsoHBJ5iZ5FmTlBVEGcrZr4AlNGYLd7x7KH91VmE3T649/C9mL1VMHE6yBWET6gFGdiCKQncafqzSvoiqddUFqzDFC6Fai41eGPm4NOpdf/vrI9/bJMKjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776263453; c=relaxed/simple;
	bh=J0XDojRw/Mna3BVb3sFZO2YT5UKBAtP4uXxt8eW+m60=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2RiboNNFfgYYPpIQOmI5gHs2soOpDHikUdYFiGpLhmURGHJ3O/fEvf1DRAUtsseO64fYFP2XrdwL8RuToKaqWw8QEhPka4RIoElT1OU7QJSKIPkHlZMqgSQqOo+GaZKNAavyzNknKdrwL8fUhd56FJpaLowlC98gN9MJ0tdzIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EArKl0On; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EArKl0On"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Uk0JsMQf+CVFWDP/CsyX5sUtLObhpV7jtN+MOYTyvWk=; b=EArKl0OnAG9XoW3gQ9ptsyMcdE
	b6gh6tQcpyIV8JguJZcbvXRbQ/wsJaYDXB0GU1SP7B1bOsZ8urKsRrJemFZjwxdWctEbvvyjCDbSR
	wFnLNA7zNVO3RbjZQz7mIIO1dFwBX6AiXbK6oncdHs1kJrzufhytyiSparn7qGacnOTLFmsS066EX
	wRDcF6P/59+TOksrTxfTvdBX4CgK94PB+IEe5dFi7H8mDyzKiFyd+LtwpF56AggnGniRVd1E/ZRCn
	Tyn8MTq6BYcEE880k7ujkyDhl7loQbrS/8ZpnNAQx5QtXWHjwdUfXEkYawLopo9a7+JN7gOKd4Oud
	uCcI9fOw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wD1GI-0000000004t-1aLk;
	Wed, 15 Apr 2026 14:30:38 +0000
Date: Wed, 15 Apr 2026 15:30:38 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>, Dave Chinner <dgc@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] FOLD: block: change the defer in task context
 interface to be procedural
Message-ID: <ad-hDv8QoeTmlPW9@casper.infradead.org>
References: <20260409160243.1008358-1-hch@lst.de>
 <20260409160243.1008358-5-hch@lst.de>
 <adgJqiA0vivaW7NA@casper.infradead.org>
 <20260410061725.GA24667@lst.de>
 <adj6iibxNot-yc9X@casper.infradead.org>
 <20260415054407.GA26893@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260415054407.GA26893@lst.de>

On Wed, Apr 15, 2026 at 07:44:07AM +0200, Christoph Hellwig wrote:
> On Fri, Apr 10, 2026 at 02:26:34PM +0100, Matthew Wilcox wrote:
> > > Yes.  On the other hand we can actually use it when we don't know if
> > > we need to offload beforehand, which enabls the two later conversions
> > > and probably more.
> > 
> > I don't understand why we need to remove _this_ way to defer completions
> > to take context in order to _add_ the ability to defer completions
> > inside the bi_end_io handler.
> 
> I don't need to, but we'd better have very strong reasons for two ways
> to do the same thing, and I don't really see it here.  But I can give it
> a try if the consensus is that we want to way to do it, and we're not
> worried about people getting the bio-flag one wrong as we could set it
> from ->bi_end_io, but it would not do anything.

I want to make all writebacks complete in task context so we can change
the i_pages.xa_lock from being irq-disabling to a plain spinlock.
