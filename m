Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p42FiDHx238313 for <xfs@oss.sgi.com>; Mon, 2 May 2011 10:44:13 -0500
Received: from mail-qy0-f174.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BCE3156AD48
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 08:47:49 -0700 (PDT)
Received: from mail-qy0-f174.google.com (mail-qy0-f174.google.com
	[209.85.216.174]) by cuda.sgi.com with ESMTP id
	rk58sMYznYFRtGUQ for <xfs@oss.sgi.com>;
	Mon, 02 May 2011 08:47:49 -0700 (PDT)
Received: by qyk7 with SMTP id 7so1548318qyk.5
	for <xfs@oss.sgi.com>; Mon, 02 May 2011 08:47:48 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 2 May 2011 11:47:48 -0400
Message-ID: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
Subject: XFS/Linux Sanity check
From: Paul Anderson <pha@umich.edu>
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

Our genetic sequencing research group is growing our file storage from
1PB to 2PB.

Our workload looks very much like large video processing might look -
relatively low metadata, very, very high sequential I/O.  The servers
will either be doing very high I/O with local I/O bound jobs, or
serving data via NFSv4 (or possibly custom data distribution means) to
our compute grid for compute bound jobs.  Our first PB of data is
largely on Promise RAID arrays, all of which are set up with XFS.
Generally, we're big fans of XFS for stability, high performance, and
robustness in the face of crashes.  We tried ZFS, ran into I/O
throttling issues that at the time seem intractable (write picketing -
essentially half the maximum write rate of hardware).

We are deploying five Dell 810s, 192GiB RAM, 12 core, each with three
LSI 9200-8E SAS controllers, and three SuperMicro 847 45 drive bay
cabinets with enterprise grade 2TB drives.

We're running Ubuntu 10.04 LTS, and have tried either the stock kernel
(2.6.32-30) or 2.6.35 from linux.org.  We organize the storage as one
software (MD) RAID 0 composed of 7 software RAID (MD) 6s, each with 18
drives, giving 204 TiB usable (9 drives of the 135 are unused).  XFS
is set up properly (as far as I know) with respect to stripe and chunk
sizes.  Allocation groups are 1TiB in size, which seems sane for the
size of files we expect to work with.

In isolated testing, I see around 5GiBytes/second raw (135 parallel dd
reads), and with a benchmark test of 10 simultaneous 64GiByte dd
commands, I can see just shy of 2 GiBytes/second reading, and around
1.4GiBytes/second writing through XFS.   The benchmark is crude, but
fairly representative of our expected use.

md apparently does not support barriers, so we are badly exposed in
that manner, I know.  As a test, I disabled write cache on all drives,
performance dropped by 30% or so, but since md is apparently the
problem, barriers still didn't work.

Nonetheless, what we need, but don't have, is stability.

With 2.6.32-30, we get reliable kernel panics after 2 days of
sustained rsync to the machine (around 150-250MiBytes/second for the
entire time - the source machines are slow), and with 2.6.35, we get a
bad resource contention problem fairly quickly - much less than 24
hours (in this instance, we start getting XFS kernel thread timeouts
similar to what I've seen posted here recently, but it isn't clear
whether it is only XFS or also ext3 boot drives that are starved for
I/O - suspending or killing all I/O load doesn't solve the problem -
only a reboot does).

Ideally, I'd firstly be able to find informed opinions about how I can
improve this arrangement - we are mildly flexible on RAID controllers,
very flexible on versions of Linux, etc, and can try other OS's as a
last resort (but the leading contender here would be "something"
running ZFS, and though I love ZFS, it really didn't seem to work well
for our needs).

Secondly, I welcome suggestions about which version of the linux
kernel you'd prefer to hear bug reports about, as well as what kinds
of output is most useful (we're getting all chassis set up with serial
console so we can do kgdb and also full kernel panic output results).

Thanks in advance,

Paul Anderson
Center for Statistical Genetics
University of Michigan
USA

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
