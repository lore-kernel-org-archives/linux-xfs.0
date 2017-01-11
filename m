Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58788 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1765035AbdAKRyS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Jan 2017 12:54:18 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1DEB643A42
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 17:54:11 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id v0BHsADH014896
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 12:54:10 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/5] xfs: basic cow fork speculative preallocation
Date: Wed, 11 Jan 2017 12:54:04 -0500
Message-Id: <1484157249-464-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's v2 of the cow fork speculative prealloc patches. No major changes
here, as outlined below. Thoughts on any of this?

Brian

v2:
- Rebased to latest for-next.
- Dropped fiemap COW fork patch.
- Added Reviewed-by tags from previous series.
v1: http://www.spinics.net/lists/linux-xfs/msg02466.html
- Rebase onto for-next (new iext lookup helpers).
- Split off speculative prealloc refactor patches into separate series.
- Prepend the COW fork fiemap patch.
- Create xfs_iomap_search_extents() helper for data/COW fork extent
  lookup.
- Reuse xfs_iomap_prealloc_size() to incorporate prealloc throttling.
- Added patch to reclaim cowblocks on write failure due to ENOSPC.
rfc: http://www.spinics.net/lists/linux-xfs/msg02152.html

Brian Foster (5):
  xfs: refactor iomap delalloc existing extent search into helper
  xfs: logically separate iomap range from allocation range
  xfs: reuse iomap delalloc code for COW fork reservation
  xfs: free cowblocks and retry on buffered write ENOSPC
  xfs: implement basic COW fork speculative preallocation

 fs/xfs/xfs_file.c  |   1 +
 fs/xfs/xfs_iomap.c | 270 +++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 193 insertions(+), 78 deletions(-)

-- 
2.7.4

