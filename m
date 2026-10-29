Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793309986;
	b=5RPtP3mlUiw7EI0FsMEU1iE3BSgaGazVo4fD2XXsvPQKfYXUZfER/OnKYTamm+q2Nxvg
	 x7g5MQL5ZxUYuwUGKXhDwB5CdYJf0NjlbwOZdoAkdzwVekSkqg4x9W+3n+IGTWgpXPD4s
	 Y1Ec/4Ayp1p+WKJy3EmybQn8bbL7RK2/fIW02szpRy1JHhLpiEIuhMcivFq8yUAcFUMZx
	 RGQAdANL63e9k76TO8pMZ8woJjoWaKZ9sBKAIszLKNYCm1TTefmJDMSQLDJXnXt3xs6Mg
	 69J35CEfBDRCesp0hQ0OVWsOKO7N+zyRKTm7WEkqi28DsSjLCY8b/fRfQ8D6mwOoIcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793309986;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=j9KYDPaLwgGzcFmGHYC+/nqBss75U3jx1877gfQHD6Q=;
	b=jMZp4c5Tc9wRj+oX9oFNgII5/urxiac1zFmBasoH/ZJ1yedTOVYkNvHneJQ0gzQkmgfM
	 ecEvPxLjCHYjWBMa9kwBBKbC4Rpm21srxE6WD/sKM6MlWJP2VoaTQcc9HKfmacCO7B+8n
	 4PCnjmrkuHJrg0xDm1qzDcJQyKy4eb64eawfxZrqyMI+mJuK0MCoG6Sh1UgpyPcp6iQ0Y
	 fHi6buuGWWZsEksebiE9CT+XfYC/Tmn69TwKVV0G4P81SB0oPueMPI/MSCqsUiztDVZJl
	 SPQJp9WsXbN6I4cXJlBw61TTUnS36LpMcn6lQMO3sUm2le5LQyCa8svjEp2t4S9Ysjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="IrG8nAF/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCBA606A31A;
	Thu, 29 Oct 2026 21:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IrG8nAF/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2221F01816;
	Thu, 29 Oct 2026 21:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793309986;
	bh=j9KYDPaLwgGzcFmGHYC+/nqBss75U3jx1877gfQHD6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IrG8nAF/5mE1YFkaR2uNq+pi4QwHtS6fkK+szSdD9oRz/ZIWnY4CmnIJEiq9zC5kT
	 ka56WPJGeDJztdVWZhmB0iIngELcZWr0Z/RbrjqFCEakqfghge7DcnoktmbE9uL19r
	 SAPCF5PeFP8NglOe7u9aMSJT9X43b8nTU0xZFZGfYkBYV86jSQWod4vLNiPNbDUr2c
	 D/eXspXNXJykomd10/IyFQT9QZtNX1mU08y/KNduk6jtGyuC5hf/I7yWNCraeNEeOm
	 0Th411SO4FYi+lYvDLdQWZbeW2W7guv/ZMpCUVH6Z0CTFI2Fi0WuBGU6OvKSPktiUs
	 ZNBa5py53bm4Q==
Date: Fri, 30 Oct 2026 08:39:34 +1100
From: Dave Chinner <dgc@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Carlos Maiolino <cem@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Hildenbrand <david@kernel.org>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Kairui Song <kasong@tencent.com>, Myeonghun Pak <mhun512@gmail.com>,
	Rafal Ostrowski <rafal.ostrowski@amd.com>,
	Likun Gao <Likun.Gao@amd.com>, James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] xfs: fix out-of-bounds write from crafted btree root
 numrecs during log recovery
Message-ID: <auO9Fk2IzecDWGtG@dread>
References: <20261027151703.973392-1-bsdhenrymartin@gmail.com>
 <auJ2jgIIh8e_JJwn@dread>
 <87cxsto38m.fsf@trenco.lwn.net>
 <auKGlGJwOSZpioMd@dread>
 <auKuGGDHTxhCDJSY@mit.edu>
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
In-Reply-To: <auKuGGDHTxhCDJSY@mit.edu>

On Wed, Oct 28, 2026 at 10:35:03PM -0400, Theodore Tso wrote:
> On Thu, Oct 29, 2026 at 10:34:44AM -0500, Dave Chinner wrote:
> > These aren't security bugs. Bugs that result from maliciously
> > corrupted filesystem images (i.e. fuzzed) are explicitly stated as
> > not covered by the kernel security threat models. IOWs, they are
> > just -bugs-, and bugs that just don't ever happen in the real world.
> 
> Well, there are people/companies who might be silly/stupid enough to
> think that containers are a real security isolation layer[1], and who
> think that they can let random users mount untrusted file systems in a
> container, and not have to worry about one company gaining access to
> PII belonging to another company because both companies are using a
> particular cloud hosting provider which uses containers and allows
> their customers to mount file systems as (container) root, with
> multiple customers sharing the some physical host.

As long as they use a filesystem that is proven to be safe for
untrusted user mounts, I have no problems with that model...

> As Dave has said, *all* of the file system maintainers have explicitly
> disclaimed this security model; from our perspective the block device
> is inside the trusted computing base (TCB),

Right, kernel-implemented block device based filesystems ain't those
filesystem...

> and if someone wants to
> dedicaste one or more full-time engineers to be file system developers
> who have contributed a large number of improvements to the file
> system, and who understand the context that they can competently drive
> LLM's to create architecturally sound patches,

You mean like I've been doing for XFS journal structure verification
that I've already pointed to in this thread? i.e. this patchset:

https://lore.kernel.org/linux-xfs/20261013060204.3138690-1-dgc@kernel.org/

is almost entirely LLM generated code that I've directed and
reviewed. I'm just about ready to post the second version, of which
the only external reviews I've got are from an LLM (sashiko). 

So, yeah, I'm already capable of using LLMs to write complex XFS
code, and to write it -fast-. With this level of complexity, I'm
generally only seeing LLMs review the code (i.e. sashiko). None of
the work I've done like this has had a human actually provide review
comments.

If no humans have the time/bandwidth to review what are increasingly
necessary changes (e.g. to stem the flow of shitty LLM fuzzer
generated bug fixes), then we've got a major problem with our merge
processes....

> I *might* be willing to
> change my stance for ext4.  But those hosting providers' engineers
> would have do most of the work to try to make this security model work
> --- and it might be that using fuse2fs, and running that fuse server
> in a sandbox (e.g. seccomp-bpf, etc.) might be a much simpler /
> cheaper solution in the end.

Yeah, I think that for untrusted filesystem images, the only sane
solution is to get them out of the kernel altogether.

-Dave.
-- 
Dave Chinner
dgc@kernel.org
