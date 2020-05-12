Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34829C54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B8222075E
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgELJ2S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 05:28:18 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:54785 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729118AbgELJ2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 05:28:18 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 62877D58691
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 19:28:15 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYRCw-0004Gz-6H
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 19:28:14 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jYRCv-007kYJ-Th
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 19:28:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5 v2] xfs: fix a couple of performance issues
Date:   Tue, 12 May 2020 19:28:06 +1000
Message-Id: <20200512092811.1846252-1-david@fromorbit.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=rV_h42ltliYjVAf9fFsA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

To follow up on the interesting performance gain I found, there's
three RFC patches that follow up the two I posted earlier. These get
rid of the CIL xc_cil_lock entirely by moving the entire CIL list
and accounting to percpu structures.

The result is that I'm topping out at about 1.12M transactions/s
and bottlenecking on VFS spinlocks in the dentry cache path walk
code and the superblock inode list lock. The XFS CIL commit path
mostly disappears from the profiles when creating about 600,000
inodes/s:


-   73.42%     0.12%  [kernel]               [k] path_openat
   - 11.29% path_openat
      - 7.12% xfs_vn_create
         - 7.18% xfs_vn_mknod
            - 7.30% xfs_generic_create
               - 6.73% xfs_create
                  - 2.69% xfs_dir_ialloc
                     - 2.98% xfs_ialloc
                        - 1.26% xfs_dialloc
                           - 1.04% xfs_dialloc_ag
                        - 1.02% xfs_setup_inode
                           - 0.90% inode_sb_list_add
>>>>>                         - 1.09% _raw_spin_lock
                                 - 4.47% do_raw_spin_lock
                                      4.05% __pv_queued_spin_lock_slowpath
                        - 0.75% xfs_iget
                  - 2.43% xfs_trans_commit
                     - 3.47% __xfs_trans_commit
                        - 7.47% xfs_log_commit_cil
                             1.60% memcpy_erms
                           - 1.35% xfs_buf_item_size
                                0.99% xfs_buf_item_size_segment.isra.0
                             1.30% xfs_buf_item_format
                  - 1.44% xfs_dir_createname
                     - 1.60% xfs_dir2_node_addname
                        - 1.08% xfs_dir2_leafn_add
                             0.79% xfs_dir3_leaf_check_int
      - 1.09% terminate_walk
         - 1.09% dput
>>>>>>      - 1.42% _raw_spin_lock
               - 7.75% do_raw_spin_lock
                    7.19% __pv_queued_spin_lock_slowpath
      - 0.99% xfs_vn_lookup
         - 0.96% xfs_lookup
            - 1.01% xfs_dir_lookup
               - 1.24% xfs_dir2_node_lookup
                  - 1.09% xfs_da3_node_lookup_int
      - 0.90% unlazy_walk
         - 0.87% legitimize_root
            - 0.94% __legitimize_path.isra.0
               - 0.91% lockref_get_not_dead
>>>>>>>           - 1.28% _raw_spin_lock
                     - 6.85% do_raw_spin_lock
                          6.29% __pv_queued_spin_lock_slowpath
      - 0.82% d_lookup
           __d_lookup
.....
+   39.21%     6.76%  [kernel]               [k] do_raw_spin_lock
+   35.07%     0.16%  [kernel]               [k] _raw_spin_lock
+   32.35%    32.13%  [kernel]               [k] __pv_queued_spin_lock_slowpath

So we're going 3-4x faster on this machine than without these
patches, yet we're still burning about 40% of the CPU consumed by
the workload on spinlocks.  IOWs, the XFS code is running 3-4x
faster consuming half the CPU, and we're bashing on other locks
now...

There's still more work to do to make these patches production
ready, but I figured people might want to comment on how much it
hurts their brain and whether there might be better ways to
aggregrate all this percpu functionality into a neater package...

Cheers,

Dave.


