Return-Path: <SRS0=pQq2=7P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C166C433DF
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 22:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5B70205CB
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Jun 2020 22:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgFBWyA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Jun 2020 18:54:00 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:58402 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726174AbgFBWyA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jun 2020 18:54:00 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 944976ABCF6;
        Wed,  3 Jun 2020 08:53:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgFn7-0000zQ-J1; Wed, 03 Jun 2020 08:53:53 +1000
Date:   Wed, 3 Jun 2020 08:53:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/30] xfs: pin inode backing buffer to the inode log item
Message-ID: <20200602225353.GI2040@dread.disaster.area>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-17-david@fromorbit.com>
 <20200602223052.GM8230@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602223052.GM8230@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=VNkSieRqFxneTYARuQ4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 03:30:52PM -0700, Darrick J. Wong wrote:
> On Tue, Jun 02, 2020 at 07:42:37AM +1000, Dave Chinner wrote:
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 2364a9aa2d71a..9739d64a46443 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -1131,11 +1131,9 @@ xfs_buf_inode_iodone(
> >  		if (ret == 1)
> >  			return;
> >  		ASSERT(ret == 2);
> > -		spin_lock(&bp->b_mount->m_ail->ail_lock);
> >  		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
> > -			xfs_set_li_failed(lip, bp);
> > +			set_bit(XFS_LI_FAILED, &lip->li_flags);
> 
> Hm.  So if I read this right, for inode buffers we set/clear LI_FAILED
> directly (i.e. without messing with li_buf) because for inodes we want
> to manage the pointer directly without LI_FAILED messing with it.  That
> way we can attach the buffer to the item when we dirty the inode, and
> release it when iflush is finished (or aborts).  Dquots retain the old
> behavior (grab the buffer only while we're checkpointing a dquot item)
> which is why the v1 series crashed in xfs/438, so we have to leave
> xfs_set/clear_li_failed alone for now.  Right?

Correct. The lip->li_buf pointer is now owned by the inode log item
for inodes, it's not a field that exists purely for buffer error
handling. Any time an inode is attached to the buffer, lip->li_buf
points to the buffer, and hence we no longer need to attach the
buffer to the log item when IO fails to be able to trigger retries.

> If so,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
