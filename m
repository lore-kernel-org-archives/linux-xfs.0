Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000F1233123
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738904746; cv=none; b=tAQ0lu2Glf7WsTJ0bl/13VfyQOvBzMMpqE/zwKsNFiah0eKTx8vvaiFVSd/emnaA2FhKuYph1V+zFbrgwr1Ikq1aOOn7/JoWKuaPxjjXJ/NR5Hp31pOnLPmGAv1wGFS05OJMBSkZakO0QA8XINsf+l55zUbQfOO92RqI8pxESzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738904746; c=relaxed/simple;
	bh=rZIYiEuE1z+R3SHStBz5eUHpv46QrKWyyH9xz3xIjYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j5gRl4pcGhSuyrhdYRQdQy2PHX5+gxX+QACd/MAfJtXAPBI1l8PF3MGETzEJ6alhrz0DxQaWYcvhVoqn8Lu7ZivxJvbXzQczkwghBrC4a9ssKRZz26/blQCqX/9ZbFP9C1ux+glqyJMA+R3854gU7BEQQU7UupkiOPAop1kZTrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lfedgfpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lfedgfpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37980C4CED1;
	Fri,  7 Feb 2025 05:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738904745;
	bh=rZIYiEuE1z+R3SHStBz5eUHpv46QrKWyyH9xz3xIjYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LfedgfpnhVVSavTT8KABQZnShsavO1r24DzRjtewXLtl96YoG8eZZ1VJ/jDCpmztp
	 TQ+khyXh/HnMPRT4pLfOpc4YfxWJz297DhicmAviMwA/n/x1YlZwIT9PkfYKrGdIGY
	 MRx0reLbmqm69hayPLwOfCWvBSRaevKRlz1SeEZStso4fYqAd83WBhsrab6vNOz9D2
	 fEpAKkbmM+zmgwdtiKaZllpeMhsZNI80z2YWtGw9XueDNy6AGjvRysQFDbezDfmWqV
	 ZBMJo1+MyrMNS7cb6E//myl2POMB0q8jZX65FuQvi41zZJWuq6yOMaMnrpNx1rLNv0
	 w1wA32ccekN+g==
Date: Thu, 6 Feb 2025 21:05:44 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/43] xfs: disable reflink for zoned file systems
Message-ID: <20250207050544.GT21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-35-hch@lst.de>
 <20250207043123.GM21808@frogsfrogsfrogs>
 <20250207045446.GA6694@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250207045446.GA6694@lst.de>

On Fri, Feb 07, 2025 at 05:54:46AM +0100, Christoph Hellwig wrote:
> On Thu, Feb 06, 2025 at 08:31:23PM -0800, Darrick J. Wong wrote:
> > On Thu, Feb 06, 2025 at 07:44:50AM +0100, Christoph Hellwig wrote:
> > > While the zoned on-disk format supports reflinks, the GC code currently
> > > always unshares reflinks when moving blocks to new zones, thus making the
> > > feature unusuable.  Disable reflinks until the GC code is refcount aware.
> > 
> > It might be worth mentioning that I've been working on a refcount-aware
> > free space defragmenter that could be used for this kind of thing,
> > albeit with the usual problems of userspace can't really stop the
> > kernel from filling its brains and starving our defragc process.
> > 
> > It would be interesting to load up that adversarial thread timing
> > sched_ext thing that I hear was talked about at fosdem.
> 
> Not sure waht sched_ext thing and how it's relevant.

https://lwn.net/Articles/1007689/

IOWs letting the wrong threads run ahead, to see if the author got the
locking right.

> It's just that refcount awareness is a bit of work and not really
> required for the initial use cases.  It might also have fun implications
> for the metabtree reservations, but otherwise I don't think it's rocket
> science.  Even more so with a pre-existing implementation to steal ideas
> from.
> 
> Talking about stealing ideas - the in-kernel GC flow should mostly work
> for a regular file system as well.  I don't think actually sharing much
> code is going to be useful because the block reservations work so
> differently, but I suspect doing it in-kernel using the same "check if
> the mapping change at I/O completion time" scheme use in GC would work
> very well for a freespace defragmenter on a regular file system.  And
> doing it in the kernel will be more efficient at operation time and
> probably also be a lot less code than doing it with a whole bunch of
> userspace to kernel roundtrips.

Admittedly there are some fun things that you can do in the kernel that
you can't do from userspace, like create a secret unlinked file that you
can map freespace into, and turn EFIs into a bmapi operation, and
reflink file blocks into without having to deal with eof blocks, and
turning on alwayscow for files you're actively trying to move around.
But that's a fun thing to think about now that I have far fewer patches
to juggle in my head, for which I am grateful. :)

--D
