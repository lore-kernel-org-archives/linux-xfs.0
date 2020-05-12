Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F20C54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 10:25:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C826207FF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 10:25:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgELKZu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 06:25:50 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:51484 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbgELKZt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 06:25:49 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 7FF371A8244
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 20:25:45 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYS6X-0004aD-RH
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 20:25:41 +1000
Date:   Tue, 12 May 2020 20:25:41 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/5 v2] xfs: fix a couple of performance issues
Message-ID: <20200512102541.GS2040@dread.disaster.area>
References: <20200512092811.1846252-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512092811.1846252-1-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=7-415B0cAAAA:8
        a=GqT1H4M-jUBrNjz5QGQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 07:28:06PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> To follow up on the interesting performance gain I found, there's
> three RFC patches that follow up the two I posted earlier. These get
> rid of the CIL xc_cil_lock entirely by moving the entire CIL list
> and accounting to percpu structures.
> 
> The result is that I'm topping out at about 1.12M transactions/s
> and bottlenecking on VFS spinlocks in the dentry cache path walk
> code and the superblock inode list lock. The XFS CIL commit path
> mostly disappears from the profiles when creating about 600,000
> inodes/s:
> 
> 
> -   73.42%     0.12%  [kernel]               [k] path_openat
>    - 11.29% path_openat
>       - 7.12% xfs_vn_create
>          - 7.18% xfs_vn_mknod
>             - 7.30% xfs_generic_create
>                - 6.73% xfs_create
>                   - 2.69% xfs_dir_ialloc
>                      - 2.98% xfs_ialloc
>                         - 1.26% xfs_dialloc
>                            - 1.04% xfs_dialloc_ag
>                         - 1.02% xfs_setup_inode
>                            - 0.90% inode_sb_list_add
> >>>>>                         - 1.09% _raw_spin_lock
>                                  - 4.47% do_raw_spin_lock
>                                       4.05% __pv_queued_spin_lock_slowpath
>                         - 0.75% xfs_iget
>                   - 2.43% xfs_trans_commit
>                      - 3.47% __xfs_trans_commit
>                         - 7.47% xfs_log_commit_cil
>                              1.60% memcpy_erms
>                            - 1.35% xfs_buf_item_size
>                                 0.99% xfs_buf_item_size_segment.isra.0
>                              1.30% xfs_buf_item_format
>                   - 1.44% xfs_dir_createname
>                      - 1.60% xfs_dir2_node_addname
>                         - 1.08% xfs_dir2_leafn_add
>                              0.79% xfs_dir3_leaf_check_int
>       - 1.09% terminate_walk
>          - 1.09% dput
> >>>>>>      - 1.42% _raw_spin_lock
>                - 7.75% do_raw_spin_lock
>                     7.19% __pv_queued_spin_lock_slowpath
>       - 0.99% xfs_vn_lookup
>          - 0.96% xfs_lookup
>             - 1.01% xfs_dir_lookup
>                - 1.24% xfs_dir2_node_lookup
>                   - 1.09% xfs_da3_node_lookup_int
>       - 0.90% unlazy_walk
>          - 0.87% legitimize_root
>             - 0.94% __legitimize_path.isra.0
>                - 0.91% lockref_get_not_dead
> >>>>>>>           - 1.28% _raw_spin_lock
>                      - 6.85% do_raw_spin_lock
>                           6.29% __pv_queued_spin_lock_slowpath
>       - 0.82% d_lookup
>            __d_lookup
> .....
> +   39.21%     6.76%  [kernel]               [k] do_raw_spin_lock
> +   35.07%     0.16%  [kernel]               [k] _raw_spin_lock
> +   32.35%    32.13%  [kernel]               [k] __pv_queued_spin_lock_slowpath
> 
> So we're going 3-4x faster on this machine than without these
> patches, yet we're still burning about 40% of the CPU consumed by
> the workload on spinlocks.  IOWs, the XFS code is running 3-4x
> faster consuming half the CPU, and we're bashing on other locks
> now...

Just as a small followup, I started this with my usual 16-way
create/unlink workload which ran at about 245k creates/s and unlinks
at about 150k/s.

With this patch set, I just ran 492k creates/s (1m54s) and 420k
unlinks/s from just 16 threads (2m18s). IOWs, I didn't need to go to
32 threads to see the perf improvement - as the above profiles
indicate, those extra 16 threads are effectively just creating heat
spinning on VFS locks...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
