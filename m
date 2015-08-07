Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 897757F80
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 16:15:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 17603AC006
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 14:15:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OojZNvrDVYNhdGVv (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Aug 2015 14:15:31 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 0E91D9D1DA
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 21:15:31 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-76.bos.redhat.com [10.18.41.76])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t77LFUWD025048
	for <xfs@oss.sgi.com>; Fri, 7 Aug 2015 17:15:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 00/12] xfs: miscellaneous logging, recovery, umount fixes
Date: Fri,  7 Aug 2015 17:15:16 -0400
Message-Id: <1438982128-38618-1-git-send-email-bfoster@redhat.com>
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

Here's v2 of the EFI/EFD and miscellaneous log fixes series. Patch 12 is
added based on a suggestion from Dave in the v1 comments. Otherwise,
most of the changes are in patch 6 where the APIs for log recovery
cancellation are shuffled around a bit. Note that I retained the
xlog_recovery_finish() helper rather than replace it because there is
another caller in this version that addresses a memory leak (plus it
seems consistent with the xlog_recovery_finish() interface).

Brian

v2:
- Added new comment around EFI/EFD refcount rules.
- Appended patch 12 to clean up AIL item removal.
- Reworked log recovery EFI cancellation APIs.
- Invoke EFI cancellation within xfs_log_mount() on failure to prevent
  memory leak.
v1: http://oss.sgi.com/pipermail/xfs/2015-August/042877.html
- Updated EFI/EFD tracking semantics based on rfc comments.
- Added more cleanups/fixes to series.
rfc: http://oss.sgi.com/pipermail/xfs/2015-July/042617.html

Brian Foster (12):
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

 fs/xfs/libxfs/xfs_ialloc.c |   2 +-
 fs/xfs/xfs_bmap_util.c     |  84 ++++++++++++----------
 fs/xfs/xfs_buf_item.c      |   7 +-
 fs/xfs/xfs_dquot.c         |   8 +--
 fs/xfs/xfs_extfree_item.c  | 109 ++++++++++++-----------------
 fs/xfs/xfs_extfree_item.h  |  26 ++++++-
 fs/xfs/xfs_inode_item.c    |  10 +--
 fs/xfs/xfs_itable.c        |   3 +-
 fs/xfs/xfs_log.c           |  37 ++++++++--
 fs/xfs/xfs_log.h           |   1 +
 fs/xfs/xfs_log_priv.h      |   2 +
 fs/xfs/xfs_log_recover.c   | 169 ++++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_mount.c         |  28 ++++----
 fs/xfs/xfs_trace.h         |  34 +++++++++
 fs/xfs/xfs_trans.c         |  15 +++-
 fs/xfs/xfs_trans.h         |   2 +-
 fs/xfs/xfs_trans_priv.h    |  14 ++++
 17 files changed, 367 insertions(+), 184 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
