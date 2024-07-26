Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696341173F;
	Fri, 26 Jul 2024 16:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722010815; cv=none; b=oBEHtvqDoHf+WCFgBkcfmGPYtzIXMk28UjXd6W0Lomw+t2DaBz8t19FhQRnh4cdTUq1p4QkJ1RUPy9+3fDtPnK2ADknXgx/jHsbtn3BmAc/qu8Q8AMwA+l7MPFXRkR8OzL93I2FfzAEl7d7lAMIe682YzLuDxbvMBKjKnb6MzOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722010815; c=relaxed/simple;
	bh=DNiXPYFhIXarkUTdY0pyfoyQ1ZAiP4mgqfzneadmMqs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ir0bGwRfYij0HNQjk7QLcjC8BQbZ/DfZ0u2YlLE7v1QqpAUBNM122oaM0imxvSWqUBsB4pCfbirOw/2vAHfdBPx0k89glA2JYxb3oq514DVSChEtzYenBo6KTqyAsRdHhSg0BgupJLvQdpwz27AJvIuZOMgC19hNBEtThuJSpLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=noaHtdoT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="noaHtdoT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38BFC32782;
	Fri, 26 Jul 2024 16:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722010815;
	bh=DNiXPYFhIXarkUTdY0pyfoyQ1ZAiP4mgqfzneadmMqs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=noaHtdoTg7hAANCm1lnd+5K1rZLAF6HfnxLYj4HXgTIltlM33qLXQXEnHUbKsdNU6
	 XUIgrUnPSYtrSorqdJCoYYMzj1BpIZz6d0IfxEBf1gBDFDj2b/uAOAOmr8VazixgcS
	 y9pFJqjovzz7mjhwA3mmx7AiOlyElZ+zRVDZN6dCfQaMFr160Tvy2Iy5u61CTCzHGA
	 E0OY0pabDv+9uLg/aaEEdFAzluTYs4KtNLJiinUHn233sTF4jUCjgDknu3HUJx0kXU
	 +rpCgXPo1NUMvNKG2I2bWdq8tl/msKshiOZWE0FNMSn1wmXeGPpV5jimavCWA0i5a7
	 gWeNdpOIEKPTQ==
Date: Fri, 26 Jul 2024 09:20:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: RFC: don't fail tests when mkfs options collide
Message-ID: <20240726162014.GQ103020@frogsfrogsfrogs>
References: <20240723000042.240981-1-hch@lst.de>
 <20240723035016.GB3222663@mit.edu>
 <20240723133904.GA20005@lst.de>
 <20240723141724.GB2333818@mit.edu>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723141724.GB2333818@mit.edu>

On Tue, Jul 23, 2024 at 10:17:24AM -0400, Theodore Ts'o wrote:
> On Tue, Jul 23, 2024 at 03:39:04PM +0200, Christoph Hellwig wrote:
> > 
> > At least in my case it's not really by overriding.  E.g. if I force
> > an allocation group (or block group in extN terms) to a specific size
> > and then want a log that is larger than that, changing the AG size
> > is generally a bad idea, and a clear warning to the user is simply the
> > better interface.
> 
> Is it just "a bad idea", or "it won't work"?  I can imagine that
> sometimes we want to have tests that do things that are generally a
> bad idea, but it's the best way to force a particular corner case to
> happen without having to run the test gazillions of times?
> 
> I do remember some cases where when we were using a 1k block size, the
> test wouldn't actually work because the file system needed to be
> bigger or the metadata overhead ended up causing an ENOSPC too early,
> or something weird like that.  So that was a case were the merging
> would _work_, and in fact was testing a combination that we actually
> wanted to test --- but we had to adjust the test subtly so it would
> work both on a 4k block size and a 1k block size.  I don't remember
> which test it was, or we hacked it, but I'm fairly certain it's
> something we've done before.  It's messy.
> 
> > Merging the options is what we're currently doing, and it works ok
> > most of the time.  The question is what to do when it doesn't.
> 
> No matter what, it seems like we'll have to look at each of these
> tests and treat them on a per-case basis.  We could have options which
> allows the test to specify that it shouldn't be merging; but then we'd
> still have to decide what we need to do.  And what do we do if we
> don't want to merge for ext4 and xfs, but it would be useful for btrfs
> (for example) to merge the options.  It's probably also going to
> depend on which test scenarios that various file system developers'
> test setups choose to use....

The big question I have is: for at least the standard -g all runs, does
this decrease the number of tests selected?  AFAICT all it does is
converts mkfs option parsing _fail into _notrun, but a 35k shell script
patch is a lot to take in.

If it doesn't change the number of tests selected to run then I think
I'm ok with this.

--D
