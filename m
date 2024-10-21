Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B40B2F4A;
	Mon, 21 Oct 2024 16:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729528911; cv=none; b=UEWCTDalhhoMnjOiGhNOvBOcErRjAHmeKvUgLxhfV8iwMQHjYX9EzBWD1VVDge5OIxZvZ6Hgg4Ol5M1NdfJCduCc4NM3NajlBEZEIRMNPv8edKx6slbxbkr1Ky0JWHpkpWWcNCgXQUpPxLNvHG6rTHRBoSSuf6Q9riCbwSZqRK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729528911; c=relaxed/simple;
	bh=Z6YFOuzYD521pPB31+qZaVvkiJ4NAAD6cnO8yrX7s4w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cbfTpgoHZQk8oOXNw/BvC+DTBPdxwKWERQ2j0SiqtrZMZ61R9YeJsTxRYurrvLHbzMEom1qaTZoUVaSUpAd1UOoj5dWUU+/Ng+pjJA2B3x6iRH4QpzPk7x1CBWPmNk7oi4kI0QsPSbDTsE6hbWTFqx1EAdZulk7tlZRQFmrU0PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pjWzMJRn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pjWzMJRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC38C4CEC3;
	Mon, 21 Oct 2024 16:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729528911;
	bh=Z6YFOuzYD521pPB31+qZaVvkiJ4NAAD6cnO8yrX7s4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pjWzMJRnqbgVTgm+o5RmPo9WygAEFPChQuK2UCPS+k14ss60uFQpKrJclqhZB9nlq
	 i6GJHINqKpxLSnSJvxuAcRpeorWqYZwGqTLfooiXSi7jUPzCYN5Q6qOrBTPSZpxrdT
	 O95d9U3OMwP4U6ATo4zY3B6VOUzlYiJXA6xU9hOXKBVX2dR+m/3iQKDvnCwkmKUDjn
	 n30BjOpHgxMpOvQRU2kpAgPrJB976Wx5oTeBgbIkHKyOnpuaRQWY4Z+6+E/9DFuMws
	 sy5ycNuNY+jP7BxTURjPmyWUip7/n/jJso6/M07YvY2yX3KDk2T8bONBzb+ha5d4Yp
	 LNUCR3ifTqrwg==
Date: Mon, 21 Oct 2024 09:41:50 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/2] fstests/xfs: a couple growfs log recovery tests
Message-ID: <20241021164150.GG2578692@frogsfrogsfrogs>
References: <20241017163405.173062-1-bfoster@redhat.com>
 <20241018050909.GA19831@lst.de>
 <ZxJGknETDaJg9to5@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxJGknETDaJg9to5@bfoster>

On Fri, Oct 18, 2024 at 07:29:22AM -0400, Brian Foster wrote:
> On Fri, Oct 18, 2024 at 07:09:09AM +0200, Christoph Hellwig wrote:
> > On Thu, Oct 17, 2024 at 12:34:03PM -0400, Brian Foster wrote:
> > > I believe you reproduced a problem with your customized realtime variant
> > > of the initial test. I've not been able to reproduce any test failures
> > > with patch 2 here, though I have tried to streamline the test a bit to
> > > reduce unnecessary bits (patch 1 still reproduces the original
> > > problems). I also don't tend to test much with rt, so it's possible my
> > > config is off somehow or another. Otherwise I _think_ I've included the
> > > necessary changes for rt support in the test itself.
> > > 
> > > Thoughts? I'd like to figure out what might be going on there before
> > > this should land..
> > 
> > Darrick mentioned that was just with his rt group patchset, which
> > make sense as we don't have per-group metadata without that.
> > 
> 
> Ah, that would explain it then.
> 
> > Anyway, the series looks good to me, and I think it supersedes my
> > more targeted hand crafted reproducer.
> > 
> 
> Ok, thanks. It would be nice if anybody who knows more about the rt
> group stuff could give the rt test a quick whirl and just confirm it's
> at least still effective in that known broken case after my tweaks.
> Otherwise I'll wait on any feedback on the code/test itself... thanks.

Perplexingly, I tried this out on the test fleet last night and got zero
failures except for torvalds TOT.

Oh, I don't have any recoveryloop VMs that also have rt enabled, maybe
that's why 610 didn't pop anywhere.

--D

> Brian
> 
