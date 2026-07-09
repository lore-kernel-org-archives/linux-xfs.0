Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4102423A88
	for <linux-xfs@vger.kernel.org>; Thu,  9 Jul 2026 12:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783600245; cv=none; b=iFCOoSq2PELPagXrx1da7apOZwGqNpbvO+f1aj3Qospx99bm2qiru0xp1VwRDhsk62IXyvXY80R5gja+gLt/5iTL9gT/8lyUn/tWLoJRLLG8GqLyelXxX0ohZW4AZN5OT8OT8CDqZC+ChlOceSqkrJS3rs28xmSMRXMg/agy0cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783600245; c=relaxed/simple;
	bh=ZSdEEa9C8wyZoDlfkq5emB+B6HJPUg5VG1FSxGoftas=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cwgDmFc9+lqYDBcfuDONvsx4dVHOTfbdPXj5i1uaEy9fDa6Nd8ur4kYwGs2o5N0XakVKsH0WaAbvhOtyIhy8hqrWzXUkr3jGSu7+bF93IyEdFVV5cMN2aAR8eBgLw8WGi2l19eVyj4v9QnvwhhCVKy+h4tTRLaSD7/WeQG/3Fec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=flk6cc4C; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cOyQC+aL; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="flk6cc4C";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cOyQC+aL"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 2591E7A009F;
	Thu,  9 Jul 2026 08:30:43 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Thu, 09 Jul 2026 08:30:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1783600243;
	 x=1783686643; bh=f0B0Hc0Za6Qlamb6tXd9r12ImZVSQNOwF5K6/RBulAw=; b=
	flk6cc4CjSX6ca2TpLIkXhBemw+RKY0FbaCLdHbVKhtSu4DEwhZMvS59sODMBlB2
	MC+45fmWEJ27llbvKqfZpD/db6iSZCxxvxU8/v0iIRZkkfCGmXfaxRs1x8LzAPIU
	TBNoekzOwwqC3pajr5Lr5BQRU2f13GA2deV54IGBXmaC79ABs/MB2ENDyypnm07A
	WIH8tuqYQUqODOkGMc+f05u+tKiSj7RgR8bAXe7lilDBor7EfP0TBHal4UHNQi5d
	qYZ6bgEvJK9bl41s7uVRlqnaEe10O79nuadER5m/e0JgUkF5piAU2dZELDls297T
	RonZ1RqtZnqY7CZhNN6qjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783600243; x=
	1783686643; bh=f0B0Hc0Za6Qlamb6tXd9r12ImZVSQNOwF5K6/RBulAw=; b=c
	OyQC+aLa1Az4vRY+UYT/lcdPbNlLAc/nSs86Pqh4Ex4GWyQfEDuuvQ87sAxUh5rh
	Dluw/kapX3/aLxyRgTsrhpe2avsBwkrxtRNC18BNtN1vPW/uywAxHUGInoC1N/7F
	KT+nBvHMVmklqHuQnl1IoddyN12s0g0NyAcWo4hDZ36yw1GovE72kuAbXHb/OaiE
	OupUkX9GoCnW3Ba/RKM9poaLhdw20VCwC9jEuisjkO69AkCg+Y4427SWA64jXVSw
	+XgLL0xCCE47f3KOkrsGE1W+x3qagw/WvpmIDvHoafzOKY67IslB5CSxDGw8e/ZD
	uqa3vlaDUAwCu7HmzLVAQ==
X-ME-Sender: <xms:cpRPah2lumBYm4Y13YehWFUoSwPDwLJsRgNE6Y_MMqqoIuzVwCCMZw>
    <xme:cpRPau9BuVe30WZllFPVO8g5LyddX-MrALMG7T57-UpSP_ELCLiLrMu19Go1RRK5W
    uM7ybMN-NhExddg-o0kj5X3DpqOkY93WWA9Sbt1eiecMKpRmKqo6bo>
X-ME-Received: <xmr:cpRPaqNfhHjFpqHZXcgpAvy5jIstbI3t5qyvIMtKguc0XyP5iHqEpzOgiDojvQPQvVhJpaZGhVoRk6JnsphvcUSwPNw>
X-ME-Proxy-Cause: dmFkZTFz3lso744GA7zQ6AI9BOnZSbM6lEFyeZdQsJwpesRsfHwGGy5B7PB2NbmFxu1rT4
    RJ4sjZaFGqaBvO6xeNX0od2KrBnagL2FuMLzobZ2XZ+OrIR9hL3H32a/jb35WhKUFhNpdb
    IZTfllyFHkDatR5XXYQ00S+dvS6iqtjkQjyMcLCeDv2sdEzA039bFgYh0LhBO9rktpCYUQ
    U0GtPFJL1xQuartuAJWawABPIOTmFRvJopTmpFSKlsQ24C+2Ge45qjS7lJ515ILdwXC+XH
    OZWdW915oosEvcnElnPrluzWEF58mPg7jc8r5ISyeZBeANIvNxA7HxkI1xWfptugaMe1q5
    sEkV0Z93wwvxScX2wUStrbflQuNEc+Vrx1RtxX+STwUEDXZg0bRHyd94lSDiekTixJuHXA
    OYlIJlK4Yle2XXKmPTjPTg0gw8fjMfFdFjg2lO7L0xVdISLni23rySWNw2fER9iyrcfR7b
    HTtlooRLJehMWw/YBvLnMqkP+23JdOl3ldMiP8mjx2KlFwgxlazOu4KQ9qFVbZqxxSk9cK
    0A750uafhza1nYJquHc9sq0Y6zghvN+E7L0hZ9UUpNd7pz2rqbvHTXO1gRCIerAHSyxe+k
    yUU5hDqvbQgXiaQlLhPhtCjE4PKLtRflAurBIj32+UTK/8ncJXqTJtYWzRcA
X-ME-Proxy: <xmx:cpRPaqdULkio1e-EwHTzmftE06Iojs34p7IXfByMqmO3YKCKsBkHOA>
    <xmx:cpRPahXS0WzkZ1MeGbjrRz2OzvdtqC6rGjeJ01FbyutOM4zrqNXyKw>
    <xmx:cpRPaqiqbb12swutw_3i9CJcFyiU9pPS0usrqiFuBB43L7tIuFKcXg>
    <xmx:cpRPao_hHYipAuqyW_NVuvR1sldZtnuyg2n-VmRG2rADl8iCma9wbw>
    <xmx:cpRPavZpzsfgb7g-zEDwGYNQnOuEdTgU7yeU7skkJHxRnui0ILB0VmdE>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Jul 2026 08:30:42 -0400 (EDT)
Message-ID: <ab8c9529-103d-4e25-b062-1700544a0bdb@sandeen.net>
Date: Thu, 9 Jul 2026 07:30:41 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] xfs: add new policy guidelines for llm-assisted
 patches
To: cem@kernel.org, linux-xfs@vger.kernel.org
Cc: dgc@kernel.org, hch@lst.de, djwong@kernel.org
References: <20260709110006.94905-1-cem@kernel.org>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20260709110006.94905-1-cem@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/9/26 6:59 AM, cem@kernel.org wrote:
> From: Carlos Maiolino <cem@kernel.org>
> 
> Hi, this idea came from some observations on the current inflow of patches
> sent to xfs, amount of time we've been spending reviewing patches, lack of
> testing coverage for them and sporadically bollocks patches that make no
> sense or even do not compile.
> 
> A talk I had with Dave earlier today made me come up with an INITIAL
> DRAFT of what should IMHO make 'reviewable' any LLM-assisted patch
> submitted to the list.
> 
> Most of the information there is also valid for non-LLM assisted code,
> but LLM-assisted code makes these policies exceptionally important
> giving LLMs make the code generation way faster and easier than we have
> time to follow through.
> 
> We do have tooling now like Sashiko to help with a gross review of
> patches and some general policies, but none of those tooling/policies
> target xfs specifically so I thought we ought to have a specific policy
> in place, specially regarding testing-coverage as submitting
> LLM-assisted patches also implies the same tooling can be used to create
> fully-functional testing coverage in xfstests.
> 
> I'll appreciate your thoughts on this.

I like it.

(applying my pedantic liberal arts native English speaker editorial preferences,
you can take it or leave it)

> Cheers
> 
> Signed-off-by: Carlos Maiolino <cem@kernel.org>
> ---
>  ...m-assisted-patch-submission-guidelines.rst | 59 +++++++++++++++++++
>  1 file changed, 59 insertions(+)
>  create mode 100644 Documentation/filesystems/xfs/xfs-llm-assisted-patch-submission-guidelines.rst
> 
> diff --git a/Documentation/filesystems/xfs/xfs-llm-assisted-patch-submission-guidelines.rst b/Documentation/filesystems/xfs/xfs-llm-assisted-patch-submission-guidelines.rst
> new file mode 100644
> index 000000000000..1f7921789988
> --- /dev/null
> +++ b/Documentation/filesystems/xfs/xfs-llm-assisted-patch-submission-guidelines.rst
> @@ -0,0 +1,59 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +.. _xfs_llm_assisted_patch_submission_guidelines:
> +
> +============================
> +XFS LLM-Assisted patch submission guidelines
> +============================
> +
> +Introduction
> +============

> +LLMs are a great tool for improving code quality when well used. But they also
> +have been creating a lot of extra workload for developers with the increasing

have the potential to create an extra workload for the XFS developer community with

> +patch flow. Requiring much more time with reviewing and testing changes.
> +
> +Some patches submited fixes obvious bugs and are welcome, while other patches

Some LLM generated patches fix obvious bugs and are welcome, while others
have obvious flaws, create regressions caught by xfstests, fix theoretical bugs
that may never be hit in the real world, and sometimes do not even build.

> +being submitted have obviously flaws, create regressions caught by xfstests,
> +fixes theoretical bugs that may never be hit in real world (even though are
> +worth fixing) and sometimes do not even build.
> +
> +So the goal of the policies described by this document is two-fold:

The goal of the policies described by 

> +
> +	- Increase XFS's code quality ensuring all code modifications are
> +	  properly tested and have extra coverage

sufficient coverage?

> +	- Reduce developers/maintainers workload with the extra income of
> +	  machine-generated patches.

Reduce developer / maintainer workload with the extra influx of

> +
> +Patch description
> +-----------------
> +
> +Patches description should be carefully trimmed by the patch submitter removing
> +all extra and unnecessary data from it.

Patch descriptions should be succinct and clear.

> +LLMs tend to generate extra-long documentation full of unnecessary information
> +that won't help neither the reviewer nor anybody looking into the git history

that won't help the reviewer or anyone reading git history in the future, 

> +in the future, and these consumes a lot of time during review.

and these consume a lot of time during review.

> +It's the patch submitter responsibility to trim it down to a concise, easily

It's the patch submitter's responsibility to ...

> +readable document, removing all the extra unnecessary information from it.

Strike "removing all the extra unnecessary information from it" which is extra
and unnecessary. ;) 

> + 
> +This also helps adding extra guardrails that the patch submitter fully understands
> +what the patch is doing without letting the LLM loose.

(this is a little unclear to me)

> +
> +Patch changes
> +-------------
> +
> +The patch submitter is fully responsible for the changes and must understand what
> +the paitch does. And it should be in full agreement with the patch description.

"patch" - but also not entirely sure what this means or how to better word it.
"Patch changes" is a bit of an odd heading. In general I 100% agree with
"you, the human, had better understand what the patch is doing before you submit it."

> +
> +Testing the changes
> +---------------
> +
> +LLM-generated patches should be coupled with a fully-functional xfstests test case
> +which exercises the bug being fixed by the patch. This will not only improve testing
> +coverage but also provide extra help for reviewers and the maintainer to properly
> +review and test the changes being made.

This will also help you, the submitter, have confidence that your patch is doing
what you expect it to do.

> +
> +Also, every patch/series submitted must be exercised through xfstests suite
> +- at least - through the auto group (and others depending on the change) as a way
> +to add extra coverage through the already existing regression cases and help
> +reviewers/maintainers through the integration process.
> +

