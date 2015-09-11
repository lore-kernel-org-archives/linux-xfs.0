Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 51C4C7F37
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 13:53:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 428C3304039
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:53:58 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vnKUrIP7xgxgN1ia (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2015 11:53:57 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id D9F2991C0E
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 18:53:56 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-37.bos.redhat.com [10.18.41.37])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t8BIrumv025857
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 14:53:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [RFC v2 0/2] xfs: detect and warn about invalid metadata lsns
Date: Fri, 11 Sep 2015 14:53:53 -0400
Message-Id: <1441997635-36644-1-git-send-email-bfoster@redhat.com>
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

Here's a second rfc pass at the kernel side of invalid metadata LSN
detection for v5 supers. This is an rfc simply because my understanding
is that the userspace code should probably go first so that the tools
for repair are available before the kernel starts detecting and warning
about this problem.

The primary change in this version is how the problem is handled once
detected. I've been a bit undecided on whether a shutdown is really
warranted because if the fs doesn't crash, it will eventually
self-correct. On the flipside, a WARN_ON_ONCE() is not sufficient
because it could suppress warnings on separate filesystems once one
filesystem has encountered the issue and fired a warning.

Therefore, this version uses something of a happy medium. The filesystem
is not shutdown but a mount flag is used to warn about the problem at
least once per-mount. Any instances thereafter are ratelimited to a once
per 24 hour period.

Brian

rfcv2:
- Refactored lsn validation and warning code into separate helpers.
- Updated warning mechanism to warn at least once per fs (ratelimited
  thereafter).
- No longer shutdown the fs on invalid metadata lsn detection.
rfcv1: http://oss.sgi.com/pipermail/xfs/2015-August/043396.html

Brian Foster (2):
  xfs: create a daily warning mechanism
  xfs: validate metadata LSNs against log on v5 superblocks

 fs/xfs/libxfs/xfs_alloc.c          |  9 +++++--
 fs/xfs/libxfs/xfs_attr_leaf.c      |  2 ++
 fs/xfs/libxfs/xfs_btree.c          | 14 +++++++++--
 fs/xfs/libxfs/xfs_da_btree.c       |  3 +++
 fs/xfs/libxfs/xfs_dir2_block.c     |  1 +
 fs/xfs/libxfs/xfs_dir2_data.c      |  1 +
 fs/xfs/libxfs/xfs_dir2_leaf.c      |  1 +
 fs/xfs/libxfs/xfs_dir2_node.c      |  1 +
 fs/xfs/libxfs/xfs_ialloc.c         |  8 +++++--
 fs/xfs/libxfs/xfs_sb.c             |  8 +++++++
 fs/xfs/libxfs/xfs_symlink_remote.c |  3 +++
 fs/xfs/xfs_log.c                   |  1 -
 fs/xfs/xfs_log_priv.h              | 24 +++++++++++++++++++
 fs/xfs/xfs_log_recover.c           | 15 +++++++++++-
 fs/xfs/xfs_message.h               | 18 ++++++++++----
 fs/xfs/xfs_mount.c                 | 49 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h                 |  3 +++
 17 files changed, 149 insertions(+), 12 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
