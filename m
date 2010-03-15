Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2F4SUJR011355 for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 23:28:31 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A83221428A88
	for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 21:30:03 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	DJEjSx0g01GslKn3 for <xfs@oss.sgi.com>;
	Sun, 14 Mar 2010 21:30:03 -0700 (PDT)
Received: from dastard (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	17021705-1927428
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 15:00:01 +1030 (CDT)
Received: from dave by dastard with local (Exim 4.71)
	(envelope-from <david@fromorbit.com>) id 1Nr1wG-0001Hz-3Y
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 15:30:00 +1100
Date: Mon, 15 Mar 2010 15:30:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC] Delayed logging
Message-ID: <20100315043000.GK4732@dastard>
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

Hi Folks,

You've all heard me talking about delayed logging, but there hasn't
been any code yet. Well, here's the first code drop - see the git
tree reference at the end of the email to get it.

If you want to know what delayed logging is and how it works, pull
the tree and read the documentation in:

	Documentation/filesystems/xfs-delayed-logging-design.txt

or navigate to it via gitweb from here:

	http://git.kernel.org/?p=linux/kernel/git/dgc/xfs.git

The delayed-logging branch that the code lives in may be rebased at
any time, hence I'm not going to point you at commits because they
won't be stable. It also means any time you want to update, you need
to need to pull into a clean new branch.

Overall, it's not a huge change:

 19 files changed, 2594 insertions(+), 580 deletions(-)

Especially when you take away the 819 lines of design documentation.
It's still a large change, though, when you consider how critical
this code is. :/

Now you know what it is, the code in the tree implements the
documented design. While the code passes XFSQA on my test systems,
there are still occassional failures that have not been resolved and
there has been almost no stress testing of the code been
done. Hence:

*** USE THIS CODE AT YOUR OWN RISK ***

At present, I have done no performance testing on production kernel
configurations - all my testing has been done with CONFIG_XFS_DEBUG
enabled along with various other kernel debugging features as well.
Hence I've really only been looking at significant deviations in
performance (up or down) to determine whether the code is meeting
design goals or not.

The following results are from a synthetic test designed to show
just the impact of delayed logging on the amount of metadata
written to the log.

load:	Sequential create 100k zero-length files in a directory per
	thread, no fsync between create and unlink.
	(./fs_mark -S0 -n 100000 -s 0 -d ....)

measurement: via PCP. XFS specific metrics:

	xfs.log.blocks
	xfs.log.writes
	xfs.log.noiclogs
	xfs.log.force
	xfs.transactions.*
	xfs.dir_ops.create
	xfs.dir_ops.remove


machine:

2GHz Dual core opteron, 3GB RAM
single 36GB 15krpm scsi drive w/ CTQ depth=32
mkfs.xfs -f -l size=128m /dev/sdb2

Current code:

mount -o "logbsize=262144" /dev/sdb2 /mnt/scratch

threads:	 fs_mark	CPU	create log	unlink log
		throughput		bandwidth	bandwidth
1		  2900/s         75%       34MB/s	 34MB/s
2		  2850/s	 75%	   33MB/s	 33MB/s
4		  2800/s	 80%	   30MB/s        30MB/s

Delayed logging:

mount -o "delaylog,logbsize=262144" /dev/sdb2 /mnt/scratch

threads:	 fs_mark	CPU	create log	unlink log
		throughput		bandwidth	bandwidth
1		  4300/s        110%       1.5MB/s	 <1MB/s
2		  7900/s	195%	   <4MB/s	 <1MB/s
4		  7500/s	200%	   <5MB/s        <1.5MB/s

I think it pretty clear that the design goal of "an order of
magnitude less log IO bandwidth" is being met here. Scalability is
looking promising, but a 2p machine is not large enough to make any
definitive statements about that. Hence from these results the
implementation is at or exceeding design levels.

Known issues that need to be resolved:

	- xfslogd can effectively lock up spinning for 10s of
	  seconds at a time under heavy load. Cause unknown,
	  needs analysis and fixing.
	- leaks memory in some error paths.
	- occasional recovery failure with recovery reading an inode
	  buffer that does not contain inodes. Cause unknown, tends
	  to be reproduced by xfsqa test 121 semi-reliably. Needs
	  further analysis and fixing. May already be fixed with a
	  recent fix to commit record synchronisation.
	- Checkpoint log ticket allocation is less than ideal - can
	  also trigger lockdep warnings if we re-enter the FS. =>
	  needs KM_NOFS and a cleanup.
	- stress will probably break it. Need to run a variety of
	  workloads/benchmarks and sort out issues that are
	  uncovered.
	- scalability, while improved, is still largely an unknown.
	  Will need to run tests on big machines to find where new
	  contention points have been introduced.
	- impact on sync/fsync heavy workloads largely unknown. It
	  should not be significant, but needs testing and analysis.
	- determine if the current checkpoint sizing is appropriate,
	  or whether further dynamic sizing (e.g. based on log size)
	  needs investigation.

Further algorithmic optimisations:

	- busy extent tracking is still not ideal - we can get lots
	  (thousands) of adjacent single extents in the same
	  transaction so combining them at transaction commit would
	  be advantageous.
	- Don't need barriers on every single log IO. Indeed,
	  funnelling 8MB of IO through 8x256k buffers is not really
	  ideal. Only really need barrier on first IO of checkpoint
	  (to ensure all the changes we are about to overwrite are on
	  disk already) and last IO (to ensure commit record hits
	  the disk).
	- commit record synchronisation is simplistic and can cause
	  too many wakeups. needs to be smarter about finding
	  previous sequences to wait on.
	- AIL pushing can trigger far too many log forces in a short
	  period of time.
	- start looking at areas where CPU usage is excessive and
	  try to trim it.

There's still a lot of work to do before this is production ready,
but I think it's stable enough now that the code is not going to
change significantly as a result of trying to fix bugs that are
lurking.  Currently I'm aiming for experimental inclusion into
mainline for 2.6.35, with the aim for it to be production ready by
2.6.37 and the default for 2.6.39.

Anyway, here's the details of the tree. Note that this branch
includes a merge of the trans-cleanup branch as it is dependent on
those changes.

The following changes since commit 5077f72749e6a78eb57211caf337cda8297bf882:
  Dave Chinner (1):
        xfs: don't warn about page discards on shutdown

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git delayed-logging

Dave Chinner (19):
      xfs: introduce new internal log vector structure
      xfs: factor xlog_write and make use of new log vector structure
      xfs: Delayed logging design documentation
      xfs: introduce delayed logging mount option
      xfs: extend the log item to support delayed logging
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
      XFS: replace fixed size busy extent array with an rbtree
      XFS: Don't use log forces when busy extents are allocated
      XFS: Simplify transaction busy extent tracking
      xfs: cluster fsync transaction

 .../filesystems/xfs-delayed-logging-design.txt     |  819 ++++++++++++++++++++
 fs/xfs/Makefile                                    |    1 +
 fs/xfs/linux-2.6/xfs_buf.c                         |    9 +
 fs/xfs/linux-2.6/xfs_file.c                        |   65 ++-
 fs/xfs/linux-2.6/xfs_super.c                       |    9 +
 fs/xfs/linux-2.6/xfs_trace.h                       |   80 ++-
 fs/xfs/xfs_ag.h                                    |   21 +-
 fs/xfs/xfs_alloc.c                                 |  257 ++++---
 fs/xfs/xfs_alloc.h                                 |    5 +-
 fs/xfs/xfs_buf_item.c                              |   33 +-
 fs/xfs/xfs_log.c                                   |  679 +++++++++++------
 fs/xfs/xfs_log.h                                   |   15 +-
 fs/xfs/xfs_log_cil.c                               |  698 +++++++++++++++++
 fs/xfs/xfs_log_priv.h                              |  117 +++-
 fs/xfs/xfs_mount.h                                 |    1 +
 fs/xfs/xfs_trans.c                                 |  193 ++++-
 fs/xfs/xfs_trans.h                                 |   53 +-
 fs/xfs/xfs_trans_item.c                            |  109 ---
 fs/xfs/xfs_trans_priv.h                            |   10 +-
 19 files changed, 2594 insertions(+), 580 deletions(-)
 create mode 100644 Documentation/filesystems/xfs-delayed-logging-design.txt
 create mode 100644 fs/xfs/xfs_log_cil.c

Anyway that's it for now - comments, thoughts, bug fixes, etc are
welcome. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
