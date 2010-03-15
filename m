Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2F2XlHG004717 for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 21:33:48 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F038A19D2E2A
	for <xfs@oss.sgi.com>; Sun, 14 Mar 2010 19:35:21 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	X1n7UjmGZXtq8bs6 for <xfs@oss.sgi.com>;
	Sun, 14 Mar 2010 19:35:21 -0700 (PDT)
Received: from dastard (unverified [121.44.103.80])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	16902520-1927428
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 13:05:18 +1030 (CDT)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Nr09E-00015q-4w
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:16 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1Nr09B-0002pP-Ek
	for xfs@oss.sgi.com; Mon, 15 Mar 2010 13:35:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/9] Log and transaction cleanups, factoring and bug fixes V2
Date: Mon, 15 Mar 2010 13:34:57 +1100
Message-Id: <1268620506-10799-1-git-send-email-david@fromorbit.com>
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

The following series is preparation for delayed logging patches. The cleanups
and factoring patches are mainly to make it simple to introduce the delayed
logging patches, especially as these changes really have nothing to do with
delayed logging. The cleanups and factoring patches should be no-ops from a
functionality point of view.

A couple of the patches are fixes for bugs that I've found as I've been working
through delayed logging prototypes.

Patches 8 (reservation bug fix) and 9 (new cleanup) of the series still
require review.

Version 2:
- drop log vector changes from the series
- fix bogus assert in xfs_trans_committed() changes
- Added Christoph's _xfs_trans_commit() cleanup patch
- Added further cleanup of the xfs_trans_committed() code as suggested by
  Christoph.


These changes are also available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfs.git trans-cleanup

Christoph Hellwig (1):
      xfs: clean up xfs_trans_commit logic even more

Dave Chinner (8):
      xfs: factor log item initialisation
      xfs: Add inode pin counts to traces
      xfs: remove stale parameter from ->iop_unpin method
      xfs: fix reservation release commit flag in xfs_bmap_add_attrfork()
      xfs: split out iclog writing from xfs_trans_commit()
      xfs: update and factor xfs_trans_committed()
      xfs: Clean up xfs_trans_committed code after factoring
      xfs: log ticket reservation underestimates the number of iclogs

 fs/xfs/linux-2.6/xfs_trace.h  |    9 +-
 fs/xfs/quota/xfs_dquot_item.c |   28 +-
 fs/xfs/xfs_bmap.c             |    2 +-
 fs/xfs/xfs_buf_item.c         |   55 ++--
 fs/xfs/xfs_extfree_item.c     |   18 +-
 fs/xfs/xfs_inode.c            |    2 +
 fs/xfs/xfs_inode_item.c       |   21 +-
 fs/xfs/xfs_log.c              |   68 +++-
 fs/xfs/xfs_log.h              |    7 +
 fs/xfs/xfs_trans.c            |  760 +++++++++++++++++++----------------------
 fs/xfs/xfs_trans.h            |    5 +-
 fs/xfs/xfs_trans_buf.c        |    3 +-
 12 files changed, 481 insertions(+), 497 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
