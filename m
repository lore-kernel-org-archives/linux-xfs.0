Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3CC200B8B;
	Wed, 14 May 2025 08:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747209634; cv=none; b=AOht8RBdb73fyWdJqCiU4GAYp+on9rCjW4by0biyIDW1KxgsApsvwG4RGRGbprfMEdaEELmnoCzR0895tRpykTFzrfmdxaiMYJyv9Ew5LUnEAqa3PclVnoNsPjmzFuADKS7j89Weeb+y5xrGY0Z3Umi1VgMqfeFwMNVbymAXkNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747209634; c=relaxed/simple;
	bh=diQeYPgCeCl0N4zVT0rzgL76qvtcdcDvP3VwTZvxUS0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qU0hvZ40Q5z34Y/VLHxA4cfnqRYucH36Y1rK06HneCg+6nXgvIHAcBtkA3xjrTlZ/E/xJOr2l7+v8G2ckBKLtkZ8/jdiSUqSgzRbfRZjm0fFa4iADWsJGhasKkm7XlwSF+mX59u86aIGOwtdrdGdoN62AyBDgdibEoWe+31qONc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E8UOcswx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E8UOcswx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78F0C4CEE9;
	Wed, 14 May 2025 08:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747209633;
	bh=diQeYPgCeCl0N4zVT0rzgL76qvtcdcDvP3VwTZvxUS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E8UOcswxhSQiVKtt3m8rF2e4HEHAI8GK4L0ZKhFmmQIqVUZSURnS91joR0W9txWkz
	 lNJwj/G05D50OQHBGNOyZSb3dPWheiCtPPQg4JvNnZIodthqSY44bskpcHPQ8V5Pja
	 B84ynZq3CP8KXJcKq9C85zWVud8oPBsYraPSr45mGEoxEuuKcuCCwd1IujRzsuReRi
	 kUTUA0JODOWheKvowY8sg+Sf9f3FGkWouRExzHA0+sfrSk4qKWTdagx2VxfoYoHTD8
	 mnR0finwb+WOuOVSNYcPyBdagljhUU1H/lzYvE28Q6g2ke6QztFSg5yWKYxQIT6GYm
	 9XNh6N8TlarnA==
Date: Wed, 14 May 2025 10:00:28 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, 
	cen zhang <zzzccc427@gmail.com>, lkmm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: mark the i_delayed_blks access in xfs_file_release
 as racy
Message-ID: <ymjsjb7ich2s5f7tmhslhlnymjmso5o2lsvdoudy3dtbr7vjwk@moxzvvjdh6zl>
References: <20250513052614.753577-1-hch@lst.de>
 <aCO7injOF7DFJGY9@dread.disaster.area>
 <FezVRpM-CK9-HuEp3IpLjF-tP7zIL0rzKfhspjIkdGvS3giuWzM9eeby5_eQjL5_gNG1YC4Zu0snd2lBHnL0xg==@protonmail.internalid>
 <20250514042946.GA23355@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514042946.GA23355@lst.de>

Hi.

On Wed, May 14, 2025 at 06:29:46AM +0200, Christoph Hellwig wrote:
> On Wed, May 14, 2025 at 07:37:14AM +1000, Dave Chinner wrote:
> > On Tue, May 13, 2025 at 07:26:14AM +0200, Christoph Hellwig wrote:
> > > We don't bother with the ILOCK as this is best-effort and thus a racy
> > > access is ok.  Add a data_race() annotation to make that clear to
> > > memory model verifiers.
> >
> > IMO, that's the thin edge of a wedge. There are dozens of places in
> > XFS where we check variable values without holding the lock needed
> > to serialise the read against modification.
> 
> Yes. And the linux kernel memory consistency model ask us to mark them,
> see tools/memory-model/Documentation/access-marking.txt.
> 
> This fails painful at first, but I'd actually wish we'd have tools
> enforcing this as strongly as possible as developers (well me at least)
> seem to think a racy access is just fine more often than they should, and
> needing an annotation and a comment is a pretty good way to sure that.
> 
> > Hence my question - are we now going to make it policy that every
> > possible racy access must be marked with data_race() because there
> > is some new bot that someone is running that will complain if we
> > don't? Are you committing to playing whack-a-mole with the memory
> > model verifiers to silence all the false positives from these
> > known-to-be-safe access patterns?
> 
> It's not really a "new bot".  It has been official memory consistency
> policy for a while, but it just hasn't been well enforced.  For new code
> asking if the review is racy and needs a marking or use READ_ONCE() and
> WRITE_ONCE() has been part of the usual review protocol.  Reviewing old
> code and fixing things we got wrong will take a while, but I'm actually
> glad about more bots for that.
> 

I agree with you here, and we could slowly start marking those shared accesses
as racy, but bots spitting false-positivies all the time doesn't help much,
other than taking somebody's else time to look into the report.

Taking as example one case in the previous report, where the report complained
about concurrent bp->b_addr access during the buffer instantiation.

This seems to be covered by the access-marking.txt doc:

"
...
Churning the code base with ill-considered additions of data_race(),
READ_ONCE(), and WRITE_ONCE() is unhelpful.
...
"

Then:

"
...
Use of Plain C-Language Accesses

2.	Initialization-time and cleanup-time accesses.	This covers
	a  wide variety of situations, including the uniprocessor
	phase of system boot, variables to be used by not-yet-spawned
	kthreads, structures not yet published to reference-counted
	or RCU-protected data structures, and the cleanup side of any
	of these situations.
...
"

So, I think Dave has a point too. Like what happens with syzkaller
and random people reporting random syzkaller warnings.

While I appreciate the reports too, I think it would be fair for the reporters
to spend some time to at least craft a RFC patch fixing the warning.

In this case for example, the reporter explicitly mentioned data_race()
annotations, so, why not just send a patch attempting fix the warning instead of
asking somebody else to do that? IMHO, somebody fidgeting with KCSAN has enough
skills to craft such patch. Of course I might be wrong here, but tweaking debug
knobs over the kernel and asking somebody else to look at the results doesn't
seem scalable.

Cheers.
