Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6Q3gt7n094561 for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 22:42:55 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E8F146FE47
	for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 20:45:57 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	AorPVooHHjatYi6D for <xfs@oss.sgi.com>;
	Sun, 25 Jul 2010 20:45:57 -0700 (PDT)
Date: Mon, 26 Jul 2010 13:45:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: filesystem shrinks after using xfs_repair
Message-ID: <20100726034545.GE655@dastard>
References: <DFB2DB04-A3BA-4272-A12A-4F28A7D51491@ucsc.edu>
	<20100712134743.624249b2@harpe.intellique.com>
	<274A8D0C-4C31-4FB9-AB2D-BA3C31D497E0@ucsc.edu>
	<20100724005426.GN32635@dastard>
	<F2AC32C3-2437-4625-980A-3BC9B3C541A2@ucsc.edu>
	<20100724023922.GP32635@dastard>
	<777100A1-57DE-4DE0-B1F0-64977BD694AD@ucsc.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <777100A1-57DE-4DE0-B1F0-64977BD694AD@ucsc.edu>
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

On Sun, Jul 25, 2010 at 08:20:44PM -0700, Eli Morris wrote:
> On Jul 23, 2010, at 7:39 PM, Dave Chinner wrote:
> > On Fri, Jul 23, 2010 at 06:08:08PM -0700, Eli Morris wrote:
> >> On Jul 23, 2010, at 5:54 PM, Dave Chinner wrote:
> >>> On Fri, Jul 23, 2010 at 01:30:40AM -0700, Eli Morris wrote:
> >>>> I think the raid tech support and me found and corrected the
> >>>> hardware problems associated with the RAID. I'm still having the
> >>>> same problem though. I expanded the filesystem to use the space of
> >>>> the now corrected RAID and that seems to work OK. I can write
> >>>> files to the new space OK. But then, if I run xfs_repair on the
> >>>> volume, the newly added space disappears and there are tons of
> >>>> error messages from xfs_repair (listed below).
> >>> 
> >>> Can you post the full output of the xfs_repair? The superblock is
> >>> the first thing that is checked and repaired, so if it is being
> >>> "repaired" to reduce the size of the volume then all the other errors
> >>> are just a result of that. e.g. the grow could be leaving stale
> >>> secndary superblocks around and repair is seeing a primary/secondary
> >>> mismatch and restoring the secondary which has the size parameter
> >>> prior to the grow....
> >>> 
> >>> Also, the output of 'cat /proc/partitions' would be interesting
> >>> from before the grow, after the grow (when everything is working),
> >>> and again after the xfs_repair when everything goes bad....
> >> 
> >> Thanks for replying. Here is the output I think you're looking for....
> > 
> > Sure is. The underlying device does not change configuration, and:
> > 
> >> [root@nimbus /]# xfs_repair /dev/mapper/vg1-vol5
> >> Phase 1 - find and verify superblock...
> >> writing modified primary superblock
> >> Phase 2 - using internal log
> > 
> > There's a smoking gun - the primary superblock was modified in some
> > way. Looks like the only way we can get this occurring without an
> > error or warning being emitted is if repair found more superblocks
> > with the old geometry in it them than the new geometry.
> > 
> > With a current kernel, growfs is supposed to update every single
> > secondary superblock, so I can't see how this could be occurring.
> > However, can you remind me what kernel your are running and gather
> > the following information?
> > 
> > Run this before the grow:
> > 
> > # echo 3 > /proc/sys/vm/drop-caches
> > # for ag in `seq 0 1 125`; do
> >> xfs_db -r -c "sb $ag" -c "p agcount" -c "p dblocks" <device>
> >> done
> > 
> > Then run the grow, sync, and unmount the filesystem. After that,
> > re-run the above xfs_db command and post the output of both so I can
> > see what growfs is actually doing to the secondary superblocks?
> 
> [root@nimbus ~]# uname -a
> Linux nimbus.pmc.ucsc.edu 2.6.18-128.1.14.el5 #1 SMP Wed Jun 17 06:38:05 EDT 2009 x86_64 x86_64 x86_64 GNU/Linux

Ok, so that's a relatively old RHEL or Centos version, right?

> [root@nimbus vm]#  echo 3 > /proc/sys/vm/drop_caches
> [root@nimbus vm]# for ag in `seq 0 1 125`; do
> > xfs_db -r -c "sb $ag" -c "p agcount" -c "p dblocks" /dev/vg1/vol5
> > done
> agcount = 126
> dblocks = 13427728384
> agcount = 126
> dblocks = 13427728384
....

All nice and consistent before.

> [root@nimbus vm]# umount /export/vol5
> [root@nimbus vm]#  echo 3 > /proc/sys/vm/drop_caches
> [root@nimbus vm]# for ag in `seq 0 1 125`; do
> > xfs_db -r -c "sb $ag" -c "p agcount" -c "p dblocks" /dev/vg1/vol5
> > done
> agcount = 156
> dblocks = 16601554944
> agcount = 126
> dblocks = 13427728384
> agcount = 126
> dblocks = 13427728384
.....

And after the grow only the primary superblock has the new size and
agcount, which is why repair is returning it back to the old size.
Can you dump the output after the grow for 155 AGs instead of 125
so we can see if the new secondary superblocks were written? (just
dumping `seq 125 1 155` will be fine.)

Also, the only way I can see this happening is that if there is an
IO error reading or writing the first secondary superblock. That
should leave a warning in dmesg - can you check to see if there's an
error of the form "error %d reading secondary superblock for ag %d"
or "write error %d updating secondary superblock for ag %d" in the
logs? I notice that if this happens, we log but don't return the
error, so the grow will look like it succeeded...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
