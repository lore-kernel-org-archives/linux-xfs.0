Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06033C43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 06:08:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbiF0GIs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jun 2022 02:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiF0GIr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jun 2022 02:08:47 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C12B26EB
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 23:08:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8102810E78A9
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jun 2022 16:08:45 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5hvQ-00BZVv-1K
        for linux-xfs@vger.kernel.org; Mon, 27 Jun 2022 16:08:44 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o5hvP-0011gH-Uy
        for linux-xfs@vger.kernel.org;
        Mon, 27 Jun 2022 16:08:43 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/6 v2] xfs: lockless buffer lookups
Date:   Mon, 27 Jun 2022 16:08:35 +1000
Message-Id: <20220627060841.244226-1-david@fromorbit.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62b9496d
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=LgRU8_fZ-viWaw5eXjYA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Current work to merge the XFS inode life cycle with the VFS indoe
life cycle is finding some interesting issues. If we have a path
that hits buffer trylocks fairly hard (e.g. a non-blocking
background inode freeing function), we end up hitting massive
contention on the buffer cache hash locks:

-   92.71%     0.05%  [kernel]                  [k] xfs_inodegc_worker
   - 92.67% xfs_inodegc_worker
      - 92.13% xfs_inode_unlink
         - 91.52% xfs_inactive_ifree
            - 85.63% xfs_read_agi
               - 85.61% xfs_trans_read_buf_map
                  - 85.59% xfs_buf_read_map
                     - xfs_buf_get_map
                        - 85.55% xfs_buf_find
                           - 72.87% _raw_spin_lock
                              - do_raw_spin_lock
                                   71.86% __pv_queued_spin_lock_slowpath
                           - 8.74% xfs_buf_rele
                              - 7.88% _raw_spin_lock
                                 - 7.88% do_raw_spin_lock
                                      7.63% __pv_queued_spin_lock_slowpath
                           - 1.70% xfs_buf_trylock
                              - 1.68% down_trylock
                                 - 1.41% _raw_spin_lock_irqsave
                                    - 1.39% do_raw_spin_lock
                                         __pv_queued_spin_lock_slowpath
                           - 0.76% _raw_spin_unlock
                                0.75% do_raw_spin_unlock

This is basically hammering the pag->pag_buf_lock from lots of CPUs
doing trylocks at the same time. Most of the buffer trylock
operations ultimately fail after we've done the lookup, so we're
really hammering the buf hash lock whilst making no progress.

We can also see significant spinlock traffic on the same lock just
under normal operation when lots of tasks are accessing metadata
from the same AG, so let's avoid all this by creating a lookup fast
path which leverages the rhashtable's ability to do rcu protected
lookups.

This is a rework of the initial lockless buffer lookup patch I sent
here:

https://lore.kernel.org/linux-xfs/20220328213810.1174688-1-david@fromorbit.com/

And the alternative cleanup sent by Christoph here:

https://lore.kernel.org/linux-xfs/20220403120119.235457-1-hch@lst.de/

This version isn't quite a short as Christophs, but it does roughly
the same thing in killing the two-phase _xfs_buf_find() call
mechanism. It separates the fast and slow paths a little more
cleanly and doesn't have context dependent buffer return state from
the slow path that the caller needs to handle. It also picks up the
rhashtable insert optimisation that Christoph added.

This series passes fstests under several different configs and does
not cause any obvious regressions in scalability testing that has
been performed. Hence I'm proposing this as potential 5.20 cycle
material.

Thoughts, comments?

Version 2:
- based on 5.19-rc2
- high speed collision of original proposals.

Initial versions:
- https://lore.kernel.org/linux-xfs/20220403120119.235457-1-hch@lst.de/
- https://lore.kernel.org/linux-xfs/20220328213810.1174688-1-david@fromorbit.com/


