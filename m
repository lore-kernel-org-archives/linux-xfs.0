Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A132534EF14;
	Fri, 31 Oct 2025 17:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761932855; cv=none; b=jwC1DShLIaJHm88bgD97ZXmDyNO1i8w568AQnFHuQlddxfUjqfSrpvLUwnuXM3eT6ShmTNffFkggW3hX3Ph/t03U9yZD4O5MonPWBIGqpqylZTYgloDilB3Ts1wwXX/nBl0jchocBxSrvO3VKwdK7nWcNO4s34UuhN+u12Khizk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761932855; c=relaxed/simple;
	bh=QYNCbVboIyAG/M4KnYvYdhCRbkd+KqDrsyXRpF7+N0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bXQ1zd0sK261S+GulvqCHdNomDaxhmZfSln5Do8Hq9mgw/Kkf5KTdsyHo+U8rRqEG8EzIRUQPgi6QjZaXGYPEC51oJ4DI5gqtu7hCu9/5qFoYc0TeXqkOvKP7QWBIynH5vRX1v1gE9yaahmiE+ytg4pY/mzjKkX+iH2qalv7rO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fb+37qJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fb+37qJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6E1C4CEE7;
	Fri, 31 Oct 2025 17:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761932855;
	bh=QYNCbVboIyAG/M4KnYvYdhCRbkd+KqDrsyXRpF7+N0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fb+37qJt+rK3tbME64cnPGBhGOeQF/HKiEy0kvHKy4VPKFtNQCQgWv9073tx5zDql
	 9AEqpLxzGWQ/zjjsr+KonaPKvrZGmtNqztrnUdXcKS5ag558OYyg9K86A9IKV2yIHl
	 lizcVJ/1dAT28U3SJf+xsGd5PoLibs0ADF+q9J9KmA1KFC8gqXIUlOPKQVMWG813jg
	 DeC553v19e28HXhY4aDAC9thP1htCZPIdv8A6WHdydn9U1c8XCOkrqxYNTZx1WiHtX
	 6ZMWBYNLoVUuXxnMxZJIrCuqXDl1XbazrwkAD55NiRo8eHaGUVcvcKwacZ62GCR3E5
	 u94PpeXF4CXDw==
Date: Fri, 31 Oct 2025 10:47:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: zlang@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/11] generic/778: fix severe performance problems
Message-ID: <20251031174734.GD6178@frogsfrogsfrogs>
References: <176107188615.4163693.708102333699699249.stgit@frogsfrogsfrogs>
 <176107188833.4163693.9661686434641271120.stgit@frogsfrogsfrogs>
 <aPhbp5xf9DgX0If7@infradead.org>
 <20251022042731.GK3356773@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251022042731.GK3356773@frogsfrogsfrogs>

On Tue, Oct 21, 2025 at 09:27:31PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 21, 2025 at 09:20:55PM -0700, Christoph Hellwig wrote:
> > On Tue, Oct 21, 2025 at 11:41:33AM -0700, Darrick J. Wong wrote:
> > > As a result, one loop through the test takes almost 4 minutes.  The test
> > > loops 20 times, so it runs for 80 minutes(!!) which is a really long
> > > time.
> > 
> > Heh.  I'm glade none of my usual test setups even supports atomics I
> > guess :)
> 
> FWIW the failure was on a regular xfs, no hw atomics.  So in theory
> you're affected, but only if you pulled the 20 Oct next branch.
> 
> > > So the first thing we do is observe that the giant slow loop is being
> > > run as a single thread on an empty filesystem.  Most of the time the
> > > allocator generates a mostly physically contiguous file.  We could
> > > fallocate the whole file instead of fallocating one block every other
> > > time through the loop.  This halves the setup time.
> > > 
> > > Next, we can also stuff the remaining pwrite commands into a bash array
> > > and only invoke xfs_io once every 128x through the loop.  This amortizes
> > > the xfs_io startup time, which reduces the test loop runtime to about 20
> > > seconds.
> > 
> > Wouldn't it make sense to adopt src/punch-alternating.c to also be
> > able to create unwritten extents instead of holes for the punched
> > range and run all of this from a C program?
> 
> For the write sizes it comes up with I'm guessing that this test will
> almost always be poking the software fallbacks so it probably doesn't
> matter if the file is full of holes.

...and now running this with 32k-fsblocks reveals that the
atomic_write_loop code actually writes the wrong value into $tmp.aw and
only runs the loop once, so the test fails because dry_run thinks the
file size should be 0.

Also the cmds+=() line needs to insert its own -c or else you end up
writing huge files to $here.  Ooops.

Will send a v2 once the brownpaperbag testing finishes.

--D

> > Otherwise this looks good:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Thanks!
> 
> --D
> 
