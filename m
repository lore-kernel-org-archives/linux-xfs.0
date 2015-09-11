Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B1D0B7F50
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 13:55:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 820C530404E
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 9Hr5ZMBu5uehVOxM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:55:44 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 2055DA19CC
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 18:55:44 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-37.bos.redhat.com [10.18.41.37])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8BIthLI022528
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 14:55:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 00/12] xfsprogs: format the log correctly on v5 supers
Date: Fri, 11 Sep 2015 14:55:30 -0400
Message-Id: <1441997742-37160-1-git-send-email-bfoster@redhat.com>
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

This is pass 2 of the userspace side of the invalid metadata LSN fixes.
It is based on the RFCv2 version of the associated kernel fixes:

  http://oss.sgi.com/pipermail/xfs/2015-September/043627.html

Outside of the rebase to the latest kernel patch, this version adds
support for the xfs_db uuid command and xfs_metadump. Both of these
utilities clear the log under certain circumstances and thus both have
been updated to format the log with a bumped cycle number when
appropriate.

The only remaining gap that I'm aware of is xfs_copy. xfs_copy support
is not included because the log formatting code therein is slightly more
complicated than what is done in other places. In particular, it uses
its own buffer and alignment mechanisms that have to deal with direct
I/O alignment rules and aren't easily compatible with the existing
buffered log formatting mechanism. I haven't quite figured out how best
to deal with that yet.

Thoughts, reviews, flames appreciated.

Brian

v2:
- Rebase to latest kernel variant of invalid metadata LSN detection.
- Added support for xfs_db's uuid command and xfs_metadump.
v1: http://oss.sgi.com/pipermail/xfs/2015-August/043397.html

Brian Foster (12):
  libxfs: validate metadata LSNs against log on v5 superblocks
  libxfs: track largest metadata LSN in use via verifiers
  libxfs: don't hardcode cycle 1 into unmount op header
  libxfs: pass lsn param to log clear and record header logging helpers
  libxfs: add ability to clear log to arbitrary log cycle
  libxlog: pull struct xlog out of xlog_is_dirty()
  xfs_repair: track log state throughout all recovery phases
  xfs_repair: process the log in no_modify mode
  xfs_repair: format the log with forward cycle number on v5 supers
  xfs_repair: don't clear the log by default
  xfs_db: do not reset current lsn from uuid command on v5 supers
  db/metadump: bump lsn when log is cleared on v5 supers

 copy/xfs_copy.c             |   4 +-
 db/init.c                   |  25 ++++---
 db/metadump.c               |  21 ++++--
 db/sb.c                     |  18 ++++-
 include/libxfs.h            |  13 ++--
 include/libxlog.h           |   3 +-
 include/xfs_mount.h         |   6 ++
 libxfs/libxfs_priv.h        |   2 +
 libxfs/rdwr.c               | 160 +++++++++++++++++++++++++++++++++++++-------
 libxfs/util.c               |  38 +++++++++++
 libxfs/xfs_alloc.c          |   9 ++-
 libxfs/xfs_attr_leaf.c      |   2 +
 libxfs/xfs_btree.c          |  14 +++-
 libxfs/xfs_da_btree.c       |   3 +
 libxfs/xfs_dir2_block.c     |   1 +
 libxfs/xfs_dir2_data.c      |   1 +
 libxfs/xfs_dir2_leaf.c      |   1 +
 libxfs/xfs_dir2_node.c      |   1 +
 libxfs/xfs_ialloc.c         |   8 ++-
 libxfs/xfs_sb.c             |   8 +++
 libxfs/xfs_symlink_remote.c |   3 +
 libxlog/util.c              |  37 +++++-----
 mkfs/xfs_mkfs.c             |   4 +-
 repair/phase2.c             |  83 +++++++++++++++--------
 repair/xfs_repair.c         |  79 +++++++++++++++++++++-
 25 files changed, 436 insertions(+), 108 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
