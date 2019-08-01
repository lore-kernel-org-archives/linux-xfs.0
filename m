Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33058 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725804AbfHANjs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 09:39:48 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 09/24] xfs: don't allow log IO to be throttled
Date: Thu, 1 Aug 2019 13:39:34 +0000
Message-ID: <F1E7CC65-D2CB-4078-9AA3-9D172ECDE17B@fb.com>
References: <20190801021752.4986-1-david@fromorbit.com>
 <20190801021752.4986-10-david@fromorbit.com>
In-Reply-To: <20190801021752.4986-10-david@fromorbit.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On 31 Jul 2019, at 22:17, Dave Chinner wrote:

> From: Dave Chinner <dchinner@redhat.com>
>
> Running metadata intensive workloads, I've been seeing the AIL
> pushing getting stuck on pinned buffers and triggering log forces.
> The log force is taking a long time to run because the log IO is
> getting throttled by wbt_wait() - the block layer writeback
> throttle. It's being throttled because there is a huge amount of
> metadata writeback going on which is filling the request queue.
>
> IOWs, we have a priority inversion problem here.
>
> Mark the log IO bios with REQ_IDLE so they don't get throttled
> by the block layer writeback throttle. When we are forcing the CIL,
> we are likely to need to to tens of log IOs, and they are issued as
> fast as they can be build and IO completed. Hence REQ_IDLE is
> appropriate - it's an indication that more IO will follow shortly.
>
> And because we also set REQ_SYNC, the writeback throttle will no
> treat log IO the same way it treats direct IO writes - it will not
> throttle them at all. Hence we solve the priority inversion problem
> caused by the writeback throttle being unable to distinguish between
> high priority log IO and background metadata writeback.
>
  [ cc Jens ]

We spent a lot of time getting rid of these inversions in io.latency=20
(and the new io.cost), where REQ_META just blows through the throttling=20
and goes into back charging instead.

It feels awkward to have one set of prio inversion workarounds for io.*=20
and another for wbt.  Jens, should we make an explicit one that doesn't=20
rely on magic side effects, or just decide that metadata is meta enough=20
to break all the rules?

-chris
