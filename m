Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAC58C433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 20 May 2022 03:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345112AbiETDid (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 May 2022 23:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234673AbiETDic (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 May 2022 23:38:32 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD69713CA13
        for <linux-xfs@vger.kernel.org>; Thu, 19 May 2022 20:38:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CAC41534496;
        Fri, 20 May 2022 13:38:30 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nrtTB-00E6R4-Ff; Fri, 20 May 2022 13:38:29 +1000
Date:   Fri, 20 May 2022 13:38:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: don't leak da state when freeing the attr
 intent item
Message-ID: <20220520033829.GC1098723@dread.disaster.area>
References: <165290007585.1646028.11376304341026166988.stgit@magnolia>
 <165290008177.1646028.17009669440155484683.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165290008177.1646028.17009669440155484683.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62870d37
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=R-z-jW9UaumzgApvX2wA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 18, 2022 at 11:54:41AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> kmemleak reported that we lost an xfs_da_state while removing xattrs in
> generic/020:
> 
> unreferenced object 0xffff88801c0e4b40 (size 480):
>   comm "attr", pid 30515, jiffies 4294931061 (age 5.960s)
>   hex dump (first 32 bytes):
>     78 bc 65 07 00 c9 ff ff 00 30 60 1c 80 88 ff ff  x.e......0`.....
>     02 00 00 00 00 00 00 00 80 18 83 4e 80 88 ff ff  ...........N....
>   backtrace:
>     [<ffffffffa023ef4a>] xfs_da_state_alloc+0x1a/0x30 [xfs]
>     [<ffffffffa021b6f3>] xfs_attr_node_hasname+0x23/0x90 [xfs]
>     [<ffffffffa021c6f1>] xfs_attr_set_iter+0x441/0xa30 [xfs]
>     [<ffffffffa02b5104>] xfs_xattri_finish_update+0x44/0x80 [xfs]
>     [<ffffffffa02b515e>] xfs_attr_finish_item+0x1e/0x40 [xfs]
>     [<ffffffffa0244744>] xfs_defer_finish_noroll+0x184/0x740 [xfs]
>     [<ffffffffa02a6473>] __xfs_trans_commit+0x153/0x3e0 [xfs]
>     [<ffffffffa021d149>] xfs_attr_set+0x469/0x7e0 [xfs]
>     [<ffffffffa02a78d9>] xfs_xattr_set+0x89/0xd0 [xfs]
>     [<ffffffff812e6512>] __vfs_removexattr+0x52/0x70
>     [<ffffffff812e6a08>] __vfs_removexattr_locked+0xb8/0x150
>     [<ffffffff812e6af6>] vfs_removexattr+0x56/0x100
>     [<ffffffff812e6bf8>] removexattr+0x58/0x90
>     [<ffffffff812e6cce>] path_removexattr+0x9e/0xc0
>     [<ffffffff812e6d44>] __x64_sys_lremovexattr+0x14/0x20
>     [<ffffffff81786b35>] do_syscall_64+0x35/0x80
> 
> I think this is a consequence of xfs_attr_node_removename_setup
> attaching a new da(btree) state to xfs_attr_item and never freeing it.
> I /think/ it's the case that the remove paths could detach the da state
> earlier in the remove state machine since nothing else accesses the
> state.  However, let's future-proof the new xattr code by adding a
> catch-all when we free the xfs_attr_item to make sure we never leak the
> da state.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c |   22 ++++++++++++++--------
>  fs/xfs/xfs_attr_item.c   |   15 ++++++++++++---
>  2 files changed, 26 insertions(+), 11 deletions(-)

Looks ok.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
