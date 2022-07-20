Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50399C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Jul 2022 23:35:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiGTXfj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Jul 2022 19:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiGTXfi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Jul 2022 19:35:38 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03A653F319
        for <linux-xfs@vger.kernel.org>; Wed, 20 Jul 2022 16:35:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4AD7010E815E;
        Thu, 21 Jul 2022 09:35:34 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oEJE4-003LFm-Ac; Thu, 21 Jul 2022 09:35:32 +1000
Date:   Thu, 21 Jul 2022 09:35:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: don't leak memory when attr fork loading fails
Message-ID: <20220720233532.GU3861211@dread.disaster.area>
References: <Ytbj3C3GF6aQJjo4@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ytbj3C3GF6aQJjo4@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62d89147
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=i9jRsUFt4n7ITWsusM0A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 19, 2022 at 10:03:24AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> I observed the following evidence of a memory leak while running xfs/399
> from the xfs fsck test suite (edited for brevity):
> 
> XFS (sde): Metadata corruption detected at xfs_attr_shortform_verify_struct.part.0+0x7b/0xb0 [xfs], inode 0x1172 attr fork
> XFS: Assertion failed: ip->i_af.if_u1.if_data == NULL, file: fs/xfs/libxfs/xfs_inode_fork.c, line: 315
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 91635 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
> CPU: 2 PID: 91635 Comm: xfs_scrub Tainted: G        W         5.19.0-rc7-xfsx #rc7 6e6475eb29fd9dda3181f81b7ca7ff961d277a40
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
> RIP: 0010:assfail+0x46/0x4a [xfs]
> Call Trace:
>  <TASK>
>  xfs_ifork_zap_attr+0x7c/0xb0
>  xfs_iformat_attr_fork+0x86/0x110
>  xfs_inode_from_disk+0x41d/0x480
>  xfs_iget+0x389/0xd70
>  xfs_bulkstat_one_int+0x5b/0x540
>  xfs_bulkstat_iwalk+0x1e/0x30
>  xfs_iwalk_ag_recs+0xd1/0x160
>  xfs_iwalk_run_callbacks+0xb9/0x180
>  xfs_iwalk_ag+0x1d8/0x2e0
>  xfs_iwalk+0x141/0x220
>  xfs_bulkstat+0x105/0x180
>  xfs_ioc_bulkstat.constprop.0.isra.0+0xc5/0x130
>  xfs_file_ioctl+0xa5f/0xef0
>  __x64_sys_ioctl+0x82/0xa0
>  do_syscall_64+0x2b/0x80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> This newly-added assertion checks that there aren't any incore data
> structures hanging off the incore fork when we're trying to reset its
> contents.  From the call trace, it is evident that iget was trying to
> construct an incore inode from the ondisk inode, but the attr fork
> verifier failed and we were trying to undo all the memory allocations
> that we had done earlier.
> 
> The three assertions in xfs_ifork_zap_attr check that the caller has
> already called xfs_idestroy_fork, which clearly has not been done here.
> As the zap function then zeroes the pointers, we've effectively leaked
> the memory.
> 
> The shortest change would have been to insert an extra call to
> xfs_idestroy_fork, but it makes more sense to bundle the _idestroy_fork
> call into _zap_attr, since all other callsites call _idestroy_fork
> immediately prior to calling _zap_attr.  IOWs, it eliminates one way to
> fail.
> 
> Note: This change only applies cleanly to 2ed5b09b3e8f, since we just
> reworked the attr fork lifetime.  However, I think this memory leak has
> existed since 0f45a1b20cd8, since the chain xfs_iformat_attr_fork ->
> xfs_iformat_local -> xfs_init_local_fork will allocate
> ifp->if_u1.if_data, but if xfs_ifork_verify_local_attr fails,
> xfs_iformat_attr_fork will free i_afp without freeing any of the stuff
> hanging off i_afp.  The solution for older kernels I think is to add the
> missing call to xfs_idestroy_fork just prior to calling kmem_cache_free.
> 
> Found by fuzzing a.sfattr.hdr.totsize = lastbit in xfs/399.
> 
> Fixes: 2ed5b09b3e8f ("xfs: make inode attribute forks a permanent part of struct xfs_inode")
> Probably-Fixes: 0f45a1b20cd8 ("xfs: improve local fork verification")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
