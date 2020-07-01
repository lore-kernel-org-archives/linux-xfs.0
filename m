Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D53C433DF
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 05:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97A9320747
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 05:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726039AbgGAFsz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 01:48:55 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:44510 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725272AbgGAFsz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 01:48:55 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id BBD831A851A;
        Wed,  1 Jul 2020 15:48:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqVc2-0003De-Fa; Wed, 01 Jul 2020 15:48:50 +1000
Date:   Wed, 1 Jul 2020 15:48:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: xfs_iflock is no longer a completion
Message-ID: <20200701054850.GR2005@dread.disaster.area>
References: <20200623095015.1934171-1-david@fromorbit.com>
 <20200623095015.1934171-2-david@fromorbit.com>
 <20200624153652.GD9914@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624153652.GD9914@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=flNyei_xha9SlnuVBY8A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 24, 2020 at 11:36:52AM -0400, Brian Foster wrote:
> On Tue, Jun 23, 2020 at 07:50:12PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > With the recent rework of the inode cluster flushing, we no longer
> > ever wait on the the inode flush "lock". It was never a lock in the
> > first place, just a completion to allow callers to wait for inode IO
> > to complete. We now never wait for flush completion as all inode
> > flushing is non-blocking. Hence we can get rid of all the iflock
> > infrastructure and instead just set and check a state flag.
> > 
> > Rename the XFS_IFLOCK flag to XFS_IFLUSHING, convert all the
> > xfs_iflock_nowait() test-and-set operations on that flag, and
> > replace all the xfs_ifunlock() calls to clear operations.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> I'd call it IFLUSHED vs. IFLUSHING, but I'm not going to harp on that.
> Just a few nits, otherwise looks like a nice cleanup.

I thought about "flushed" but that implies something that has
alerady happened in the past (e.g. XFS_ITRUNCATED) rather than
something that is currently happening. i.e. we are wanting to know
if a flush is in progress right now, not whether a flush has been
done in the past...

> >  fs/xfs/xfs_icache.c     | 19 ++++++------
> >  fs/xfs/xfs_inode.c      | 67 +++++++++++++++--------------------------
> >  fs/xfs/xfs_inode.h      | 33 +-------------------
> >  fs/xfs/xfs_inode_item.c |  6 ++--
> >  fs/xfs/xfs_inode_item.h |  4 +--
> >  5 files changed, 39 insertions(+), 90 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > index a973f180c6cd..0d73559f2d58 100644
> > --- a/fs/xfs/xfs_icache.c
> > +++ b/fs/xfs/xfs_icache.c
> ...
> > @@ -1045,23 +1044,23 @@ xfs_reclaim_inode(
> >  
> >  	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
> >  		goto out;
> > -	if (!xfs_iflock_nowait(ip))
> > +	if (xfs_iflags_test_and_set(ip, XFS_IFLUSHING))
> >  		goto out_iunlock;
> >  
> >  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
> >  		xfs_iunpin_wait(ip);
> >  		/* xfs_iflush_abort() drops the flush lock */
> 
> The flush what? ;P
> 
> >  		xfs_iflush_abort(ip);
> > +		ASSERT(!xfs_iflags_test(ip, XFS_IFLUSHING));
> 
> Seems a bit superfluous right after the abort.

Yup, I'll that clean up and the comments the search and replace I
did missed.

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
