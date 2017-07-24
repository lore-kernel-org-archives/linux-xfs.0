Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41458 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754830AbdGXNeg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 24 Jul 2017 09:34:36 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B2FE67F418
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2017 13:34:36 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (unknown [10.43.17.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3607C91E99
        for <linux-xfs@vger.kernel.org>; Mon, 24 Jul 2017 13:34:36 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2 V7] Resubmit items failed during writeback
Date: Mon, 24 Jul 2017 15:34:29 +0200
Message-Id: <20170724133431.11479-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

V7 version of this patchset,

just removed an 'unused variable' warning from an ASSERT in xfs_inode_item_error
in patch 2/2

no changes in patch 1/2

keeping Brian's reviewed-by on both patches

cheers

Carlos Maiolino (2):
  xfs: Add infrastructure needed for error propagation during buffer IO
    failure
  xfs: Properly retry failed inode items in case of error during buffer
    writeback

 fs/xfs/xfs_buf_item.c   | 60 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_buf_item.h   |  3 +++
 fs/xfs/xfs_inode_item.c | 47 ++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_trans.h      |  8 +++++--
 fs/xfs/xfs_trans_ail.c  |  3 ++-
 fs/xfs/xfs_trans_priv.h | 31 +++++++++++++++++++++++++
 6 files changed, 144 insertions(+), 8 deletions(-)

-- 
2.9.4

