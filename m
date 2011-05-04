Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4416jWq048192 for <xfs@oss.sgi.com>; Tue, 3 May 2011 20:06:45 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7592A42AC45
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 18:10:21 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id eSdfqB3hwr5pVOIl
	for <xfs@oss.sgi.com>; Tue, 03 May 2011 18:10:21 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id AD9ED6C073
	for <xfs@oss.sgi.com>; Tue,  3 May 2011 20:10:20 -0500 (CDT)
Message-ID: <4DC0A779.9030509@hardwarefreak.com>
Date: Tue, 03 May 2011 20:10:17 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS/Linux Sanity check
References: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
In-Reply-To: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 5/2/2011 10:47 AM, Paul Anderson wrote:

Hi Paul,

> md apparently does not support barriers, so we are badly exposed in
> that manner, I know.  As a test, I disabled write cache on all drives,
> performance dropped by 30% or so, but since md is apparently the
> problem, barriers still didn't work.

...

> Ideally, I'd firstly be able to find informed opinions about how I can
> improve this arrangement - we are mildly flexible on RAID controllers,

I'm not familiar enough with the md driver to address the barrier issue. 
  Try the mdadm mailing list.  However...

You should be able to solve the barrier issue, and get additional 
advantages, by simply swapping out the LSI 9200-8E's with the 9285-8E 
w/cache battery.  The 9285 has a dual core 800MHz PowerPC (vs single 
core 533MHz on the 9280) and 1GB of cache.  Configure 3x15 drive 
hardware RAID6 arrays per controller, then stitch the resulting 9 arrays 
together with mdraid or LVM striping or concatenation.  I'd test both 
under your normal multistreaming workload to see which works best.

A multilevel stripe will show better performance with an artificial 
single stream test such as dd, but under your operational multiple 
stream workload, concatenation may have similar performance, while at 
the same time giving you additional capability, especially if done with 
LVM instead of mdraid --linear.  Using LVM concatenation enables 
snapshots and the ability to grow and shrink the volume, neither of 
which you can do with striping (RAID 0).

The 9285-8E will be pricier than the 9280-8E but it's well worth the 
extra dollars, given the low overall cost percentage of the HBAs vs 
total system cost.  You'll get better performance and the data safety 
you're looking for.  Just make sure that in addition to BBWC on the HBAs 
you have good UPS units backing the servers and SC847 chassis.

> very flexible on versions of Linux, etc, and can try other OS's as a
> last resort (but the leading contender here would be "something"
> running ZFS, and though I love ZFS, it really didn't seem to work well
> for our needs).

Supermicro product is usually pretty decent.  However, "DIY" arrays 
comprised of an inexpensive teir 2/3 vendor drive box/backplane/expander 
and off the shelf drives, whose firmware may not all match, can often be 
a recipe for problems that are difficult to troubleshoot.  Your problems 
may not be caused by a kernel issue at all.  The kernel may simply be 
showing the symptoms but not the cause.

You've ordered, if my math is correct, 675 'enterprise class' 2TB SATA 
drives, 45 per chassis, 135 per system, 5 systems.  Did you 
specify/verify with the vendor that all drives must be of the same 
manufacturing lot and have matching firmware?  When building huge 
storage subsystems it is critical that all drives behave the same, which 
usually means identical firmware.

> Secondly, I welcome suggestions about which version of the linux
> kernel you'd prefer to hear bug reports about, as well as what kinds
> of output is most useful (we're getting all chassis set up with serial
> console so we can do kgdb and also full kernel panic output results).

Others are better qualified to answer this.  I'm just the lowly hardware 
guy on the list. ;)

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
