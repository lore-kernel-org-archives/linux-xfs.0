Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C150213B5A9;
	Fri, 22 Nov 2024 16:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732293439; cv=none; b=mlL8vlBMx0xypHsNkM+zwBat2zeN0vR997e2lWFBZ69y+/MigpI48bpVjSI4KcaWL3ynyQjg11EBHPKfUR0KvQb3glwuZfveiguf7cn9iCsFPjtVI97xjSbZ4B1wXNqJCqvZz2iYXEv+iYFfEd5z69Ldx5Pj4yLc2s/bZkm1nEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732293439; c=relaxed/simple;
	bh=M1HB1rLV6Jzr8lTduDgqG9VkAqAAbhVK+Avzn0BhABc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DD7iKYLSAJZPETXnF95FuaF/aY4f39jgYHEwGTyVp9EdggQkezj8IlSggQbS4pSzQlU6bIpoey31Bdo0u/5ejeM+vy2GV+g7SmQqCRAPZYu2qZMZkRTVf3W6GrbEJ1Sr8E0zcZ8bugrIqIo3zCQAjYrQQ8IMjVLLFgRnGupb/H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q8/NF/nQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q8/NF/nQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504BFC4CECE;
	Fri, 22 Nov 2024 16:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732293438;
	bh=M1HB1rLV6Jzr8lTduDgqG9VkAqAAbhVK+Avzn0BhABc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q8/NF/nQmXd9aMs8Q6QYNTCiE5OoAIkp/D/202gt7IbNhlD5QkrC9a6WRfCi+dnPT
	 lbaQffrvwtjm70yMSkhr1xuGIWjnRzBpoVxbSw1Ecba9iFnSFnoEB7FzhjKC2IHvPo
	 jUiLYDBsU7VSwcYq6V5mhkG83JLonQBA4kod/SRi0Dbbm/zji+0Evfn2blWfsXnFZ9
	 jdFsZ23okYUCyhkg163glEpBqptIEIr4kCKBZjbC4cz1C7fbjP74HSWida+wpNEOd/
	 6LtvBIrj8iQYy60dlZT3pFByjEJAw2kA7YME8M86I7EYLok3LbOvgcQw576yNmgNCU
	 Zxuna9KC39usg==
Date: Fri, 22 Nov 2024 08:37:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@redhat.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241122163717.GJ1926309@frogsfrogsfrogs>
References: <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs>
 <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241121100555.GA4176@lst.de>
 <Zz8nWa1xGm7c2FHt@bfoster>
 <20241121131239.GA28064@lst.de>
 <Zz8_rFRio0vp07rd@bfoster>
 <20241122123133.GA26198@lst.de>
 <Z0CL9mrUeHxgwFFg@bfoster>
 <20241122161347.GA9425@frogsfrogsfrogs>
 <Z0CyVHd4MmhurX8B@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0CyVHd4MmhurX8B@bfoster>

On Fri, Nov 22, 2024 at 11:33:24AM -0500, Brian Foster wrote:
> On Fri, Nov 22, 2024 at 08:13:47AM -0800, Darrick J. Wong wrote:
> > On Fri, Nov 22, 2024 at 08:49:42AM -0500, Brian Foster wrote:
> > > On Fri, Nov 22, 2024 at 01:31:33PM +0100, Christoph Hellwig wrote:
> > > > On Thu, Nov 21, 2024 at 09:11:56AM -0500, Brian Foster wrote:
> > > > > > I'm all for speeding up tests.  But relying on a unspecified side effect
> > > > > > of an operation and then requiring a driver that implements that side
> > > > > > effect without documenting that isn't really good practice.
> > > > > > 
> > > > > 
> > > > > It's a hack to facilitate test coverage. It would obviously need to be
> > > > > revisited if behavior changed sufficiently to break the test.
> > > > > 
> > > > > I'm not really sure what you're asking for wrt documentation. A quick
> > > > > scan of the git history shows the first such commit is 65cc9a235919
> > > > > ("generic/482: use thin volume as data device"), the commit log for
> > > > > which seems to explain the reasoning.
> > > > 
> > > > A comment on _log_writes_init that it must only be used by dm-thin
> > > > because it relies on the undocumented behavior that dm-trim zeroes
> > > > all blocks discarded.
> > > > 
> > > > Or even better my moving the dm-think setup boilerplate into the log
> > > > writes helpers, so that it gets done automatically.
> > > > 
> > > 
> > > A related idea might be to incorporate your BLKZEROOUT fix so the core
> > > tool is fundamentally correct, but then wrap the existing discard
> > > behavior in a param or something that the dm-thin oriented tests can
> > > pass to enable it as a fast zero hack/optimization.
> > > 
> > > But that all seems reasonable to me either way. I'm not sure that's
> > > something I would have fully abstracted into the logwrites stuff
> > > initially, but here we are ~5 years later and it seems pretty much every
> > > additional logwrites test has wanted the same treatment. If whoever
> > > wants to convert this newer test over wants to start by refactoring
> > > things that way, that sounds like a welcome cleanup to me.
> > 
> > Ugh, I just want to fix this stupid test and move on with the bugfixes,
> > not refactor every logwrites user in the codebase just to reduce one
> > test's runtime from hours to 90s.
> > 
> > It's not as simple as making the logwrites init function set up thinp on
> > its own, because there's at least one test out there (generic/470) that
> > takes care of its own discarding, and then there's whatever the strange
> > stuff that the tests/btrfs/ users do -- it looks fairly simple, but I
> > don't really want to go digging into that just to make sure I didn't
> > break their testing.
> > 
> > I'll send what I have currently, which adds a warning about running
> > logwrites on a device that supports discard but isn't thinp... in
> > addition to fixing the xfs log recovery thing, and in addition to fixing
> > the loop duration.
> > 
> > I guess I can add yet another patch to switch the replay program to use
> > BLKDISCARD if the _init function thinks it's ok, but seriously... you
> > guys need to send start sending patches implementing the new
> > functionality that you suggest.
> > 
> 
> Sorry, I should have been more clear. I certainly don't insist on it as
> an immediate change or to gatekeep the current patch. I'm just acking
> the idea, and I think it's perfectly fair to say "more time consuming
> than I have time for right now" if you planned to just fixup the test
> itself. I may get to it opportunistically someday, or if hch cares
> enough about it he's certainly capable of picking it up sooner.
> 
> For future reference, I'm generally not trying to tell people what to do
> with their patches or force work on people, etc. I realize we have a
> tendency to do that. I don't like it either. It would be nice if we had
> a clearer way to express/discuss an idea without implying it as a
> demand.

/me suggests

"Here's something that we ought to do, though as a separate patchset:
clean up all the $fubar to be $less_fubar.  In the meantime this patch
is good enough for now."

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > 
> > 
> 
