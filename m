Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58840 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728414AbfHBOM1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Aug 2019 10:12:27 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 09/24] xfs: don't allow log IO to be throttled
Date: Fri, 2 Aug 2019 14:11:53 +0000
Message-ID: <7093F5C3-53D2-4C49-9C0D-64B20C565D18@fb.com>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-10-david@fromorbit.com>
 <F1E7CC65-D2CB-4078-9AA3-9D172ECDE17B@fb.com>
 <20190801235849.GO7777@dread.disaster.area>
In-Reply-To: <20190801235849.GO7777@dread.disaster.area>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On 1 Aug 2019, at 19:58, Dave Chinner wrote:

> On Thu, Aug 01, 2019 at 01:39:34PM +0000, Chris Mason wrote:
>> On 31 Jul 2019, at 22:17, Dave Chinner wrote:
>>
>>> From: Dave Chinner <dchinner@redhat.com>
>>>
>>> Running metadata intensive workloads, I've been seeing the AIL
>>> pushing getting stuck on pinned buffers and triggering log forces.
>>> The log force is taking a long time to run because the log IO is
>>> getting throttled by wbt_wait() - the block layer writeback
>>> throttle. It's being throttled because there is a huge amount of
>>> metadata writeback going on which is filling the request queue.
>>>
>>> IOWs, we have a priority inversion problem here.
>>>
>>> Mark the log IO bios with REQ_IDLE so they don't get throttled
>>> by the block layer writeback throttle. When we are forcing the CIL,
>>> we are likely to need to to tens of log IOs, and they are issued as
>>> fast as they can be build and IO completed. Hence REQ_IDLE is
>>> appropriate - it's an indication that more IO will follow shortly.
>>>
>>> And because we also set REQ_SYNC, the writeback throttle will no
>>> treat log IO the same way it treats direct IO writes - it will not
>>> throttle them at all. Hence we solve the priority inversion problem
>>> caused by the writeback throttle being unable to distinguish between
>>> high priority log IO and background metadata writeback.
>>>
>>   [ cc Jens ]
>>
>> We spent a lot of time getting rid of these inversions in io.latency
>> (and the new io.cost), where REQ_META just blows through the=20
>> throttling
>> and goes into back charging instead.
>
> Which simply reinforces the fact that that request type based
> throttling is a fundamentally broken architecture.
>
>> It feels awkward to have one set of prio inversion workarounds for=20
>> io.*
>> and another for wbt.  Jens, should we make an explicit one that=20
>> doesn't
>> rely on magic side effects, or just decide that metadata is meta=20
>> enough
>> to break all the rules?
>
> The problem isn't REQ_META blows throw the throttling, the problem
> is that different REQ_META IOs have different priority.

Yes and no.  At some point important FS threads have the potential to=20
wait on every single REQ_META IO on the box, so every single REQ_META IO=20
has the potential to create priority inversions.

>
> IOWs, the problem here is that we are trying to infer priority from
> the request type rather than an actual priority assigned by the
> submitter. There is no way direct IO has higher priority in a
> filesystem than log IO tagged with REQ_META as direct IO can require
> log IO to make progress. Priority is a policy determined by the
> submitter, not the mechanism doing the throttling.
>
> Can we please move this all over to priorites based on
> bio->b_ioprio? And then document how the range of priorities are
> managed, such as:
>
> (99 =3D highest prio to 0 =3D lowest)
>
> swap out
> swap in				>90
> User hard RT max		89
> User hard RT min		80
> filesystem max			79
> ionice max			60
> background data writeback	40
> ionice min			20
> filesystem min			10
> idle				0
>
> So that we can appropriately prioritise different types of kernel
> internal IO w.r.t user controlled IO priorities? This way we can
> still tag the bios with the type of data they contain, but we
> no longer use that to determine whether to throttle that IO or not -
> throttling/scheduling should be done entirely on a priority basis.

I think you and I are describing solutions to different problems.  The=20
reason the back charging works so well in io.latency and io.cost is=20
because the IO controllers are able to remember that a given cgroup=20
created X amount of IO, and then just make that cgroup wait at a safe=20
time, instead of trying to assign priority to things that have infinite=20
priority.

I can't really see bio->b_ioprio working without the rest of the IO=20
controller logic creating a sensible system, and giving userland the=20
framework to define weights etc.  My question is if it's worth trying=20
inside of the wbt code, or if we should just let the metadata go=20
through.

Tejun reminded me that in a lot of ways, swap is user IO and it's=20
actually fine to have it prioritized at the same level as user IO.  We=20
don't want to let a low prio app thrash the drive swapping things in and=20
out all the time, and it's actually fine to make them wait as long as=20
other higher priority processes aren't waiting for the memory.  This=20
depends on the cgroup config, so wrt your current patches it probably=20
sounds crazy, but we have a lot of data around this from the fleet.

-chris
