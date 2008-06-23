Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 23 Jun 2008 11:04:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5NI44XP013822
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 11:04:04 -0700
Received: from web34506.mail.mud.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B710626B686
	for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 11:05:03 -0700 (PDT)
Received: from web34506.mail.mud.yahoo.com (web34506.mail.mud.yahoo.com [66.163.178.172]) by cuda.sgi.com with SMTP id YqB5TFtYvkRM3YJ2 for <xfs@oss.sgi.com>; Mon, 23 Jun 2008 11:05:03 -0700 (PDT)
Date: Mon, 23 Jun 2008 11:05:02 -0700 (PDT)
From: Mark <musicman529@yahoo.com>
Reply-To: MusicMan529@yahoo.com
Subject: XFS mkfs/mount options (w/ better results this time)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <574409.56108.qm@web34506.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I have found that Dbench highlights the differences of various filesystems' throughput, and the results are surprising. (Summary: XFS is the clear winner, under pretty much all circumstances.)

The basic test:

# dbench -D /tester -t 60 {threads}

The primary variable is the filesystem (ext3, XFS, and JFS), with CPU speed and disk elevator being secondary variables. The journal partition is on the first SATA controller, and the main data partition is on the second SATA controller, to exploit SMP capabilities. I'm running on an AMD64-X2 2.5GHz with 2G RAM.

My kernel is custom-compiled for 1000Hz task scheduler and forced kernel preemption, including preempting the Big Kernel Lock. Per Martin Steigerwald's earlier advice, I also ran irqbalance (but more on this later). All tests were run in runlevel 1, which on Slackware means 6 VT's but no services (net, mouse, etc.).

Aside: 60 seconds may not be a long time to run a disk benchmark, but I found that after about 15 seconds, the disk throughput had leveled off dramatically on my system. In the context of the final numbers, the actual intra-test variation became insignificant. I have kept all test output for review.

I created and mounted filesystems with the following options:

ext3: no options to mke2fs, so sparse_super,filetype,resize_inode,dir_index,ext_attr were all enabled
mounted with "data=writeback" and noatime

JFS: mounted with "noatime"

XFS: mkfs.xfs -l size=64m,logdev=/dev/sda2,lazy-count=1 -d agcount=8 -f /dev/sdb5
mount -o noatime,logdev=/dev/sda2,logbufs=8

I ran a round of tests using 5 threads, to resemble 1 runnable and 1 waiting on each CPU, plus 1 more waiting. In other words, lightly overloaded. XFS was the clear winner, with 378 MB/sec using the "noop" scheduler. The "deadline" scheduler was a close second, with 371 MB/sec.

Here was the first twist: The completely fair queueing (CFQ) scheduler seriously impeded XFS performance, so badly that even "noop" out-performed it when the CPU was running at 40% clock.

After I un-mounted the XFS volume, I noticed I was not actually running irqbalance. Oops! It had been running under runlevel 4, but exited when I ran "telinit 1". The IRQs were left in the last "balanced" state, but there was no dynamic re-adjustment for the different conditions. If irqbalance could help the other two filesystems reach 378 MB/sec throughput, why not? So I launched it and continued.

Running the same test on JFS gave a comparatively poor result, with 147 MB/sec using the "deadline" scheduler. ext3 was somewhat better, with 279 MB/sec also with "deadline." They didn't get nearly enough help from irqbalance to make a difference in rank.

I re-ran all tests with 20 threads, to simulate severe process I/O overloading. Even on my 2-CPU system, XFS scaled somewhat, achieving 403 MB/sec with "deadline" and 401 MB/sec with "anticipatory." CFQ didn't hurt the throughput as much this time, but it still came in last (263 MB/sec).

JFS suffered horribly under 20 threads. All throughput fell between 41 and 46 MB/sec, no matter the elevator or the CPU speed.

ext3 fared somewhat better, with 256 MB/sec on the CFQ scheduler. Finally, a filesystem that CFQ can help. But it's still not as good as XFS on "deadline."

For a final twist, I re-ran the 5-thread tests, but adding "sync" to the mount options. I hand-tuned the elevator according to the best for each filesystem. I ran dbench once, to warm disk buffers, then re-ran and captured the results. Once more, XFS is the hands-down winner:

XFS+noop: 65 MB/sec
JFS+deadline: 40 MB/sec
ext3+CFQ: 37 MB/sec

I am very impressed.

If you want to see the test script and results for yourself, I can put a tarball on my website and send you the link. My testing may not be perfect, but I find these numbers very difficult to explain by test shortcomings.

-- 
Mark

"What better place to find oneself than
 on the streets of one's home village?"
      --Capt. Jean-Luc Picard, "Family"
