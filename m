Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 792E5C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Mar 2022 08:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbiCQIZw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Mar 2022 04:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiCQIZt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Mar 2022 04:25:49 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28B5A16BFAE
        for <linux-xfs@vger.kernel.org>; Thu, 17 Mar 2022 01:24:15 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 71D5753395D;
        Thu, 17 Mar 2022 19:24:11 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUlQZ-006TWf-2F; Thu, 17 Mar 2022 19:24:11 +1100
Date:   Thu, 17 Mar 2022 19:24:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        "Spraul Manfred (XC/QMM21-CT)" <Manfred.Spraul@de.bosch.com>
Subject: Re: Metadata CRC error detected at
 xfs_dir3_block_read_verify+0x9e/0xc0 [xfs], xfs_dir3_block block 0x86f58
Message-ID: <20220317082411.GA3927073@dread.disaster.area>
References: <613af505-7646-366c-428a-b64659e1f7cf@colorfullife.com>
 <20220313224624.GJ3927073@dread.disaster.area>
 <8024317e-07be-aa3d-9aa3-2f835aaa1278@colorfullife.com>
 <3242ad20-0039-2579-b125-b7a9447a7230@colorfullife.com>
 <20220317024705.GY3927073@dread.disaster.area>
 <20220317030828.GZ3927073@dread.disaster.area>
 <21c13283-2a9f-4978-25e4-228e44ab74e6@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21c13283-2a9f-4978-25e4-228e44ab74e6@colorfullife.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6232f02d
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=Vru7tE-Dn4nHED3q0wEA:9 a=CjuIK1q_8ugA:10 a=BjvGB96Vj3QA:10
        a=5gVn6xHntvQA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 17, 2022 at 07:49:02AM +0100, Manfred Spraul wrote:
> Hi Dave,
> 
> [+Ted as the topic also applies to ext4]
> 
> On 3/17/22 04:08, Dave Chinner wrote:
> > On Thu, Mar 17, 2022 at 01:47:05PM +1100, Dave Chinner wrote:
> > > On Wed, Mar 16, 2022 at 09:55:04AM +0100, Manfred Spraul wrote:
> > > > Hi Dave,
> > > > 
> > > > On 3/14/22 16:18, Manfred Spraul wrote:
> > > > 
> > > > But:
> > > > 
> > > > I've checked the eMMC specification, and the spec allows that teared write
> > > > happen:
> > > Yes, most storage only guarantees that sector writes are atomic and
> > > so multi-sector writes have no guarantees of being written
> > > atomically.  IOWs, all storage technologies that currently exist are
> > > allowed to tear multi-sector writes.
> > > 
> > > However, FUA writes are guaranteed to be whole on persistent storage
> > > regardless of size when the hardware signals completion. And any
> > > write that the hardware has signalled as complete before a cache
> > > flush is received is also guaranteed to be whole on persistent
> > > storage when the cache flush is signalled as complete by the
> > > hardware. These mechanisms provide protection against torn writes.
> 
> My plan was to create a replay application that randomly creates disc images
> allowed by the writeback_cache_control documentation.
> 
> https://www.kernel.org/doc/html/latest/block/writeback_cache_control.html
>
> And then check that the filesystem behaves as expected/defined.

We already have that tool that exercises stepwise flush/fua aware
write recovery for filesystem testing: dm-logwrites was written and
integrated into fstests years ago (2016?) by Josef Bacik for testing
btrfs recovery, but it was a generic solution that all filesystems
can use to test failure recovery....

See, for example, common/dmlogwrites and tests/generic/482 - g/482
uses fsstress to randomly modify the filesystem while dm-logwrites
records all the writes made by the filesystem. It then replays them
one flush/fua at a time, mounting the filesystem to ensure that it
can recover the filesystem, then runs filesystem checkers to ensure
that the filesystem does not have any corrupt metadata. Then it
replays to the next flush/fua and repeats.

tools/dm-logwrite-replay provides a script and documents the
methodology to run step by step through replay of g/482 failures to
be able to reliably reproduce and diagnose the cause of the failure.

There's no need to re-invent the wheel if we've already got a
perfectly good one...

> > > > Is my understanding correct that XFS support neither eMMC nor NVM devices?
> > > > (unless there is a battery backup that exceeds the guarantees from the spec)
> > > Incorrect.
> > > 
> > > They are supported just fine because flush/FUA semantics provide
> > > guarantees against torn writes in normal operation. IOWs, torn
> > > writes are something that almost *never* happen in real life, even
> > > when power fails suddenly. Despite this, XFS can detect it has
> > > occurred (because broken storage is all too common!), and if it
> > > can't recovery automatically, it will shut down and ask the user to
> > > correct the problem.
> 
> So for xfs the behavior should be:
> 
> - without torn writes: Mount always successful, no errors when accessing the
> content.

Yes.

Of course, there are software bugs, so mounts, recovery and
subsequent repair testing can still fail.

> - with torn writes: There may be error that will be detected only at
> runtime. The errors may at the end cause a file system shutdown.

Yes, and they may even prevent the filesystem from being mounted
because recovery trips over them (e.g. processing pending unlinked
inodes or replaying incomplete intents).

> (commented dmesg is attached)
> 
> The application I have in mind are embedded systems.
> I.e. there is no user that can correct something, the recovery strategy must
> be included in the design.

Good luck with that - storage hardware fails in ways that no
existing filesystem can recover automatically from 100% of the time.
And very few even attempt to do so because it is largely an
impossible requirement to fulfil. Torn writes are just the tip of
the iceberg....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
