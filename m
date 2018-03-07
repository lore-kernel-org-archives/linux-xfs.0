Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36150 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933048AbeCGJFM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Mar 2018 04:05:12 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BDE3C4067734
        for <linux-xfs@vger.kernel.org>; Wed,  7 Mar 2018 09:05:11 +0000 (UTC)
Received: from odin.brq.redhat.com (unknown [10.43.17.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6281510B0F49
        for <linux-xfs@vger.kernel.org>; Wed,  7 Mar 2018 09:05:11 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/4 V2] Remove a few macros
Date: Wed,  7 Mar 2018 10:05:02 +0100
Message-Id: <20180307090506.30199-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

this is a second version of the patchset aimed to clean up some old macros from
xfsprogs, as the objective to bring xfs_buf handling code closer to kernel code.

It fixes some pointer castings Dave mentioned on the V1 patch, also, it removes
a few unneeded castings I spotted while reviewing the ones Dave mentioned.

Cheers

Carlos Maiolino (4):
  Get rid of XFS_BUF_PTR() macro
  Get rid of XFS_BUF_TARGET() macro
  get rid of XFS_BUF_COUNT() macro
  Get rid of XFS_BUF_SET_COUNT() macro

 libxfs/libxfs_io.h        |  6 +-----
 libxfs/logitem.c          |  2 +-
 libxfs/rdwr.c             | 10 +++++-----
 libxfs/trans.c            |  2 +-
 libxlog/xfs_log_recover.c |  2 +-
 logprint/log_print_all.c  |  4 ++--
 mkfs/proto.c              |  8 ++++----
 mkfs/xfs_mkfs.c           | 14 +++++++-------
 repair/agheader.c         |  8 ++++----
 repair/attr_repair.c      |  4 ++--
 repair/dino_chunks.c      |  2 +-
 repair/phase6.c           |  4 ++--
 repair/prefetch.c         |  4 ++--
 13 files changed, 33 insertions(+), 37 deletions(-)

-- 
2.14.3

