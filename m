Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:26246 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752540AbdBCWge (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2017 17:36:34 -0500
Date: Sat, 4 Feb 2017 09:36:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: reset b_first_retry_time when clear the retry
 status of xfs_buf_t
Message-ID: <20170203223630.GD32761@dastard>
References: <1486112905-38025-1-git-send-email-houtao1@huawei.com>
 <20170203203258.GA3580@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203203258.GA3580@birch.djwong.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, cmaiolino@redhat.com, sandeen@redhat.com

On Fri, Feb 03, 2017 at 12:32:58PM -0800, Darrick J. Wong wrote:
> On Fri, Feb 03, 2017 at 05:08:25PM +0800, Hou Tao wrote:
> > After successful IO or permanent error, b_first_retry_time also
> > needs to be cleared, else the invalid first retry time will be
> > used by the next retry check.
> > 
> > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > ---
> >  fs/xfs/xfs_buf_item.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 2975cb2..0306168 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -1162,6 +1162,7 @@ xfs_buf_iodone_callbacks(
> >  	 */
> >  	bp->b_last_error = 0;
> >  	bp->b_retries = 0;
> > +	bp->b_first_retry_time = 0;
> 
> Looks ok, will try to queue it up as an rc7 fix.

It's not a critical bug, nor is it a regression introduced in
4.10-rc1, so IMO it's not a -rc7 candidate fix. Just add it in the
for-next queue and mark it for stable. It'll still get to most users
at pretty much the same time via the stable trees...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
