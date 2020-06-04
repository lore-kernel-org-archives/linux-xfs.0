Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D8FC433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 01:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC44520772
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 01:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgFDBzC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 21:55:02 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:43886 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726011AbgFDBzC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jun 2020 21:55:02 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id D0F0A5EC51D;
        Thu,  4 Jun 2020 11:54:59 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgf5s-00024O-6n; Thu, 04 Jun 2020 11:54:56 +1000
Date:   Thu, 4 Jun 2020 11:54:56 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/30] xfs: add an inode item lock
Message-ID: <20200604015456.GR2040@dread.disaster.area>
References: <20200601214251.4167140-1-david@fromorbit.com>
 <20200601214251.4167140-4-david@fromorbit.com>
 <20200602163444.GC7967@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602163444.GC7967@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=8QfzhXM7zhgUWszBLBMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 02, 2020 at 12:34:44PM -0400, Brian Foster wrote:
> On Tue, Jun 02, 2020 at 07:42:24AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> ...
> > @@ -122,23 +117,30 @@ xfs_trans_log_inode(
> >  	 * set however, then go ahead and bump the i_version counter
> >  	 * unconditionally.
> >  	 */
> > -	if (!test_and_set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags) &&
> > -	    IS_I_VERSION(VFS_I(ip))) {
> > -		if (inode_maybe_inc_iversion(VFS_I(ip), flags & XFS_ILOG_CORE))
> > -			flags |= XFS_ILOG_CORE;
> > +	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags)) {
> > +		if (IS_I_VERSION(inode) &&
> > +		    inode_maybe_inc_iversion(inode, flags & XFS_ILOG_CORE))
> > +			iversion_flags = XFS_ILOG_CORE;
> >  	}
> >  
> > -	tp->t_flags |= XFS_TRANS_DIRTY;
> > +	/*
> > +	 * Record the specific change for fdatasync optimisation. This allows
> > +	 * fdatasync to skip log forces for inodes that are only timestamp
> > +	 * dirty. We do this before the change count so that the core being
> > +	 * logged in this case does not impact on fdatasync behaviour.
> > +	 */
> 
> We no longer do this before the change count logic so that part of the
> comment is bogus.

Ugh. Another 6 patch conflicts to resolve coming right up....

> > +	spin_lock(&iip->ili_lock);
> > +	iip->ili_fsync_fields |= flags;
> >  
> >  	/*
> > -	 * Always OR in the bits from the ili_last_fields field.
> > -	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
> > -	 * routines in the eventual clearing of the ili_fields bits.
> > -	 * See the big comment in xfs_iflush() for an explanation of
> > -	 * this coordination mechanism.
> > +	 * Always OR in the bits from the ili_last_fields field.  This is to
> > +	 * coordinate with the xfs_iflush() and xfs_iflush_done() routines in
> > +	 * the eventual clearing of the ili_fields bits.  See the big comment in
> > +	 * xfs_iflush() for an explanation of this coordination mechanism.
> >  	 */
> > -	flags |= ip->i_itemp->ili_last_fields;
> > -	ip->i_itemp->ili_fields |= flags;
> > +	iip->ili_fields |= (flags | iip->ili_last_fields |
> > +			    iversion_flags);
> > +	spin_unlock(&iip->ili_lock);
> >  }
> >  
> >  int
> > diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> > index 403c90309a8ff..0abf770b77498 100644
> > --- a/fs/xfs/xfs_file.c
> > +++ b/fs/xfs/xfs_file.c
> > @@ -94,6 +94,7 @@ xfs_file_fsync(
> >  {
> >  	struct inode		*inode = file->f_mapping->host;
> >  	struct xfs_inode	*ip = XFS_I(inode);
> > +	struct xfs_inode_log_item *iip = ip->i_itemp;
> >  	struct xfs_mount	*mp = ip->i_mount;
> >  	int			error = 0;
> >  	int			log_flushed = 0;
> > @@ -137,13 +138,15 @@ xfs_file_fsync(
> >  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> >  	if (xfs_ipincount(ip)) {
> >  		if (!datasync ||
> > -		    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> > -			lsn = ip->i_itemp->ili_last_lsn;
> > +		    (iip->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> > +			lsn = iip->ili_last_lsn;
> 
> I am still a little confused why the lock is elided in other read cases,
> such as this one or perhaps the similar check in xfs_bmbt_to_iomap()..?

They are still all serialised against those field changing the same
way they currently are. i.e. they are all under the ILOCK, so
changes that occur during IO submission will never occur.  Hence the
only thing that we can race with is IO completion clearing the
fields, in which case the subsequent operations if the item is now
clean turn into no-ops.

i.e:
- ILOCK serialises transaction logging vs IO submission.
- iflock serialises IO submission vs IO completion.
- Nothing serialises transaction logging vs IO completion.

The latter is what the ili_lock is intended for; everything else is
still protected by the existing serialisation mechanisms that they
are now. Any races in areas outside xfs_trans_log_inode() vs
xfs_iflush_done/abort() is largely outside the scope of this patch
and this lock...

> Similarly, it looks like we set the ili_[flush|last]_lsn fields outside
> of this lock (though last_lsn looks like it's also covered by ilock),
> yet the update to the inode_log_item struct implies they should be
> protected. What's the intent there?

The lsn fields are updated via xfs_trans_ail_lsn_copy(), which on 32
bit systems takes the AIL lock, and I don't think it's a good idea
to put the AIL lock inside the inode item lock.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
