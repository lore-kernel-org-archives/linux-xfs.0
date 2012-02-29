Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1T48OYZ243841 for <xfs@oss.sgi.com>; Tue, 28 Feb 2012 22:08:24 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	fzcW8CtKCowt4BCY for <xfs@oss.sgi.com>;
	Tue, 28 Feb 2012 20:08:22 -0800 (PST)
Date: Wed, 29 Feb 2012 15:08:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Poor performance using discard
Message-ID: <20120229040819.GZ3592@dastard>
References: <1330469778.9688.7.camel@core24> <20120229012259.GW3592@dastard>
	<1330480826.9688.23.camel@core24>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1330480826.9688.23.camel@core24>
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
To: Thomas Lynema <lyz27@yahoo.com>
Cc: xfs@oss.sgi.com

On Tue, Feb 28, 2012 at 09:00:26PM -0500, Thomas Lynema wrote:
> 
> On Wed, 2012-02-29 at 12:22 +1100, Dave Chinner wrote:
> > On Tue, Feb 28, 2012 at 05:56:18PM -0500, Thomas Lynema wrote:
> > > /dev/mapper/ssdvg0-testLV on /media/temp type ext4
> > > (rw,noatime,nodiratime,discard)
> > > 
> > > time rm -rf linux-3.2.6-gentoo/
> > > 
> > > real   0m0.943s
> > > user   0m0.050s
> > > sys   0m0.830s 
> > 
> > I very much doubt that a single discard IO was issued during that
> > workload - ext4 uses the same fine-grained discard method XFS does,
> > and it does it at journal checkpoint completion just like XFS. So
> > I'd say that ext4 didn't commit the journal during this workload,
> > and no discards were issued, unlike XFS.
> > 
> > So, now time how long it takes to run sync to get the discards
> > issued and completed on ext4. Do the same with XFS and see what
> > happens. i.e.:
> > 
> > $ time (rm -rf linux-3.2.6-gentoo/ ; sync)
> > 
> > is the only real way to compare performance....
> > 
> > > xfs mounted without discard seems to handle this fine:
> > > 
> > > /dev/mapper/ssdvg0-testLV on /media/temp type xfs
> > > (rw,noatime,nodiratime)
> > > 
> > > time rm -rf linux-3.2.6-gentoo/
> > > real	0m1.634s
> > > user	0m0.040s
> > > sys	0m1.420s
> > 
> > Right, that's how long XFS takes with normal journal checkpoint
> > IO latency. Add to that the time it takes for all the discards to be
> > run, and you've got the above number.
> > 
> > Cheers,
> > 
> > Dave.
> 
> 
> Dave and Peter,
> 
> Thank you both for the replies.  Dave, it is actually your article on
> lwn and presentation that you did recently that lead me to use xfs on my
> home computer.
> 
> Let's try this with the sync as Dave suggested and the command that
> Peter used:
> 
> mount /dev/ssdvg0/testLV -t xfs -o
> noatime,nodiratime,discard /media/temp/
> 
> time sh -c 'sysctl vm/drop_caches=3; rm -r linux-3.2.6-gentoo; sync'
> vm.drop_caches = 3
> 
> real	6m35.768s
> user	0m0.110s
> sys	0m2.090s
> 
> vmstat samples.  Not putting 6 minutes worth in the email unless it is
> necessary.
> 
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  0  1   3552 6604412      0 151108    0    0  6675  5982 3109 3477  3 24 55 18
>  0  1   3552 6594756      0 161032    0    0  9948     0 1655 2006  1  1 74 24
>  0  1   3552 6587068      0 168672    0    0  7572     8 2799 3130  1  1  74 24
>  1  0   3552 6580744      0 174852    0    0  6288     0 2880 3215  6  2  74 19
> ----i/o wait here----
>  1  0   3552 6580496      0 174972    0    0     0     0  782 1110 22  4 74  0
>  1  0   3552 6580744      0 174972    0    0     0     0  830 1194 22  4 74  0
>  1  0   3552 6580744      0 174972    0    0     0     0  771 1117 23  3 74  0
>  1  0   3552 6580744      0 174972    0    0     0     4 1538 2637 30  5 66  0
>  1  0   3552 6580744      0 174972    0    0     0     0 1168 1946 26  3 72  0
>  1  0   3552 6580744      0 174976    0    0     0     0  762 1169 23  4 73  0

There's no IO wait time here - it's apparently burning a CPU in userspace and
doing no IO at all. running discards all happens in kernel threads,
so there should be no user time at all if it was stuck doing
discards. What is consuming that CPU time?

....
> EXT4 sample
> 
> mkfs.ext4 /dev/ssdvg0/testLV
> mount /dev/ssdvg0/testLV -t ext4 -o
> discard,noatime,nodiratime /media/temp/
> 
> 
> time sh -c 'sysctl vm/drop_caches=3; rm -r linux-3.2.6-gentoo; sync'
> vm.drop_caches = 3
> 
> real	0m2.711s
> user	0m0.030s
> sys	0m1.330s
> 
> #because I didn't believe it, I ran the command a second time.
> 
> time sync
> 
> real	0m0.157s
> user	0m0.000s
> sys	0m0.000s
> 0m1.420s
> 
> vmstat 1
> 
> procs -----------memory---------- ---swap-- -----io---- -system--
> ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  1  0   3548 5474268  19736 1191868    0    0     0     0 1274 2097 25 3 72  0
>  1  0   3548 5474268  19736 1191872    0    0     0     0 1027 1614 26 3 71  0
>  2  1   3548 6649292   4688 154264    0    0  9512     8 2256 3267 11 18 58 12
>  2  2   3548 6633188  15920 161592    0    0 18788  7732 5137 6274  5 17 49 29
>  0  1   3548 6623044  19624 167936    0    0  9948 10081 3233 4810  4  7 54 35
>  0  1   3548 6621556  19624 170068    0    0  2112  2642 1294 2135  4  1 72 23
>  0  2   3548 6611140  19624 179420    0    0 10260    50 1677 2930  7  2 64 27
>  0  1   3548 6606660  19624 183828    0    0  4181    32 2192 2707  6  2 67 26
>  1  0   3548 6604700  19624 185864    0    0  2080     0  961 1451  7  2 74 17
>  1  0   3548 6604700  19624 185864    0    0     0     0  966 1715 24  3 73  0
>  2  0   3548 6604700  19624 185864    0    0     8   196 1025 1582 24  4 72  0
>  1  0   3548 6604700  19624 185864    0    0     0     0 1133 1901 24  3 73  0

Same again - aparently when you system goes idle, it burns a CPU in
user time, but stops doing that when IO is in progress.

> This time, I ran a sync.  That should mean all of the discard operations
> were completed...right?

Well, it certainly is the case for XFS. I'm not sure what is
happening with ext4 though.

> If it makes a difference, when I get the i/o hang during the xfs
> deletes, my entire system seems to hang.  It doesn't just hang that
> particular mounted volumes' i/o.

Any errors in dmesg?

Also, I think you need to provide a block trace (output of
blktrace/blkparse for the rm -rf workloads) for both the XFS and
ext4 cases so we can see what discards are actually being issued and
how long they take to complete....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
