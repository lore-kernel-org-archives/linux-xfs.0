Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793722256;
	b=XTTUkhh6Au06w1rm5wiLgUHM9ODEcHy5pLmDT6AphVnnEVi5oc8TZoCtWjdAkc9m3Frn
	 x1LVtv6urk53QLi2tpyYi4OvxFj9cQ+rfM2zL0omTSdeRWA1WYRBLZDDioyztpJxBgTea
	 eWwI0jJh8gUjDhvhNqt6TGx6ul6H63DBpLzYfiMX0BqgMFaF0Wc9c9VZKB1g0Wc8obj8K
	 Lt7d1GQKD8VCLDDoeeWRVw/KUm+GtpPAw6IJu1uogCHIPvJ4woa2H6pBPhvCrQ/tRjCOA
	 0KYPjSB5eUY06bVU4ACNLnikE1kjUW7mo8PDEhl5JgseGLw6ppZznaZlh9ngoHoYHBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793722256;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=uB/isL/mh+XyqmD3jEprYhQCSreexZ2AYBTAr5UT5pk=;
	b=H4ZQVACjEOFuEumv3l9HjecTwgNvWIPnqCRfSXMCQGdYsYwLWTbXWkAPgtvuQGaXiwbL
	 5Y4O8abQViW9giSOXRwIwnPCnj/B4CIkH7seSVt5sH9YyzmR2cUKDkLJB97hynwBpOlfC
	 O0inMEiOhDX+qDA1SGAwq1oC2kI9KvxOwyucxamy71Kveq3wonjOLzkPKKGbQjwqdD3Ds
	 zQLyK2+mh+qNzMc2k5+BS6XXhLkhHSOvbhztSmFkJ6gQpsoZ+ZaH5zsjtks+wie4Yhw7E
	 drgd8UahyJ+rQSCFI79CoWzN+bSiXkIPikZEG9RBf0/saL4sg9zyS3EVXC0x8XzG/gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hKzrT2kU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06A1606D806;
	Tue,  3 Nov 2026 16:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hKzrT2kU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF611F00A18;
	Tue,  3 Nov 2026 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722255;
	bh=uB/isL/mh+XyqmD3jEprYhQCSreexZ2AYBTAr5UT5pk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hKzrT2kUZEUHi1FPPnIDv8E/OETqKdE0rygAQbJgemUWcdl8WX3MR5lNm53m0NNmD
	 ZkMSsITwJ/qk5GL6aqGOyKHFC28G/6vUpghEZoZRyXSe/pNRM95G/18I7AgPdO1Jnq
	 j3VkG4WkHAncv5OyiC2/wyOB05OCT9lF+XO8T/UjYo+gt7Mq2ojwyS7jjYbpNf4q6b
	 TYpMIPLSvFyQ6JEWK5yCnEe6zdLB34FZlD/dbo3KSLcsem5UJd7YMXKQGugakeZwQJ
	 7zvnLpIo070I6bXgklm5PR92qa86BhkF1ZzRgRewfM3V2PB8Y05s+mRPdir6MUenht
	 bQy3prgUXV4hw==
Date: Tue, 3 Nov 2026 17:10:48 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <dgc@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, Jonathan Corbet <corbet@lwn.net>, 
	Henry Martin <bsdhenrymartin@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, Alex Deucher <alexander.deucher@amd.com>, 
	David Hildenbrand <david@kernel.org>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Kairui Song <kasong@tencent.com>, Myeonghun Pak <mhun512@gmail.com>, 
	Rafal Ostrowski <rafal.ostrowski@amd.com>, Likun Gao <Likun.Gao@amd.com>, 
	James Clark <james.clark@linaro.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix out-of-bounds write from crafted btree root
 numrecs during log recovery
Message-ID: <auoBg6stER6_EUfa@nidhogg.toxiclabs.cc>
References: <20261027151703.973392-1-bsdhenrymartin@gmail.com>
 <auJ2jgIIh8e_JJwn@dread>
 <87cxsto38m.fsf@trenco.lwn.net>
 <auKGlGJwOSZpioMd@dread>
 <auKuGGDHTxhCDJSY@mit.edu>
 <auO9Fk2IzecDWGtG@dread>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auO9Fk2IzecDWGtG@dread>

On Fri, Oct 30, 2026 at 08:39:34AM +1100, Dave Chinner wrote:
> On Wed, Oct 28, 2026 at 10:35:03PM -0400, Theodore Tso wrote:
> > On Thu, Oct 29, 2026 at 10:34:44AM -0500, Dave Chinner wrote:
> > > These aren't security bugs. Bugs that result from maliciously
> > > corrupted filesystem images (i.e. fuzzed) are explicitly stated as
> > > not covered by the kernel security threat models. IOWs, they are
> > > just -bugs-, and bugs that just don't ever happen in the real world.
> > 
> > Well, there are people/companies who might be silly/stupid enough to
> > think that containers are a real security isolation layer[1], and who
> > think that they can let random users mount untrusted file systems in a
> > container, and not have to worry about one company gaining access to
> > PII belonging to another company because both companies are using a
> > particular cloud hosting provider which uses containers and allows
> > their customers to mount file systems as (container) root, with
> > multiple customers sharing the some physical host.
> 
> As long as they use a filesystem that is proven to be safe for
> untrusted user mounts, I have no problems with that model...
> 
> > As Dave has said, *all* of the file system maintainers have explicitly
> > disclaimed this security model; from our perspective the block device
> > is inside the trusted computing base (TCB),
> 
> Right, kernel-implemented block device based filesystems ain't those
> filesystem...
> 
> > and if someone wants to
> > dedicaste one or more full-time engineers to be file system developers
> > who have contributed a large number of improvements to the file
> > system, and who understand the context that they can competently drive
> > LLM's to create architecturally sound patches,
> 
> You mean like I've been doing for XFS journal structure verification
> that I've already pointed to in this thread? i.e. this patchset:
> 
> https://lore.kernel.org/linux-xfs/20261013060204.3138690-1-dgc@kernel.org/
> 
> is almost entirely LLM generated code that I've directed and
> reviewed. I'm just about ready to post the second version, of which
> the only external reviews I've got are from an LLM (sashiko). 
> 
> So, yeah, I'm already capable of using LLMs to write complex XFS
> code, and to write it -fast-. With this level of complexity, I'm
> generally only seeing LLMs review the code (i.e. sashiko). None of
> the work I've done like this has had a human actually provide review
> comments.
> 
> If no humans have the time/bandwidth to review what are increasingly
> necessary changes (e.g. to stem the flow of shitty LLM fuzzer
> generated bug fixes), then we've got a major problem with our merge
> processes....

I don't think the problem is the process itself... It's been pretty
time consuming to keep filtering the good patches from the bad ones,
and no matter what we do, people will always yell at us.
If we don't review patches, people will yell, if we do a non-thorough
review and miss something, people will yell. If we use assistants to
help on review and yet something slips, people will yell.
We've got a huge inflow of patches but from those patches I'd guess 5%
of the authors actually understand what the patch is doing, 1% actually
at least do some testing and 0.1% do any trustable review (and not just
look at Sashiko interface and RwB based on that), and... LLMs are
convincing enough that it gets really hard to catch issues and LLMs try
extremely hard to sell their fix which adds to the time toll.

> 
> > I *might* be willing to
> > change my stance for ext4.  But those hosting providers' engineers
> > would have do most of the work to try to make this security model work
> > --- and it might be that using fuse2fs, and running that fuse server
> > in a sandbox (e.g. seccomp-bpf, etc.) might be a much simpler /
> > cheaper solution in the end.
> 
> Yeah, I think that for untrusted filesystem images, the only sane
> solution is to get them out of the kernel altogether.
> 
> -Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
> 
