Return-Path: <SRS0=zZWs=CB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0348C433E1
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Aug 2020 22:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DC3C2067C
	for <linux-xfs@archiver.kernel.org>; Sun, 23 Aug 2020 22:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgHWWQ5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 18:16:57 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:33320 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726059AbgHWWQ4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Aug 2020 18:16:56 -0400
Received: from dread.disaster.area (pa49-181-146-199.pa.nsw.optusnet.com.au [49.181.146.199])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id BC32C6AC639;
        Mon, 24 Aug 2020 08:16:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1k9yI8-0000XT-LS; Mon, 24 Aug 2020 08:16:44 +1000
Date:   Mon, 24 Aug 2020 08:16:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Alberto Garcia <berto@igalia.com>, Kevin Wolf <kwolf@redhat.com>,
        qemu-devel@nongnu.org, qemu-block@nongnu.org,
        Max Reitz <mreitz@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/1] qcow2: Skip copy-on-write when allocating a zero
 cluster
Message-ID: <20200823221644.GI7941@dread.disaster.area>
References: <w518sedz3td.fsf@maestria.local.igalia.com>
 <20200817155307.GS11402@linux.fritz.box>
 <w51pn7memr7.fsf@maestria.local.igalia.com>
 <20200819150711.GE10272@linux.fritz.box>
 <20200819175300.GA141399@bfoster>
 <w51v9hdultt.fsf@maestria.local.igalia.com>
 <20200820215811.GC7941@dread.disaster.area>
 <20200821110506.GB212879@bfoster>
 <w51364gjkcj.fsf@maestria.local.igalia.com>
 <20200821125944.GC212879@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821125944.GC212879@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LPwYv6e9 c=1 sm=1 tr=0 cx=a_idp_d
        a=GorAHYkI+xOargNMzM6qxQ==:117 a=GorAHYkI+xOargNMzM6qxQ==:17
        a=kj9zAlcOel0A:10 a=y4yBn9ojGxQA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=Yn-qdE-4gtgSY-Nu0ZIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 21, 2020 at 08:59:44AM -0400, Brian Foster wrote:
> On Fri, Aug 21, 2020 at 01:42:52PM +0200, Alberto Garcia wrote:
> > On Fri 21 Aug 2020 01:05:06 PM CEST, Brian Foster <bfoster@redhat.com> wrote:
> > And yes, (4) is a bit slower than (1) in my tests. On ext4 I get 10%
> > more IOPS.
> > 
> > I just ran the tests with aio=native and with a raw image instead of
> > qcow2, here are the results:
> > 
> > qcow2:
> > |----------------------+-------------+------------|
> > | preallocation        | aio=threads | aio=native |
> > |----------------------+-------------+------------|
> > | off                  |        8139 |       7649 |
> > | off (w/o ZERO_RANGE) |        2965 |       2779 |
> > | metadata             |        7768 |       8265 |
> > | falloc               |        7742 |       7956 |
> > | full                 |       41389 |      56668 |
> > |----------------------+-------------+------------|
> > 
> 
> So this seems like Dave's suggestion to use native aio produced more
> predictable results with full file prealloc being a bit faster than per
> cluster prealloc. Not sure why that isn't the case with aio=threads. I

That will the context switch overhead with aio=threads becoming a
performance limiting factor at higher IOPS. The "full" workload
there is probably running at 80-120k context switches/s while the
aio=native if probably under 10k ctxsw/s because it doesn't switch
threads for every IO that has to be submitted/completed.

For all the other results, I'd consider the difference to be noise -
it's just not significant enough to draw any conclusions from at
all.

FWIW, the other thing that aio=native gives us is plugging across
batch IO submission. This allows bio merging before dispatch and
that can greatly increase performance of AIO when the IO being
submitted has some mergable submissions. That's not the case for
pure random IO like this, but there are relatively few pure random
IO workloads out there... :P

> was wondering if perhaps the threading affects something indirectly like
> the qcow2 metadata allocation itself, but I guess that would be
> inconsistent with ext4 showing a notable jump from (1) to (4) (assuming
> the previous ext4 numbers were with aio=threads).

> > raw:
> > |---------------+-------------+------------|
> > | preallocation | aio=threads | aio=native |
> > |---------------+-------------+------------|
> > | off           |        7647 |       7928 |
> > | falloc        |        7662 |       7856 |
> > | full          |       45224 |      58627 |
> > |---------------+-------------+------------|
> > 
> > A qcow2 file with preallocation=metadata is more or less similar to a
> > sparse raw file (and the numbers are indeed similar).
> > 
> > preallocation=off on qcow2 does not have an equivalent on raw files.
> > 
> 
> It sounds like preallocation=off for qcow2 would be roughly equivalent
> to a raw file with a 64k extent size hint (on XFS).

Yes, the effect should be close to identical, the only difference is
that qcow2 adds new clusters to the end of the file (i.e. the file
itself is not sparse), while the extent size hint will just add 64kB
extents into the file around the write offset. That demonstrates the
other behavioural advantage that extent size hints have is they
avoid needing to extend the file, which is yet another way to
serialise concurrent IO and create IO pipeline stalls...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
