Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3S8ZY2Z217529 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 03:35:34 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD78F1C81A11
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 01:37:37 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	pot02h0buyZpkCKV for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 01:37:37 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	22132590-1927428
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 18:07:35 +0930 (CST)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1O72lg-0005mj-Nc
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 18:37:16 +1000
Date: Wed, 28 Apr 2010 18:37:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [GIT, RFC] Delayed logging V2
Message-ID: <20100428083716.GG9783@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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

Hi flks,

This is version 2 of the delayed logging series.

I won't repeat everything about what it is, just point you
here:

http://marc.info/?l=linux-xfs&m=126862777118946&w=2

for the description, and here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git delayed-logging

for the current code.

To address the known issues from the first posting:

	1. xfslogd spining for long periods - unable to reproduce
	2. memory leaks - some fixed, could be others.
	3. recovery failure in 121 - NOT FIXED, in progress
	4. Checkpoitn log ticket allocation - fixed
	5. stress testing - I can't break it anymore with fs_mark,
	   postmark, dbench, bonnie++ or xfsqa, so is much better
	   than the previous posting.
	6. Scalabilty - good enough for now - see results below.
	7. checkpoint sizing - good enough for now.

There are no new known issues with this release.

To address the algorithmic optimisations:

	1. busy extent tracking - separated and posted for review.
	2. log IO barriers -> later
	3. commit record synchronisation -> later
	4. AIL pushing causing log forces -> later
	5. CPU usage optimisations -> later

The change has reduced in size now that much of the preliminary log
and transaction changes are in the main tree. These numbers still
both include the busy extent tracking work:

Version 1: 19 files changed, 2594 insertions(+), 580 deletions(-)
Version 2: 22 files changed, 2188 insertions(+), 377 deletions(-)

Anyway, at this point I'd like to have this considered for inclusion
in the dev tree as an experimental feature to get it out to a wider
testing audience. I'm working on the recovery issue, but I don't
want that to hold up the review process. The full pull request is
below.

Scalability:

These tests were run on a VM with 8p and 4GB RAM, with a 10GB
filesystem that can do about 5kiop/s and 530MB/s.

$ sudo mkfs.xfs -f -l size=128m /dev/vdb
meta-data=/dev/vdb               isize=256    agcount=4, agsize=655360 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=2621440, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
$ sudo mount -o logbsize=262144,nobarrier /dev/vdb /mnt/scratch

For delayed logging, the mount options were teh only difference. The
test creates a directory per thread, and creates 100,000 zero length
files in each directory, then removes them.  The work per thread is
the same, there is no contention between them until the log it
reached, so the number of files/s should increase in proportion with
the number of threads active or the log subsystem becomes the
bottleneck. The command line for each test looks like:

$ fs_mark -S0 -s 0 -n 100000 -d /mnt/scratch/0 -d ...

Results:
		    files/s		log IOPS/MB/s
Threads		vanilla	  delaylog	vanilla   delaylog
   1		 6190	   6790		 300/70	    20/5
   2		11700	  12400		 600/140   50/15
   4		20790	  23292		1000/250  120/30
   8		19760	  21960		1400/350  140/35
  16		12210	  15723		 650/150  120/30


Running the same test on the same VM, but with a block device that
can do 100MB/s and maybe 500 iops/s, we see:

		    files/s		log IOPS/MB/s
Threads		vanilla	  delaylog	vanilla   delaylog
   1		 6430	   6650		 300/70	    20/5
   2		 7870	  12150		 400/100  50/15
   4		 8830	  22130		 500/120  120/30
   8		 8010	  21000		 400/100  140/35
  16		 5560	  14560		 250/70   120/30

These results tell me that without any special analysis or tuning,
delayed logging is showing equivalent performance and scalability on
high end storage, and significantly better scalability on low-end
storage.

The drop-off at higher thread counts is not a transaction/log
subsystem limitation - it's caused by the fact that the creation of
800k files takes long enough for background writeback to kick in, so
new creates compete with inode cluster writeback and other metadata
for IO. Further, at 16 threads, the 1.6M inodes did not all fit in
the cache, so about 25% of them ended up getting re-read from disk
during the unlink phase, slowing that down further.

However, the results are good enough for me at this point.

-----

The following changes since commit 29db3370a1369541d58d692fbfb168b8a0bd7f41:
  Alex Elder (1):
        xfs: kill off l_sectbb_mask

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git delayed-logging

Dave Chinner (14):
      xfs: Improve scalability of busy extent tracking
      xfs: allow log ticket allocation to take allocation flags
      xfs: Delayed logging design documentation
      xfs: introduce delayed logging mount option
      xfs: Introduce the Committed Item List
      xfs: Add delayed logging checkpoint context infrastructure
      xfs: introduce new chained log vector transaction formatting code
      xfs: format and insert log vectors into the CIL
      xfs: attach transactions to the checkpoint context
      xfs: checkpoint transaction infrastructure
      xfs: Allow multiple in-flight checkpoints
      xfs: forced unmounts need to push the CIL
      xfs: enable background pushing of the CIL
      xfs: modify buffer item reference counting for delayed logging

 .../filesystems/xfs-delayed-logging-design.txt     |  819 ++++++++++++++++++++
 fs/xfs/Makefile                                    |    1 +
 fs/xfs/linux-2.6/xfs_buf.c                         |    9 +
 fs/xfs/linux-2.6/xfs_quotaops.c                    |    1 +
 fs/xfs/linux-2.6/xfs_super.c                       |    9 +
 fs/xfs/linux-2.6/xfs_trace.h                       |   80 ++-
 fs/xfs/support/debug.c                             |    1 +
 fs/xfs/xfs_ag.h                                    |   21 +-
 fs/xfs/xfs_alloc.c                                 |  272 ++++---
 fs/xfs/xfs_alloc.h                                 |    5 +-
 fs/xfs/xfs_buf_item.c                              |   33 +-
 fs/xfs/xfs_filestream.c                            |    1 +
 fs/xfs/xfs_log.c                                   |  113 ++-
 fs/xfs/xfs_log.h                                   |   11 +-
 fs/xfs/xfs_log_cil.c                               |  685 ++++++++++++++++
 fs/xfs/xfs_log_priv.h                              |  118 +++-
 fs/xfs/xfs_mount.h                                 |    1 +
 fs/xfs/xfs_trans.c                                 |  207 ++++-
 fs/xfs/xfs_trans.h                                 |   44 +-
 fs/xfs/xfs_trans_extfree.c                         |    1 +
 fs/xfs/xfs_trans_item.c                            |  114 +---
 fs/xfs/xfs_trans_priv.h                            |   19 +-
 22 files changed, 2188 insertions(+), 377 deletions(-)
 create mode 100644 Documentation/filesystems/xfs-delayed-logging-design.txt
 create mode 100644 fs/xfs/xfs_log_cil.c

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
