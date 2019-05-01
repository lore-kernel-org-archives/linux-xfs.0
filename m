Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbfEAOFF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 May 2019 10:05:05 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0EC3630ADBCC
        for <linux-xfs@vger.kernel.org>; Wed,  1 May 2019 14:05:05 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF38517502
        for <linux-xfs@vger.kernel.org>; Wed,  1 May 2019 14:05:04 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs: rely on minleft instead of total for bmbt res
Date: Wed,  1 May 2019 10:05:02 -0400
Message-Id: <20190501140504.16435-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is a follow up to the RFC[1] I posted the other day. After poking
around some more, I noticed that the bmapi allocation code already set
args.minleft based on the state of the associated fork. Based on the
reasoning in the commit logs, it seems that a bunch of the 'args.total =
extent length + bmbt res' bmapi allocation callers were superfluous and
could just rely on the existing minleft logic.

Note that this doesn't address the other users of args.total (inode,
dquot, xattr, etc.). It remains to be seen whether there is still value
in having something like args.extra instead of args.total. For one,
passing zero is somewhat of a landmine if transaction block reservations
happen to change. It would be nice to clean this all up so the
additional reservation portion of the mapping request is explicit and
robust, particularly for callers where minlen < maxlen. As it is, it's
still kind of pointless to specify minlen < maxlen and total >= maxlen
because if we can't satisfy maxlen, the total check in
xfs_alloc_space_available() will never pass until xfs_bmap_btalloc()
reduces args.total, and it's set to minlen essentially ignoring what the
caller set it to originally. That might not matter so much in cases
where the allocation is a strict minlen == maxlen request and we're
going to simply pass or fail.

In summary, this whole mechanism is still quite hairy and could probably
use further improvements. For that reason, careful review of patch 2 is
probably in order. So far, this has survived a full fstests auto run
with default geometry and an enospc group run with an agsize=20MB
geometry (~750+ AGs). I'm currently (sllloowlly) repeating the auto
group run with the latter format and perhaps will follow that up with an
fsstress cycle that slams the fs into -ENOSPC for a longish period of
time (hours/days).

Thoughts, reviews, flames appreciated. 

Brian

[1] https://marc.info/?l=linux-xfs&m=155628702230215&w=2

Brian Foster (2):
  xfs: drop minlen before tossing alignment on bmap allocs
  xfs: don't set bmapi total block req where minleft is sufficient

 fs/xfs/libxfs/xfs_bmap.c | 13 +++++++++----
 fs/xfs/xfs_bmap_util.c   |  4 ++--
 fs/xfs/xfs_dquot.c       |  4 ++--
 fs/xfs/xfs_iomap.c       |  4 ++--
 fs/xfs/xfs_reflink.c     |  4 ++--
 fs/xfs/xfs_rtalloc.c     |  3 +--
 6 files changed, 18 insertions(+), 14 deletions(-)

-- 
2.17.2
