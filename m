Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8612 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728885AbfHESc6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 5 Aug 2019 14:32:58 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 09/24] xfs: don't allow log IO to be throttled
Date: Mon, 5 Aug 2019 18:32:51 +0000
Message-ID: <C823BAA1-18D5-4C25-9506-59A740817E8C@fb.com>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-10-david@fromorbit.com>
 <F1E7CC65-D2CB-4078-9AA3-9D172ECDE17B@fb.com>
 <20190801235849.GO7777@dread.disaster.area>
 <7093F5C3-53D2-4C49-9C0D-64B20C565D18@fb.com>
 <20190802232814.GP7777@dread.disaster.area>
In-Reply-To: <20190802232814.GP7777@dread.disaster.area>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On 2 Aug 2019, at 19:28, Dave Chinner wrote:

> On Fri, Aug 02, 2019 at 02:11:53PM +0000, Chris Mason wrote:
>> On 1 Aug 2019, at 19:58, Dave Chinner wrote:
>> I can't really see bio->b_ioprio working without the rest of the IO
>> controller logic creating a sensible system,
>
> That's exactly the problem we need to solve. The current situation
> is ... untenable. Regardless of whether the io.latency controller
> works well, the fact is that the wbt subsystem is active on -all-
> configurations and the way it "prioritises" is completely broken.

Completely broken is probably a little strong.   Before wbt, it was=20
impossible to do buffered IO without periodically saturating the drive=20
in unexpected ways.  We've got a lot of data showing it helping, and=20
it's pretty easy to setup a new A/B experiment to demonstrate it's=20
usefulness in current kernels.  But that doesn't mean it's perfect.

>
>> framework to define weights etc.  My question is if it's worth trying
>> inside of the wbt code, or if we should just let the metadata go
>> through.
>
> As I said, that doesn't  solve the problem. We /want/ critical
> journal IO to have higher priority that background metadata
> writeback. Just ignoring REQ_META doesn't help us there - it just
> moves the priority inversion to blocking on request queue tags.

Does XFS background metadata IO ever get waited on by critical journal=20
threads?  My understanding is that all of the filesystems do this from=20
time to time.  Without a way to bump the priority of throttled=20
background metadata IO, I can't see how to avoid prio inversions without=20
running background metadata at the same prio as all of the critical=20
journal IO.

>
>> Tejun reminded me that in a lot of ways, swap is user IO and it's
>> actually fine to have it prioritized at the same level as user IO. =20
>> We
>
> I think that's wrong. Swap *in* could have user priority but swap
> *out* is global as there is no guarantee that the page being swapped
> belongs to the user context that is reclaiming memory.
>
> Lots of other user and kernel reclaim contexts may be waiting on
> that swap to complete, so it's important that swap out is not
> arbitrarily delayed or susceptible to priority inversions. i.e. swap
> out must take priority over swap-in and other user IO because that
> IO may require allocation to make progress via swapping to free
> "user" file data cached in memory....
>
>> don't want to let a low prio app thrash the drive swapping things in=20
>> and
>> out all the time,
>
> Low priority apps will be throttled on *swap in* IO - i.e. by their
> incoming memory demand. High priority apps should be swapping out
> low priority app memory if there are shortages - that's what priority
> defines....
>
>> other higher priority processes aren't waiting for the memory.  This
>> depends on the cgroup config, so wrt your current patches it probably
>> sounds crazy, but we have a lot of data around this from the fleet.
>
> I'm not using cgroups.
>
> Core infrastructure needs to work without cgroups being configured
> to confine everything in userspace to "safe" bounds, and right now
> just running things in the root cgroup doesn't appear to work very
> well at all.

I'm not disagreeing with this part, my real point is there isn't a=20
single answer.  It's possible for swap to be critical to the running of=20
the box in some workloads, and totally unimportant in others.

-chris
