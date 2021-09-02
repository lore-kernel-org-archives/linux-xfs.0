Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF398C432BE
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 01:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC7886054F
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 01:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhIBBnQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Sep 2021 21:43:16 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:48347 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229454AbhIBBnQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Sep 2021 21:43:16 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 57FC61144670;
        Thu,  2 Sep 2021 11:42:16 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLbjy-007fCO-Je; Thu, 02 Sep 2021 11:42:06 +1000
Date:   Thu, 2 Sep 2021 11:42:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: Mysterious ENOSPC
Message-ID: <20210902014206.GN2566745@dread.disaster.area>
References: <335ae292-cb09-6e6e-9673-68cfae666fc0@sandeen.net>
 <20210826205635.GA2453892@onthe.net.au>
 <20210827025539.GA3583175@onthe.net.au>
 <20210827054956.GP3657114@dread.disaster.area>
 <20210827065347.GA3594069@onthe.net.au>
 <20210827220343.GQ3657114@dread.disaster.area>
 <20210828002137.GA3642069@onthe.net.au>
 <20210828035824.GA3654894@onthe.net.au>
 <20210829220457.GR3657114@dread.disaster.area>
 <20210830073720.GA3763165@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830073720.GA3763165@onthe.net.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=gtWBzVrL4aRwStGtoSkA:9 a=CjuIK1q_8ugA:10 a=q1W7-ncRT9EA:10
        a=V8jACeeQO_sA:10 a=_UtYBm2FmLkA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 30, 2021 at 05:37:20PM +1000, Chris Dunlop wrote:
> On Mon, Aug 30, 2021 at 08:04:57AM +1000, Dave Chinner wrote:
> > On Sat, Aug 28, 2021 at 01:58:24PM +1000, Chris Dunlop wrote:
> > > On Sat, Aug 28, 2021 at 10:21:37AM +1000, Chris Dunlop wrote:
> > > > On Sat, Aug 28, 2021 at 08:03:43AM +1000, Dave Chinner wrote:
> > > > > commit fd43cf600cf61c66ae0a1021aca2f636115c7fcb
> > > > > Author: Brian Foster <bfoster@redhat.com>
> > > > > Date:   Wed Apr 28 15:06:05 2021 -0700
> > > > > 
> > > > >   xfs: set aside allocation btree blocks from block reservation
> > > > 
> > > > Oh wow. Yes, sounds like a candidate. Is there same easy(-ish?) way of
> > > > seeing if this fs is likely to be suffering from this particular issue
> > > > or is it a matter of installing an appropriate kernel and seeing if the
> > > > problem goes away?
> > > 
> > > Is this sufficient to tell us that this filesystem probably isn't suffering
> > > from that issue?
> > 
> > IIRC, it's the per-ag histograms that are more important here
> > because we are running out of space in an AG because of
> > overcommitting the per-ag space. If there is an AG that is much more
> > fragmented than others, then it will be consuming much more in way
> > of freespace btree blocks than others...
> 
> Per-ag histograms attached.
> 
> Do the blocks used by the allocation btrees show up in the AG histograms?
> E.g. with an AG like this:
> 
> AG 18
>    from      to extents  blocks    pct
>       1       1    1961    1961   0.01
>       2       3   17129   42602   0.11
>       4       7   33374  183312   0.48
>       8      15   68076  783020   2.06
>      16      31  146868 3469398   9.14
>      32      63  248690 10614558  27.96
>      64     127   32088 2798748   7.37
>     128     255    8654 1492521   3.93
>     256     511    4227 1431586   3.77
>     512    1023    2531 1824377   4.81
>    1024    2047    2125 3076304   8.10
>    2048    4095    1615 4691302  12.36
>    4096    8191    1070 6062351  15.97
>    8192   16383     139 1454627   3.83
>   16384   32767       2   41359   0.11
> total free extents 568549
> total free blocks 37968026
> average free extent size 66.7806
> 
> ...it looks like it's significantly fragmented, but, if the allocation
> btrees aren't part of this, it seems there's still sufficient free space
> that it shouldn't be getting to ENOSPC?

Unless something asks for ~120GB of space to be allocated from the
AG, and then it will have only a small amount of free space and
could trigger such issues.

As you said, this is difficult to reproduce, so the current state of
the FS is unlikely to be in the exact state that triggers the
problem. What I'm looking at is whether the underlying conditions
are present that could potentially lead to that sort of problem
occuring

> > Context is very important when trying to determine if free space
> > fragmentation is an issue or not. Most of the time, it isn't an
> > issue at all but people have generally been trained to think "all
> > fragmentation is bad" rather than "only worry about fragmentation if
> > there is a problem that is directly related to physical allocation
> > patterns"...
> 
> In this case it's a typical backup application: it uploads regular
> incremental files and those are later merged into a full backup file, either
> by extending or overwriting or reflinking depending on whether the app
> decides to use reflinks or not. The uploads are sequential and mostly
> large-ish writes (132K+), then the merge is small to medium size randomish
> writes or reflinks (4K-???). So the smaller writes/reflinks are going to
> create a significant amount of fragmentation. The incremental files are
> removed entirely at some later time (no discard involved).

IOWs, sets of data with different layouts and temporal
characteristics. Yup, that will cause fragmentation over time and
slowly prevent recovery of large free spaces as files are deleted.
The AG histograms largely reflect this.

> I guess if it's determined this pattern is critically suboptimal and causing
> this errant ENOSPC issue, and the changes in 5.13 don't help, there's
> nothing to stop me from occasionally doing a full (non-reflink) copy of the
> large full backup files into another file to get them nicely sequential. I'd
> lose any reflinks along the way of course, but they don't last a long time
> anyway (days to a few weeks) depending on how long the smaller incremental
> files are kept.

IOWs, you suggest defragmenting the file data. You could do that
transparently with xfs_fsr, but defragmenting data doesn't actually
fix free space fragmentation - it actually makes it worse. This is
inherent in the defragmentation algorithm - small used spaces get
turned into small free spaces and large free spaces get turned into
large used spaces.

Defragmenting free space is a whole lot harder, and it involves
identifying where free space is interleaved with data and then
moving that data to other free space so the small free spaces are
reconnected into a large free space. Defragmenting data is easy,
defragmenting free space is much harder...

> AG 15
>    from      to extents  blocks    pct
>       1       1     207     207   0.00
>       2       3     519    1471   0.02
>       4       7    1978   10867   0.13
>       8      15    3736   42434   0.50
>      16      31    6604  154719   1.83
>      32      63   13689  653865   7.73
>      64     127   24824 2356818  27.86
>     128     255   21639 3771966  44.59
>     256     511    1990  611208   7.23
>     512    1023     157  105129   1.24
>    1024    2047      74  107559   1.27
>    2048    4095     153  377991   4.47
>    4096    8191      27  163987   1.94
>    8192   16383       9  101213   1.20
> total free extents 75606
> total free blocks 8459434
> average free extent size 111.888

This is the AG is a candidate - it's only got ~35GB of free space
in it and has significant free space fragmentation - at least 160
freespace btree blocks per btree in this AG.

> AG 30
>    from      to extents  blocks    pct
>       1       1    1672    1672   0.03
>       2       3    1073    2577   0.05
>       4       7    1202    6461   0.13
>       8      15    1751   19741   0.39
>      16      31    2830   65939   1.29
>      32      63    4589  216879   4.25
>      64     127    8443  801744  15.71
>     128     255    5988 1023450  20.05
>     256     511    2230  737877  14.46
>     512    1023     714  495411   9.71
>    1024    2047     377  536218  10.51
>    2048    4095     212  611170  11.98
>    4096    8191      85  478388   9.37
>    8192   16383       7   86683   1.70
>   16384   32767       1   19328   0.38
> total free extents 31174
> total free blocks 5103538
> average free extent size 163.711

This one has the least free space, but fewer free space
extents. It's still a potential candidate for AG ENOSPC conditions
to be triggered, though.

Ok, now I've seen the filesystem layout, I can say that the
preconditions for per-ag ENOSPC conditions do actually exist. Hence
we now really need to know what operation is reporting ENOSPC. I
guess we'll just have to wait for that to occur again and hope your
scripts capture it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
