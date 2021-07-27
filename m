Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882FBC4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:17:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 619C560F90
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Jul 2021 23:17:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhG0XRT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 19:17:19 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:43978 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232701AbhG0XRS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 19:17:18 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 1D74C10105F;
        Wed, 28 Jul 2021 09:17:17 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8WK1-00BXxm-VQ; Wed, 28 Jul 2021 09:17:13 +1000
Date:   Wed, 28 Jul 2021 09:17:13 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 09/12] xfs: Rename XFS_IOC_BULKSTAT to
 XFS_IOC_BULKSTAT_V5
Message-ID: <20210727231713.GX664593@dread.disaster.area>
References: <20210726114541.24898-1-chandanrlinux@gmail.com>
 <20210726114541.24898-10-chandanrlinux@gmail.com>
 <20210727225400.GS559212@magnolia>
 <20210727230002.GT559212@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727230002.GT559212@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=4dKMDOqn4CZxlIOLAQ0A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 27, 2021 at 04:00:02PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 27, 2021 at 03:54:00PM -0700, Darrick J. Wong wrote:
> > On Mon, Jul 26, 2021 at 05:15:38PM +0530, Chandan Babu R wrote:
> > > This commit renames XFS_IOC_BULKSTAT to XFS_IOC_BULKSTAT_V5 to allow a future
> > > commit to extend bulkstat facility to support 64-bit extent counters. To this
> > > end, this commit also renames xfs_bulkstat->bs_extents field to
> > > xfs_bulkstat->bs_extents32.
> > > 
> > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_fs.h |  4 ++--
> > >  fs/xfs/xfs_ioctl.c     | 27 ++++++++++++++++++++++-----
> > >  fs/xfs/xfs_ioctl32.c   |  7 +++++++
> > >  fs/xfs/xfs_itable.c    |  4 ++--
> > >  fs/xfs/xfs_itable.h    |  1 +
> > >  5 files changed, 34 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > > index 2594fb647384..d760a969599e 100644
> > > --- a/fs/xfs/libxfs/xfs_fs.h
> > > +++ b/fs/xfs/libxfs/xfs_fs.h
> > > @@ -394,7 +394,7 @@ struct xfs_bulkstat {
> > >  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
> > >  
> > >  	uint32_t	bs_nlink;	/* number of links		*/
> > > -	uint32_t	bs_extents;	/* number of extents		*/
> > > +	uint32_t	bs_extents32;	/* number of extents		*/
> > 
> > I wish I'd thought of this when we introduced bulkstat v5 so you
> > wouldn't have had to do this.
> > 
> > (I might have more to say in the bulkstat v6 patch review.)
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> 
> Actually, I take that back, I have things to say /now/. :)
> 
> Rather than adding a whole new ioctl definition which (I haven't looked
> at the xfsprogs changes) likely creates a bunch of churn in userspace,
> what if we added a XFS_IBULK_ flag for supporting large extent counts?
> There's also quite a bit of reserved padding space in xfs_bulk_ireq, so
> perhaps we should define one of those padding u64 as a op-specific flag
> field that would be a way to pass bulkstat-specific flags to the
> relevant operations.  That way the 64-bit extent counts are merely a
> variant on bulkstat v5 instead of a whole new format.

Yup, this.

The only reason for creating a new revision of the ioctl is if we've
run out of expansion space in the existing ioctl structures to cater
for new information we want to export to userspace.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
