Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o461hu5k064977 for <xfs@oss.sgi.com>; Wed, 5 May 2010 20:43:56 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BD9C1B0A173
	for <xfs@oss.sgi.com>; Wed,  5 May 2010 18:46:05 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	riOHIoqezqvMTVcE for <xfs@oss.sgi.com>;
	Wed, 05 May 2010 18:46:05 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	23118553-1927428
	for <xfs@oss.sgi.com>; Thu, 06 May 2010 11:16:03 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1O9q9w-0005DK-6U
	for xfs@oss.sgi.com; Thu, 06 May 2010 11:45:52 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1O9q9v-0000cD-44
	for xfs@oss.sgi.com; Thu, 06 May 2010 11:45:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/11] xfs: delayed logging
Date: Thu,  6 May 2010 11:45:40 +1000
Message-Id: <1273110351-2333-1-git-send-email-david@fromorbit.com>
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


Hi Folks,

This is version 4 of the delayed logging series.

I won't repeat everything about what it is, just point you
here:

http://marc.info/?l=linux-xfs&m=126862777118946&w=2

for the description, and here:

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git delayed-logging

for the current code. Note that this is a rebased branch, so you'll
need to pull it again into a new branch to review.

This version includes a number of fixes and cleanups related to the
busy extent tracking. This includes fixing a long standing
off-by-one that was causing assert failures when inserting busy
extents that overlapped with existing busy extents.

The patch series follows this mail to make it easier for people to
respond to specific pieces of the code during review. I'm still
making the entire patch set available through git, though.

The changes are mostly small and isolated, so there isn't much
change from the previous version:

Version 4: 26 files changed, 2351 insertions(+), 510 deletions(-)
Version 3: 28 files changed, 2366 insertions(+), 506 deletions(-)
Version 2: 22 files changed, 2188 insertions(+), 377 deletions(-)
Version 1: 19 files changed, 2594 insertions(+), 580 deletions(-)

Changes for V4:

o fixes duplicate transaction IDs on rolling transactions (new commit)
o folded in a busy extent freeing cleanup from Christoph Hellwig
o made API prefix consistent (xfs_alloc_busy_*)
o combined xfs_alloc_mark_busy and xfs_alloc_busy_insert
o reverted back to tracking transaction pointers in busy extents
o removed exporting of transaction ID for busy extents
o fixed an off-by-one in the extent range match in the busy extent
  search code that has been triggering assert failures
o use list_splice_init() when splicing busy extents from the
  transaction to the checkpoint context to ensure we don't get
  transactions thinking they have busy extents to free after we've
  already attached them to the checkpoint.

Changes for V3:
o changed buffer log item reference counted model to be consistent
  for both logging modes
o cleaned up XFS_BLI flags usage (new commit)
o separated out log ticket overrun printing cleanup (new commit)
o made sure "delaylog" option shows up in /proc/mounts
o collapsed many of the intermediate commits together to make it
  easier to review
o fixed inode buffer tagging issue that was causing shutdowns in log
  recovery in test 087 and 121

Changes for V2:
o 22 files changed, 2188 insertions(+), 377 deletions(-)
o fixed some memory leaks
o fixed ticket allocation for checkpoints to use KM_NOFS
o minor code cleanups
o performed stress and scalability testing

The following changes since commit 6ff75b78182c314112c1173edaab6c164c95d775:
  Christoph Hellwig (1):
        xfs: mark xfs_iomap_write_ helpers static

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git delayed-logging

Dave Chinner (11):
      xfs: Don't reuse the same transaciton ID for duplicated transactions.
      xfs: Improve scalability of busy extent tracking
      xfs: allow log ticket allocation to take allocation flags
      xfs: modify buffer item reference counting V2
      xfs: Clean up XFS_BLI_* flag namespace
      xfs: clean up log ticket overrun debug output
      xfs: Delayed logging design documentation
      xfs: Introduce delayed logging core code
      xfs: forced unmounts need to push the CIL
      xfs: enable background pushing of the CIL
      xfs: Ensure inode allocation buffers are fully replayed

 .../filesystems/xfs-delayed-logging-design.txt     |  819 ++++++++++++++++++++
 fs/xfs/Makefile                                    |    1 +
 fs/xfs/linux-2.6/xfs_buf.c                         |   11 +-
 fs/xfs/linux-2.6/xfs_quotaops.c                    |    1 +
 fs/xfs/linux-2.6/xfs_super.c                       |   12 +-
 fs/xfs/linux-2.6/xfs_trace.h                       |   80 ++-
 fs/xfs/quota/xfs_dquot.c                           |    6 +-
 fs/xfs/xfs_ag.h                                    |   21 +-
 fs/xfs/xfs_alloc.c                                 |  276 ++++---
 fs/xfs/xfs_alloc.h                                 |    7 +-
 fs/xfs/xfs_alloc_btree.c                           |    2 +-
 fs/xfs/xfs_buf_item.c                              |  166 ++--
 fs/xfs/xfs_buf_item.h                              |   18 +-
 fs/xfs/xfs_error.c                                 |    2 +-
 fs/xfs/xfs_log.c                                   |  116 ++-
 fs/xfs/xfs_log.h                                   |   10 +-
 fs/xfs/xfs_log_cil.c                               |  733 ++++++++++++++++++
 fs/xfs/xfs_log_priv.h                              |  116 +++-
 fs/xfs/xfs_log_recover.c                           |   46 +-
 fs/xfs/xfs_log_recover.h                           |    2 +-
 fs/xfs/xfs_mount.h                                 |    1 +
 fs/xfs/xfs_trans.c                                 |  195 ++++-
 fs/xfs/xfs_trans.h                                 |   44 +-
 fs/xfs/xfs_trans_buf.c                             |   46 +-
 fs/xfs/xfs_trans_item.c                            |  114 +---
 fs/xfs/xfs_trans_priv.h                            |   16 +-
 26 files changed, 2351 insertions(+), 510 deletions(-)
 create mode 100644 Documentation/filesystems/xfs-delayed-logging-design.txt
 create mode 100644 fs/xfs/xfs_log_cil.c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
