Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39812 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726953AbeH0SMk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Aug 2018 14:12:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C220F40216E9
        for <linux-xfs@vger.kernel.org>; Mon, 27 Aug 2018 14:25:48 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAE16101325E
        for <linux-xfs@vger.kernel.org>; Mon, 27 Aug 2018 14:25:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/3] xfs: bli refcount fixups
Date: Mon, 27 Aug 2018 10:25:45 -0400
Message-Id: <20180827142548.45029-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is a v2 of the stale buffer locking fix for an aborted transaction.
It has minor refactoring changes noted below. I've added two optional
patches on top because I wanted to take a stab at a bit more cleanup in
this area, but these are aesthetic changes only and can be dropped if
desired.

Patch 1 is the original bug fix. Patch 2 cleans up xfs_trans_brelse() to
remove some cruft and use similar logic/flow as xfs_buf_item_unlock().
Patch 3 refactors the bli refcount cleanup logic that is common between
the two functions. There is still open-coded bli refcount handling on
unpin because there are additional considerations in that path. Stale
inode buffer handling has special handling, for whatever reason. The
stale inode buf handling actually looks quite similar to the
non-specialized buffer handling, but further cleanup in that area would
require a more in-depth audit to be sure.

I find the end result a bit cleaner but I'm not wedded to it and I'm
fine with just dropping patches 2-3 if the current approach is
preferred. FWIW, this also raised a couple thoughts on alternative
approaches, such as reworking the bli refcount such that the AIL also
holds a reference, but it's not totally clear that (by itself)
simplifies things in the case of a shutdown with AIL-held blis.

Thoughts, reviews, flames appreciated.

Brian

v2:
- Refactor stale bli unlock logic to more closely resemble original.
- Use bool for 'freed' variable and clean up type casting.
- Reorder asserts/tracepoints and remove unused stale tracepoint.
- Added patches 2 and 3.
v1: https://marc.info/?l=linux-xfs&m=153486008127962&w=2

Brian Foster (3):
  xfs: don't unlock invalidated buf on aborted tx commit
  xfs: clean up xfs_trans_brelse()
  xfs: refactor xfs_buf_log_item reference count handling

 fs/xfs/xfs_buf_item.c  | 115 +++++++++++++++++++++--------------------
 fs/xfs/xfs_buf_item.h  |   1 +
 fs/xfs/xfs_trace.h     |   1 -
 fs/xfs/xfs_trans_buf.c |  98 +++++++++--------------------------
 4 files changed, 84 insertions(+), 131 deletions(-)

-- 
2.17.1
