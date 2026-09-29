Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E27A52842D;
	Tue, 29 Sep 2026 14:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790691103; cv=none; b=hvVEqf20d+jUpblGJoAgBw3W/fX473ISEGRDHv+YqG/LM5VzxA5Ds02neOcZHoCQGmTNqXDousuW6o+lA/xtcYp1+W18qKevEFKIcQPeSZPcVw5+3KHEV8yMFP+vP6VQY0aMPf+yWXQ3G3w3fc1gBcrNTvRLQ+vSmHK4VBYAKJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790691103; c=relaxed/simple;
	bh=FICs7ZOfXhNmCkhR2AzsmOkG0Y6ZkMV+ClwNIA6YywY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dsMDIRSITREUGDJcrTkNN0o/BSPyLvSNLMYNrcLmy5OOYqsE9HO86/M8hSIwTqdw4+xlS8HHFHWaYDZcITRf6V0JUQJjA8dVKwC6Q1LRQuwTQOzG4i3pEZCbCB2Bt6uNXJSD68N0duYb+1LRegxHNv9GulahCTPj8FVDMuJUqj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O1MCWa3E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O1MCWa3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013091F000FF;
	Tue, 29 Sep 2026 14:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790691101;
	bh=jBBTy4CPgMElWFcJhEv0l/wBEjegeHrEhmU8acYpceM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O1MCWa3E1r1ZOUGMAWe93uCU+fZhnl5IPIelBmwimhSXK+sJcGsASVxW/SdQvko6h
	 QP5EpPy4Nbs3H9LECJLozfUnmKhtepmyy4uEHoDxj93E5DI29uV2Xx0sx/KcnKaWrw
	 KGnCvgao5LPbvCS+dIgcZ4p66SXltCbq0yimXcbXhpNqjUlSbUKXAEUqFAAdkHuG85
	 CmaDbRhZnnCVEpMLUVV88zWOPueomLsAxbiGwpjQUXDray3fosWlcz76e0oomA+l9k
	 cs0cfEHW3EmWCq0Uo2GsCClECXt74C+SMvJJeG9smAVidMIvvjHwclairIwoeVv1KC
	 kHMGqPgbGMPQw==
Date: Wed, 30 Sep 2026 00:11:32 +1000
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: support for RT data checksums
Message-ID: <arvHFOjF-CD5Vd3g@dread>
References: <20260924100032.2733101-1-hch@lst.de>
 <arWpyhFyV3ouYAEx@dread>
 <20260925062710.GA3798@lst.de>
 <armf05yfzhSBUsUh@dread>
 <20260928052436.GA18925@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928052436.GA18925@lst.de>

On Mon, Sep 28, 2026 at 07:24:36AM +0200, Christoph Hellwig wrote:
> On Mon, Sep 28, 2026 at 08:59:31AM +1000, Dave Chinner wrote:
> > You haven't answered any of my concerns - you're just handwaving
> > them away and....
> > 
> > > > and there's a
> > > > whole new buffer cache interface to "read a buffer", and that is
> > > > used to open code reading checksum buffers and joining them to a
> > > > transaction rather than using the existing xfs_trans_read_buf...()
> > > > interfaces.  That in itself needs careful consideration, and clear
> > > > justification for why it must be duplicated to stand outside all the
> > > > existing BLI/transaction APIs, especially given all the "use the new
> > > > async buf read interface to do sync buffer reads" behaviour across
> > > > the patchset that could just use the existing interfaces.
> > > 
> > > I'm not sure what to make of this.  The paragraph almost reads like
> > > AI slop to me.
> > 
> > ... calling the concerns of an experienced engineer "AI slop".
> 
> No, I call your meandering writing style slop.

And you think that makes what you said any better? Talk about not
knowing when to stop digging...

How hard is it to say "I don't really understand your concern - can
you clarify what you are concerned about?" instead of calling it
slop?

That's would have been a constructive response, and the discussion
then goes an entirely different (and far more pleasant) way from
there.

There are three lines in the commit message and two in your reply
repeating the same thing: "it's for issuing the checksum block read
in parallel with the data read".

I know that - it's just async readahead of the checksum block
followed by a blocking operation that waits for the readahead to
complete.

What I said above is that this async read IO pattern already exists
in XFS - btree traversals do this same readahead/blocking read
pattern to pull sibling nodes into memory ahead of time as we search
sideways across levels. And they do it within existing transaction
APIs, too.

That is, we already have an API that allows async_read+blocking_read
pairs that wait for async readahead to complete.  It also gathers
errors - if readahead IO fails, the blocking read will reissue the
read IO and gather the error if it fails again.

Hence I'm wanting to know why you chose to duplicate that code and
place it behind a slightly different API with slightly different
semantics instead of just using the existing code with a couple of
small tweaks? Why is this new code better than reusing the existing
code?

My concerns about the checksum buffer transactionsi are about not
using existing APIs. By open coding them, you've skipped all the
transaction/BLI recursion detection. i.e. you've encoded an
assumption that a buffer will never get relogged within a given
transaction. You've also encoded that external values bound
memcpy()s in to the buffer and logging ranges to within the buffer
length, but the buffer length itself is never checked. 

I don't know enough about the design to validate these assumptions,
and there is no documentation (code, comments or commit messages)
describing why the code is safe the way it is written...

We also use wrapper functions to set BLFT type specific BLI flags
(inode bufs, dquot bufs, ordered bufs, etc) along with the BLFT
type. These also include asserts to ensure that we call those
functions appropriately. The csum logging code open codes these
flags/types, and there are no asserts anywhere to indicate incorrect
usage of the new BLI flags that csum buffers use. Why deviate from
the existing BLI patterns and APIs?

IMO, if you're going to implement new transaction and BLI
interactions, you need to document and explain how it all works.
BLI life cycle bugs are still an ongoing source of crashes and UAFs
and I'd really like to make sure that these changes don't make it
impossible to fix the life cycle issues and UAFs they result in.

> > I'm so disappointed right now.
> > 
> > You're better than this, Christoph. You know better than to attack
> > the person instead of addressing the technical concerns they've
> > raised. Calling the concerns of an experienced engineer "AI Slop" is
> > also pretty insulting.
> 
> Stop this bullshit. Replay to technical details in the patches if you
> want, or wait for the requested document, but don't write weirdly
> halluscinated high-level concerns.

Clearly you haven't understood why I'm disappointed in you.  If you
don't want to deal with "this BS", then -don't be an asshole-. End
of story. 

> > Yes, the buffer payload is new, and it uses a new BLF flag that
> > indicates it contains regions with some new on-disk format. And
> > there are interactions with fsync and data integrity requirements.
> > Document them!
> 
> No, as explained before and clearly visible even from the full diff
> it does not use any new BLF flag.   See why this discussion is so
> hard?

I meant "BLFT", not BLF - it's just a simple typo. There's no need
to be an asshole over a simple typo, especially as the typo doesn't
materially change what I said (i.e. BFLTs are BLF flags...)

> > Documenting the design helps -everyone-, not just now, but well into
> > the future as well.
> 
> And I've not disagree with this.

But you also haven't agreed to write a design doc yet, either.

Your previous response was pretty negative towards my request -
saying "I think I explained it pretty well" is a fair indication
that you aren't going to write one.

So, are you going to write a design doc or not?

> But next time you think you need one
> just request it, and don't generate pages full of rambling and incorrect
> text.

Four paragraphs to request a design doc and it's scope it is hardly
"pages full of rambling".  Why are you being so obnoxious about
being asked for a design doc?

-Dave.
-- 
Dave Chinner
dgc@kernel.org
