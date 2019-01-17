Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59894 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726993AbfAQTUF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Jan 2019 14:20:05 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 69A1B804F3
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jan 2019 19:20:05 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2022D600C6
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jan 2019 19:20:05 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/5] xfs: properly invalidate cached writeback mapping
Date: Thu, 17 Jan 2019 14:19:59 -0500
Message-Id: <20190117192004.49346-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's v2 of the cached writeback mapping invalidation series. Note that
this post is a bit premature as I'm still testing this code. Christoph
pointed out that he has some patches shifting code around in the same
area so I'm posting what I have under test at this point to hopefully
work out any potential conflicts.

The changes in v2 are basically to beef up the invalidation logic a bit
in xfs_map_blocks() via a new (old) xfs_imap_valid() helper and the
introduction of patch 5, which attempts to add similar mapping
validation in xfs_iomap_write_allocate() to replace the old truncate
detection logic.

Thoughts, reviews, flames appreciated.

Brian

fstest: https://marc.info/?l=fstests&m=154756141122233&w=2

v2:
- Refactor validation logic into xfs_imap_valid() helper.
- Revalidate seqno after the lock cycle in xfs_map_blocks().
- Update *seq in xfs_iomap_write_allocate() regardless of fork type.
- Add patch 5 for seqno revalidation on xfs_iomap_write_allocate() lock
  cycles.
v1: https://marc.info/?l=linux-xfs&m=154721212321112&w=2

Brian Foster (5):
  xfs: eof trim writeback mapping as soon as it is cached
  xfs: update fork seq counter on data fork changes
  xfs: validate writeback mapping using data fork seq counter
  xfs: remove superfluous writeback mapping eof trimming
  xfs: revalidate imap properly before writeback delalloc conversion

 fs/xfs/libxfs/xfs_bmap.c       |  11 ----
 fs/xfs/libxfs/xfs_bmap.h       |   1 -
 fs/xfs/libxfs/xfs_iext_tree.c  |  13 ++--
 fs/xfs/libxfs/xfs_inode_fork.h |   2 +-
 fs/xfs/xfs_aops.c              |  71 ++++++++++++++--------
 fs/xfs/xfs_iomap.c             | 105 ++++++++++++++-------------------
 6 files changed, 98 insertions(+), 105 deletions(-)

-- 
2.17.2
