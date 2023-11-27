Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t+6UwYk0"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E29198;
	Mon, 27 Nov 2023 08:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/KxJlNDgiMvoj6hWMLQPOYzYeXYoJ6pzhezDDs7d1SQ=; b=t+6UwYk0XTYdHg91EIlUpOiQfG
	UdnQjWKUKwqL+2h//Q3coOJ0qukeLJ8K7Uq+NNKBJHy7B64rxff2JPv1FPJ8pEnO7Y7XqO6Hy7BoT
	rC5gdYSX/5TpXCcOrmJm8yOICcfEDQAkB0xu8mfS/1OK3rJHbR2E7o5ifQIeKmaCzS07yDWCzQnfj
	MyJRgpJf231m+WzU5CT7Wmd4TKzZg+pRCWPIuGEjd+A3Pd1H/DCnGMkDE+a0E4YtigW5/paGrAwBH
	7ozxIgu4nxHsP97H8oxaowDXmw6jVHnDF82cZyjxbf68vlS/scBmNhJ/eePvu097j8sBnWmTcR0HP
	H7A7gbLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r7e6W-002uVY-39;
	Mon, 27 Nov 2023 16:05:00 +0000
Date: Mon, 27 Nov 2023 08:05:00 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-sparse@vger.kernel.org,
	linux-xfs@vger.kernel.org, smatch@vger.kernel.org
Subject: Re: sparse feature request: nocast integer types
Message-ID: <ZWS+LLCggp70Eav3@infradead.org>
References: <ZUxoJh7NlWw+uBlt@infradead.org>
 <3423b42d-fc11-4695-89cc-f1e2d625fa90@suswa.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3423b42d-fc11-4695-89cc-f1e2d625fa90@suswa.mountain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 27, 2023 at 03:51:05PM +0300, Dan Carpenter wrote:
> My plan was to go through the false positives and manually edit out
> stuff like this.  The problem is that it's a lot of work and I haven't
> done it.  I did a similar thing for tracking user data and that works
> pretty decently these days.  So it's doable.

Yes, doing it without specific annotations seems like a pain.  I did a
little prototype with the existing sparse __nocast for one xfs type that
is not very heavily used, and it actually worked pretty good.

The major painpoint is that 0 isn't treated special, but with that 
fixed the amount of churn is mangable.

The next big thing is our stupid 64-bit divison helpers (do_div & co),
which require helpers to do that case. I'm actually kinda tempted to
propose that we drop 32-bit support for xfs to get rid of that and a
lot of other ugly things because of do_div.  That is unless we can
finally agree that the libgcc division helpes might not be great but
good enough that we don't want to inflict do_div on folks unless they
want to optize that case, which would be even better.

Linus, any commens on that?

> I'd prefer an annotation that had the type of the unit built in.

Annotating the type seems really hard.  I think the sparse concept
of simply not alowing different of these types to be mixed is good
enough without needing to know the actual unit in the type system.
