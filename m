Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9PDfLfW234663 for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 08:41:21 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2FAE8121F2A
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 06:42:37 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id T0sKBt6C5RDiL2LB
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 06:42:37 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 596CA6C124
	for <xfs@oss.sgi.com>; Mon, 25 Oct 2010 08:42:37 -0500 (CDT)
Message-ID: <4CC5894D.6090409@hardwarefreak.com>
Date: Mon, 25 Oct 2010 08:42:37 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS Test Results Interpretation
References: <3C5E029826A0704DB5998577FCFF46F0095A278CEB@dagobah>
In-Reply-To: <3C5E029826A0704DB5998577FCFF46F0095A278CEB@dagobah>
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
To: xfs@oss.sgi.com

Andrew Debenham put forth on 10/25/2010 6:17 AM:
> Stan -
> 
> Thank you for your response and I apologize if my initial explanation wasn't clear.  The applications will be running on identical hardware (see specs. below) but each application will be running on a dedicated system.  My original spreadsheet had this information but it obviously didn't come through correctly.  I would like to tune the XFS file systems to accommodate the two different applications.  As I mentioned before, I experimented with various parameters (e.g. sunit, swidth, log size, etc.) and different mounting options (e.g. logbufs, logbsize, etc.), but it sounds like I may have been wasting my time attempting to benchmark the file systems.  Any information or recommendations you can provide would be greatly appreciated.  Also, can you recommend a tool that would be good for benchmarking an XFS file system (if one exists)?  Thanks again!

No apology necessary.  Regarding benchmarking...

1.  Good for apples to apples comparisons between
  a.  Two or more different storage subsystems
  b.  Two or more different kernel versions
  c.  Two or more different RAID controllers
  d.  Two or more different elevators
  e.  Two or more different mkfs/mount options
2.  _Not_ good for determining specific application performance

You could tweak and test every mkfs and mount option until you squeezed
maximum throughput and IOPs from your array, and then see abysmal
performance from your apps, if their access patterns are sufficiently
different than the synthetic tests.

You need to use the applications themselves as the benchmark.  Create
multiple XFS filesystems with different mkfs parms and mount options and
see which combination performs best with your application.  If your
applications lack sufficient performance measuring instrumentation, now
might be a good time to add some, assuming these are home grown apps.
But, before doing this, read my comments below regarding the age of your
OS and utils.  When you do this in depth app testing, do it on your much
newer OS platform.

> System Specs
> -----------------
> Motherboard:  Supermicro X8DTU

Good choice.  I've been a SuperMicro fan for over 10 years--built many a
system using their boards.

> Chipset:  Intel 5520 (Tylersburg)
> Processors:  Dual Intel Xeon E5540 @2.53GHz
> RAM:  32GB PC3-8500 1066MHz
> OS:  CentOS 5.3
> Kernel:  2.6.18-128.el5

You need a much newer kernel.  2.6.18 is _ancient_ released in 2006,
though CentOS have patched the bejesus out of it--128 times.

> RAID Controller:  3ware 9650SE-12M
> Disk Type:  SATA
> Disk Size:  1.82 TB
> RAID Level:  6
> # of disks:  11
> Stripe Size:  256 KB
> File System Size:  16.37 TB
> XFS Info:  kmod-xfs-0.4-2, xfsprogs-2.9.4-1.el5.centos

You also need a much newer xfsprogs.  2.9.4 is ancient.  Your XFS kernel
module is 2 years old.  Not quite ancient yet, but getting there.

You'd be doing yourself a huge favor by moving to something like Fedora
13 or OpenSuSE 11.3, which have much newer code in all these areas, and
more.  If you're not wed to RedHat and the RPM package standard, Ubuntu
10.4 LTS would be a good option as well.  Or, maybe you can get all
these things as binary RPMs from a 3rd party?  I'm not at all familiar
with the CentOS ecosystem.  I've been a Debian user for almost a decade.

There are some XFS specific problems you might run into with that old of
a kernel, module, and xfsprogs.  Dave Chinner and other devs can provide
the details.  I can't recall the specific issues, though one or two of
them were discussed here not long ago due to OPs with problems.  IIRC
one of them having problems was running CentOS 5.4, slightly newer than
yours.

Hopes this helps, and I hope I'm not sounding preachy.  Just giving
direct answers.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
