Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 017D77F74
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 12:44:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 74B6EAC00A
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 10:44:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rMcjfpNad30e5dE7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Aug 2015 10:44:35 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id 663F9D0A9A
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 17:44:34 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t76HiXQG017987
	for <xfs@oss.sgi.com>; Thu, 6 Aug 2015 13:44:34 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 00/11] xfs: miscellaneous logging, recovery, umount fixes
Date: Thu,  6 Aug 2015 13:44:21 -0400
Message-Id: <1438883072-28706-1-git-send-email-bfoster@redhat.com>
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

This series includes a bunch of bug fixes from doing some log recovery
testing. It started with an RFC of the EFI/EFD bits and expanded to
include more fixes as problems were discovered.

Patch 1 removes the superfluous EFI/EFD extent count reference tracking.
Patches 2-6 make a couple cleanups and fix the explicit EFI/EFD
reference counting to avoid leaving EFI items on the AIL in the event of
error. Patches 7-8 fix handling of cancelled icreate transactions in log
recovery. Patch 9 is a repost of a previous log recovery fix. Patches
10-11 fix a couple more mount related crash/hang issues.

Just about all of these problems were reproduced by running repeated
fsstress/godown workloads against XFS. This set has gone ~150 iterations
of said testing before hitting some kind of recovery time directory
corruption in the form of a dir. block write verifier failure. I'll see
if it is reproducible, but I don't think it's related to anything
here since I haven't touched directory code...

Brian

v1:
- Updated EFI/EFD tracking semantics based on rfc comments.
- Added more cleanups/fixes to series.
rfc: http://oss.sgi.com/pipermail/xfs/2015-July/042617.html

Brian Foster (11):
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

 fs/xfs/libxfs/xfs_ialloc.c |   2 +-
 fs/xfs/xfs_bmap_util.c     |  84 +++++++++++++++-----------
 fs/xfs/xfs_extfree_item.c  | 118 +++++++++++++++++-------------------
 fs/xfs/xfs_extfree_item.h  |   1 +
 fs/xfs/xfs_itable.c        |   3 +-
 fs/xfs/xfs_log.c           |  23 +++++--
 fs/xfs/xfs_log.h           |   2 +-
 fs/xfs/xfs_log_priv.h      |   2 +
 fs/xfs/xfs_log_recover.c   | 147 +++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_mount.c         |  37 ++++++++----
 fs/xfs/xfs_trace.h         |  34 +++++++++++
 fs/xfs/xfs_trans.c         |  15 ++++-
 fs/xfs/xfs_trans.h         |   2 +-
 13 files changed, 307 insertions(+), 163 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
