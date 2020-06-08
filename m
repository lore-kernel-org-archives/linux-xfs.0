Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308ACC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 21:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1623C2074B
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 21:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgFHVFQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 17:05:16 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:51517 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726606AbgFHVFQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 17:05:16 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 6942C105F39;
        Tue,  9 Jun 2020 07:05:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jiOxB-0000NW-0H; Tue, 09 Jun 2020 07:05:09 +1000
Date:   Tue, 9 Jun 2020 07:05:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/30] xfs: attach inodes to the cluster buffer when
 dirtied
Message-ID: <20200608210508.GG2040@dread.disaster.area>
References: <20200604074606.266213-1-david@fromorbit.com>
 <20200604074606.266213-26-david@fromorbit.com>
 <20200608164503.GC36278@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608164503.GC36278@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=fJ5XghZlGOtlfqy60v4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 08, 2020 at 12:45:03PM -0400, Brian Foster wrote:
> On Thu, Jun 04, 2020 at 05:46:01PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Rather than attach inodes to the cluster buffer just when we are
> > doing IO, attach the inodes to the cluster buffer when they are
> > dirtied. The means the buffer always carries a list of dirty inodes
> > that reference it, and we can use that list to make more fundamental
> > changes to inode writeback that aren't otherwise possible.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_trans_inode.c |  9 ++++++---
> >  fs/xfs/xfs_buf_item.c           |  1 +
> >  fs/xfs/xfs_icache.c             |  1 +
> >  fs/xfs/xfs_inode.c              | 24 +++++-------------------
> >  fs/xfs/xfs_inode_item.c         | 16 ++++++++++++++--
> >  5 files changed, 27 insertions(+), 24 deletions(-)
> > 
> ...
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 64bdda72f7b27..697248b7eb2be 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -660,6 +660,10 @@ xfs_inode_item_destroy(
> >   * list for other inodes that will run this function. We remove them from the
> >   * buffer list so we can process all the inode IO completions in one AIL lock
> >   * traversal.
> > + *
> > + * Note: Now that we attach the log item to the buffer when we first log the
> > + * inode in memory, we can have unflushed inodes on the buffer list here. These
> > + * inodes will have a zero ili_last_fields, so skip over them here.
> >   */
> >  void
> >  xfs_iflush_done(
> > @@ -677,12 +681,15 @@ xfs_iflush_done(
> >  	 */
> >  	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> >  		iip = INODE_ITEM(lip);
> > +
> >  		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
> > -			list_del_init(&lip->li_bio_list);
> >  			xfs_iflush_abort(iip->ili_inode);
> >  			continue;
> >  		}
> >  
> > +		if (!iip->ili_last_fields)
> > +			continue;
> > +
> 
> If I follow the comment above this is essentially a proxy for checking
> whether the inode is flushed. IOW, could this eventually be replaced
> with the state flag check based on the cleanup discussed in the previous
> patch, right?

Yes, likely it can.

> Otherwise LGTM:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
