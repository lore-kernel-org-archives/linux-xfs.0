Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:55848 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753180AbcKDHHm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 03:07:42 -0400
Message-ID: <581C310E.8080801@tlinx.org>
Date: Thu, 03 Nov 2016 23:56:14 -0700
From: "L.A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: [rfe]: finobt option separable from crc option? (was [rfc] larger
 batches for crc32c)
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com> <20161027214244.GO14023@dastard> <20161028131234.24a5cb6f@roar.ozlabs.ibm.com> <20161028160218.1af40906@roar.ozlabs.ibm.com> <20161031030853.GK22126@dastard> <20161101143918.4f154154@roar.ozlabs.ibm.com> <20161101054725.GZ14023@dastard> <58194CF8.1000501@tlinx.org> <20161103082950.GJ9920@dastard> <581B601A.4060403@tlinx.org> <20161103230018.GC28177@dastard>
In-Reply-To: <20161103230018.GC28177@dastard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org



Dave Chinner wrote:
> If I had a dollar for every time someone said "hardware raid
> protects me" I'd have retired years ago.
----
	It's not a sole line of protection, but it does a fair
job of *detection*.  

> Media scrubbing does not protect against misdirected writes,
> corruptions to/from the storage, memory errors, software bugs, bad
> compilers (yes, we've already had XFS CRCs find a compiler bug),
> etc.
---
	Crc's don't _protect_ against such things either -- they
can allow detection, but for protection ... I make due with
xfsdump.  As for crc's -- I already had the feature
prevent me from creating and using new partitions where it
didn't like me setting the disk UUID when creating a
new partition -- something that I heard
would be fixed -- but something that prevented me from testing
the new finobt feature I was interested in.

I'm sure I'm not alone in wanting to test in my environment, but 
_both_ with and without the crc option.  

	I seem to remember, recently, that it took other kernel
developers to disable xfs panicing the entire system on problem
detection, with the idea of only disabling what was broken.

	Along the same lines, if I am using crc's and badness is
detected, I'd want to be able to keep the disk online, though
in "read-only" mode to allow me to explore what was wrong and find
the best solution. 
 
> You may not care about this, but plenty of other XFS users do.
---
	That's a crock -- I never said I didn't care about having
it -- just that I wanted to be able to run finobt with crc's being
disabled.  I noted after my last response, that you said your crc
testing only jumped around the tests to compare crc's -- which
sounded like they were still being generated but not checked -- no 
wonder the no-crc option was the slowest of tested options.
 
> I can't do this for you. I don't know what your workload is, nor
> what hardware you use.  *Give me numbers* that I can work with -
> something we can measure and fix. You need to do the work to show
> there's an issue - I can't do that for you, and no amount of
> demanding that I do will change that.

I don't want to bother others with my testing, I just want the
platform to be open enough for me to quietly do my own testing
and go forward from there.  I may be ignorant, but I'm also
picky about things I care about -- thus I prefer to do _some_
things myself, thank-you.

I realize that closed-platforms where the undesirable 
is bundled with the desirable and where end-users have no choice
is the wave of the future.  I realize that in many cases, large
corporations are pushing these changes.

Microsoft's last "open-update" that allowed selecting what 
updates you wanted is history and now you are forced to take
everything or nothing.  Such offerings are not made for the benefit
of the users -- it's not something they want.  But it doesn't matter,
it's where large companies are pushing things so consumers will be
easier to control.  I wouldn't be surprised if this feature bundling
was being pushed by project sponsors and that developers had little
choice and I may not either, as I don't have the smallest fraction
of the time I would need to add in options or changes to the
SW I use, just to hold the "status quo", let alone make improvements. 

All I can usually do is ask and later, "re-ask" -- since policies
in effect at one point in time may not be present later.

Cheers!
-l



