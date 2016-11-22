Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49250 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932577AbcKVNBW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 22 Nov 2016 08:01:22 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 19374C0528A0
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2016 13:01:22 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uAMD13lC025931
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2016 08:01:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/3] clean up speculative preallocation tracking and tagging
Date: Tue, 22 Nov 2016 08:00:59 -0500
Message-Id: <1479819662-64416-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

These are a few patches that resulted from the following discussion with
regard to how to tag reflink inodes correctly for COW fork
preallocation:

  http://www.spinics.net/lists/linux-xfs/msg02155.html

The problem with the current code is that xfs_reflink_reserve_cow()
doesn't consider preallocation due to start offset alignment. The
problem with the first pass patch above is that the same function
doesn't distinguish between extent preallocation and extent merge.

The solution in this series pushes down the incorporation of
preallocation to the bmapi call, where it already has the additional
context to identify whether an extent allocation was widened due to
cowextszhint alignment. The callers are still responsible for defining
how much to preallocate, to throttle, retry if necessary, etc.

Note that this series is based on top of Christoph's recent extent
lookup cleanup patches. This survives xfstests for me on a reflink=1 fs.
Thoughts, reviews, flames appreciated.

Brian

Brian Foster (3):
  xfs: track preallocation separately in xfs_bmapi_reserve_delalloc()
  xfs: clean up cow fork reservation and tag inodes correctly
  xfs: pass post-eof speculative prealloc blocks to bmapi

 fs/xfs/libxfs/xfs_bmap.c | 23 +++++++++++++++++++++--
 fs/xfs/libxfs/xfs_bmap.h |  2 +-
 fs/xfs/xfs_iomap.c       | 33 +++++++++++++--------------------
 fs/xfs/xfs_reflink.c     | 29 +++--------------------------
 4 files changed, 38 insertions(+), 49 deletions(-)

-- 
2.7.4

