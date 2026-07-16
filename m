Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D4F3D952E
	for <linux-xfs@vger.kernel.org>; Thu, 16 Jul 2026 23:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784245684; cv=none; b=LdlnN3dahC0zN56U/xPZPNM1lCbfhiAtzpVH9e5rBy7BeYz8jwnPxRHCalqkj+qxHBeLJEZyK6nqOqmo9v+zweL34jxp6QkawXh734YwJf8c8bQRdiqabY6838ppfbuf35ngZbH7DrqjS2N3UdHT/KeCcH5N1elpClUNiiGCNoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784245684; c=relaxed/simple;
	bh=xtoQ+CUkfGpU+6OdjVqHce9+/i3djuTIes7nmQTuhXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vs4sUoDC9ayVKGmJJ5IaulUjRSuWw/CYISfoQtbLxeFhuLzzP6YfDMeQTQva8ro4ALfAIPtQODZHPeo717rHcCSh+RTAfDlQtHB8E3dzTF3gJahQK+Hi0Jtln2T55EviWRSGxJIGnicD/1sRqM63S82bz1Pv41rU6DCpNVLhoH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I1BwqHOg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I1BwqHOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD17B1F000E9;
	Thu, 16 Jul 2026 23:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784245682;
	bh=20vYJOt8SrYSSHYMwK7rkFsNZEBuV8/JrdYKhtcliS4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I1BwqHOgqB/2VStPBWjL8ThbOyn/doQeqasDgZQfKbZ4xf3y/MLK0rMgyckV0fjEJ
	 En98cCkLRSjW3SUz17jic0Ok07rfRBuONGlx4mWmRKnzjyeP2op9PnzcGatEKjIBNW
	 h1QLHv3GXnt1C+3DQuy/iT+RyICLe3t8IoAVimm+dhlwPej4DNJKxW6F0Jc4pJlJVh
	 L9uFYu4OVmiwAtelXtEU8B5evrT8XEx49x3WxC99Pm20+bjeTmMF1HZqMp/I8GpIId
	 3RxuN7tlG2A5xtoJ9uxZ8a4a2czn2cMfM2Gbuuv3zmbnFgBWdUrGkydm0+/rGXfy7Z
	 a1npluw0y/LlQ==
Date: Fri, 17 Jul 2026 09:47:53 +1000
From: Dave Chinner <dgc@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>,
	cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [RFC PATCH] xfs: add new policy guidelines for llm-assisted
 patches
Message-ID: <alltqTAwLLMcJfzG@dread>
References: <20260709110006.94905-1-cem@kernel.org>
 <ab8c9529-103d-4e25-b062-1700544a0bdb@sandeen.net>
 <20260709163352.GD15210@frogsfrogsfrogs>
 <alYumOWysqudowaq@bfoster>
 <20260714160332.GD7380@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714160332.GD7380@frogsfrogsfrogs>

On Tue, Jul 14, 2026 at 09:03:32AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 14, 2026 at 08:42:00AM -0400, Brian Foster wrote:
> > > > > +Also, every patch/series submitted must be exercised through xfstests suite
> > > > > +- at least - through the auto group (and others depending on the change) as a way
> > > > > +to add extra coverage through the already existing regression cases and help
> > > > > +reviewers/maintainers through the integration process.
> > > 
> > > What about patches to online fsck, in which case the auto group may or
> > > may not cover it other than incidentally through xfs/28[56]? ;)
> > > 
> > > How about:
> > > 
> > > "Every patch submitted must be exercised through the fstests suite
> > > because good test coverage makes review and maintenance processes
> > > easier.  Ideally, the change should be exercised by a fstest case in the
> > > "auto" group, but another group may be more appropriate depending on the
> > > change."
> > > 
> > 
> > Since some things are not practical to test directly with an fstest, I
> > wonder if we should require or recommend that in absence of a viable
> > fstest, the submitter of an LLM generated patch should include a brief
> > description of how some change was unit and/or code coverage tested.
> > 
> > That way for things that look like hard to hit races, require crafted fs
> > images for log recovery corruption cases, etc., we have at least some
> > indication that the change works and doesn't tickle some other
> > previously unknown problem (like busted error paths, etc.).
> > 
> > IME even these sorts of cases can be coverage tested with custom
> > instrumentation. For example, "I don't have a custom fs image that
> > reproduced this broken log record condition, so I added an if (1) at
> > LINE XYZ to trigger the error check on a standard dirty log test fs
> > image. I confirm it works as expected, doesn't explode the kernel, and
> > the mount fails gracefully."

Here's my take: LLMs are powerful, and they can easily extend
existing tools to do new things. 

We're getting lots of people doing random perutrbations on journals
to find issues, but outside of that we have no deterministic way of
modifying the contents of a journal. LLMs are being used to play the
old game of whack-a-mole; they do it faster than anything else, but
at the end of the day it is still just a game of whack-a-mole.

Lets step back for a moment and look at the bigger picture.

We already have a tool specifically for observing and manipulating
the on-disk format of the filesystem - xfs_db. It can also
deterministically fuzz any metadata structure in the filesystem, and
we have fstests that exercise this capability to validate the
filesystem handles metadata corruptions reliably.

However, xfs_db cannot parse or modify journal structures, so we
cannot use it to inspect, modify or fuzz journal contents.

xfs_logprint can parse the structures, but it can't modify anythign,
and that code is so, so terrible that is needs to be rewritten
completely before it could be used for anything like fuzzing
specific journals structures.

Whilst I've been working far away from XFS for the past year and so
not doing any real dev work in the field, I've been using time
devoted to learning tasks to do some experimental stuff.
As a "learn how to drive LLMs" exercise as well
and trying to learn a bit about Rust, I've been rebuilding
xfs_logprint with Rust and the field-table architecture of xfs_db
to allow robust introspection of the on-disk journal structures.

I did this, because I wanted to be able to decode fragments of
structures that are held in sparsely logged buf_log_items. Having
logprint be aware of what the log item holds (e.g. we have BLFT that
defines the contents) and being able to print the actual structure
that was logged in exactly the same way as xfs_db would print the
structure makes analysing the journal contents so much easier. i.e.
no more manual structure decoding from a hex dump to compare that to
the structure on disk to see what changed in the journal....

I've got logprint half way there - most of the big issues are
solved, I've now in the process of adding support for all the
on-disk structures - dir/attr is next, then intents, and then all
the RT/metadir stuff and it'll be largely complete. It's already
much more useful and robust than the existing logprint code, but
there's still a ways to go before I'm ready to publish the first
prototype.

Once that is done, however, it's not much of a stretch for a
structure aware journal structure parser to be able to perform
targeted modification and rewrite structures. At that point, we have
a deterministic journal fuzzing tool, just like the xfs_db fuzz
command....

Ultimately, I want a combined db/logprint utility to be able to
recover the log onto an ram-based overlay, so when triaging log
recovery issues we can look at the original on-disk structure, the
multiple verions of the modified structure in the journal and in
memory as each version is recovered, all side by side in the one
context...

And, well, if it can do this, then we can probably also do log
recovery in userspace pretty easily, too.

Yeah, that's the sort of experiment I call a "learning task"
because, in the process, I have learnt how to drive LLMs well enough
that I don't need to write code anymore. The LLM functions as my
code editor that is capable of extremely fancy DWIM predictive text
insertion. For someone who hates the process of typing out code,
this has been a revelation.

I can push out the logrpint code I have so far for people to look
at; but it's not really ready for prime time yet and I'm only
mentioning it because the both the reason behind wanting to create
this tool and the process I've been using to build it are directly
relevant to this discussion.

IMO, this is the infrastructure project we should be asking people
spending big bucks on LLM tokens to help us build instead
of playing whack-a-mole on randomly corrupted fs images. Swamping us
with bandaids that don't adidress the underlying issues doesn't
improve the status quo.

We need to be leveraging the vast LLM resources that are available
to the wider community to build the infrastructure needed to make
our software more reliable. We've long complained that we don't have
the resources to tackle these sorts of big issues, but we're now
failing to recognise that LLMs actually provide us with the
resources and capabilities we've been wanting. What is best (and
worst) about LLM capabilities is that it does not require a 
change in available andi/or relevant human expertise to leverage.

In this case, we should be asking the people running the LLMs to
redirect their time towards building infrastructure that allows
deterministic exploration of the -entire- on-disk format variable
space without needing a million monkeys to bash randomly on stuff
until they find something that breaks. The on-disk format is well
defined, and verification can largely be derived from that
specification. With such a verification infrastructure, we can use
it to:

	a) find *all the bugs* deterministically, reliably reproduce
	them and use the LLMs to automate writing and testing fixes;
	and

	b) provide a robust regression test for the on-disk format
	parsers that will highlight when we break something into the
	foreseeable future.

LLMs are a big force-multiplier - we should be encouraging people
with LLM resources and tokens to spend to build the tools and
architecture required to make our software robust. Using them to
play the same old whack-a-mole game might fix existing bugs faster,
but it does nothing to address the underlying vulnerabilities in our
infrastructure, tools and processes that allow the creation of the
bugs in the first place.

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
