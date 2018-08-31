Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727326AbeHaTVY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 31 Aug 2018 15:21:24 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 92FA687A81
        for <linux-xfs@vger.kernel.org>; Fri, 31 Aug 2018 15:13:27 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 790972166B41
        for <linux-xfs@vger.kernel.org>; Fri, 31 Aug 2018 15:13:27 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 0/3] xfs: bli refcount fixups
Date: Fri, 31 Aug 2018 11:13:24 -0400
Message-Id: <20180831151327.41225-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

v4:
- Add a space to xfs_buf_item_unlock().
- Move xfs_buf_item_put() and add a comment.
v3: https://marc.info/?l=linux-xfs&m=153556359604256&w=2
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

 fs/xfs/xfs_buf_item.c  | 119 ++++++++++++++++++++++-------------------
 fs/xfs/xfs_buf_item.h  |   1 +
 fs/xfs/xfs_trace.h     |   1 -
 fs/xfs/xfs_trans_buf.c |  99 +++++++++-------------------------
 4 files changed, 89 insertions(+), 131 deletions(-)

-- 
2.17.1
