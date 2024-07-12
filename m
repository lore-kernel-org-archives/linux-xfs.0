Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1600F15E86;
	Fri, 12 Jul 2024 05:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720760602; cv=none; b=Mp7QnqOPKwQcHq3/QeFRR5O7Bwbm0mSjKpScFlkGfh4OYYAmpIXu3fx4WwoxUPrSR32vj3kJGBKm9Y/cEzgupcAxvYxQx8wBdwwjQRkdyAZIksDCvBbmBQcQ63ZksRB9uNVxNBjniVoQVYzBu/l2XzMBvN6nRnxLF3SdkoJyqSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720760602; c=relaxed/simple;
	bh=uJycFH3NJIBIuG+gFB/IYFfH3iQJ7e8hH1DDh32UioA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pg+MOaz+Y9uXoj+ETIw7HIacXx+/mNHHjH3wsG/TzbU3NzXUdID8nH0cyyOwCFHHYa06PJscH/5fhvlq39ZIvmkK03PECpSky/xD4w5MaKKx3jx0//+MFN37s1NYeVWkL+CBuPUNheAujNDQaoSXkOng8+ueK2cahuU4l7WEqcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kdtvkkKT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kdtvkkKT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2WZFKEc9WACGtPIZyva0QWyby7W17U1DEZ7Cz1V4Law=; b=kdtvkkKTRq5vO17iq0BnkmWF/L
	N8sLOy/p0S5Oh70WXTDoixiK8UWtl0RKrWTLEmkuHWALen5077c449BM474s+/ZFbbojfvFkXNZb8
	CeTaeAxDODFfQjYQeRSG49gyoar8zsnsCaQoUkTN2uENJBiQBLwCc3qsTZ+4gAue91fENIFFHsG8K
	RcUtF9fQZAdXhDypfd6QedNqU9RxqRBDEJcpryvXvxP3SloLqjXCFXm8KqzLfQ7meTpJ26KLNu+RM
	G2sHVbWSJ0f3KVj2KgWr9Su2rq5PxXCd7uBzzKji0z0NIhkJVK03W14/b7ww+Zqfnm5GUECEQy4Rj
	iCtCV+qw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sS8RB-0000000GSJC-2Ujn;
	Fri, 12 Jul 2024 05:03:17 +0000
Date: Thu, 11 Jul 2024 22:03:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Julia Lawall <Julia.Lawall@inria.fr>
Subject: Re: [PATCH] xfs: fix file_path handling in tracepoints
Message-ID: <ZpC5FTEvLDbCije6@infradead.org>
References: <ZpAB2HU8zE41s9j6@infradead.org>
 <20240711211754.316de618@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240711211754.316de618@gandalf.local.home>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 11, 2024 at 09:17:54PM -0400, Steven Rostedt wrote:
> That "f->f_path.dentry" is a dereference of the passed in pointer. If we
> did that in the TP_printk(), then it would dereference that file pointer
> saved by the trace. This would happen at some time later from when the file
> pointer was saved. That is, it will dereference the pointer when the user
> reads the trace, not when the trace occurred. This could be seconds,
> minutes, hours, days even months later! So %pD would not work there.

Indeed.  I'm so used to these useful format strings that I keep
forgetting about them doing non-trivial things.

Which also brings up that it would be good if we had some kind of static
checker that detects usage of these magic %p extensions in the trace
macros and warns about them.

> 		__dynamic_array(char, pathname, snprintf(NULL, 0, "%pD", xf->file) + 1);
> 
> // This will allocated the space needed for the string
> 

> 		sprintf(__get_dynamic_array(pathname), "%pD", xf->file);
> 
> // and the above will copy it directly to that location.
> // It assumes the value of the first snprintf() will be the same as the second.
> 

> 		  (char *)__get_dynamic_array(pathname),
> 
> // for accessing the string, although yes, __get_str(pathname) would work,
> // but that's more by luck than design.

That sounds pretty cool, but except for the dynamic sizing doesn't
really buy us much over the version Darrick proposed, right?

> Looking at this file, I noticed that you have some open coded __string_len()
> fields. Why not just use that? In fact, I think I even found a bug:
> 
> There's a:
> 		memcpy(__get_str(name), name, name->len);
> 
> Where I think it should have been:
> 
> 		memcpy(__get_str(name), name->name, name->len);
> 
> Hmm, I should make sure that __string() and __string_len() are passed in
> strings. As this is a common bug.
> 
> I can make this a formal patch if you like. Although, I haven't even tried
> compile testing it ;-)

Without having compiled it either, this looks sensible to me.  As XFS
was one of the earliest adopters of event tracing I suspect these
predate the string helpers.

