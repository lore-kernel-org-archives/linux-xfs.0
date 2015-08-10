Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 039FA7F6A
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 14:01:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 7EDE8AC004
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 12:01:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id JhciwipgKGEV6v4R (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Aug 2015 12:01:51 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id B235383F69
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 19:01:50 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-184.bos.redhat.com [10.18.41.184])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7AJ1ou7005094
	for <xfs@oss.sgi.com>; Mon, 10 Aug 2015 15:01:50 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 00/13] xfs: miscellaneous logging, recovery, umount fixes
Date: Mon, 10 Aug 2015 15:01:36 -0400
Message-Id: <1439233309-19959-1-git-send-email-bfoster@redhat.com>
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

Here is v3 of the EFI/EFD/logging fixup series with updates based on
Christoph's review (in the v1 thread). I debated folding patch 4 into
patch 3 given the additional refactoring, but opted to keep them
separate to keep patch 3 to functional changes. Feel free to fold them
if that is preferred.

I also appended patch 13 to add some missing xfs_bmap_cancel() calls,
which I had deferred looking into until the lower level
xfs_bmap_finish() fixes were more solidified.

Brian

v3:
- Various, minor style fixups.
- Updated the commit log description for patch 1.
- Migrated xfs_trans_log_efd_extent() to an xfs_trans_free_extent()
  helper that encodes the new EFD logging rules (patch 4).
- Appended patch 13 to add a few missing xfs_bmap_cancel() calls.
v2: http://oss.sgi.com/pipermail/xfs/2015-August/042922.html
- Added new comment around EFI/EFD refcount rules.
- Appended patch 12 to clean up AIL item removal.
- Reworked log recovery EFI cancellation APIs.
- Invoke EFI cancellation within xfs_log_mount() on failure to prevent
  memory leak.
v1: http://oss.sgi.com/pipermail/xfs/2015-August/042877.html
- Updated EFI/EFD tracking semantics based on rfc comments.
- Added more cleanups/fixes to series.
rfc: http://oss.sgi.com/pipermail/xfs/2015-July/042617.html

Brian Foster (13):
  xfs: disentagle EFI release from the extent count
  xfs: return committed status from xfs_trans_roll()
  xfs: fix efi/efd error handling to avoid fs shutdown hangs
  xfs: ensure EFD trans aborts on log recovery extent free failure
  xfs: use EFI refcount consistently in log recovery
  xfs: don't leave EFIs on AIL on mount failure
  xfs: icreate log item recovery and cancellation tracepoints
  xfs: fix broken icreate log item cancellation
  xfs: checksum log record ext headers based on record size
  xfs: clean up root inode properly on mount failure
  xfs: fix btree cursor error cleanups
  xfs: add helper to conditionally remove items from the AIL
  xfs: add missing bmap cancel calls in error paths

 fs/xfs/libxfs/xfs_bmap.c   |   1 +
 fs/xfs/libxfs/xfs_ialloc.c |   2 +-
 fs/xfs/xfs_bmap_util.c     |  87 ++++++++++++-----------
 fs/xfs/xfs_buf_item.c      |   7 +-
 fs/xfs/xfs_dquot.c         |   8 +--
 fs/xfs/xfs_extfree_item.c  | 108 ++++++++++++-----------------
 fs/xfs/xfs_extfree_item.h  |  26 ++++++-
 fs/xfs/xfs_inode.c         |   9 +--
 fs/xfs/xfs_inode_item.c    |  10 +--
 fs/xfs/xfs_itable.c        |   3 +-
 fs/xfs/xfs_log.c           |  37 ++++++++--
 fs/xfs/xfs_log.h           |   1 +
 fs/xfs/xfs_log_priv.h      |   2 +
 fs/xfs/xfs_log_recover.c   | 167 ++++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_mount.c         |  28 ++++----
 fs/xfs/xfs_rtalloc.c       |  57 ++++++++--------
 fs/xfs/xfs_trace.h         |  34 +++++++++
 fs/xfs/xfs_trans.c         |  15 +++-
 fs/xfs/xfs_trans.h         |   9 ++-
 fs/xfs/xfs_trans_extfree.c |  32 ++++++---
 fs/xfs/xfs_trans_priv.h    |  14 ++++
 21 files changed, 423 insertions(+), 234 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
