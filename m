Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB8837F67
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 15:43:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2768CAC003
	for <xfs@oss.sgi.com>; Sun,  1 Feb 2015 13:43:21 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	0uz0BRvGvaJyJ8Mh for <xfs@oss.sgi.com>;
	Sun, 01 Feb 2015 13:43:19 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1YI2IW-0003p8-2d
	for xfs@oss.sgi.com; Mon, 02 Feb 2015 08:43:16 +1100
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1YI2IW-0007wy-1Q
	for xfs@oss.sgi.com; Mon, 02 Feb 2015 08:43:16 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 0/5] xfs: use generic percpu counters for icsb
Date: Mon,  2 Feb 2015 08:42:58 +1100
Message-Id: <1422826983-29570-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

After listening to Eric swear about the per-cpu counter
implementation we have for the in-core superblock all week, I
decided the best thing to do woul dbe to simply replace them with
generic per-cpu counters. The current icsb counters were implemented
long before we had generic counter infrastructure, and it's remained
that way because if it ain't broke....

Anyway, we do have a couple of issues with the counters to do with
enforcing the maximum inode count on small filesystems. Fixing these
problems is what Eric spend time swearing about.

Anyway, to cut a long story short, there is nothing unique about the
inode counters - neither the allocated inode count nor the free
inode count need to be accurate at zero as they are not used for
ENOSPC enforcement at this limit, and the allocated inode count
doesn't need to be perfectly accurate at the maximum count, either.
Hence we can just replace them with generic per-cpu coutners without
second thoughts.

The free block counter is a little different. We need to be able to
accurately determine zero free blocks due to ENOSPC detection
requirements, and this is where all the complexity came from in the
existing infrastructure. The key technique that the existing
infrastructure uses to be accurate at zero is that it goes back to
a global lock and serialisation as it approaches zero. hence we
trade off scalability for accuracy at ENOSPC.

It turns out we can play the same trick with the generic per-cpu
counter infrastructure. They allow a customised "batch" value, which
is the threshold at which the local per-cpu counter is folded back
into the global counter. By setting this batch to 1 we effectively
serialise all modifications to the counter as any change will be
over the batch fold threshold. Hence we can add a simple check on
the global counter value and switch from large batch values to small
values as we approach the zero threshold.

This patchset has passed xfstests with no regressions, and there are
no performance impacts measurable on my 16p test VM on inode
allocation/freeing intensive workloads, nor on delayed allocation
workloads (which reserve a block at a time and hence trigger
extremely frequent updates) at IO rates of over 1GB/s. it also fixes
the maxicount enforcement issue on small filesystems that started
this off...

SGI:  this is a change that you are going to want to test for
regressions on one of your large machines that has multiple GB/s of
IO bandwidth. I don't expect there to be any problems, but if
there are we might need to tweak batch thresholds based on CPU
count......

This patchset is based on for-next, as it is dependent on the
superblock logging changes that are already queued for the next
cycle. Diffstat is as follows:

 fs/xfs/libxfs/xfs_bmap.c   |  16 +-
 fs/xfs/libxfs/xfs_format.h |  96 +------
 fs/xfs/libxfs/xfs_ialloc.c |   6 +-
 fs/xfs/libxfs/xfs_sb.c     |  43 +--
 fs/xfs/xfs_fsops.c         |  16 +-
 fs/xfs/xfs_iomap.c         |   3 +-
 fs/xfs/xfs_linux.h         |   9 -
 fs/xfs/xfs_log_recover.c   |   5 +-
 fs/xfs/xfs_mount.c         | 730 ++++++-----------------------------------------
 fs/xfs/xfs_mount.h         |  67 +----
 fs/xfs/xfs_rtalloc.c       |   6 +-
 fs/xfs/xfs_super.c         | 101 +++++--
 fs/xfs/xfs_super.h         |  83 ++++++
 fs/xfs/xfs_trans.c         |  19 +-
 14 files changed, 309 insertions(+), 891 deletions(-)

Comments, thoughts?

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
