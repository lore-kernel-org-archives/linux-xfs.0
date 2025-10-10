Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288B1248F64;
	Fri, 10 Oct 2025 20:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760129239; cv=none; b=AmPBZI2E+khctRPaNzK+CsVkWeQRqunaRF/OyOnq4wi8bIdVVxIfotY3+fhGNK4lVK877awbYv7ntfxYcQmFSG14ErYc/JklTDKy+pCHuqZf3ywBmtJXqz+ruE/PdvcStowTkaQpsPcpzuwNNlZjYlQH1HUToAdk3BHEeu8XaO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760129239; c=relaxed/simple;
	bh=c709M48U7alMEyUz+SD2ZpbICR91u3I55FSYP41GlWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uKJ+TwpeOllGPv3Hc165uq8ZnBPD/vY2MNPlTFcTqQY24z8T/V2iOIfabNjeqOdTjIXPXPo5ThiU0+ORlpIgyft/0rb96DR8CCHI0h/z+e6sAabFzTp9h6iguWzb/djzXyfhIj1Z1NFqnnLHAnAYiZpeXASSunn87As5nZlofns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net; spf=pass smtp.mailfrom=sandeen.net; dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b=aJ8VrVev; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=K/XxJ6ed; arc=none smtp.client-ip=202.12.124.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sandeen.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandeen.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandeen.net header.i=@sandeen.net header.b="aJ8VrVev";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="K/XxJ6ed"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 061997A016D;
	Fri, 10 Oct 2025 16:47:15 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Fri, 10 Oct 2025 16:47:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sandeen.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1760129235;
	 x=1760215635; bh=+NHfaBIGbOK3n+4CS4jfCL0l/uw+gJvckKUlSbjuHlk=; b=
	aJ8VrVevepFTUq4XIXmFqBj81twA8P4E5J53yH9METSAVUjsO8Psr0yRJPSH7eG+
	bs0iQOIQiePNLe3FZToqzOuDSE1/0Jdzo3KSQSd/itfSa1L0tHNDYrSk4G0TfKOG
	qT8wxVOBeUYuuZqsfyVhNF6uBFqaXf1Yd5YEWH/YbpdDL/79mABidabk69I8tn8n
	MTJnUuTvJDnNH9C6W0kyJ7RkM0eG3feZMT+twd6o7YqZxoBkC6maPMyy4uxyhhgK
	emgoRNQlnDhUXpALIvqUkmgeMZ2P1YNgqkzTEX4A+K7M7zZH3af+IXpk9bRTEJSA
	VYwvu5IUUUXD5X++dTqq6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1760129235; x=
	1760215635; bh=+NHfaBIGbOK3n+4CS4jfCL0l/uw+gJvckKUlSbjuHlk=; b=K
	/XxJ6edvwGNztKyDT3HERpvou6k3KeIN4VucWF54h0T+wI3CjqD+zG0X0C/EfkKv
	i16TpGQfQlL+hHvMkpR0zkiNWEEVm8fT+ehT3LM5RMFwGb5n7/q12XxOy0s/fWxW
	qM0ssgkewIvLLR9zTao61o8GNUBoievjkLffoJzbQ/CeV7HcVkxzxL/A8SIPfH2X
	l3kDd4C0FHgnu+Nqcs6BtHQ8wToErCZTlQDnrKi/LtozKpsJeO22uJa8+mrIsN4m
	I0RSbBH0lc9l11SS7P9KQXKeVnNbVpUviOF2t5NwN97nOtUtdRajkDDfBhPRSM76
	dPxKSRdfqL/y1Xj8URePA==
X-ME-Sender: <xms:03DpaBjeCcHVWv0PwSiAwaBso3ToffHzRWelHm1JsFDaSxhVcjFGSQ>
    <xme:03DpaD0u_XXfKHuV45xJwW8OL7I2-sr2mPfyE5vTE7LYAZQ4iQFQ8PML7ueNhxezS
    TJxN_sLwGXTtGUNSXsINRpwP1DCbkDOHZyJwOFjUNR0_8UgpX6PnA>
X-ME-Received: <xmr:03DpaLiz1OfHYxl-aotOjf-9DVgjQg-ShLEnTWCXjgA0ZxnJ0ENliNAk7Inyn0E3tvuhQx1SP1HWw9lF7W4gK3U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduuddttdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtvdejnecuhfhrohhmpefgrhhitgcu
    ufgrnhguvggvnhcuoehsrghnuggvvghnsehsrghnuggvvghnrdhnvghtqeenucggtffrrg
    htthgvrhhnpeevieekueetfeeujedtheeffedvgeffiedvjeejleffhfeggeejuedtjeeu
    lefhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hsrghnuggvvghnsehsrghnuggvvghnrdhnvghtpdhnsggprhgtphhtthhopeegpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopegujhifohhngheskhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehfshhtvghsthhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    ephhgthhesihhnfhhrrgguvggrugdrohhrgh
X-ME-Proxy: <xmx:03DpaDcjPluKIhtvZZlebTtpKrIpRapv4UJ2uMkcwuHw5fysI2cvJg>
    <xmx:03DpaOl7t11RJ3HgyEZlPEN9mgQ99KeIDKw31bNsvjtFqW2S7gGf9w>
    <xmx:03DpaMv-ayQL70K9rbKoCXgb1PFcn859ytZO7XnevPiC5LXMxCAorw>
    <xmx:03DpaE9xHBkmjF-hl1DakXx867Ckoojfc-Cr2Uaa3FOTleFhmZpF3w>
    <xmx:03DpaCoebyLYO608gtJBObfBVgl8usbtLFsQR4Cn4HaE0zNNOCctKVkW>
Feedback-ID: i2b59495a:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Oct 2025 16:47:15 -0400 (EDT)
Message-ID: <f7d5eaab-c2fe-4a11-82d5-a7c5ca563e75@sandeen.net>
Date: Fri, 10 Oct 2025 15:47:14 -0500
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mkfs.xfs "concurrency" change concerns
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 "fstests@vger.kernel.org" <fstests@vger.kernel.org>,
 Christoph Hellwig <hch@infradead.org>
References: <84c8a5e5-938d-4745-996d-4237009c9cc5@sandeen.net>
 <20251010191713.GE6188@frogsfrogsfrogs>
Content-Language: en-US
From: Eric Sandeen <sandeen@sandeen.net>
In-Reply-To: <20251010191713.GE6188@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/10/25 2:17 PM, Darrick J. Wong wrote:
> On Thu, Oct 09, 2025 at 03:13:47PM -0500, Eric Sandeen wrote:
>> Hey all -
>>
>> this got long, so tl;dr:
>>
>> 1) concurrency geometry breaks some xfstests for me
>> 2) concurrency behavior is not consistent w/ loopback vs. imagefile
>> 3) concurrency defaults to the mkfs machine not the mount machine

...

> Uggggh.  You're right, I see golden output changes in xfs/078 if I boost
> the number of VM CPUs past four:
> 
> --- /run/fstests/bin/tests/xfs/078.out  2025-07-15 14:41:40.195202883 -0700
> +++ /var/tmp/fstests/xfs/078.out.bad    2025-10-10 11:56:14.040263143 -0700
> @@ -188,6 +188,6 @@
>  *** mount loop filesystem
>  *** grow loop filesystem
>  xfs_growfs --BlockSize=4096 --Blocks=268435456
> -data blocks changed from 268435456 to 4194304001
> +data blocks changed from 268435456 to 4194304000
>  *** unmount
>  *** all done

Yeah I saw exactly that.

> Can this happen if RAID stripe parameters also get involved and change
> the AG count?  This test could be improved by parsing the block counts
> and using _within to get past those kinds of problems, if there's more
> than one way to make the golden output wrong despite correct operation.

Maybe? Not sure tbh. I hadn't seen it fail before.

> What do your xfs/21[67] failures look like?

On a VM w/ 8 CPUs, like this:

xfs/216 4s ... - output mismatch (see /root/xfstests-dev/results//xfs/216.out.bad)
    --- tests/xfs/216.out	2024-02-08 15:39:34.883667028 -0600
    +++ /root/xfstests-dev/results//xfs/216.out.bad	2025-10-10 15:28:24.055130959 -0500
    @@ -7,4 +7,4 @@
     fssize=32g log      =internal log           bsize=4096   blocks=16384, version=2
     fssize=64g log      =internal log           bsize=4096   blocks=16384, version=2
     fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
    -fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
    +fssize=256g log      =internal log           bsize=4096   blocks=32767, version=2
    ...
    (Run 'diff -u /root/xfstests-dev/tests/xfs/216.out /root/xfstests-dev/results//xfs/216.out.bad'  to see the entire diff)
Ran: xfs/216
Failures: xfs/216
Failed 1 of 1 tests

217 was similarly off by one. So maybe _within works ...

>> One option might be to detect whether the "concurrency" args
>> exist in mkfs.xfs, and set that back to 4, which is probably likely
>> to more or less behave the old way, and match the current golden
>> output which was (usually) based on 4 AGs. But that might break
>> the purpose of some of the tests, if we're only validating behavior
>> when a specific set of arguments is applied.
> 
> I think you're really asking to force the old behavior from before the
> concurrency options existed, but only if fstests is running.  Or maybe
> a little more than that; I'll get to that at the end.

Not so much asking for as musing about, and I don't think it's the
best idea ...

...

>> # losetup /dev/loop4 testfile.img
>>
>> # mkfs.xfs -f /dev/loop4 2>&1 | grep agcount
>> meta-data=/dev/loop4             isize=512    agcount=6, agsize=11184810 blks
>>
>> # mkfs.xfs -f testfile.img 2>&1 | grep agcount
>> meta-data=testfile.img           isize=512    agcount=4, agsize=16777216 blks
>>
>> so we get different behavior depending on how you access the image file.
> 
> What kernel is this?  6.17 sets ROTATIONAL by default and clears it if
> the backing bdev (or the bdev backing the file) has ROTATIONAL set.
> That might be why you see the discrepancy.  I think that behavior has
> been in the kernel since ~6.11 or so.

This was 6.17. The backing file get the nonrotational/concurrency treatment
but the loop device does. This probably says more about the xfsprogs test
(ddev_is_solidstate) than the kernel.

ioctl(3, BLKROTATIONAL, 0x7ffd9d48f696) = -1 ENOTTY (Inappropriate ioctl for device)

fails, so ddev_is_solidstate returns false. For the loop dev, BLKROTATIONAL
says rotational == 0 so we get true for solidstate.

But TBH this might be the right answer for mkfsing a file directly, as it is
likely an image destined for another machine.

Perhaps ddev_is_solidstate() should default to "not solidstate" for regular
files /and/ loopback devices if possible?

> [Aside: Obviously, checking inode->i_sb->sb_bdev isn't sufficient for
> files on a multi-disk filesystem, but it's probably close enough here.]
> 
> (But see below)
> 
>> And speaking of image files, it's a pretty common use case to use mkfs.xfs
>> on image files for deployment elsewhere.  Maybe the good news, even if
> 
> Yes, mkfs defaults to assuming rotational (and hence not computing a
> concurrency factor) if the BLKROTATIONAL query fails.  So that might
> be why you get 4 AGs on a regular file but 6 on a loop device pointing
> to the same file.

Yes, exactly.

>> accidental, is that if you mkfs the file directly, you don't get system-
>> specific "concurrence" geometry. But I am concerned that there is no
>> guarantee that the machine performing mkfs is the machine that will mount
>> the filesystem, so this seems like a slightly dangerous assumption for 
>> default behavior.
> 
> What I tell our internal customers is:
> 
> 1. Defer formatting until deployment whenever possible so that mkfs can
> optimize the filesystem for the storage and machine it actually gets.
> 
> 2. If you can't do that, then try to make the image creator machine
> match the deployment hardware as much as possible in terms of
> rotationality and CPU count.

I just don't think that's practical in real life when you're creating a
generic OS image for wide distribution into unknown environments.

> 3. We shouldn't have a #3 because that's leaving performance on the
> table.
> 
> They were very happy to see performance gains after adjusting their
> WOS generation scripts towards #1.
> 
> But I think it's this #3 here that's causing the most concern for you?
> I suppose if you really don't know what the deployment hardware is going
> to look like then ... falling back to the default calculations (which
> are mostly for spinning-rust) at least is familiar.
> 
> Would the creation of -[dlr] concurrency=never options to mkfs.xfs
> address all of your concerns?

Not quite, because *defaults* have changed, and it's almost impossible
to chase down every consumer who's going to happily update xfsprogs and
suddenly get wildly different geometry which might really help them!
Or might make no sense at all. But that horse has kind of left the barn,
I guess.

I'm tempted to say "do not do the concurrency thing for regular files or
for loopback files because that's a strong hint that this filesystem has
at least a good chance of being destined for another machine." Thoughts?

(from your other email)

> Now that I've read the manpage, I'm reminded that -[dlr] concurrency=0
> already disables the automatic calculation.  Does injecting that into
> dparam (in xfs/078) fix the problem for you?  It does for me.

I'm sure it does. Gets back to my question about whether that is too
detrimental to test coverage for the default behavior. I think probably
a _within is better. _within would take a little work since we're comparing
strings with numbers in them not just numbers but I think we really do
care only about one number in the string, so it's probably fine.

>> I understand the desire to DTRT by default, but I am concerned about
>> test breakage, loopdev inconsistencies, and too-broad assumptions about
>> where the resulting filesystem will actually be used.
> 
> That itself is a ... very broad statement considering that this code
> landed in 6.8 and this is the first I've heard of complaints. ;)

Yeah, I started off with acking that I am very late to this. Been a million
work distractions keeping me from this stuff, I'm sorry. :(

But as you said, any test env. with > 4 CPUs probably started failing tests
since 6.8 so it's probably not all on me. ;)

I think where I'll go from here is do a big run with -d and -l concurrency
set to something biggish in MKFS_OPTIONS, see what breaks, and see what sort
of _within changes might help.

And then I might also see about a patch to make ddev_is_solidstate explicitly
return false for loop devices and regular files, unless anyone sees issues
with that approach.

thanks,
-Eric
