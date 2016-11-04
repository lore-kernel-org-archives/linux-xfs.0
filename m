Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34898 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935292AbcKDRhI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 4 Nov 2016 13:37:08 -0400
Subject: Re: [rfe]: finobt option separable from crc option? (was [rfc] larger
 batches for crc32c)
References: <20161028031747.68472ac7@roar.ozlabs.ibm.com>
 <20161027214244.GO14023@dastard>
 <20161028131234.24a5cb6f@roar.ozlabs.ibm.com>
 <20161028160218.1af40906@roar.ozlabs.ibm.com>
 <20161031030853.GK22126@dastard>
 <20161101143918.4f154154@roar.ozlabs.ibm.com>
 <20161101054725.GZ14023@dastard> <58194CF8.1000501@tlinx.org>
 <20161103082950.GJ9920@dastard> <581B601A.4060403@tlinx.org>
 <20161103230018.GC28177@dastard> <581C310E.8080801@tlinx.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5e8b1988-3af3-bd25-c733-31e6b78c62bf@sandeen.net>
Date: Fri, 4 Nov 2016 12:37:06 -0500
MIME-Version: 1.0
In-Reply-To: <581C310E.8080801@tlinx.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "L.A. Walsh" <xfs@tlinx.org>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On 11/4/16 1:56 AM, L.A. Walsh wrote:
> 
> 
> Dave Chinner wrote:
>> If I had a dollar for every time someone said "hardware raid
>> protects me" I'd have retired years ago.
> ----
>     It's not a sole line of protection, but it does a fair
> job of *detection*. 
>> Media scrubbing does not protect against misdirected writes,
>> corruptions to/from the storage, memory errors, software bugs, bad
>> compilers (yes, we've already had XFS CRCs find a compiler bug),
>> etc.
> ---
>     Crc's don't _protect_ against such things either -- they
> can allow detection, but for protection ... I make due with
> xfsdump.  As for crc's -- I already had the feature
> prevent me from creating and using new partitions where it
> didn't like me setting the disk UUID when creating a
> new partition -- something that I heard
> would be fixed -- but something that prevented me from testing
> the new finobt feature I was interested in.

That has been fixed for over a year, now, FWIW.

v4.3 kernel / v4.2.0 xfsprogs

> I'm sure I'm not alone in wanting to test in my environment, but _both_ with and without the crc option. 
>     I seem to remember, recently, that it took other kernel
> developers to disable xfs panicing the entire system on problem
> detection, with the idea of only disabling what was broken.

Sorry, what?

>     Along the same lines, if I am using crc's and badness is
> detected, I'd want to be able to keep the disk online, though
> in "read-only" mode to allow me to explore what was wrong and find
> the best solution.
>> You may not care about this, but plenty of other XFS users do.
> ---
>     That's a crock -- I never said I didn't care about having
> it -- just that I wanted to be able to run finobt with crc's being
> disabled. 

If you want an untestable a la carte mishmash every option, there
are other filesystems which will do that for you.  They have lots of
weird broken corner cases as a result.

The xfs development crew has limited resources, and part of the decision
to /not/ make infinite combinations of features available was so that
we can get reliable coverage in testing and produce a robust result.

But we already went through all this on a similar thread 1 year ago...

> I noted after my last response, that you said your crc
> testing only jumped around the tests to compare crc's -- which
> sounded like they were still being generated but not checked -- no wonder the no-crc option was the slowest of tested options.
> 
>> I can't do this for you. I don't know what your workload is, nor
>> what hardware you use.  *Give me numbers* that I can work with -
>> something we can measure and fix. You need to do the work to show
>> there's an issue - I can't do that for you, and no amount of
>> demanding that I do will change that.
> 
> I don't want to bother others with my testing, I just want the
> platform to be open enough for me to quietly do my own testing
> and go forward from there.  I may be ignorant, but I'm also
> picky about things I care about -- thus I prefer to do _some_
> things myself, thank-you.
> 
> I realize that closed-platforms where the undesirable is bundled with the desirable and where end-users have no choice
> is the wave of the future.  I realize that in many cases, large
> corporations are pushing these changes.

Oh come on, now.

Open source doesn't mean everyone gets a pet pony in their favorite
color.  Failing to offer said ponies to each user doesn't make 
this a "closed platform" and I resent the assertion on behalf of
Dave and other xfs developers.  We're performing a herculean task
with a skeleton crew.  Dave, in particular, has performed tirelessly
for /years/ helping to create what is now arguably the highest-performing,
most robust, most scalable filesystem available on Linux.

A large part of XFS's success has been due to wise design and development
decisions, /including/ the decision to keep the test matrix under control.

And I'm not sure what to make sure of your mention of "large corporations"
but I can assure you that decisions like this are made within the xfs
developer community, without outside influence.

-Eric

> -l
