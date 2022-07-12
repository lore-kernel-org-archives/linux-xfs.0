Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3292ECCA47F
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Jul 2022 18:32:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiGLScW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 14:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiGLScW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Jul 2022 14:32:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F81655B5
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 11:32:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E72861A9C
        for <linux-xfs@vger.kernel.org>; Tue, 12 Jul 2022 18:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6507BC3411E;
        Tue, 12 Jul 2022 18:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657650740;
        bh=b4lugB8gYwkm+QTFY+rA00kXKbFiCVSENZ3enpPfuMs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gT1dEnYJaZTh6yiIz8d3Le7t6FkGPnnJZrX2vCkAZ6VJj+Ut0exdOVPCNAG5T9KZ6
         NhVOzr+Vrc/gNXygJSMEGvSRicQVxyGp72LWSse3sK5xnCk8VRrPSvv92HsONBSyxM
         0P+pbgqPzCDQJyIA+Km9eRbJ2ZUK9mPMiOjP9l/EqHPRtXzs5gPsAZz/EztBfSGot/
         f8aJsy6PlXsenNufbAAzPQY6MJ9Ik/b3CI3qXFG5EWPXogF5UR91P5JF2l/yC1BhTr
         RTln69GOw5JCHkOnNc32Z6AUOwsFIVTBRIiDJhcbCneFVvpQx8wqQiKpP2Vlw8J3t8
         rCeVP0OpvDZTQ==
Date:   Tue, 12 Jul 2022 11:32:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Zhang Yi <yi.zhang@huawei.com>, linux-xfs@vger.kernel.org,
        yukuai3@huawei.com
Subject: Re: [PATCH] xfs: flush inode gc workqueue before clearing agi bucket
Message-ID: <Ys2+MxBH/gdV93pY@magnolia>
References: <20220711144134.3103197-1-yi.zhang@huawei.com>
 <20220711220642.GC3861211@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711220642.GC3861211@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 12, 2022 at 08:06:42AM +1000, Dave Chinner wrote:
> On Mon, Jul 11, 2022 at 10:41:34PM +0800, Zhang Yi wrote:
> > In the procedure of recover AGI unlinked lists, if something bad
> > happenes on one of the unlinked inode in the bucket list, we would call
> > xlog_recover_clear_agi_bucket() to clear the whole unlinked bucket list,
> > not the unlinked inodes after the bad one. If we have already added some
> > inodes to the gc workqueue before the bad inode in the list, we could
> > get below error when freeing those inodes, and finaly fail to complete
> > the log recover procedure.
> > 
> >  XFS (ram0): Internal error xfs_iunlink_remove at line 2456 of file
> >  fs/xfs/xfs_inode.c.  Caller xfs_ifree+0xb0/0x360 [xfs]
> > 
> > The problem is xlog_recover_clear_agi_bucket() clear the bucket list, so
> > the gc worker fail to check the agino in xfs_verify_agino(). Fix this by
> > flush workqueue before clearing the bucket.
> > 
> > Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> > ---
> >  fs/xfs/xfs_log_recover.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 5f7e4e6e33ce..2f655ef4364e 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2714,6 +2714,7 @@ xlog_recover_process_one_iunlink(
> >  	 * Call xlog_recover_clear_agi_bucket() to perform a transaction to
> >  	 * clear the inode pointer in the bucket.
> >  	 */
> > +	xfs_inodegc_flush(mp);
> >  	xlog_recover_clear_agi_bucket(mp, agno, bucket);
> >  	return NULLAGINO;
> >  }
> 
> Looks good.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

I propose adding:
Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

> 
> Darrick, FYI, I actually tripped over this and fixed it in the inode
> iunlink series as part of double linking the unlinked inode list in
> this patch:
> 
> https://lore.kernel.org/linux-xfs/20220707234345.1097095-6-david@fromorbit.com/
> 
> I didn't realise at the time I was forward porting this code that it
> was a pre-existing bug.....

Yep.  I'll merge this into the tree for easier porting with 5.15, and
fix up whatever merge conflicts result, if you're still interested in
merging the incore iunlinks for 5.20.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
