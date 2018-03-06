Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33344 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750947AbeCFNA6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Mar 2018 08:00:58 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EB27C84222
        for <linux-xfs@vger.kernel.org>; Tue,  6 Mar 2018 13:00:57 +0000 (UTC)
Received: from odin.brq.redhat.com (unknown [10.43.17.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 909D610B0F32
        for <linux-xfs@vger.kernel.org>; Tue,  6 Mar 2018 13:00:57 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/4] Remove a few macros
Date: Tue,  6 Mar 2018 14:00:49 +0100
Message-Id: <20180306130053.13958-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

For a while, these macros have been removed from kernel, removing them from
xfsprogs brings the code closer to kernel code, and is a first step on such
process.

I tried to get rid of such macros as more segmented as possible (1 macro per
patch), although, last to patches are good candidates to be merged together, but
I believe it's just cleaner to have them as separated patches

Carlos Maiolino (4):
  Get rid of XFS_BUF_PTR() macro
  Get rid of XFS_BUF_TARGET() macro
  get rid of XFS_BUF_COUNT() macro
  Get rid of XFS_BUF_SET_COUNT() macro

 libxfs/libxfs_io.h        |  6 +-----
 libxfs/logitem.c          |  2 +-
 libxfs/rdwr.c             |  6 +++---
 libxfs/trans.c            |  2 +-
 libxlog/xfs_log_recover.c |  2 +-
 logprint/log_print_all.c  |  4 ++--
 mkfs/proto.c              |  8 ++++----
 mkfs/xfs_mkfs.c           | 14 +++++++-------
 repair/agheader.c         |  6 +++---
 repair/attr_repair.c      |  4 ++--
 repair/dino_chunks.c      |  2 +-
 repair/phase6.c           |  4 ++--
 repair/prefetch.c         |  4 ++--
 13 files changed, 30 insertions(+), 34 deletions(-)

-- 
2.14.3

