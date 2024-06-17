Received: from poodle.tulip.relay.mailchannels.net (poodle.tulip.relay.mailchannels.net [23.83.218.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CB8288BD
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 23:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.249
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718667921; cv=pass; b=hE1TcLNll/S7lejCnGuEwAlKPC96N08HnKXSPQ9hl6B+kQfZsWeqH3yWEQkhKtxUEy+arW3LFDsh8rY++SqBTJ3d2yd/6PGlDYCs/6PFoNFJANzyzwQk3pW4MjnSKpdO9kX0U0FrTMq87hzfjH8ilW7th9u2N28YRu68+mZ3cNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718667921; c=relaxed/simple;
	bh=Thd6FDZURDPISy81LFnjhwP7nZrWmVK9yR1rrBWOvtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u9s27dPEmP6MLskW0zGqAOneekiD0EV3VV/FyDKfJ5b7S3zvGxwOxvqYs3ORpmRCyolAORsyDfx47aznHXKHDp27XFYb5C00LcM3IIDGuOO4BGQDc654RVMYTIfSXiwq21nCliS7qHBlBU3cXVUU/ysSbqiDtLEgeWXbZSWgX38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=C1TNdwE0; arc=pass smtp.client-ip=23.83.218.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="C1TNdwE0"
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 7E9A4903574
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 23:45:06 +0000 (UTC)
Received: from pdx1-sub0-mail-a203.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 453DE903604
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 23:45:05 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1718667905; a=rsa-sha256;
	cv=none;
	b=F8SzoYHyaMVtnYrXEJP5cGK/4YAGIRx5LW0gy/Tc0z3Qd7E2VYgE7desRx+ouunAgBgHku
	V2Ew0pOjbFoHTxw6dhX2p5UKQG/uTM/GFs0kIaro/O8FUxNBkrle5Jm8NkFgvdAbcF88kY
	BTIsDd3/lfpk44fH6w1YyYo5bp2BCzupTdpqyOW8NECt8dGZ+bD2JmkyNHknfU5sNF7R3M
	GiTtweybG+4ZtqUXHlJKwhgnYGZq60aO557nKe5arzm6MJKliZHim+RSgVNOhunbA8eihI
	tTS0dRdrd0Pey7BhpHYwRgJZjHE1V79ojhUIXxWPt6F+M11rrFMInVPnPBWPOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1718667905;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 resent-to:resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=7E1nFxCvR83LR0BmDx0IxQdh/SW12G1wVJarjGPZZyQ=;
	b=wTp9YW45afPa5F+nf8zpc4A+jLyUw2FWkYgtBCoUQlu1UaK7b7D/4+5+yhT79NEPZdi8bI
	pbzdzsgJav2rHKzPvBtadQpm+yW7ODyfkklSfUeWLcvxcKus63IouKDNnD6a9yk2vWQxxS
	aSx5/fyLARUdd3RypfEKAPOD7hyh3xublyXqXyo9PI0QznupkYIs05mzQ0V9neHKITGYJ5
	uankM3eYjDTT7JvS/L/sImnURGF+2XM8ZbPpycFY5zz2BPb6MAw04FcL70mBrz7S33yg3q
	HoxMaYJEAgkNQ6KQExR4ZWxNGC8mfiDVBqqGrg48NhHoUo0FLG8NFWVyVAA7VQ==
ARC-Authentication-Results: i=1;
	rspamd-79677bdb95-thq6d;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=johansen@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Share-Harbor: 686c20f43a07b01c_1718667905505_3164876893
X-MC-Loop-Signature: 1718667905504:3941097618
X-MC-Ingress-Time: 1718667905504
Received: from pdx1-sub0-mail-a203.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.42.83 (trex/6.9.2);
	Mon, 17 Jun 2024 23:45:05 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a203.dreamhost.com (Postfix) with ESMTPSA id 4W361s0FtQz80
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 16:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1718667905;
	bh=7E1nFxCvR83LR0BmDx0IxQdh/SW12G1wVJarjGPZZyQ=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=C1TNdwE093S/r3DX+ddZlpL+7bBqikIK3wKUrW2bme2c5b24JvbY7FbwdKKMY0J50
	 3Q19BfTVxnU+yWqTax6EKpnCd4REG97zXi5XbHyg7O8HFDrUHxfMPxKGA6ua/U/MkC
	 bIVlu2d0W8j3dplQATCN2xI90De/dKjKGIuP/2DR0vkwKxPZ07/c+8/e+Z6hfqkp4V
	 6ER0tjWJe7eZkmavd1fFhfEVNpOAxohfOxsrS/c/FRrKxst0sUbD9he1KsGM9am7qt
	 7un7hiNPa1BfBfrGgcNlJNNA/vm4VicVuLnxQVvc6zRB5PFES81OIWlswOfwA4lMc5
	 bmnva69YcUTzQ==
Received: from johansen (uid 1000)
	(envelope-from johansen@templeofstupid.com)
	id e002c
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Mon, 17 Jun 2024 16:44:28 -0700
Resent-From: Krister Johansen <johansen@templeofstupid.com>
Resent-Date: Mon, 17 Jun 2024 16:44:28 -0700
Resent-Message-ID: <20240617234428.GB2044@templeofstupid.com>
Resent-To: linux-xfs@vger.kernel.org
Date: Mon, 17 Jun 2024 15:25:27 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Gao Xiang <xiang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] bringing back the AGFL reserve
Message-ID: <20240617222527.GA2044@templeofstupid.com>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
 <ZmuSsYn/ma9ejCoP@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmuSsYn/ma9ejCoP@dread.disaster.area>

On Fri, Jun 14, 2024 at 10:45:37AM +1000, Dave Chinner wrote:
> On Thu, Jun 13, 2024 at 01:27:09PM -0700, Krister Johansen wrote:
> > I managed to work out a reproducer for the problem.  Debugging that, the
> > steps Gao outlined turned out to be essentially what was necessary to
> > get the problem to happen repeatably.
> > 
> > 1. Allocate almost all of the space in an AG
> > 2. Free and reallocate that space to fragement it so the freespace
> > b-trees are just about to split.
> > 3. Allocate blocks in a file such that the next extent allocated for
> > that file will cause its bmbt to get converted from an inline extent to
> > a b-tree.
> > 4. Free space such that the free-space btrees have a contiguous extent
> > with a busy portion on either end
> > 5. Allocate the portion in the middle, splitting the extent and
> > triggering a b-tree split.
> 
> Do you have a script that sets up this precondition reliably?
> It sounds like it can be done from a known filesystem config. If you
> do have a script, can you share it? Or maybe even better, turn it
> into an fstest?

I do have a script that reproduces the problem.  At the moment it is in
a pretty embarrasing state.  I'm happy to clean it up a bit and share
it, or try to turn it into a fstest, or both.  The script currently
creates small loop devices to generate a filesystem layout that's a
little easier to work with.  Is it considered acceptable to have a
fstest create a filesystem with a particular geometry?  (And would you
consider taking a patch to let mkfs.xfs --unsupported take both size and
agsize arguments so the overall filesystem size and the per-ag size
could be set by a test?)

> > On older kernels this is all it takes.  After the AG-aware allocator
> > changes I also need to start the allocation in the highest numbered AG
> > available while inducing lock contention in the lower numbered AGs.
> 
> Ah, so you have to perform a DOS on the lower AGFs so that the
> attempts made by the xfs_alloc_vextent_start_ag() to trylock the
> lower AGFs once it finds it cannot allocate in the highest AG
> anymore also fail.
> 
> That was one of the changes made in the perag aware allocator
> rework; it added full-range AG iteration when XFS_ALLOC_FLAG_TRYLOCK
> is set because we can't deadlock on reverse order AGF locking when
> using trylocks.
> 
> However, if the trylock iteration fails, it then sets the restart AG
> to the minimum AG be can wait for without deadlocking, removes the
> trylock and restarts the iteration. Hence you've had to create AGF
> lock contention to force the allocator back to being restricted by
> the AGF locking orders.

The other thing that I really appreciated here is that the patchset
cleaned up a bunch of the different allocation functions and made
everything easier to read and follow.  Thanks for that as well.

> Is this new behaviour sufficient to mitigate the problem being seen
> with this database workload? Has it been tested with kernels that
> have those changes, and if so did it have any impact on the
> frequency of the issue occurring?

I don't have a good answer for this yet.  The team is planning to start
migrating later in the year and this will probably run through to next
year.  I'll have that information eventually and will share it when I
do, but don't know yet.  Aside from the script, other synethtic
load-tests have not been successful in reproducing the problemr.  That
may be the result of the databases that are spun up for load testing not
having filesystems that as full and fragmented as the production ones.

> > In order to ensure that AGs have enough space to complete transactions
> > with multiple allocations, I've taken a stab at implementing an AGFL
> > reserve pool.
> 
> OK. I'll comment directly on the code from here, hopefully I'll
> address your other questions in those comments.

Thanks, Dave.  I appreciate you spending the time to review and provide
feedback.

-K
