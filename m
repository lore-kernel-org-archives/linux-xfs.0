Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0223F9F2D;
	Mon, 21 Sep 2026 22:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790029157; cv=none; b=SzxvDkgjgSNDpo4ZEtTTJGZavkxly4LqZQSOL2gVMWhyotMtXQMDuoUv4RiuYuS3J8HBZn41TN9EufP+SuLQRdmp+ZzNbsxjPyLCHXY0PCdYo9M3dr7bdne92MfeO0ojGtBgjXE5BQM7sF2C6XzYvUBv+oWueA1hvxHm4uH0Yzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790029157; c=relaxed/simple;
	bh=b5ZksdflgV+zrh3EiCXBE3eTHwA25Y0hkMKbpDgQUKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LEdL13SdWcn+wkHtWIuy6uJFnEM6Dd7wh9hSiue3lqa3hUlKFvh+ZqjmicXa0lAmIiW5xFG59hbV4rja+A1k3kOHwDNUCoEgN7QjEK4XDtAiw5DfO1+NLZMyUGSHkDJz/ayq5ZX7KaYXo/jYeODWZeG6WlrV8PwjtoHSaFyHWuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gA5nmgzY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gA5nmgzY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A752F1F000FF;
	Mon, 21 Sep 2026 22:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790029155;
	bh=s+bV+8HfdSyVZngufDuRq5szpgPIBAkhen9uqlwvL+Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gA5nmgzYE1JTwLF2zOCf6GZeJGthkZibJKOBqN7wItiAph+Lz1hBxbVSVC7VxUe2h
	 /X7K2z8XY+A3EcQrBXxTIOxD5IRPhpor2ElLR9GCQgty6BTZni0i/O4+XoR8hT63pV
	 Zb/2zUWZBAkSTPrPE7gGlT/VG4Ezbq3+cQABQgRoXyLDBF/uWmj5YQigwEHCcW+BcV
	 Av9ukr4GMz/M04fXxap3YOUyYpLwsdkr9MoIiRJDvyC4pDz6cRTLzr0WmWSDwdudtc
	 KSds+5TlzUIRbpJTcD7G0qzP87Hmc2onaQ939T7U1AEsnL17uQnUvZ1ELI5gNo5CRN
	 9vkBDFYrrhe7Q==
Date: Tue, 22 Sep 2026 08:19:07 +1000
From: Dave Chinner <dgc@kernel.org>
To: Jeffin Philip <jeffinphilip14@gmail.com>
Cc: cem@kernel.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] xfs: change xfs log item refcount design
Message-ID: <arGtW9KfyvFbcz60@dread>
References: <aqsYHjEp-7TM1h8F@dread>
 <20260917035104.10762-1-jeffinphilip14@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917035104.10762-1-jeffinphilip14@gmail.com>

On Thu, Sep 17, 2026 at 09:21:04AM +0530, Jeffin Philip wrote:
> On Wed, September 16 2026 at 10:28 PM, Dave Chinner wrote:
> >On Fri, Sep 11, 2026 at 03:55:00PM +0530, Jeffin Philip wrote:
> >> This patch series is the first of the series where we attempt to convert
> >> the XFS Log item reference counting design to be more generic
> >> compared to the previous type-specific state to fix the "zero
> >> refcount but in AIL means alive" state. The patch series follows
> >> instructions outlined here[1].
> >> 
> >> Obviously, the wrappers will be integrated in type-specific functions
> >> later on.
> >> 
> >> No behavioral change as of yet.
> >> 
> >> [1]: https://lore.kernel.org/all/aqI6v-_dc2DDSbgB@dread/
> >> 
> >> Jeffin Philip (2):
> >>   xfs: add lockref and generic helpers for refcounting
> >>   xfs: change xfs_trans_ail_delete return type to bool
> >
> >It's great to see you starting on this, but there's not much point
> >in just posting wrappers that aren't used by anything. Until there
> >is code that uses them, we can't really say anythign useful about
> >the wrappers. e.g.
> >
> >Is the API optimal? Don't know.
> >
> >Is open coding the init correct for the generic case or is that just
> >projecting an antipattern from the BLI reference counting? Don't
> >know.
> >
> >And so on. Hence it's best to present the wrappers with the code
> >that then uses them so we have the necessary context with which to
> >review them.
> 
> The BLI changes have almost been finished and I am testing them. The
> reason I did not post it is because I wanted it to face more proper
> review and that is likely to be stricter when the patches are
> few. I could still write the entire implementation and post it as a
> giant patch series provided it does not fatigue the reviewers from
> reviewing several tens of patches at a time. Until then, I feel like
> it mould be much better to post 1 implementation step at a time in 1
> patchset. If you prefer otherwise, that can be done too.

I'm not sure it wise to only convert a single item type at a time,
as there are intricacies in different log item life cycles that may
expose difficult to solve issues further down the track. If we've
already converted and merged some of the code before we find that it
needs a fundamental rework, then that's worse that asking reviewers
to review a large patchset.

e.g. the AIL needs to take reference counts and they need to be
factored into log item life cycles, especially the shutdown
processing of items in the AIL.  Right now the AIL is not
responsible for removing items on shutdown because it does not hold
a reference to them. Changing the AIL to own a reference to the log
item means that there is a good chance that the shutdown behaviour
for items in the AIL may need to change...

So I'd be inclined to ensure at least have one of each group of item
types is fully converted (e.g. buf, inode, dquot, EFI, quotaoff) so
that most of the crouching tigers in the design have been flushed
out before asing for code review.

You can also push it to a git repo somewhere so people whoa re
interested can look at it and give early feedback before you are
ready to post it to the list for review...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
