Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD539344031;
	Sun, 27 Sep 2026 22:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790549982; cv=none; b=VKukMAGsnwd0AaQDj4dp9ED6b34PENzigMyRfp/CUXsiyhnKN0ByIl1z+YeLi3a6nEslAjkNqImJpDh3d5yPOl2c4aYsWq2zIxJfyK7lC/bjnrudp3H3x5cIqYD7Ebdej55dS63jDSW8sFOJtmexq8Cw3ENziz1SOE1doSLMbgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790549982; c=relaxed/simple;
	bh=DSPKCCvXWwkhuO2V9MElUWg4NwtFtUeJ3ScX9mLmsfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UEAHDCm0S0/ZFESBzcdvMFt9SpvJSra23Nt3Znb90OBxQM9ZA4N2PmA3uKA8DegBmKYAaMxx9iHzx/OK4lWpkmQPR9qmb9gibPhZ5xHNSaK2myRxl4K0v0cbEt40fe5hvjjOXFYCBtT6y3/gxWsCmduBhHsayW4cT57wQjipCqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AzJnptY2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AzJnptY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02651F000FF;
	Sun, 27 Sep 2026 22:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790549980;
	bh=Hq1LKObVOhK5OwpylNLhHyrxziCSH7fNn6E55vubs6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AzJnptY2Q8e+TSLDWCylLGqQvJ2P4JtQ00HbHk2vsDRsxuLlXueL1/rIVvTUQzMDa
	 ALDuPnTXFcBI54byv58HaHVid0yZRJh7t8J5EhS5+wGbIy7OhzRd746lbibXokyKBg
	 472DTOjWgNGYPehCXF1nAR7bEbNwP5xDTM+n11Obi4H84gOreafXn9tImkTzPsgJkZ
	 iN+t4T+74RS15ZPaMv1HsFA3BEFyfSCm9FfA46k37ryi4QjQF0tv0yjBLTUk/McF4G
	 ZvzDkFz1bB9gM0ZAelk8IUgUx337u/i5M48k4mb8wHV9EBDvNCTc10Z11TsJr6Huvm
	 YuLVLI/51swSg==
Date: Mon, 28 Sep 2026 08:59:31 +1000
From: Dave Chinner <dgc@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: support for RT data checksums
Message-ID: <armf05yfzhSBUsUh@dread>
References: <20260924100032.2733101-1-hch@lst.de>
 <arWpyhFyV3ouYAEx@dread>
 <20260925062710.GA3798@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925062710.GA3798@lst.de>

On Fri, Sep 25, 2026 at 08:27:10AM +0200, Christoph Hellwig wrote:
> On Fri, Sep 25, 2026 at 08:52:58AM +1000, Dave Chinner wrote:
> > There's new buffer and inode locking in transactions,
> 
> Not sure what is new about that.  Tere is a single new transaction,
> which logs a single buffer per transaction.  Not exactly new and
> dancy.

You haven't answered any of my concerns - you're just handwaving
them away and....

> > and there's a
> > whole new buffer cache interface to "read a buffer", and that is
> > used to open code reading checksum buffers and joining them to a
> > transaction rather than using the existing xfs_trans_read_buf...()
> > interfaces.  That in itself needs careful consideration, and clear
> > justification for why it must be duplicated to stand outside all the
> > existing BLI/transaction APIs, especially given all the "use the new
> > async buf read interface to do sync buffer reads" behaviour across
> > the patchset that could just use the existing interfaces.
> 
> I'm not sure what to make of this.  The paragraph almost reads like
> AI slop to me.

... calling the concerns of an experienced engineer "AI slop".

I'm so disappointed right now.

You're better than this, Christoph. You know better than to attack
the person instead of addressing the technical concerns they've
raised. Calling the concerns of an experienced engineer "AI Slop" is
also pretty insulting.

You also know this has a chilling effect - how many people are going
to be willing to say anything negative about your code, if all they
get from it is a bunch of insults in return?

I don't tolerate people who behave like this towards me or other
team members anymore. "But I write lots of code" is just not good
enough anymore, Christoph. You need to do better.

FWIW, let's address the "AI Slop" aspect. I don't need to us an LLM
to review code - I know the XFS code base as well as you do,
Christoph.

I hadn't even considered passing your code to a LLM yet to see how
many holes I can poke in it. Everything I wrote document concerns my
own brain raised  when doing an initial high level scan of the
patchset. I always do that first so I don't waste time (or tokens!)
doing detailed review on something that needs deeper rework before
it is anywhere near ready for merge.

That scan raised lots of questions in my head about the change, and
so I documented some of my concerns and asked for more detail about
how all this new functionality is supposed to work to be documented.
Not just for me right now, but so there is a permanent record of the
design for future reference.

Performing critical analysis and asking for more detail to be
documented is not "AI Slop". A LLM would just plow on through with
whatever misunderstanding it started with and produce slop. It is
very much a human behaviour to stop and ask for more context,
detail, documentation, etc to address missing knoweldge before going
any further.

If you don't want meaningful review of this code, then just say so -
don't insult the people who spend their own time tryng to understand
the new functionality well enough to review it...

> The rationale is pretty clear and documented: it
> turns two dependent reads into two reads that work in parallel.

Maybe that is clear to you, but it certainly isn't from my initial
reading of the patches.

I don't have all the unwritten knowledge that is in your head that
you didn't document. I've never discussed this code with you, I have
no background on how it is supposed to work, etc. I am coming in
-cold-.

I have not been able to find clear, logical descriptions of
the algorithms for reading and writing checksums, the data
intregrity protocols, the crash recovery protocols, etc. At this
point, the only way for me to to understand details like this is to
-reverse engineer the design from implementation-.

That's the problem - you've presented an implementation without an
overall design being documented, and then asking people to review
the implementation without any other context. I need to understand
the design before I review the implementation, as that is the only
way I can perform a decent -implementation- review.

Indeed, people often complain that it is too hard to adequately
review complex changes, and this is one of the reasons: we are
presented with an implementation, and -zero- design/architecture
context from which to understand the implementation that has been
presented. We need to fix that.

> > I'd also like to have the format of the new on disk log item format
> > structures clearly documented (because we're going to have to
> 
> There is no new log item format, it uses the standard buffer log format.
> The buffer payload is somewhat new.  It is is the standard rt format,
> a xfs_rtbuf_blkinfo followed by the real payload, which is an array
> of checksums.

Yes, the buffer payload is new, and it uses a new BLF flag that
indicates it contains regions with some new on-disk format. And
there are interactions with fsync and data integrity requirements.
Document them!

> > validate them) at recovery time, and also have a clear explaination
> > of the data vs metadata ordering algorithms that ensures that
> > checksums are always valid in crash+recovery situations, especially
> > w.r.t. data integrity operations like fsync.
> 
> I think I explained it pretty well,

You didn't, and that's the problem I am asking you to address.

> but happy to repeat it again:
> The zoned write path writes data first, and then records bmap, rmap
> and used space tacking in the zone from the I/O completion handler.
> The rtcsum code builds on that and only logs that csum from that
> same I/O completion handler.  I.e. that data must have reached the
> device for the code to log it to be even called, and for devices
> with volatile write caches the generic cache flushing must work
> (it did not until recently, but the verification of this code found
> that bug and it is now fixed upstream).

So document the design in the first patch in the series! In detail,
in the tree alongside the code. That gives all reviewers the
necessary context to understand what comes next in the patchset.

Indeed, I ask this not just for reviewiers, but for anyone coming
along in the future that needs to understand how data checksums work
because they need to triage a bug, add new functionality, need to
optimise for performance, etc. Just because you understand how it
works and what you wrote in the commit messages, it doesn't mean how
it is supposed to work, why it works, or why it was implemented in
the way it was is obvious to anyone else.

Documenting the design helps -everyone-, not just now, but well into
the future as well.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
