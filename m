Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:31716 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752280AbdK2LiM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Nov 2017 06:38:12 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH 0/5] v2 xfs refcount conversions
Date: Wed, 29 Nov 2017 13:37:58 +0200
Message-Id: <1511955483-18275-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com
Cc: darrick.wong@oracle.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, peterz@infradead.org, keescook@chromium.org, Elena Reshetova <elena.reshetova@intel.com>

Hi Dave,

Following our previous conversation I have updated each
patch with a highlight of potential problematic places
with regards to the memory ordering guarantees, as well
as link to the document I am working on to clarify the
matter.

While I didn't see any issues with these 5 particular
conversions, of course I don't understand code anywhere
good enough to make the final claim that "everything is
100% ok".

Please let me know what kind of other clarification or
anything is needed that can help you to make the needed
verification.

Best Regards,
Elena.



Changes in v2:
  - each patch now has a clarification on potential
    problematic places with regards to the memory ordering
    guarantees as well as reference to a hopefully soon to be
    merged more extensive documentation on the
    differences between atomic_t and refcount_t on ordering.
  - Rebase on linux-next master.


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

