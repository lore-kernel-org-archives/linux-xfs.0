Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:28527 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967864AbdDSXsn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 19:48:43 -0400
Date: Thu, 20 Apr 2017 09:48:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfsaild in D state seems to be blocking all other i/o
 sporadically
Message-ID: <20170419234838.GH12369@dastard>
References: <e5f2ccc2-7923-934c-e655-59983903ca11@dermichi.com>
 <20170419121202.2m3pi4ffojpnqyxc@eorzea.usersys.redhat.com>
 <ced08a44-d736-6250-c682-0f495a882bea@dermichi.com>
 <82e1fa48-909c-97a4-6bf9-5b84cf0af986@dermichi.com>
 <20170419140446.3rl2pruz2dlcr5cg@eorzea.usersys.redhat.com>
 <d6f598d1-7e7e-ac85-3cdc-e4f4bfdba94e@dermichi.com>
 <20170419180811.GB41631@bfoster.bfoster>
 <268ce851-dad0-a777-526a-82ad967490cd@dermichi.com>
 <20170419205525.GD5205@birch.djwong.org>
 <86fbec25-f026-350b-ffe3-b0b182b768ac@dermichi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86fbec25-f026-350b-ffe3-b0b182b768ac@dermichi.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Michael Weissenbacher <mw@dermichi.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Wed, Apr 19, 2017 at 11:47:43PM +0200, Michael Weissenbacher wrote:
> OK, do i understand you correctly that the xfsaild does all the actual
> work of updating the inodes? And it's doing that single-threaded,
> reading both the log and the indoes themselves?

The problem is that the backing buffers that are used for flushing
inodes have been reclaimed due to memory pressure, but the inodes in
cache are still dirty. Hence to write the dirty inodes, we first
have to read the inode buffer back into memory.

Essentially, the log pins more dirty inodes than than writeback
can keep up with given the memory pressure that is occurring.

> 
> > ...500MB / 200 bytes per dirty inode record = ~2.5 million inodes.
> > ~2.5m inodes / 10 minutes = ~4200 inodes per second...
> Yes, these numbers sound plausible. When everything is running smoothly
> (i.e. most of the time) i do see up to 4500 combined reads+writes per
> second. But when the problem arises, all i see i xfsaild doing around
> 120 reads/second, which is roughly the performance of a single 7200rpm
> drive. Directly after this "read only phase" (which lasts for about 5-10
> minutes most of the time) there is a short burst of up to 10000+
> writes/sec (writing to the RAID controller cache I suppose).

Yes. Inode buffer reads from the xfsaild are sequential so block the
aild and log tail pushing while they are on-going. It then queues
the writes on a delayed write list and they are issued all in one
go. Essentially, the system can dirty far more metadata in memory
than it can effectively cache and flush to disk in a timely manner.

> And then
> the system goes back to the "normal phase" where it is doing both reads
> and writes and all those blocked D state processes continue working.

Yup, because the xfsaild has move the tail of the log, so there is
now log space available and ongoing transactions can run at CPU
speed again. The xfsaild will still be doing RMW inode writeback,
but nothing is blocking waiting for it to reach it's target now...

I'd suggest that the only thing you can realistically do to mitigate
this stall without changing the log size is change
/proc/sys/fs/xfs/xfssyncd_centisecs down to one second so that the
CIL is flushed to disk every second, and the AIL push target is
updated immediately after the CIL flush is done. This will result in
the xfsaild trying to push metadata almost as quickly as it is
committed to the journal, hence it should be trying to flush inodes
while th einode buffer is still cached in memory and hence avoid the
read IO. This will help avoid AIL pushing from getting so far behind
that inode buffers are reclaimed before the dirty inodes are
written. It may not completely avoid the stalls, but it should make
them less frequent...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
