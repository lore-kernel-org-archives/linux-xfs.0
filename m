Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49A9C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 05:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbiDNFUa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 01:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbiDNFU3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 01:20:29 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B01613C4B5
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 22:18:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-115-138.pa.nsw.optusnet.com.au [49.181.115.138])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8B7E210C7CBA;
        Thu, 14 Apr 2022 15:18:03 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nerrl-00HUnv-C1; Thu, 14 Apr 2022 15:18:01 +1000
Date:   Thu, 14 Apr 2022 15:18:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Dunlop <chris@onthe.net.au>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Limits to growth
Message-ID: <20220414051801.GM1544202@dread.disaster.area>
References: <20220414040024.GA550443@onthe.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414040024.GA550443@onthe.net.au>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6257ae8b
        a=/kVtbFzwtM2bJgxRVb+eeA==:117 a=/kVtbFzwtM2bJgxRVb+eeA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=OLL_FvSJAAAA:8 a=7-415B0cAAAA:8
        a=kcv77Ns9LPlNEK7RUsEA:9 a=CjuIK1q_8ugA:10 a=s8Q-P5ZNcwsA:10
        a=cuWa6V1mSGoA:10 a=oIrB72frpwYPwTMnlWqB:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 14, 2022 at 02:00:24PM +1000, Chris Dunlop wrote:
> Hi,
> 
> I have a nearly full 30T xfs filesystem that I need to grow significantly,
> e.g. to, say, 256T, and potentially further in future, e.g. up to, say, 1PB.

That'll be fun. :)

> Alternatively at some point I'll need to copy a LOT of data from the
> existing fs to a newly-provisioned much larger fs. If I'm going to need to
> copy data around I guess it's better to do it now, before there's a whole
> lot more data to copy.
> 
> According to Dave Chinner:
> 
>   https://www.spinics.net/lists/linux-xfs/msg20084.html
>   Rule of thumb we've stated every time it's been asked in the past 10-15
> years is "try not to grow by more than 10x the original size".
> 
> It's also explained the issue is the number of AGs.
> 
> Is it ONLY the number of AGs that's a concern when growing a fs?

No.

> E.g. for a fs starting in the 10s of TB that may need to grow substantially
> (e.g. >=10x), is it advisable to simply create it with the maximum available
> agsize, and you can then grow to whatever multiple without worrying about
> XFS getting ornery?

If you start with anything greater 4-32TB, there's a good chance
you've already got maximally sized AGs....

> Looking my fs and just considering the number of AGs (agcount)...
> 
> My original fs has:
> 
> meta-data=xxxx           isize=512    agcount=32, agsize=244184192 blks

Which is just short of maximally sized AGs. There's nothing to be
gained by reformatting to larger AGs here.

>          =               sectsz=4096  attr=2, projid32bit=1
>          =               crc=1        finobt=1, sparse=1, rmapbt=1
>          =               reflink=1    bigtime=0 inobtcount=0
> data     =               bsize=4096   blocks=7813893120, imaxpct=5
>          =               sunit=128    swidth=512 blks
> naming   =version 2      bsize=4096   ascii-ci=0, ftype=1
> log      =internal log   bsize=4096   blocks=521728, version=2
>          =               sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none           extsz=4096   blocks=0, rtextents=0
> 
> If I do a test xfs_grow to 256T, it shows:
> 
> metadata=xxxxx           isize=512    agcount=282, agsize=244184192 blks
> 
> Creating a new fs on 256T, I get:
> 
> metadata=xxxxx           isize=512    agcount=257, agsize=268435328 blks

Yup.

> So growing the fs from 30T to 256T I end up with an agcount ~10% larger (and
> agsize ~10% smaller) than creating a 256T fs from scratch.

Yup.

> Just for the exercise, creating a new FS on 1P (i.e. 33x the current fs)
> gives:
> 
> metadata=xxxxx           isize=512    agcount=1025, agsize=268435328 blks

Yup.

> I.e. it looks like for this case the max agsize is 268435328 blocks.

Yup.

> So even
> if the current fs were to grow to a 1P or more, e.g. 30x - 60x original, I'm
> still only going to be ~10% worse off in terms of agcount than creating a
> large fs from scratch and copying all the data over.

Yup.

> Is that really going to make a significant difference?

No.

But there will be significant differences. e.g. think of the data
layout and free space distribution of a 1PB filesystem that it is
90% full and had it's data evenly distributed throughout it's
capacity. Now consider the free space distribution of a 100TB
filesystem that has been filled to 99% and then grown by 100TB nine
times to a capacity of 90% @ 1PB. Where is all the free space?

That's right - the free space is only in the region that was
appended in the last 100TB grow operation. IOWs, 90% of the AGs are
completley full, and the newly added 10% are compeltely empty.

However, the allocation algorithms do linear target increments and
linear scans over *all AGs* trying to distribute the allocation
across the entire filesystem and to find the best available free
space for allocations.  When you have hundreds of AGs and only 10%
of them have usable free space, this becomes a problem.  e.g. if the
locality algorithm targets low numbered AGs that are full (and it
will because the target increments and wraps in a linear fashion),
then it might be scanning hundreds of AGs before it finds one of the
recently added high numbered AGs with a big enough free space to
allocate from.

Then consider that it is not unreasonable for the filesystem to hit
this case for thousands of consecutive allocations at a time (e.g.
untarring a tarball full of small files such as a kernel source tree
will trigger this), maybe even occur for every single allocation
over a time span of minutes or even hours.

IOWs, the scanning algorithms don't really scale to large numbers of
AGs when most of the AGs are full and cannot be allocated from, and
repeatedly growing full filesystems pushes the algorithms into
highly undesirable corner cases much, much faster than filesystems
that started off with that capacity,,,

IOWs, growing by more than 10x really starts to push the limits of
the algorithms regardless of the AG count it results in.  It's not a
capacity thing - it's a reflection of the number of AGs with usable
free space in them and the algorithms used to find free space in
those AGs.

The algorithms can be fixed, but it's not been an important issue to
solve because so few people are using grow[*] in this manner - growing
once or twice is generally as much as occurs over the life of a
typical production filesysetm...

Cheers,

Dave.

[*] Now, if you have a 2GB filesystem and you grow it to several TB
(that's a nasty antipattern we see quite frequently in cloud
deployments) then having 10,000+ tiny AGs has these linear scan
problems as well as all sorts of other scalability issues related to
the sheer number of AGs, but that's a different set of large ag count
problems....

-- 
Dave Chinner
david@fromorbit.com
