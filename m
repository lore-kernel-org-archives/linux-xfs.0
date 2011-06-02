Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p52EgnqL203753 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 09:42:49 -0500
Received: from mail-ww0-f51.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 190E51235F25
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 07:42:47 -0700 (PDT)
Received: from mail-ww0-f51.google.com (mail-ww0-f51.google.com
	[74.125.82.51]) by cuda.sgi.com with ESMTP id KLUJyOFvnw4DBXlG
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 07:42:47 -0700 (PDT)
Received: by wwf26 with SMTP id 26so752669wwf.32
	for <xfs@oss.sgi.com>; Thu, 02 Jun 2011 07:42:46 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 2 Jun 2011 10:42:46 -0400
Message-ID: <BANLkTim_BCiKeqi5gY_gXAcmg7JgrgJCxQ@mail.gmail.com>
Subject: I/O hang, possibly XFS, possibly general
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
To: xfs-oss <xfs@oss.sgi.com>

This morning, I had a symptom of a I/O throughput problem in which
dirty pages appeared to be taking a long time to write to disk.

The system is a large x64 192GiB dell 810 server running 2.6.38.5 from
kernel.org - the basic workload was data intensive - concurrent large
NFS (with high metadata/low filesize), rsync/lftp (with low
metadata/high file size) all working in a 200TiB XFS volume on a
software MD raid0 on top of 7 software MD raid6, each w/18 drives.  I
had mounted the filesystem with inode64,largeio,logbufs=8,noatime.

The specific symptom was that 'sync' hung, a dpkg command hung
(presumably trying to issue fsync), and experimenting with "killall
-STOP" or "kill -STOP" of the workload jobs didn't let the system
drain I/O enough to finish the sync.  I probably did not wait long
enough, however.

So here's what I did to diagnose: when all workloads were stopped,
there was still low rate I/O from kflush->md array jobs.  No CPU
starvation, but the I/O rate was low - 5-30MiB/second (the array can
readily do >1000MiB/second for big I/O).  Mind you, one "md5sum
--check" job was able to run at >200MiB/second without trouble - turn
it off or on and the aggregate I/O load shoots right up or down along
with it, so I'm fairly confident in the underlying physical arrays as
well as XFS large data I/O.

I did "echo 3 > /proc/sys/vm/drop_caches" repeatedly and noticed that
according to top, the total amount of cached data would drop down
rapidly (first time had the big drop), but still be stuck at around
8-10Gigabytes.  While continuing to do this, I noticed finally that
the cached data value was in fact dropping slowly (at the rate of
5-30MiB/second), and in fact finally dropped down to approximately
60Megabytes at which point the stuck dpkg command finished, and I was
again able to issue sync commands that finished instantly.

My guess is that I've done something to fill the buffer pool with slow
to flush metadata - and prior to rebooting the machine a few minutes
ago, I removed the largeio option in /etc/fstab.

I can't say this is an XFS bug specifically, but more likely how I am
using it - are there other tools I can use to better diagnose what is
going on?  I do know it will happen again, since we will have 5 of
these machines running at very high rates soon.  Also, any suggestions
for better metadata or log management are very welcome.

This particular machine is probably our worst, since it has the widest
variation in offered file I/O load (tens of millions of small files,
thousands of >1GB  files).  If this workload is pushing XFS too hard,
I can deploy new hardware to split the workload across different
filesystems.

Thanks very much for any thoughts or suggestions,

Paul Anderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
