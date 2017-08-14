Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35092 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbdHNQyx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 14 Aug 2017 12:54:53 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D093C1643B5
        for <linux-xfs@vger.kernel.org>; Mon, 14 Aug 2017 16:54:52 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0A695D964
        for <linux-xfs@vger.kernel.org>; Mon, 14 Aug 2017 16:54:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 0/2] xfs: refactor ordered buffer logging code
Date: Mon, 14 Aug 2017 12:54:49 -0400
Message-Id: <20170814165451.43788-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's an initial refactoring based on the discussion on Alex's empty
xattr leaf buffer holding patch [1]. These patches split off some of
xfs_trans_log_buf() into a new helper and update xfs_trans_ordered_buf()
to use it and thus eliminate the need to log dirty ranges on ordered
buffers. The secondary purpose here is to create a function that we can
call from deferred ops processing to relog an already dirty/held buffer
across transaction rolls.

Note that this has only been very lightly tested and I might have one or
two more cleanups to tack on. Thoughts, reviews, flames appreciated...

Brian

[1] http://marc.info/?l=linux-xfs&m=150227679029089&w=2

Brian Foster (2):
  xfs: refactor buffer logging into buffer dirtying helper
  xfs: don't log dirty ranges for ordered buffers

 fs/xfs/libxfs/xfs_btree.c  |  3 +-
 fs/xfs/libxfs/xfs_ialloc.c |  2 --
 fs/xfs/xfs_trans.h         |  4 ++-
 fs/xfs/xfs_trans_buf.c     | 71 ++++++++++++++++++++++++++++------------------
 4 files changed, 48 insertions(+), 32 deletions(-)

-- 
2.9.4

