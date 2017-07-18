Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbdGROyV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 18 Jul 2017 10:54:21 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C1672C058EAF
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 14:54:20 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (ovpn-204-54.brq.redhat.com [10.40.204.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 34AB67E594
        for <linux-xfs@vger.kernel.org>; Tue, 18 Jul 2017 14:54:20 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2 V5] Resubmit items failed during writeback
Date: Tue, 18 Jul 2017 16:54:13 +0200
Message-Id: <20170718145415.21230-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

this is the V5 review of the fix for buffer resubmission.

Changes related are described on each patch.

The xfstests to test this problem is already in fstests list, and this patchset
passes the test cleanly.

Cheers 

Carlos Maiolino (2):
  xfs: Add infrastructure needed for error propagation during buffer IO
    failure
  xfs: Properly retry failed inode items in case of error during buffer
    writeback

 fs/xfs/xfs_buf_item.c   | 58 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_buf_item.h   |  3 +++
 fs/xfs/xfs_inode_item.c | 45 ++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_trans.h      |  8 +++++--
 fs/xfs/xfs_trans_ail.c  |  4 ++--
 fs/xfs/xfs_trans_priv.h | 31 ++++++++++++++++++++++++++
 6 files changed, 140 insertions(+), 9 deletions(-)

-- 
2.9.4

