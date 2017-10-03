Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7948 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750812AbdJCUcQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:32:16 -0400
Date: Wed, 4 Oct 2017 07:32:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Suggested XFS setup/options for 10TB file system w/ 18-20M files.
Message-ID: <20171003203214.GM3666@dastard>
References: <65736D53-5B93-46DD-95D2-02496B59D09C@gmail.com>
 <20171002231420.GI3666@dastard>
 <2F69CA38-6029-4D9B-BA3C-FD793E613693@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2F69CA38-6029-4D9B-BA3C-FD793E613693@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "R. Jason Adams" <rjasonadams@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Oct 03, 2017 at 02:10:57PM -0400, R. Jason Adams wrote:
> Reformated the drive and it's refilling. With the changes
> suggested (100 dir, 512 nodes, defaults) it already seems better.
> We’re currently at 6% full and the reads are quite a bit less
> than they were before at similar fullness.

Ok, that's good - we're making progress :)

> One thing I’m
> noticing in Grafana, the read request/s seem to keep increasing
> (up to ~8/s) for around an 15 minutes, then they drop down 1/s for
> 10-15 minutes.. then over the next 15 minutes they build back up..
> etc

I'm still curious as to what the reads are - can you run a blktrace
to try to capture some of them? That will give us a better idea of
what might be done to further reduce this.

It might be worth checking what is happening with the xfs inode
cache and overall memory usage and see if this change in read
behaviour correlates with memory reclaim being active?

> > FWIW, how much RAM do you have in the system, and what does
> > 'echo 200 > /proc/sys/fs/xfs/xfssyncd_centisecs' do to the
> > behaviour?
> 
> System has 24G of ram. I’m guessing a move to 96 or 192G would
> help a lot.. in the end the system will have 36 of these 10TB
> drives.

24G should be enough if you're not walking the entire data set
periodically. The working set of inodes should be pretty small,
so the amount of memory being used to cache the working set
shouldn't be huge nor cause much trouble in terms of turnover.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
