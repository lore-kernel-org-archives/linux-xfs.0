Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5F6152534
	for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2024 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721744273; cv=none; b=PX4p0flu8I72QmI96ViaSk+TRus1ACPrtzQHgxwT4Zvo3i+k/DsbvSUqIlMlqA2yz+fDYds7wk9hDSOBJVjvhrPRSs0Etmf5cUhNX89ikBm0ADmE1RlP8dAIj+QZvM+0Hc+AwtPzh26Ctz7VrX0mO30AofrazXnykET3l6G0XYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721744273; c=relaxed/simple;
	bh=9PpDrYuo25dApKZcxMFaecAo701EWpEvGrXliapIEy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fpw87YRmYIq+YPu6AnniE52/u3o4os8il57XIVhDFUbD/0dE8EpZeeGNxb1RCudguOO6q5und3b696Gv7vHb18Ro40mnK66iHb+FNieszJZFK7GtFTlQex+/FfUWGvftnRMTodgDNrVzD1vRi3tiTEd/eCzDfKEDleTHoP2pZv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=Nn6HZ1vx; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="Nn6HZ1vx"
Received: from cwcc.thunk.org (pool-173-48-115-17.bstnma.fios.verizon.net [173.48.115.17])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 46NEHPW2017290
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jul 2024 10:17:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1721744247; bh=5FuwJxfx4pnJM5RAur/rzO3G0hUgblHnrklHQN2/DlY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=Nn6HZ1vxOUjeW8hTQNoNiV1gQQheN/mUlrZESfJoopXyEVvhHzMSmimkIePfWn7sT
	 uEPuadQZIWkNqrJCsY3ZG9G6QOauQY8OsI8QzKcjJkpDqX4Od1XbdibnCvJ+floI7n
	 um803S3wxbTx6zZBjvgliMPGCz6tgd26cyvhPdh6vgk4EDkEjdiBPb6T6aX3TGV33P
	 yyu/1Z6HVtHY2LQZRTk2ntTH4hJ67zJZpeDHwxTzi7m7TSj6CBZReZNnizp7eibxK4
	 guin3ZUUavJdV6RC7vs60BKsDtufYXmGWXakpxf8bTQN24z0FW3EkiHFZg3cw89z32
	 pqglfERH03GqQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id D56B915C0300; Tue, 23 Jul 2024 10:17:24 -0400 (EDT)
Date: Tue, 23 Jul 2024 10:17:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Christoph Hellwig <hch@lst.de>
Cc: Zorro Lang <zlang@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: RFC: don't fail tests when mkfs options collide
Message-ID: <20240723141724.GB2333818@mit.edu>
References: <20240723000042.240981-1-hch@lst.de>
 <20240723035016.GB3222663@mit.edu>
 <20240723133904.GA20005@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723133904.GA20005@lst.de>

On Tue, Jul 23, 2024 at 03:39:04PM +0200, Christoph Hellwig wrote:
> 
> At least in my case it's not really by overriding.  E.g. if I force
> an allocation group (or block group in extN terms) to a specific size
> and then want a log that is larger than that, changing the AG size
> is generally a bad idea, and a clear warning to the user is simply the
> better interface.

Is it just "a bad idea", or "it won't work"?  I can imagine that
sometimes we want to have tests that do things that are generally a
bad idea, but it's the best way to force a particular corner case to
happen without having to run the test gazillions of times?

I do remember some cases where when we were using a 1k block size, the
test wouldn't actually work because the file system needed to be
bigger or the metadata overhead ended up causing an ENOSPC too early,
or something weird like that.  So that was a case were the merging
would _work_, and in fact was testing a combination that we actually
wanted to test --- but we had to adjust the test subtly so it would
work both on a 4k block size and a 1k block size.  I don't remember
which test it was, or we hacked it, but I'm fairly certain it's
something we've done before.  It's messy.

> Merging the options is what we're currently doing, and it works ok
> most of the time.  The question is what to do when it doesn't.

No matter what, it seems like we'll have to look at each of these
tests and treat them on a per-case basis.  We could have options which
allows the test to specify that it shouldn't be merging; but then we'd
still have to decide what we need to do.  And what do we do if we
don't want to merge for ext4 and xfs, but it would be useful for btrfs
(for example) to merge the options.  It's probably also going to
depend on which test scenarios that various file system developers'
test setups choose to use....

						- Ted
