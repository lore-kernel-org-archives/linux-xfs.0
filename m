Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22834C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Mar 2022 23:11:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiC1XMz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Mar 2022 19:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiC1XMy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Mar 2022 19:12:54 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D2A5EBF7
        for <linux-xfs@vger.kernel.org>; Mon, 28 Mar 2022 16:11:12 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-43-123.pa.nsw.optusnet.com.au [49.180.43.123])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id EFDCA10E5081;
        Tue, 29 Mar 2022 10:11:11 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nYyVx-00B4sP-0h; Tue, 29 Mar 2022 10:11:09 +1100
Date:   Tue, 29 Mar 2022 10:11:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: aborting inodes on shutdown may need buffer lock
Message-ID: <20220328231109.GV1544202@dread.disaster.area>
References: <20220324002103.710477-1-david@fromorbit.com>
 <20220324002103.710477-2-david@fromorbit.com>
 <20220328224452.GA27690@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328224452.GA27690@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62424090
        a=MV6E7+DvwtTitA3W+3A2Lw==:117 a=MV6E7+DvwtTitA3W+3A2Lw==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=7-415B0cAAAA:8
        a=TuYxW_UxKIsRaeBSoBoA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 28, 2022 at 03:44:52PM -0700, Darrick J. Wong wrote:
> On Thu, Mar 24, 2022 at 11:20:58AM +1100, Dave Chinner wrote:
> >  xfs_iflush_abort(
> >  	struct xfs_inode	*ip)
> >  {
> >  	struct xfs_inode_log_item *iip = ip->i_itemp;
> > -	struct xfs_buf		*bp = NULL;
> > +	struct xfs_buf		*bp;
> >  
> > -	if (iip) {
> > -		/*
> > -		 * Clear the failed bit before removing the item from the AIL so
> > -		 * xfs_trans_ail_delete() doesn't try to clear and release the
> > -		 * buffer attached to the log item before we are done with it.
> > -		 */
> > -		clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
> > -		xfs_trans_ail_delete(&iip->ili_item, 0);
> > +	if (!iip) {
> > +		/* clean inode, nothing to do */
> > +		xfs_iflags_clear(ip, XFS_IFLUSHING);
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * Remove the inode item from the AIL before we clear it's internal
> 
> Nit: "it's" is a contraction, "its" is possessive.
> 
> > +	 * state. Whilst the inode is in the AIL, it should have a valid buffer
> > +	 * pointer for push operations to access - it is only safe to remove the
> > +	 * inode from the buffer once it has been removed from the AIL.
> > +	 *
> > +	 * We also clear the failed bit before removing the item from the AIL
> > +	 * as xfs_trans_ail_delete()->xfs_clear_li_failed() will release buffer
> > +	 * references the inode item owns and needs to hold until we've fully
> > +	 * aborted the inode log item and detatched it from the buffer.
> 
> Nit: detached
> 
> > +	 */
> > +	clear_bit(XFS_LI_FAILED, &iip->ili_item.li_flags);
> 
> I wonder, is there any chance the AIL will stumble onto the inode item
> right here?

It can, but now it will fail to get the buffer lock because we
currently hold it and so can't do anything writeback related with
the inode item regardless of whether this bit is set or not.  i.e.
This patch actually fixes the race you are refering to....

> > +	xfs_trans_ail_delete(&iip->ili_item, 0);
> > +
> > +	/*
> > +	 * Capture the associated buffer and lock it if the caller didn't
> > +	 * pass us the locked buffer to begin with.
> 
> I agree that we're capturing the buffer here, but this function is not
> locking the buffer since the comment says that the caller has to hold
> the buffer lock already, correct?  And AFAICT from looking at all the
> callers, they all hold the buffer locked, like the comment requires.

I thought I killed that comment - you noted it was incorrect in
the previous iteration. I'll kill it properly when I update the
spulling misteaks above.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
