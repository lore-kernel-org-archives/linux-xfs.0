Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B820F7F37
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 13:06:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A2BC68F8035
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 11:06:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KfYPLfO346HaV7UB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Aug 2015 11:06:49 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 3B375C1A4B29
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 18:06:49 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-103.bos.redhat.com [10.18.41.103])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7SI6mLV003649
	for <xfs@oss.sgi.com>; Fri, 28 Aug 2015 14:06:49 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/9] xfsprogs: handle the log correctly on v5 supers
Date: Fri, 28 Aug 2015 14:06:38 -0400
Message-Id: <1440785207-17543-1-git-send-email-bfoster@redhat.com>
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

Hi all,

Here's a first pass at a series to address the problem of repair putting
the current LSN behind existing metadata LSNs via log zeroing. The goal
is to detect when the current LSN is behind the maximum used metadata
LSN in the fs, for whatever reason, and reformat the log with a higher
cycle number when necessary. This is only lightly tested so far.

Patch 1 is a backport of the recently posted kernel patch with the
validation helper stubbed out. Patch 2 fills in the validation helper to
implement max metadata LSN tracking. Patches 3-5 clean up the record
logging code and add the ability to format the log to an arbitrary cycle
number. Patches 6-8 update xfs_repair to detect an improper current LSN
and reformat the log when necessary. Patch 9 updates xfs_repair to no
longer zero the log by default in phase 2.

Some notes:

- This series currently only considers xfs_repair. Other utilities might
  have to be updated to handle the same problem.
- Right now this only uses verifiers for max metadata LSN tracking. I
  don't believe this covers physical inodes, perhaps other data
  structures..?

Thoughts, reviews, flames appreciated.

Brian

Brian Foster (9):
  xfs: validate metadata LSNs against log on v5 superblocks
  libxfs: track largest metadata LSN in use via verifiers
  libxfs: don't hardcode cycle 1 into unmount op header
  libxfs: pass lsn param to log clear and record header logging helpers
  libxfs: add ability to clear log to arbitrary log cycle
  xfs_repair: track log state throughout all recovery phases
  xfs_repair: process the log in no_modify mode
  xfs_repair: format the log with forward cycle number on v5 supers
  xfs_repair: don't clear the log by default

 copy/xfs_copy.c             |   4 +-
 db/sb.c                     |   2 +-
 include/libxfs.h            |  13 ++++--
 include/xfs_mount.h         |   6 +++
 libxfs/libxfs_priv.h        |   2 +
 libxfs/rdwr.c               | 106 ++++++++++++++++++++++++++++++++++++++------
 libxfs/util.c               |  40 +++++++++++++++++
 libxfs/xfs_alloc.c          |  10 ++++-
 libxfs/xfs_attr_leaf.c      |   3 ++
 libxfs/xfs_btree.c          |  18 +++++++-
 libxfs/xfs_da_btree.c       |   3 ++
 libxfs/xfs_dir2_block.c     |   2 +
 libxfs/xfs_dir2_data.c      |   2 +
 libxfs/xfs_dir2_leaf.c      |   2 +
 libxfs/xfs_dir2_node.c      |   2 +
 libxfs/xfs_ialloc.c         |   9 +++-
 libxfs/xfs_sb.c             |   9 ++++
 libxfs/xfs_symlink_remote.c |   3 ++
 mkfs/xfs_mkfs.c             |   2 +-
 repair/phase2.c             |  83 ++++++++++++++++++++++------------
 repair/xfs_repair.c         |  78 ++++++++++++++++++++++++++++++--
 21 files changed, 339 insertions(+), 60 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
