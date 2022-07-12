Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98889C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jul 2022 23:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiGLXJ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 19:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGLXJZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 19:09:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F601974AE
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 16:09:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5A5861703
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 23:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D48C3411C;
        Tue, 12 Jul 2022 23:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657667362;
        bh=MUG7IY3AnwpB/FZXiF+UkFbeEqDfTCn4Z0wVtL1VULQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WrR0uZDJkgOLiAdbXCo/uNSq5AyUVPjaY6Gfsyp0UCAPJYLzHwvyY8TSkkKP4c3o1
         qHgaf7NbzDq+KfdjzjdDEs/4JS/UPX3q/J+Pox6WUr3PzwxY+LP82ZkytZLfkSPLE/
         GCNGsd67t/k3s3nTDqqum6j8epBM/0P26Mruo5kZndguBA1vODduMcx3FNgUownyFO
         C1ZQs3nRxMSz3T+UQTr45QYUSM0j/I8l+5Ji5Waa83eMO/J7Tq4vvJPZq+Ey+MpQMd
         JDOFxNqv6C4oXP4YqTWfewU7sB6rRMGWcwaYl56Q8VFO8/oLjSJi9yM1xN15/j5q8J
         WZXrfaYg9b/fQ==
Date:   Tue, 12 Jul 2022 16:09:21 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Zhang Yi <yi.zhang@huawei.com>, linux-xfs@vger.kernel.org,
        yukuai3@huawei.com
Subject: Re: [PATCH] xfs: flush inode gc workqueue before clearing agi bucket
Message-ID: <Ys3/IeDLGMXiTUen@magnolia>
References: <20220711144134.3103197-1-yi.zhang@huawei.com>
 <20220711220642.GC3861211@dread.disaster.area>
 <Ys2+MxBH/gdV93pY@magnolia>
 <20220712214940.GM3861211@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712214940.GM3861211@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 13, 2022 at 07:49:40AM +1000, Dave Chinner wrote:
> On Tue, Jul 12, 2022 at 11:32:19AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 12, 2022 at 08:06:42AM +1000, Dave Chinner wrote:
> > > On Mon, Jul 11, 2022 at 10:41:34PM +0800, Zhang Yi wrote:
> > > > In the procedure of recover AGI unlinked lists, if something bad
> > > > happenes on one of the unlinked inode in the bucket list, we would call
> > > > xlog_recover_clear_agi_bucket() to clear the whole unlinked bucket list,
> > > > not the unlinked inodes after the bad one. If we have already added some
> > > > inodes to the gc workqueue before the bad inode in the list, we could
> > > > get below error when freeing those inodes, and finaly fail to complete
> > > > the log recover procedure.
> > > > 
> > > >  XFS (ram0): Internal error xfs_iunlink_remove at line 2456 of file
> > > >  fs/xfs/xfs_inode.c.  Caller xfs_ifree+0xb0/0x360 [xfs]
> > > > 
> > > > The problem is xlog_recover_clear_agi_bucket() clear the bucket list, so
> > > > the gc worker fail to check the agino in xfs_verify_agino(). Fix this by
> > > > flush workqueue before clearing the bucket.
> > > > 
> > > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > > ---
> > > >  fs/xfs/xfs_log_recover.c | 1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > > index 5f7e4e6e33ce..2f655ef4364e 100644
> > > > --- a/fs/xfs/xfs_log_recover.c
> > > > +++ b/fs/xfs/xfs_log_recover.c
> > > > @@ -2714,6 +2714,7 @@ xlog_recover_process_one_iunlink(
> > > >  	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
> > > >  	 * clear the inode pointer in the bucket.
> > > >  	 */
> > > > +	xfs_inodegc_flush(mp);
> > > >  	xlog_recover_clear_agi_bucket(mp, agno, bucket);
> > > >  	return NULLAGINO;
> > > >  }
> > > 
> > > Looks good.
> > > 
> > > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > 
> > I propose adding:
> > Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
> > 
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > > 
> > > Darrick, FYI, I actually tripped over this and fixed it in the inode
> > > iunlink series as part of double linking the unlinked inode list in
> > > this patch:
> > > 
> > > https://lore.kernel.org/linux-xfs/20220707234345.1097095-6-david@fromorbit.com/
> > > 
> > > I didn't realise at the time I was forward porting this code that it
> > > was a pre-existing bug.....
> > 
> > Yep.  I'll merge this into the tree for easier porting with 5.15, and
> > fix up whatever merge conflicts result, if you're still interested in
> > merging the incore iunlinks for 5.20.
> 
> Yes, I'll send you a pull request for it soon now that all reviews
> have been done. If you want, I'll include this fix first and rebase
> the commits that is causes conflicts with on top of it cleanly....

Yes, please include it in the rebase. :)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
