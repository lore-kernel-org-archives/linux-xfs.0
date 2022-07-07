Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32860C433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 02:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiGGCkL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Jul 2022 22:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiGGCkK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Jul 2022 22:40:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8472F3A7
        for <linux-xfs@vger.kernel.org>; Wed,  6 Jul 2022 19:40:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A866620CE
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 02:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D06DC3411C;
        Thu,  7 Jul 2022 02:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657161607;
        bh=4Lu63VFCCkXzxl8Uqa5sfz2UHrse6FkT+X6hO8OqSxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SAYSfH06ztjw31U3j9IhXSdjxct11lV8W+A1q0E+Z/Rr42Hc3+3pxAa1QbkcGRghy
         5MTv1WM3wHqSIK21ZfZ1o+5y+Uojw6sK8588aSIATCWDnKC9qQsQ4/UoMdTUtSsGCv
         Cig5wlJFnVSdmcJRObZNUyJi4/Mhd23HPrHJ0gqSDCsFrAt2hguPpKGvFhD9zdNbXZ
         CV8Ki0e8DqHuNtUhDH3LOWqSCpPE4kQ7Qi3nh/S+Bu9ka8IdBziGU8fFJmpEEmT3x7
         G68rJwv1A0hE674NE3Fgw+kf9TLYsczC43akEHcnH+rhaa3XvNtRaWGIEWkHoiyv04
         +bKhvGY7VWgNg==
Date:   Wed, 6 Jul 2022 19:40:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] xfs: lockless buffer lookups
Message-ID: <YsZHh2ZkopJFmaKx@magnolia>
References: <20220627060841.244226-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627060841.244226-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 04:08:35PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> Current work to merge the XFS inode life cycle with the VFS indoe
> life cycle is finding some interesting issues. If we have a path
> that hits buffer trylocks fairly hard (e.g. a non-blocking
> background inode freeing function), we end up hitting massive
> contention on the buffer cache hash locks:
> 
> -   92.71%     0.05%  [kernel]                  [k] xfs_inodegc_worker
>    - 92.67% xfs_inodegc_worker
>       - 92.13% xfs_inode_unlink
>          - 91.52% xfs_inactive_ifree
>             - 85.63% xfs_read_agi
>                - 85.61% xfs_trans_read_buf_map
>                   - 85.59% xfs_buf_read_map
>                      - xfs_buf_get_map
>                         - 85.55% xfs_buf_find
>                            - 72.87% _raw_spin_lock
>                               - do_raw_spin_lock
>                                    71.86% __pv_queued_spin_lock_slowpath
>                            - 8.74% xfs_buf_rele
>                               - 7.88% _raw_spin_lock
>                                  - 7.88% do_raw_spin_lock
>                                       7.63% __pv_queued_spin_lock_slowpath
>                            - 1.70% xfs_buf_trylock
>                               - 1.68% down_trylock
>                                  - 1.41% _raw_spin_lock_irqsave
>                                     - 1.39% do_raw_spin_lock
>                                          __pv_queued_spin_lock_slowpath
>                            - 0.76% _raw_spin_unlock
>                                 0.75% do_raw_spin_unlock
> 
> This is basically hammering the pag->pag_buf_lock from lots of CPUs
> doing trylocks at the same time. Most of the buffer trylock
> operations ultimately fail after we've done the lookup, so we're
> really hammering the buf hash lock whilst making no progress.
> 
> We can also see significant spinlock traffic on the same lock just
> under normal operation when lots of tasks are accessing metadata
> from the same AG, so let's avoid all this by creating a lookup fast
> path which leverages the rhashtable's ability to do rcu protected
> lookups.
> 
> This is a rework of the initial lockless buffer lookup patch I sent
> here:
> 
> https://lore.kernel.org/linux-xfs/20220328213810.1174688-1-david@fromorbit.com/
> 
> And the alternative cleanup sent by Christoph here:
> 
> https://lore.kernel.org/linux-xfs/20220403120119.235457-1-hch@lst.de/
> 
> This version isn't quite a short as Christophs, but it does roughly
> the same thing in killing the two-phase _xfs_buf_find() call
> mechanism. It separates the fast and slow paths a little more
> cleanly and doesn't have context dependent buffer return state from
> the slow path that the caller needs to handle. It also picks up the
> rhashtable insert optimisation that Christoph added.
> 
> This series passes fstests under several different configs and does
> not cause any obvious regressions in scalability testing that has
> been performed. Hence I'm proposing this as potential 5.20 cycle
> material.
> 
> Thoughts, comments?

Any chance there'll be a v3 (or just responses to the replies sent so
far) in time for 5.20?

--D

> Version 2:
> - based on 5.19-rc2
> - high speed collision of original proposals.
> 
> Initial versions:
> - https://lore.kernel.org/linux-xfs/20220403120119.235457-1-hch@lst.de/
> - https://lore.kernel.org/linux-xfs/20220328213810.1174688-1-david@fromorbit.com/
> 
> 
