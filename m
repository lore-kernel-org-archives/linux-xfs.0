Return-Path: <cmaiolino@redhat.com>
Resent-Message-ID: <20170227144956.yk7bdleheydnkb4a@eorzea.usersys.redhat.com>
Resent-To: sandeen@sandeen.net
Received: from mga02.intel.com ([134.134.136.20]:56060 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbdBUPtM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 21 Feb 2017 10:49:12 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 0/7] fs, xfs subsystem refcounter conversions
Date: Tue, 21 Feb 2017 17:49:00 +0200
Message-Id: <1487692147-17066-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, darrick.wong@oracle.com, Elena Reshetova <elena.reshetova@intel.com>

Now when new refcount_t type and API are finally merged
(see include/linux/refcount.h), the following
patches convert various refcounters in the fs/xfs susystem from atomic_t
to refcount_t. By doing this we prevent intentional or accidental
underflows or overflows that can led to use-after-free vulnerabilities.

The below patches are fully independent and can be cherry-picked separately.
Since we convert all kernel subsystems in the same fashion, resulting
in about 300 patches, we have to group them for sending at least in some
fashion to be manageable. Please excuse the long cc list.

Elena Reshetova (7):
  fs, xfs: convert xfs_bui_log_item.bui_refcount from atomic_t to
    refcount_t
  fs, xfs: convert xfs_buf.b_hold and xfs_buf.b_lru_ref from atomic_t to
    refcount_t
  fs, xfs: convert xfs_buf_log_item.bli_refcount from atomic_t to
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
 fs/xfs/xfs_buf.c           | 35 ++++++++++++++++++-----------------
 fs/xfs/xfs_buf.h           |  7 ++++---
 fs/xfs/xfs_buf_item.c      | 16 ++++++++--------
 fs/xfs/xfs_buf_item.h      |  4 +++-
 fs/xfs/xfs_extfree_item.c  |  4 ++--
 fs/xfs/xfs_extfree_item.h  |  4 +++-
 fs/xfs/xfs_log.c           | 10 +++++-----
 fs/xfs/xfs_log_priv.h      |  4 +++-
 fs/xfs/xfs_refcount_item.c |  4 ++--
 fs/xfs/xfs_refcount_item.h |  4 +++-
 fs/xfs/xfs_rmap_item.c     |  4 ++--
 fs/xfs/xfs_rmap_item.h     |  4 +++-
 fs/xfs/xfs_trace.h         | 10 +++++-----
 fs/xfs/xfs_trans_buf.c     | 32 ++++++++++++++++----------------
 16 files changed, 82 insertions(+), 68 deletions(-)

-- 
2.7.4

