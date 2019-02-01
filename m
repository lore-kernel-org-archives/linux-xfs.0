Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726172AbfBAOc5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 1 Feb 2019 09:32:57 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF8D9C0528B9
        for <linux-xfs@vger.kernel.org>; Fri,  1 Feb 2019 14:32:56 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92B235D9D1
        for <linux-xfs@vger.kernel.org>; Fri,  1 Feb 2019 14:32:56 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v4 0/6] xfs: properly invalidate cached writeback mapping
Date: Fri,  1 Feb 2019 09:32:50 -0500
Message-Id: <20190201143256.43232-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is a minor update of this series to fold in some changes from
Christoph's follow on series to rework the delalloc conversion code. The
changes apply to patches 5 and 6 and rename/rework the delalloc helper.
The subsequent series will fill in a real implementation for the wrapper
and further clean up the writeback code.

Brian

v4:
- Fold in Christoph's interface changes from the delalloc conversion
  rework series (patches 5-6).
v3: https://marc.info/?l=linux-xfs&m=154826889919747&w=2
- Move comment in xfs_imap_valid().
- Replace lookup+trim in xfs_iomap_write_allocate() with
  xfs_bmapi_delalloc() wrapper mechanism.
v2: https://marc.info/?l=linux-xfs&m=154775280823464&w=2
- Refactor validation logic into xfs_imap_valid() helper.
- Revalidate seqno after the lock cycle in xfs_map_blocks().
- Update *seq in xfs_iomap_write_allocate() regardless of fork type.
- Add patch 5 for seqno revalidation on xfs_iomap_write_allocate() lock
  cycles.
v1: https://marc.info/?l=linux-xfs&m=154721212321112&w=2

Brian Foster (6):
  xfs: eof trim writeback mapping as soon as it is cached
  xfs: update fork seq counter on data fork changes
  xfs: validate writeback mapping using data fork seq counter
  xfs: remove superfluous writeback mapping eof trimming
  xfs: create delalloc bmapi wrapper for full extent allocation
  xfs: use the latest extent at writeback delalloc conversion time

 fs/xfs/libxfs/xfs_bmap.c       |  68 ++++++++++---
 fs/xfs/libxfs/xfs_bmap.h       |   3 +-
 fs/xfs/libxfs/xfs_iext_tree.c  |  13 ++-
 fs/xfs/libxfs/xfs_inode_fork.h |   2 +-
 fs/xfs/xfs_aops.c              |  71 +++++++++-----
 fs/xfs/xfs_iomap.c             | 171 +++++++++++----------------------
 6 files changed, 165 insertions(+), 163 deletions(-)

-- 
2.17.2
