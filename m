Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6O2aO7I236682 for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 21:36:25 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEB46C20A04
	for <xfs@oss.sgi.com>; Fri, 23 Jul 2010 19:46:25 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	BtDGyKf3nctkycrz for <xfs@oss.sgi.com>;
	Fri, 23 Jul 2010 19:46:25 -0700 (PDT)
Date: Sat, 24 Jul 2010 12:39:22 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: filesystem shrinks after using xfs_repair
Message-ID: <20100724023922.GP32635@dastard>
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
	<20100712134743.624249b2@harpe.intellique.com>
	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
	<20100724005426.GN32635@dastard>
	<F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eli Morris <ermorris@ucsc.edu>
Cc: xfs@oss.sgi.com

On Fri, Jul 23, 2010 at 06:08:08PM -0700, Eli Morris wrote:
> On Jul 23, 2010, at 5:54 PM, Dave Chinner wrote:
> > On Fri, Jul 23, 2010 at 01:30:40AM -0700, Eli Morris wrote:
> >> I think the raid tech support and me found and corrected the
> >> hardware problems associated with the RAID. I'm still having the
> >> same problem though. I expanded the filesystem to use the space of
> >> the now corrected RAID and that seems to work OK. I can write
> >> files to the new space OK. But then, if I run xfs_repair on the
> >> volume, the newly added space disappears and there are tons of
> >> error messages from xfs_repair (listed below).
> > 
> > Can you post the full output of the xfs_repair? The superblock is
> > the first thing that is checked and repaired, so if it is being
> > "repaired" to reduce the size of the volume then all the other errors
> > are just a result of that. e.g. the grow could be leaving stale
> > secndary superblocks around and repair is seeing a primary/secondary
> > mismatch and restoring the secondary which has the size parameter
> > prior to the grow....
> > 
> > Also, the output of 'cat /proc/partitions' would be interesting
> > from before the grow, after the grow (when everything is working),
> > and again after the xfs_repair when everything goes bad....
> 
> Thanks for replying. Here is the output I think you're looking for....

Sure is. The underlying device does not change configuration, and:

> [root@nimbus /]# xfs_repair /dev/mapper/vg1-vol5
> Phase 1 - find and verify superblock...
> writing modified primary superblock
> Phase 2 - using internal log

There's a smoking gun - the primary superblock was modified in some
way. Looks like the only way we can get this occurring without an
error or warning being emitted is if repair found more superblocks
with the old geometry in it them than the new geometry.

With a current kernel, growfs is supposed to update every single
secondary superblock, so I can't see how this could be occurring.
However, can you remind me what kernel your are running and gather
the following information?

Run this before the grow:

# echo 3 > /proc/sys/vm/drop-caches
# for ag in `seq 0 1 125`; do
> xfs_db -r -c "sb $ag" -c "p agcount" -c "p dblocks" <device>
> done

Then run the grow, sync, and unmount the filesystem. After that,
re-run the above xfs_db command and post the output of both so I can
see what growfs is actually doing to the secondary superblocks?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
