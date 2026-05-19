Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B720E3BE642;
	Tue, 19 May 2026 20:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223153; cv=none; b=UDBz0DKrjqidjcIJn7Eqasi1vB2uKC6GgLj0ORBxWOvlzIaVdv/qHRst9CeFCVMS4Q4P51fzQSyiyypvvQWTScurOCGq48fHop1oT/HCjDSu8eSWjObnr7xQlhDLGQhfWGpXKVa7rjF8JwJmCjp/jk14wi/LmYypgzwtUlHuNMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223153; c=relaxed/simple;
	bh=mtwp1O+fWLCXvgs8V6s2T95rtcXXphqWM/EFL7u/pkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T/bQQ0BCkonSCp5rMAwQ6uOCg3cHtBhbuZVmI7dRZUr21FKyxlzpdV76vhgmSbKKpuGp62fVQjkFZOOvlpaV8Uf7Vx9b3DENNNprrc/qkxHSvglyHRKgdOaldA6vVEGBd3TuWULoYzZC9/66Y1cLIUfFReJMl1jFiKdquCOhhtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOrj7sY7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOrj7sY7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E651F000E9;
	Tue, 19 May 2026 20:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779223152;
	bh=qTVY2rUdXHo+MZi2M+iCzj1a9NH32hn1MLg6kvsoxEE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YOrj7sY7VhnXcfQq7rurk4k7VGRqHxW9734GrAiBBUYXS71DYrpadRsScHs2jC8QM
	 2jnQCSL8ZgJIC8eitVi2GXh3J2b4s7OFIBORcalQgRrGT81i0SRkeDRgs6XT+oNnES
	 kE9WBlM4aQs5w9i74pu3tzdkZjfjq+t+NF3wqgwy5eydVu6WWtyNiHv/AQU1WRy0Bp
	 xQ/hIG1fp6AKlViD5Pn/TIJfbDn1xunfzOAwrH0mVDFhkLkLWASVha+lXxJl2J560I
	 SQm3hXpWk/5XGY6R8PpeAzT4NkM+07fMxuRTl1Akp3dqFBeUnhWoIpNNQhl06rYaoF
	 mNCki9fHvTHnQ==
Date: Wed, 20 May 2026 04:39:04 +0800
From: Zorro Lang <zlang@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, 
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH] generic: add a test that stresses metadata eviction
Message-ID: <agzIe4JbAlfi86W7@zlang-mailbox>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, 
	Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>, fstests@vger.kernel.org, 
	linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
References: <20260518062514.506071-1-hch@lst.de>
 <agsEQ9TjHelfbWXr@nidhogg.toxiclabs.cc>
 <agtbqjAxUsCsLwyr@zlang-mailbox>
 <20260519125704.GA30408@macsyma-wired.lan>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260519125704.GA30408@macsyma-wired.lan>

On Tue, May 19, 2026 at 08:57:04AM -0400, Theodore Tso wrote:
> On Tue, May 19, 2026 at 03:03:37AM +0800, Zorro Lang wrote:
> > Currently, we don’t have a formal commit trailer to define this
> > specific scenario, but perhaps this is a good opportunity for us to
> > discuss and agree on one.
> 
> My suggestion is that this should go in a comment of the forked test, e.g.
> 
> # Based on generic/579 with fsverity-specific bits removed
> 
> That way, if someone fixes a problem in generic/579 in the future, a
> quick grep might turn up other tests that need a similar adjustment.
> The commit trailer doesn't seem as useful to me since it's harder to
> find.

Thanks Ted, since Eric agreed with this as well and there are no other
objections, I think we can hold off on creating a new git trailer. Let's
just proceed as usual: mention the original case number in the commit log,
and also add it to the case's initial comments would make it easier to track.

Thanks,
Zorro

> 
> 							- Ted
> 
