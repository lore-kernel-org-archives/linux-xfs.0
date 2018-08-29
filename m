Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:47020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727204AbeH2VYb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Aug 2018 17:24:31 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E98F587A70
        for <linux-xfs@vger.kernel.org>; Wed, 29 Aug 2018 17:26:34 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D2EFA2166B41
        for <linux-xfs@vger.kernel.org>; Wed, 29 Aug 2018 17:26:34 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/3] xfs: bli refcount fixups
Date: Wed, 29 Aug 2018 13:26:31 -0400
Message-Id: <20180829172634.57981-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's v3 of the bli refcount fix. This includes only minor changes from
v2, as noted below. Patch 1 is a bug fix and patches 2-3 are refactoring
patches.

Brian

v3:
- Rename xfs_buf_item_unref() to xfs_buf_item_put()
- Minor logic and comment fixups.
v2: https://marc.info/?l=linux-xfs&m=153537995111772&w=2
- Refactor stale bli unlock logic to more closely resemble original.
- Use bool for 'freed' variable and clean up type casting.
- Reorder asserts/tracepoints and remove unused stale tracepoint.
- Added patches 2 and 3.
v1: https://marc.info/?l=linux-xfs&m=153486008127962&w=2

Brian Foster (3):
  xfs: don't unlock invalidated buf on aborted tx commit
  xfs: clean up xfs_trans_brelse()
  xfs: refactor xfs_buf_log_item reference count handling

 fs/xfs/xfs_buf_item.c  | 113 +++++++++++++++++++++--------------------
 fs/xfs/xfs_buf_item.h  |   1 +
 fs/xfs/xfs_trace.h     |   1 -
 fs/xfs/xfs_trans_buf.c |  99 +++++++++---------------------------
 4 files changed, 82 insertions(+), 132 deletions(-)

-- 
2.17.1
