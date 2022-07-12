Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FFCEC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jul 2022 21:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbiGLVtr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 17:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiGLVto (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 17:49:44 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17FF697497
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 14:49:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id A2DB762C687;
        Wed, 13 Jul 2022 07:49:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oBNlE-0009aU-ML; Wed, 13 Jul 2022 07:49:40 +1000
Date:   Wed, 13 Jul 2022 07:49:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zhang Yi <yi.zhang@huawei.com>, linux-xfs@vger.kernel.org,
        yukuai3@huawei.com
Subject: Re: [PATCH] xfs: flush inode gc workqueue before clearing agi bucket
Message-ID: <20220712214940.GM3861211@dread.disaster.area>
References: <20220711144134.3103197-1-yi.zhang@huawei.com>
 <20220711220642.GC3861211@dread.disaster.area>
 <Ys2+MxBH/gdV93pY@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys2+MxBH/gdV93pY@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62cdec76
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=i0EeH86SAAAA:8 a=20KFwNOVAAAA:8
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=2iBHPgXUinvJ9jGLYcoA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 12, 2022 at 11:32:19AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 12, 2022 at 08:06:42AM +1000, Dave Chinner wrote:
> > On Mon, Jul 11, 2022 at 10:41:34PM +0800, Zhang Yi wrote:
> > > In the procedure of recover AGI unlinked lists, if something bad
> > > happenes on one of the unlinked inode in the bucket list, we would call
> > > xlog_recover_clear_agi_bucket() to clear the whole unlinked bucket list,
> > > not the unlinked inodes after the bad one. If we have already added some
> > > inodes to the gc workqueue before the bad inode in the list, we could
> > > get below error when freeing those inodes, and finaly fail to complete
> > > the log recover procedure.
> > > 
> > >  XFS (ram0): Internal error xfs_iunlink_remove at line 2456 of file
> > >  fs/xfs/xfs_inode.c.  Caller xfs_ifree+0xb0/0x360 [xfs]
> > > 
> > > The problem is xlog_recover_clear_agi_bucket() clear the bucket list, so
> > > the gc worker fail to check the agino in xfs_verify_agino(). Fix this by
> > > flush workqueue before clearing the bucket.
> > > 
> > > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > > ---
> > >  fs/xfs/xfs_log_recover.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > > index 5f7e4e6e33ce..2f655ef4364e 100644
> > > --- a/fs/xfs/xfs_log_recover.c
> > > +++ b/fs/xfs/xfs_log_recover.c
> > > @@ -2714,6 +2714,7 @@ xlog_recover_process_one_iunlink(
> > >  	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
> > >  	 * clear the inode pointer in the bucket.
> > >  	 */
> > > +	xfs_inodegc_flush(mp);
> > >  	xlog_recover_clear_agi_bucket(mp, agno, bucket);
> > >  	return NULLAGINO;
> > >  }
> > 
> > Looks good.
> > 
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> I propose adding:
> Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> > 
> > Darrick, FYI, I actually tripped over this and fixed it in the inode
> > iunlink series as part of double linking the unlinked inode list in
> > this patch:
> > 
> > https://lore.kernel.org/linux-xfs/20220707234345.1097095-6-david@fromorbit.com/
> > 
> > I didn't realise at the time I was forward porting this code that it
> > was a pre-existing bug.....
> 
> Yep.  I'll merge this into the tree for easier porting with 5.15, and
> fix up whatever merge conflicts result, if you're still interested in
> merging the incore iunlinks for 5.20.

Yes, I'll send you a pull request for it soon now that all reviews
have been done. If you want, I'll include this fix first and rebase
the commits that is causes conflicts with on top of it cleanly....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
