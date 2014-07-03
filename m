Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E17C97F54
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 04:43:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 538DAAC001
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 02:43:53 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	LQw54rvo1duQrdlC for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 02:43:50 -0700 (PDT)
Date: Thu, 3 Jul 2014 19:43:47 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Got "Internal error XFS_WANT_CORRUPTED_GOTO". Filesystem needs
	reformatting to correct issue.
Message-ID: <20140703094347.GU4453@dastard>
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>
	<20140702120441.GA51757@bfoster.bfoster>
	<alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1407030057310.9881@Telcontar.valinor>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Carlos E. R." <carlos.e.r@opensuse.org>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Thu, Jul 03, 2014 at 05:00:47AM +0200, Carlos E. R. wrote:
> On Wednesday, 2014-07-02 at 08:04 -0400, Brian Foster wrote:
> >On Wed, Jul 02, 2014 at 11:57:25AM +0200, Carlos E. R. wrote:
> 
> ...
> 
> >This is the background eofblocks scanner attempting to free preallocated
> >space on a file. The scanner looks for files that have been recently
> >grown and since been flushed to disk (i.e., no longer concurrently being
> >written to) and trims the post-eof preallocation that comes along with
> >growing files.
> >
> >The corruption errors at xfs_alloc.c:1602,1629 on v3.11 fire if the
> >extent we are attempting to free is already accounted for in the
> >by-block allocation btree. IOW, this is attempting to free an extent
> >that the allocation metadata thinks is already free.
> >
> >>
> >>Brief description:
> >>
> >>
> >> * It happens only on restore from hibernation.
> >
> >Interesting, could you elaborate a bit more on the behavior this system
> >is typically subjected to? i.e., is this a server that sees a constant
> >workload that is also frequently hibernated/awakened?

....

> The machine may be used anywhere from 4 to 16 hours a day, and
> hibernated at least once a day, perhaps three times if I have to go
> out several times. It makes no sense to me to leave the machine
> powered doing nothing, if hibernating is so easy and reliable - till
> now. If I have to leave for more than a week, I tend to do a full
> "halt".

Hibernation has always been suspect w.r.t. flushing filesystem
metadata. It does not guarantee that the filesystem is quiesced
and idle, it just does a sync() and hopes that is sufficient to get
the filesystem into a consistent state. The mess that this leaves is
then left to filesystem developers to play whack-a-mole with when
users have problems.

> But soon after, it oopses:

Point of note: there is no oops or crash occurring. XFS dumps the
stack when a corruption occurs to tell use where it was detected
and then shuts down the filesystem. Your system is still just fine
apart from not being able to access that filesystem until you
unmount it, rpeair it and mount it again.

> 3 PID: 57 Comm: kworker/3:1 Tainted: P           O 3.11.10-7-desktop

What's tainting your kernel? If you remove that taint, does the
problem still occur?

....
> <0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.819191] Enabling non-boot CPUs ...
> <0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.819191] smpboot: Booting Node 0 Processor 1 APIC 0x1
> <0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.832336] CPU1 is up
> <0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.832467] smpboot: Booting Node 0 Processor 2 APIC 0x2
> <0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.845865] CPU2 is up
> <0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.846034] smpboot: Booting Node 0 Processor 3 APIC 0x3
> <0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280266.859609] CPU3 is up
....
> <0.6> 2014-04-17 22:47:08 Telcontar kernel - - - [280269.796130] PM: restore of devices complete after 2736.343 msecs
> <0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.081655] Restarting kernel threads ... done.
> <0.4> 2014-04-17 22:47:08 Telcontar kernel - - - [280270.086714] Restarting tasks ... done.
.....
> <0.1> 2014-04-17 22:47:08 Telcontar kernel - - - [280271.851374] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c54fe9

So the corruption occurred within 2s of the kernel restarting tasks
after a hibernation. It's really looking like a hibernation issue.

> <3.4> 2014-06-29 04:51:50 Telcontar pm-utils - - -  Hibernating (95)...
.....
> <0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212887.640186] Enabling non-boot CPUs ...
.....
> <0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.615073] PM: restore of devices complete after 2735.034 msecs
> <0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.626346] XFS: Internal error XFS_WANT_CORRUPTED_GOTO at line 1602 of file /home/abuild/rpmbuild/BUILD/kernel-desktop-3.11.10/linux-3.11/fs/xfs/xfs_alloc.c.  Caller 0xffffffffa0c39fe9
.....
> <0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.706440] XFS (sde5): Corruption of in-memory data detected.  Shutting down filesystem
> <0.1> 2014-06-29 12:32:18 Telcontar kernel - - - [212890.706440] XFS (sde5): Please umount the filesystem and rectify the problem(s)
> <0.6> 2014-06-29 12:32:18 Telcontar kernel - - - [212891.026207] usb 1-6: USB disconnect, device number 4
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212891.025944] Restarting kernel threads ... done.
> <0.4> 2014-06-29 12:32:18 Telcontar kernel - - - [212891.026371] Restarting tasks ... done.

Well, there's the smoking gun. The XFS kworker is running and
reporting errors before the thawing process has restarted
the frozen workqueues:

void thaw_kernel_threads(void)
{
        struct task_struct *g, *p;

        pm_nosig_freezing = false;
        printk("Restarting kernel threads ... ");

        thaw_workqueues();
....

Which points to the fact that we probably need WQ_FREEZABLE on some
of our workqueues. Brian, do you want to have a look at this?

> Question.
> 
> As this always happens on recovery from hibernation, and seeing the message
> "Corruption of in-memory data detected", could it be that thawing does a bad
> memory recovery from the swap?  I thought that the procedure includes some
> checksum, but I don't know for sure.

It's the fact that the filesystem si still running and modifying
state when the snapshot is being taken that results in the snapshot
image containing an inconsistent snapshot. That then gets loaded
on thaw and it goes boom.

> To me, there are two problems:
> 
>  1) The corruption itself.
>  2) That xfs_repair fails to repair the filesystem. In fact, I believe
>     it does not detect it!

That's because the filesystem is likely to be consistent on disk.
The issue is in-memory corruption, not on-disk corruption, like
the messages are telling us:

XFS (sde5): Corruption of in-memory data detected.

Basically, XFS is catching a bad state in memory and preventing it
from being propagated to disk. if it gets to disk, then you are
likely to lose data. IOWs, XFS is behaving as designed and is
actually preventing data loss in this situation.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
