Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6230D2B9A2;
	Fri, 22 Nov 2024 16:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732292028; cv=none; b=DPQvYkAv70ttdeGlqvzLQlf6YLLPumsp/e+JqAcIE09yOXzWtRFW04jkr0DHowqpEePkJhz9dMMxbRdVJuDB0WJaGCrTPpRB2LPi0vQwyew1Levy7bAJZ7x9kanlPt5hiSS+xrVX9mDhZsC/ToRDzvEVP1WoOKYpKoUDC3wSt00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732292028; c=relaxed/simple;
	bh=ivLgztwFNuW6hdtpDAHKu7YY/OIA100XHYZkWddd9Nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pt9IRFhVoyAUIyUCMj/uMinE1Kywr1N+6zPZtR7Md0E+pVMPoCbfFRpxCl7P9tMV1/lJ6eHLC3s9TROhIFITSMxfxNm+Z59Ked6BS3r+56J5RNgoE+SAfmOzs5mCL551YnoMou3lLtL0MXKfQImJb+VEWUpYlR5k+mH2CAp+Fxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cq8E6kCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cq8E6kCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A68C4CECE;
	Fri, 22 Nov 2024 16:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732292027;
	bh=ivLgztwFNuW6hdtpDAHKu7YY/OIA100XHYZkWddd9Nc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cq8E6kCqfo4ZnKW5n3shwh0ydUA5AdfCGXeDpQvdDhJxBrnx2ZLIQb+fSrVeuo2Ra
	 H5OS2MGKk21viRcGMgOXXbNIoid/fyB2DrTC1PxKSEqviNco45KS5nTT31Gmcn+7un
	 oM1j7IUBdiK3c4hAKX344Puw8UvzCvZAl4v8CujjLVz6fN1p3+PDlP5hcmNavQXcfT
	 4POr/2lyGLCweTLA+jONXz8GLw9pncLBkQsY0DxbCcZ5xle3O6rXWT8xo/5uF57gGu
	 /gyuIJ/CBMSpqqdbaQ9W60bPixi4E2dOV7MKBHoj53VZlm9EUUR6F77VzDk/LdanZi
	 8kF6NYWTcB/Dg==
Date: Fri, 22 Nov 2024 08:13:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@redhat.com>,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 01/12] generic/757: fix various bugs in this test
Message-ID: <20241122161347.GA9425@frogsfrogsfrogs>
References: <173197064408.904310.6784273927814845381.stgit@frogsfrogsfrogs>
 <173197064441.904310.18406008193922603782.stgit@frogsfrogsfrogs>
 <20241121095624.ecpo67lxtrqqdkyh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20241121100555.GA4176@lst.de>
 <Zz8nWa1xGm7c2FHt@bfoster>
 <20241121131239.GA28064@lst.de>
 <Zz8_rFRio0vp07rd@bfoster>
 <20241122123133.GA26198@lst.de>
 <Z0CL9mrUeHxgwFFg@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0CL9mrUeHxgwFFg@bfoster>

On Fri, Nov 22, 2024 at 08:49:42AM -0500, Brian Foster wrote:
> On Fri, Nov 22, 2024 at 01:31:33PM +0100, Christoph Hellwig wrote:
> > On Thu, Nov 21, 2024 at 09:11:56AM -0500, Brian Foster wrote:
> > > > I'm all for speeding up tests.  But relying on a unspecified side effect
> > > > of an operation and then requiring a driver that implements that side
> > > > effect without documenting that isn't really good practice.
> > > > 
> > > 
> > > It's a hack to facilitate test coverage. It would obviously need to be
> > > revisited if behavior changed sufficiently to break the test.
> > > 
> > > I'm not really sure what you're asking for wrt documentation. A quick
> > > scan of the git history shows the first such commit is 65cc9a235919
> > > ("generic/482: use thin volume as data device"), the commit log for
> > > which seems to explain the reasoning.
> > 
> > A comment on _log_writes_init that it must only be used by dm-thin
> > because it relies on the undocumented behavior that dm-trim zeroes
> > all blocks discarded.
> > 
> > Or even better my moving the dm-think setup boilerplate into the log
> > writes helpers, so that it gets done automatically.
> > 
> 
> A related idea might be to incorporate your BLKZEROOUT fix so the core
> tool is fundamentally correct, but then wrap the existing discard
> behavior in a param or something that the dm-thin oriented tests can
> pass to enable it as a fast zero hack/optimization.
> 
> But that all seems reasonable to me either way. I'm not sure that's
> something I would have fully abstracted into the logwrites stuff
> initially, but here we are ~5 years later and it seems pretty much every
> additional logwrites test has wanted the same treatment. If whoever
> wants to convert this newer test over wants to start by refactoring
> things that way, that sounds like a welcome cleanup to me.

Ugh, I just want to fix this stupid test and move on with the bugfixes,
not refactor every logwrites user in the codebase just to reduce one
test's runtime from hours to 90s.

It's not as simple as making the logwrites init function set up thinp on
its own, because there's at least one test out there (generic/470) that
takes care of its own discarding, and then there's whatever the strange
stuff that the tests/btrfs/ users do -- it looks fairly simple, but I
don't really want to go digging into that just to make sure I didn't
break their testing.

I'll send what I have currently, which adds a warning about running
logwrites on a device that supports discard but isn't thinp... in
addition to fixing the xfs log recovery thing, and in addition to fixing
the loop duration.

I guess I can add yet another patch to switch the replay program to use
BLKDISCARD if the _init function thinks it's ok, but seriously... you
guys need to send start sending patches implementing the new
functionality that you suggest.

--D

> Brian
> 
> 
