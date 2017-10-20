Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:35826 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752793AbdJTLPz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:15:55 -0400
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 0/5] xfs refcount conversions
Date: Fri, 20 Oct 2017 14:07:53 +0300
Message-Id: <1508497678-10508-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, peterz@infradead.org, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>

Note: our previous thread didn't finish in any conclusion, so
I am resending this now (rebased at latest linux-next) to revive
the discussion. refcount_t is slowly becoming a standard for
refcounters and we would really like to make all conversions
done where it is applicable.

******

This series, for xfs, replaces atomic_t reference
counters with the new refcount_t type and API (see include/linux/refcount.h).
By doing this we prevent intentional or accidental
underflows or overflows that can lead to use-after-free vulnerabilities.

The patches are fully independent and can be cherry-picked separately.
If there are no objections to the patches, please merge them via respective trees.

Elena Reshetova (5):
  fs, xfs: convert xfs_bui_log_item.bui_refcount from atomic_t to
    refcount_t
  fs, xfs: convert xfs_efi_log_item.efi_refcount from atomic_t to
    refcount_t
  fs, xfs: convert xlog_ticket.t_ref from atomic_t to refcount_t
  fs, xfs: convert xfs_cui_log_item.cui_refcount from atomic_t to
    refcount_t
  fs, xfs: convert xfs_rui_log_item.rui_refcount from atomic_t to
    refcount_t

 fs/xfs/xfs_bmap_item.c     |  6 +++---
 fs/xfs/xfs_bmap_item.h     |  2 +-
 fs/xfs/xfs_extfree_item.c  |  6 +++---
 fs/xfs/xfs_extfree_item.h  |  2 +-
 fs/xfs/xfs_linux.h         |  1 +
 fs/xfs/xfs_log.c           | 10 +++++-----
 fs/xfs/xfs_log_priv.h      |  2 +-
 fs/xfs/xfs_refcount_item.c |  6 +++---
 fs/xfs/xfs_refcount_item.h |  2 +-
 fs/xfs/xfs_rmap_item.c     |  6 +++---
 fs/xfs/xfs_rmap_item.h     |  2 +-
 11 files changed, 23 insertions(+), 22 deletions(-)

-- 
2.7.4

