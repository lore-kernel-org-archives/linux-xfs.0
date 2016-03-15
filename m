Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BA0BA7CD7
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 15:39:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2B2BDAC005
	for <xfs@oss.sgi.com>; Tue, 15 Mar 2016 13:39:14 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	o4ozv6xNb6E7ASlT for <xfs@oss.sgi.com>;
	Tue, 15 Mar 2016 13:39:10 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1afvkC-0005cX-CU
	for xfs@oss.sgi.com; Wed, 16 Mar 2016 07:39:08 +1100
Date: Wed, 16 Mar 2016 07:39:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 2cdb958
Message-ID: <20160315203908.GE11812@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This is the last update for the 4.6 merge
window - after it has sat in linux-next for a couple of days I'll
tag it and ask Linus to pull.

The new head of the for-next branch is commit:

2cdb958 Merge branch 'xfs-misc-fixes-4.6-4' into for-next

New Commits:

Brian Foster (4):
      [801cc4e] xfs: debug mode forced buffered write failure
      [b2706a0] xfs: update freeblocks counter after extent deletion
      [a9bd24a] xfs: refactor delalloc indlen reservation split into helper
      [d34999c] xfs: borrow indirect blocks from freed extent when available

Christoph Hellwig (1):
      [355cced] xfs: always set rvalp in xfs_dir2_node_trim_free

Dave Chinner (1):
      [2cdb958] Merge branch 'xfs-misc-fixes-4.6-4' into for-next

Eric Sandeen (1):
      [cc07eed] xfs: ensure committed is initialized in xfs_trans_roll


Code Diffstat:

 fs/xfs/libxfs/xfs_bmap.c      | 157 ++++++++++++++++++++++++++++++++------------
 fs/xfs/libxfs/xfs_dir2_node.c |   4 +-
 fs/xfs/xfs_aops.c             |   9 ++-
 fs/xfs/xfs_mount.h            |  25 +++++++
 fs/xfs/xfs_sysfs.c            |  78 +++++++++++++++++++---
 fs/xfs/xfs_trans.c            |   4 +-
 6 files changed, 221 insertions(+), 56 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
