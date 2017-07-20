Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751903AbdGTNPO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 09:15:14 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C80467CB8D
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 13:15:13 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (ovpn-204-190.brq.redhat.com [10.40.204.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 373FD7C1C6
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 13:15:13 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2 V6] Resubmit items failed during writeback
Date: Thu, 20 Jul 2017 15:15:06 +0200
Message-Id: <20170720131508.13582-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

V6 of this patchset,

differences from the previous version are mostly cosmetic, details on each patch
header.

Cheers

Carlos Maiolino (2):
  xfs: Add infrastructure needed for error propagation during buffer IO
    failure
  xfs: Properly retry failed inode items in case of error during buffer
    writeback

 fs/xfs/xfs_buf_item.c   | 60 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_buf_item.h   |  3 +++
 fs/xfs/xfs_inode_item.c | 49 ++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_trans.h      |  8 +++++--
 fs/xfs/xfs_trans_ail.c  |  3 ++-
 fs/xfs/xfs_trans_priv.h | 31 +++++++++++++++++++++++++
 6 files changed, 146 insertions(+), 8 deletions(-)

-- 
2.9.4

