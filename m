Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793307596;
	b=U1AVzphoQufV/UA9RjkpJZYRG+GCtZPRmuypdWpiYVr38WjtJjdnvSXf96cXtEOij+GY
	 LPsjoKFRaZk3DIaFs1CYhgqSUP8ONR0LMWY6mL5iZkP9WHiahW51d52oe7UHIkUw6OOZv
	 pOI3a0TgoSZTWFxFwmksV3ljnSu1MVNpoY2zqFnInILa5H4jF235Ki/SzVfL/d08/zjVo
	 WxmgduTZ3imVwkBEcjSlJlo6EKaR2fFGKZ/JwdCG9s+rLh/xNvnr1iZbIVRUCcoGIXj3P
	 wIsfI+YPMYnvNW2SgXZH5etlVBjyTzXvHAwjhDHhTAYIJfo32294y4gdL4wEaAwwK0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793307596;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=zv/crP/MT0jYur3oiHEd6/mz9hTesI/3yGVAKcISCCI=;
	b=CvqlKciRRdUTcI4iwnHWDvrbIvkHzQzmlTZsl8fOEH4JNV3Lh27Q9OnDm4QKPLPvm2np
	 UOUT3VTiG5bTmRdSgMbVqI7FPNKiz69obnx/dnXvY7zjXQu8XOKyP1NitjI6GBCUkTTST
	 +zhYWwtdjJd79/9XWzHob0A4QKGhXrRFcMdqKoRbKhMN/oV6kGwETme80aDxwo4UxIwUa
	 9xHcKUkyfljQe3NsVdDqyAQWRHNnF7xCBTsvtNZcZvSPOnYQnGHa53ZtEowrHRgkQrT9+
	 oj3p1xJ8nTykwX41DZofC887UmfTeRGXxhKE+u/xOQAJL1dEfMc7mudmrRVL3/EyH0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HPaeDql8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B36A606A31C;
	Thu, 29 Oct 2026 20:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HPaeDql8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFCA1F01816;
	Thu, 29 Oct 2026 20:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793307596;
	bh=zv/crP/MT0jYur3oiHEd6/mz9hTesI/3yGVAKcISCCI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HPaeDql8TU0d83FLVuu7oZ6q9sc5s25c41uOxEQGAX9lBJBmM0MJO9OUT31O3vCQa
	 apmX9azBQIHLuMgB2GF4LwJLiAvezvIoQ94Kg9l79OhfXEOVK0QaclqGHcfVsZiU8i
	 6bgQPnbu/UZkyZP/FPjMDLBEf5a8zlRC9UqCH8A4zanGetv6d0T+qlWmJS+nChbket
	 IcNRN9bTgr7SfH3Bstf1L0Eiyq5lbOdoIAwrlAfdpjBzEZxMzBl5rCLThFa7GWWA+C
	 GfabmOkNjMxLWmxAbJ6ijStKwQyppzrId+YIKipXKR39lt8yRUjSI1RcSdEbdUxMU0
	 H4hfMbOr1KY/A==
Date: Fri, 30 Oct 2026 07:59:45 +1100
From: Dave Chinner <dgc@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Henry Martin <bsdhenrymartin@gmail.com>,
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
Message-ID: <auOzwfNyfbSNLCDC@dread>
References: <20261027151703.973392-1-bsdhenrymartin@gmail.com>
 <auJ2jgIIh8e_JJwn@dread>
 <87cxsto38m.fsf@trenco.lwn.net>
 <auKGlGJwOSZpioMd@dread>
 <87v76kmv3h.fsf@trenco.lwn.net>
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
In-Reply-To: <87v76kmv3h.fsf@trenco.lwn.net>

On Thu, Oct 29, 2026 at 08:37:06AM -0600, Jonathan Corbet wrote:
> Dave Chinner <dgc@kernel.org> writes:
> 
> > On Wed, Oct 28, 2026 at 04:43:37PM -0600, Jonathan Corbet wrote:
> >> Dave Chinner <dgc@kernel.org> writes:
> >> 
> >> > Unless you know how to fix the discovered problem correctly, don't
> >> > send what your LLM proposed for review. It will be garbage, and all
> >> > that will do is annoy whoever has to review it. Just report the bug,
> >> > let the subsystem developers fix it.
> >> 
> >> Just to be obnoxious...this runs counter to the advice we have in
> >> Documentation/process/security-bugs.rst, where reporters are requested
> >> to include a proposed fix as well.  It seems we're sending a bit of a
> >> mixed message...
> >
> > These aren't security bugs. Bugs that result from maliciously
> > corrupted filesystem images (i.e. fuzzed) are explicitly stated as
> > not covered by the kernel security threat models. IOWs, they are
> > just -bugs-, and bugs that just don't ever happen in the real world.
> 
> I wasn't arguing about the nature of the bug ... just noting the
> disconnect with what I've heard from some maintainers, who say that
> providing a patch helps in the identification of the problem, even if
> the patch is not used.

In this day and age, feeding a bug description to an LLM to get an
analysis of the issue takes less time and is more informative than
trying to get the same information from a patch generated by an LLM
to 'fix' the problem.

It's verifying the correctness of the root cause analysis that is
important here, not the code review.  LLMs frequently miss important
stuff that experienced developers know, and it's that wider context
that makes all the difference.

With everyone presenting fixes rather than bugs now, we end up
having to reverse engineer both the problem and why the specific fix
was chosen during code review. The typical commit message is
opaque and doesn't describe the symptoms that the bug exhibited.
This makes "code review" much harder and more time consuming than if
the bug was simply reported to the list.

After a year of using LLMs to write code and fixing complex bugs, I
know that an LLM requires its context to be properly primed for it
to generate a solid fix rather than a copy-pasted band-aid. It needs
to understand abstractions, other code that does similar things,
pre-exiting helper functions, etc. These generally lie outside the
immeidate scope of the code containing the bug. This is where the
experience and skill of the person running the LLM make all the
difference.

IOWs, the important part of fixing a bug with an LLM is running an
extensive, guided root cause analysis process to fully prime the
context window. Hence I want comprehensive bug reports to run the
analysis process on, not have to try and recreate that from somebody
(or something) else's interpretation of how the bug should be
fixed....

-Dave.
-- 
Dave Chinner
dgc@kernel.org
