Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28394 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751062AbdCAIxB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Mar 2017 03:53:01 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 0/5] fs, xfs atomic_t to refcount_t conversions version 2
Date: Wed,  1 Mar 2017 10:47:35 +0200
Message-Id: <1488358060-693-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, darrick.wong@oracle.com, david@fromorbit.com, Elena Reshetova <elena.reshetova@intel.com>

changes in v2:

 * removed two patches that actually caused problems in testing and 
 there didn't seem to be a resonable way to convert them to refcount_t 
 based on all the triggered issues.
 * run xfstests with TEST and SCRATCH partitions enabled, XFS_DEBUG on,
 and WARNs on refcount_t API on. No issues found in the log upon execution. 
 Some random test failures (based on different runs) and stress tests do not always
 pass, but again, no issues on refcounts noticed anywhere. 


Now when new refcount_t type and API are finally merged
(see include/linux/refcount.h), the following
patches convert various refcounters in the fs/xfs susystem from atomic_t
to refcount_t. By doing this we prevent intentional or accidental
underflows or overflows that can led to use-after-free vulnerabilities.

The below patches are fully independent and can be cherry-picked separately.
Since we convert all kernel subsystems in the same fashion, resulting
in about 300 patches, we have to group them for sending at least in some
fashion to be manageable. Please excuse the long cc list.

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

 fs/xfs/xfs_bmap_item.c     |  4 ++--
 fs/xfs/xfs_bmap_item.h     |  4 +++-
 fs/xfs/xfs_extfree_item.c  |  4 ++--
 fs/xfs/xfs_extfree_item.h  |  4 +++-
 fs/xfs/xfs_log.c           | 10 +++++-----
 fs/xfs/xfs_log_priv.h      |  4 +++-
 fs/xfs/xfs_refcount_item.c |  4 ++--
 fs/xfs/xfs_refcount_item.h |  4 +++-
 fs/xfs/xfs_rmap_item.c     |  4 ++--
 fs/xfs/xfs_rmap_item.h     |  4 +++-
 10 files changed, 28 insertions(+), 18 deletions(-)

-- 
2.7.4

