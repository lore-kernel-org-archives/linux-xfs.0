Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E338C194AD1
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 16:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730218463; cv=none; b=okO4SVgLa9yH2P4lkk/tMjEEN+K8uraan7VQrvIMASUZZ3ztEnpMr3MMzZwfQl05yzrMuBtmvtjnBtPpwtyrfXsKTpfX5BTC23Iyw+weCXaKoMK3GQnnrQfQkHAmFEtZ9uC/cP9Tee+doooiEomF3LjOFKOubDweFsWtMZYX0vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730218463; c=relaxed/simple;
	bh=5ttpxhmr0BJ4/EQz5l2OPq48fstXuY+ayf3mya8zEJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fLJn6Zlx4u9FQQKWgIef6CzNOOjomnc93tua6X8cgoPInqWH1+vB1ydb7Wpyt99Kld5Vj8VUJP4WG2luMfnWoTwIx103yTuQ3sxmimwkMMwlxE+0Lv6O3qYMwAJW5AcVzkKePVEIiU5QfGZYfgD3xS6YksOcdx/+zya65JxpSFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=ndLlpAzX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=BPF1NtBA; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="ndLlpAzX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BPF1NtBA"
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 0BD7C2540199;
	Tue, 29 Oct 2024 12:14:20 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Tue, 29 Oct 2024 12:14:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:content-transfer-encoding:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1730218459;
	 x=1730304859; bh=VWIGViBgecSo89X8MtXurfNJuxGlrnQLCKDy/4pMSd8=; b=
	ndLlpAzXkvuNxCCmcIFtvI3lb4bAUuUErKh+hrhCJdWtbzMCZYx/qpnmofYQ72R1
	w5taCceYpAh9LIcday1Vf+03TJSW0KnJhLahlN7UKZJVp12HstsfbXKNXS8EKvHw
	EycjKiKTHnll+LhmQ92TK4yTifu0CVcDvf6yWNht6LFQcr26F05BcQVGqlEii20L
	K+kvW/M/NLEPGVbvOICeAF5K37VJnNCiFz+VoGuXOsi31v5mVFUzxWSq4r1+wBLT
	2EBHLMAZ95N2j3a3V1RL4K8ITWNi1Y19nj2pSQFbSQ8SG6k3AbUaFpfeGoTi/IbY
	8rKVorHclaPriFQnqbXtLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1730218459; x=1730304859; bh=V
	WIGViBgecSo89X8MtXurfNJuxGlrnQLCKDy/4pMSd8=; b=BPF1NtBAss6btBHNW
	hm3R02sK5UOLXRxFrE2Gfa+sq7CsKXUPSm1EkVG05XsA9J6+jgo963KaZwKsE0U2
	HxF2y/apxYlLfUF7nLL1gQX+1JwDkIPkzFET0dXBH81fQI2oKrowoIDXR/80w3gO
	+MDRAA/5UA9svflZFm5Cs3vMiIgbgn+xei+zwRAGSl8RexOGx+V2iTf4e6TM80bN
	KyJu64qaCCxCqobC5jmflxOv5ZmTmAycAaNZHvYlMHPcL86nlloZYHpcUGhybKWi
	oJDgjFCieOD/pAgBVlTu1aWg36JtDCaPx/C0xHIoXBVCqjN+NeLV83oAtJFc5lgd
	8CFBg==
X-ME-Sender: <xms:2wkhZzdH3xxH8Pbu7Vpu32JJhxWn4DyTZxTZA1dRpYT_h1dB4MaDVw>
    <xme:2wkhZ5PYtoVbQfQsR3Q32B-pyuNGoDT7h8pdOPc_1Cr1d1lR_xbmeIGhsGvtTqcVZ
    RC5StfQnHBp-YL84ps>
X-ME-Received: <xmr:2wkhZ8igUk4gcBAZwRKasAPr0DzuhlyeEs15RrQzNY6p3CH73vh4idPAHuufCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvdekuddgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucenucfjughrpefkffggfg
    fuvfhfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpefgrhhitgcuufgrnhguvggvnhcu
    oehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtqeenucggtffrrghtthgvrhhnpedvue
    ejieffgeehjeelfeduieejfeejleffudfhudfgheejhedvgeeihfdvfeeifeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehsrghnuggvvghnse
    hsrghnuggvvghnrdhnvghtpdhnsggprhgtphhtthhopedvpdhmohguvgepshhmthhpohhu
    thdprhgtphhtthhopegurghvihgusehfrhhomhhorhgsihhtrdgtohhmpdhrtghpthhtoh
    eplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:2wkhZ0-R5YJlA9thEJcFl0eYXoad-ndBM1p595_p1flncRBvw6f9_w>
    <xmx:2wkhZ_ucY69VZiF1Mof48_9K6aYQdR4NKYJ-Q3JzVaSHcqJ00Z13tQ>
    <xmx:2wkhZzH1vQ7V1hwpKr09_BjUTydTyFh4X5Y_NshIpI6K-i-WrCA2Dg>
    <xmx:2wkhZ2P99Oq6WIRmDtscV3p3IbDVjyquaV6mZQ-5aLCe_SDKazpeaA>
    <xmx:2wkhZ44uacw4Fujg2TC-3sKCWNzQYRMscO2rQT4i9YDKu_iuL25FIVEq>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 29 Oct 2024 12:14:19 -0400 (EDT)
Message-ID: <4da62d9a-0509-46e7-9021-d0bc771f86d9@sandeen.net>
Date: Tue, 29 Oct 2024 11:14:18 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] xfs: sparse inodes overlap end of filesystem
To: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
References: <20241024025142.4082218-1-david@fromorbit.com>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20241024025142.4082218-1-david@fromorbit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/23/24 9:51 PM, Dave Chinner wrote:
> There is one question that needs to be resolved in this patchset: if
> we take patch 2 to allow sparse inodes at the end of the AG, why
> would we need the change in patch 1? Indeed, at this point I have to
> ask why we even need the min/max agbno guidelines to the inode chunk
> allocation as we end up allowing any aligned location in the AG to
> be used by sparse inodes. i.e. if we take patch 2, then patch 1 is
> unnecessary and now we can remove a bunch of code (min/max_agbno
> constraints) from the allocator paths...
> 
> I'd prefer that we take the latter path: ignore the first patch.
> This results in more flexible behaviour, allows existing filesystems
> with this issue to work without needing xfs_repair to fix them, and
> we get to remove complexity from the code.
> 
> Thoughts?

For some reason I'm struggling to grasp some of the details here, so
maybe I can just throw out a "what I think should happen" type response.

A concern is that older xfs_repair binaries will continue to see
inodes in this region as corrupt, and throw them away, IIUC - even
if the kernel is updated to handle them properly.

Older xfs_repair could be encountered on rescue CDs/images, maybe
even in initramfs environments, by virt hosts managing guest filesystems,
etc.

So it seems to me that it would be worth it to prevent any new inode
allocations in this region going forward, even if we *can* make it work,
so that we won't continue to generate what looks like corruption to older
userspace.

That might not be the most "pure" upstream approach, but as a practical
matter I think it might be a better outcome for users and support
orgs... even if distros update kernels & userspace together, that does
not necessarily prevent older userspace from encountering a filesystem
with inodes in this range and trashing them.

Thanks,
-Eric
