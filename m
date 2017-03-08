Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18420 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751867AbdCHJB5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 8 Mar 2017 04:01:57 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 0/5] fs, xfs refcount conversions
Date: Wed,  8 Mar 2017 10:53:34 +0200
Message-Id: <1488963219-11709-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, Elena Reshetova <elena.reshetova@intel.com>

v3:
 * fixed header file inclusion

Now when new refcount_t type and API are finally merged
(see include/linux/refcount.h), the following
patches convert various refcounters in the xfs susystem from atomic_t
to refcount_t. By doing this we prevent intentional or accidental
underflows or overflows that can led to use-after-free vulnerabilities.


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
 fs/xfs/xfs_bmap_item.h     |  2 +-
 fs/xfs/xfs_extfree_item.c  |  4 ++--
 fs/xfs/xfs_extfree_item.h  |  2 +-
 fs/xfs/xfs_linux.h         |  1 +
 fs/xfs/xfs_log.c           | 10 +++++-----
 fs/xfs/xfs_log_priv.h      |  2 +-
 fs/xfs/xfs_refcount_item.c |  4 ++--
 fs/xfs/xfs_refcount_item.h |  2 +-
 fs/xfs/xfs_rmap_item.c     |  4 ++--
 fs/xfs/xfs_rmap_item.h     |  2 +-
 11 files changed, 19 insertions(+), 18 deletions(-)

-- 
2.7.4

