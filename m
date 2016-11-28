Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58826 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752415AbcK1TJo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 28 Nov 2016 14:09:44 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 938067971C
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 19:09:43 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uASJ9hdY025624
        for <linux-xfs@vger.kernel.org>; Mon, 28 Nov 2016 14:09:43 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/6] xfs: basic cow fork speculative preallocation
Date: Mon, 28 Nov 2016 14:09:35 -0500
Message-Id: <1480360181-20396-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here is a first legitimate pass at COW fork speculative preallocation.
Updates from the previously posted rfc are noted below. Highlights are
inclusion of the COW fork fiemap patch, support for throttling
preallocation on low free space conditions and refactoring tweaks to
create a separate helper for the data fork -> COW fork lookup sequence.
Other changes are minor updates based on review of the rfc. Note that I
decided to retain patch 3 as an independent patch and hopefully explain
it a bit better. We can still squash it into the subsequent patch if
warranted, however.

The xfs_io patch to take advantage of COW fork fiemap is available here:

  http://www.spinics.net/lists/linux-xfs/msg01710.html

This survives xfstests with the exception of generic/305, which appears
to just be a case of hardcoded accounting in the golden output file
changing due to preallocation. I'll have to figure out the best way to
deal with that (a preceding eofb scan perhaps?). Thoughts, reviews,
flames appreciated.

Brian

v1:
- Rebase onto for-next (new iext lookup helpers).
- Split off speculative prealloc refactor patches into separate series.
- Prepend the COW fork fiemap patch.
- Create xfs_iomap_search_extents() helper for data/COW fork extent
  lookup.
- Reuse xfs_iomap_prealloc_size() to incorporate prealloc throttling.
- Added patch to reclaim cowblocks on write failure due to ENOSPC.
rfc: http://www.spinics.net/lists/linux-xfs/msg02152.html

Brian Foster (6):
  xfs: fiemap support for cow fork
  xfs: refactor iomap delalloc existing extent search into helper
  xfs: logically separate iomap range from allocation range
  xfs: reuse iomap delalloc code for COW fork reservation
  xfs: free cowblocks and retry on buffered write ENOSPC
  xfs: implement basic COW fork speculative preallocation

 fs/xfs/xfs_file.c           |   1 +
 fs/xfs/xfs_iomap.c          | 315 +++++++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_iomap.h          |   1 +
 fs/xfs/xfs_iops.c           |   4 +
 include/uapi/linux/fiemap.h |   1 +
 5 files changed, 244 insertions(+), 78 deletions(-)

-- 
2.7.4

