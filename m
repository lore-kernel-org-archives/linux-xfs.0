Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qACBqXCC217518 for <xfs@oss.sgi.com>; Mon, 12 Nov 2012 05:52:33 -0600
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	KYjNkl8apUGcKZ3Y for <xfs@oss.sgi.com>;
	Mon, 12 Nov 2012 03:54:34 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TXsb3-00053K-5w
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:54:33 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TXsax-00011X-Pn
	for xfs@oss.sgi.com; Mon, 12 Nov 2012 22:54:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/32] xfs: current queue for 3.8
Date: Mon, 12 Nov 2012 22:53:52 +1100
Message-Id: <1352721264-3700-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

This is my current patch queue for the 3.8 merge window. We are now
getting close to the window opening (at -rc5 now), so I'd really
like to see this stuff into the dev tree ASAP so that there is some
wider test coverage before the merge window comes along.

The bulk of this patch series has been reviewed and revised over the
past month. The only new patch in this is the additional attribute
trace points that I needed to track down the corruption problem I
recently fixed.

Other than that, I've reordered the patches to make growfs use
uncached buffers ahead of the verifier series and rebased the
verifier series on top of it. i also folded the fixes I had in
additional patches back into the base patches in the verifier
series.

I'm not sure whether I have captured all the Reviewed-by tags that
people have given - if necessary I can go back and search the lists
for them all and add the ones I've missed....

Diffstat for the series is:

$ git diff --stat --summary -C -M 074dad5..f02d23b
 fs/xfs/Kconfig            |    1 +
 fs/xfs/Makefile           |    1 -
 fs/xfs/uuid.h             |    6 +
 fs/xfs/xfs_ag.h           |    4 +
 fs/xfs/xfs_alloc.c        |  141 ++++++++++++---
 fs/xfs/xfs_alloc.h        |    3 +
 fs/xfs/xfs_alloc_btree.c  |   77 +++++++++
 fs/xfs/xfs_alloc_btree.h  |    2 +
 fs/xfs/xfs_aops.c         |    2 +-
 fs/xfs/xfs_attr.c         |  103 +++++------
 fs/xfs/xfs_attr_leaf.c    |  143 ++++++++++------
 fs/xfs/xfs_attr_leaf.h    |    6 +
 fs/xfs/xfs_bmap.c         |   64 ++++---
 fs/xfs/xfs_bmap_btree.c   |   63 +++++++
 fs/xfs/xfs_bmap_btree.h   |    1 +
 fs/xfs/xfs_btree.c        |  111 +++++++-----
 fs/xfs/xfs_btree.h        |   22 ++-
 fs/xfs/xfs_buf.c          |   59 +++++--
 fs/xfs/xfs_buf.h          |   27 ++-
 fs/xfs/xfs_cksum.h        |   63 +++++++
 fs/xfs/xfs_da_btree.c     |  141 ++++++++++++---
 fs/xfs/xfs_da_btree.h     |   10 +-
 fs/xfs/xfs_dfrag.c        |   13 +-
 fs/xfs/xfs_dir2_block.c   |  436 +++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_dir2_data.c    |  170 ++++++++++++++----
 fs/xfs/xfs_dir2_leaf.c    |  172 +++++++++++++------
 fs/xfs/xfs_dir2_node.c    |  288 ++++++++++++++++++++-----------
 fs/xfs/xfs_dir2_priv.h    |   19 ++-
 fs/xfs/xfs_dquot.c        |  135 ++++++++++++---
 fs/xfs/xfs_file.c         |   27 +--
 fs/xfs/xfs_fs_subr.c      |   96 -----------
 fs/xfs/xfs_fsops.c        |  137 ++++++++++-----
 fs/xfs/xfs_ialloc.c       |   74 +++++---
 fs/xfs/xfs_ialloc.h       |    4 +-
 fs/xfs/xfs_ialloc_btree.c |   55 ++++++
 fs/xfs/xfs_ialloc_btree.h |    2 +
 fs/xfs/xfs_inode.c        |  131 ++++++++------
 fs/xfs/xfs_inode.h        |    1 +
 fs/xfs/xfs_iops.c         |    4 +-
 fs/xfs/xfs_itable.c       |    3 +-
 fs/xfs/xfs_linux.h        |    1 +
 fs/xfs/xfs_log.c          |  135 ++++++++++++---
 fs/xfs/xfs_log_priv.h     |   11 +-
 fs/xfs/xfs_log_recover.c  |  145 ++++++++--------
 fs/xfs/xfs_mount.c        |  130 +++++++++-----
 fs/xfs/xfs_mount.h        |    4 +-
 fs/xfs/xfs_qm.c           |    5 +-
 fs/xfs/xfs_rtalloc.c      |   15 +-
 fs/xfs/xfs_sb.h           |   10 +-
 fs/xfs/xfs_trace.h        |   54 +++++-
 fs/xfs/xfs_trans.h        |   19 +--
 fs/xfs/xfs_trans_buf.c    |    9 +-
 fs/xfs/xfs_vnodeops.c     |   48 ++++--
 fs/xfs/xfs_vnodeops.h     |    7 -
 54 files changed, 2327 insertions(+), 1083 deletions(-)
 create mode 100644 fs/xfs/xfs_cksum.h
 delete mode 100644 fs/xfs/xfs_fs_subr.c

It seems pretty solid - all the bug fixes I've been pushing out
recently have been found as a result of testing this patch series.
They have started life at the end of the series, and once confirmed
to fix the problem have been re-ordered to the start. Hence the
series has been seeing all the testing I have been doing recently.

I really do not want this stuff to miss the 3.8 window due
to a repeat of the last cycle's misadventures. Given how quiet -rc5
was, we might only be 2 weeks away from the 3.8 merge window
opening. Which means that, realistically, this series need to be
finalised by the end of the week so that it's got some soak time in
linux-next before it moves into Linus' tree.

The main reason I don't want this to miss 3.8 is that I'm planning
on 3.9 for all the CRC metadata format changes and supporting code
to be ready. There's a lot more code for coming for 3.9 than there
is in this patch series (probably twice the size) and it's a lot
more complex, so the less that ends up in 3.9 from this series the
better...

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
