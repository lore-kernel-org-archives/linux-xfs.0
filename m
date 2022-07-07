Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E28C43334
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Jul 2022 17:55:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbiGGRzr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 Jul 2022 13:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235960AbiGGRzq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jul 2022 13:55:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9309B33E1E
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 10:55:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3080F620A1
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 17:55:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88693C341C8;
        Thu,  7 Jul 2022 17:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657216544;
        bh=GOFwR3X9dGKgpgUk+PElQdGEG41zywhwq2lsiEpXWhg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Mj3achxxTC7GUWbiFc2XPaWfsDUsavLco6QEoPD6PI27p91G08+HV++eT9At6CbJ5
         mA+IXyYaKL5W/CpDnaskpWA0Lfa8BZ2OLzcOOkXDnQh4QBQTv+NmRqkMP5tKUSNLI7
         3LDYII2GnC5r6spAiRytZ0G1ICn0IduTPd5afgn2nvaBpq9+hkj/TYiutAngz5jkrM
         Q90ueZUHmkIM6ZIteIkkbIoQrNhtPfkHWEuxGdpfUB4TfWM15ZBURB3QnmWWm/LxxO
         /cprXBmMfDeS/XgOSV3PdvbVOEkI5BFS3nqKrnplBuFThw1BoSXgzROO31ePLJkDWv
         iJ5rdfQon2BnA==
Date:   Thu, 7 Jul 2022 10:55:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: lockless buffer lookup
Message-ID: <YsceIFL3iFwtHWx0@magnolia>
References: <20220627060841.244226-1-david@fromorbit.com>
 <20220627060841.244226-7-david@fromorbit.com>
 <YrzMeZ/mW+yN94Oo@magnolia>
 <20220707123633.GM227878@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707123633.GM227878@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 07, 2022 at 10:36:33PM +1000, Dave Chinner wrote:
> On Wed, Jun 29, 2022 at 03:04:41PM -0700, Darrick J. Wong wrote:
> > On Mon, Jun 27, 2022 at 04:08:41PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Now that we have a standalone fast path for buffer lookup, we can
> > > easily convert it to use rcu lookups. When we continually hammer the
> > > buffer cache with trylock lookups, we end up with a huge amount of
> > > lock contention on the per-ag buffer hash locks:
> > > 
> > > -   92.71%     0.05%  [kernel]                  [k] xfs_inodegc_worker
> > >    - 92.67% xfs_inodegc_worker
> > >       - 92.13% xfs_inode_unlink
> > >          - 91.52% xfs_inactive_ifree
> > >             - 85.63% xfs_read_agi
> > >                - 85.61% xfs_trans_read_buf_map
> > >                   - 85.59% xfs_buf_read_map
> > >                      - xfs_buf_get_map
> > >                         - 85.55% xfs_buf_find
> > >                            - 72.87% _raw_spin_lock
> > >                               - do_raw_spin_lock
> > >                                    71.86% __pv_queued_spin_lock_slowpath
> > >                            - 8.74% xfs_buf_rele
> > >                               - 7.88% _raw_spin_lock
> > >                                  - 7.88% do_raw_spin_lock
> > >                                       7.63% __pv_queued_spin_lock_slowpath
> > >                            - 1.70% xfs_buf_trylock
> > >                               - 1.68% down_trylock
> > >                                  - 1.41% _raw_spin_lock_irqsave
> > >                                     - 1.39% do_raw_spin_lock
> > >                                          __pv_queued_spin_lock_slowpath
> > >                            - 0.76% _raw_spin_unlock
> > >                                 0.75% do_raw_spin_unlock
> > > 
> > > This is basically hammering the pag->pag_buf_lock from lots of CPUs
> > > doing trylocks at the same time. Most of the buffer trylock
> > > operations ultimately fail after we've done the lookup, so we're
> > > really hammering the buf hash lock whilst making no progress.
> > > 
> > > We can also see significant spinlock traffic on the same lock just
> > > under normal operation when lots of tasks are accessing metadata
> > > from the same AG, so let's avoid all this by converting the lookup
> > > fast path to leverages the rhashtable's ability to do rcu protected
> > > lookups.
> > > 
> > > We avoid races with the buffer release path by using
> > > atomic_inc_not_zero() on the buffer hold count. Any buffer that is
> > > in the LRU will have a non-zero count, thereby allowing the lockless
> > > fast path to be taken in most cache hit situations. If the buffer
> > > hold count is zero, then it is likely going through the release path
> > > so in that case we fall back to the existing lookup miss slow path.
> > > 
> > > The slow path will then do an atomic lookup and insert under the
> > > buffer hash lock and hence serialise correctly against buffer
> > > release freeing the buffer.
> > > 
> > > The use of rcu protected lookups means that buffer handles now need
> > > to be freed by RCU callbacks (same as inodes). We still free the
> > > buffer pages before the RCU callback - we won't be trying to access
> > > them at all on a buffer that has zero references - but we need the
> > > buffer handle itself to be present for the entire rcu protected read
> > > side to detect a zero hold count correctly.
> > 
> > Hmm, so what still uses pag_buf_lock?  Are we still using it to
> > serialize xfs_buf_rele calls?
> 
> slow path lookup/insert and xfs_buf_rele calls.
> 
> The only thing we are allowing lockless lookups on are buffers with
> at least one reference. With the LRU holding a reference, that means
> it the buffer is still actively cached or referenced by something
> else so won't disappear from under us. If the ref count is zero,
> then it means the buffer is being removed from the cache, so we
> need to go the slow way and take the pag_buf_lock to serialise the
> lookup against the release of the unreferenced buffer we found in
> the cache.

Ah, right, got it.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
