Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38311 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752401AbdBCXSw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Feb 2017 18:18:52 -0500
Date: Fri, 3 Feb 2017 15:18:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: reset b_first_retry_time when clear the retry
 status of xfs_buf_t
Message-ID: <20170203231841.GD3580@birch.djwong.org>
References: <1486112905-38025-1-git-send-email-houtao1@huawei.com>
 <20170203203258.GA3580@birch.djwong.org>
 <20170203223630.GD32761@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170203223630.GD32761@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Hou Tao <houtao1@huawei.com>, linux-xfs@vger.kernel.org, cmaiolino@redhat.com, sandeen@redhat.com

On Sat, Feb 04, 2017 at 09:36:30AM +1100, Dave Chinner wrote:
> On Fri, Feb 03, 2017 at 12:32:58PM -0800, Darrick J. Wong wrote:
> > On Fri, Feb 03, 2017 at 05:08:25PM +0800, Hou Tao wrote:
> > > After successful IO or permanent error, b_first_retry_time also
> > > needs to be cleared, else the invalid first retry time will be
> > > used by the next retry check.
> > > 
> > > Signed-off-by: Hou Tao <houtao1@huawei.com>
> > > ---
> > >  fs/xfs/xfs_buf_item.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > > index 2975cb2..0306168 100644
> > > --- a/fs/xfs/xfs_buf_item.c
> > > +++ b/fs/xfs/xfs_buf_item.c
> > > @@ -1162,6 +1162,7 @@ xfs_buf_iodone_callbacks(
> > >  	 */
> > >  	bp->b_last_error = 0;
> > >  	bp->b_retries = 0;
> > > +	bp->b_first_retry_time = 0;
> > 
> > Looks ok, will try to queue it up as an rc7 fix.
> 
> It's not a critical bug, nor is it a regression introduced in
> 4.10-rc1, so IMO it's not a -rc7 candidate fix. Just add it in the
> for-next queue and mark it for stable. It'll still get to most users
> at pretty much the same time via the stable trees...

Ok.  I'll queue it up for 4.11 then.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
