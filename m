Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33604 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726972AbeK1Q0h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 11:26:37 -0500
Date: Tue, 27 Nov 2018 21:26:04 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v1 6/7] xfs: Rewrite retried read
Message-ID: <20181128052604.GE8125@magnolia>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
 <1543376991-5764-7-git-send-email-allison.henderson@oracle.com>
 <20181128051719.GK6311@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181128051719.GK6311@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com

On Wed, Nov 28, 2018 at 04:17:19PM +1100, Dave Chinner wrote:
> On Tue, Nov 27, 2018 at 08:49:50PM -0700, Allison Henderson wrote:
> > If we had to try more than one mirror to get a successful
> > read, then write that buffer back to correct the bad mirro
> > 
> > Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> > ---
> >  fs/xfs/xfs_buf.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > index f102d01..81f6491 100644
> > --- a/fs/xfs/xfs_buf.c
> > +++ b/fs/xfs/xfs_buf.c
> > @@ -847,6 +847,14 @@ xfs_buf_read_map(
> >  
> >  		}
> >  retry_done:
> > +
> > +		/*
> > +		 * if we had to try more than one mirror to sucessfully read
> > +		 * the buffer, write the buffer back
> > +		 */
> > +		if (!bp->b_error && i > 0)
> > +			xfs_bwrite(bp);
> > +
> 
> This can go in the case statement on retry and then you don't need
> to check for i > 0 or, well, bp->b_error. i.e.
> 
> 		swtich (bp->b_error) {
> 		case -EBADCRC:
> 		case -EIO:
> 		case -EFSCORRUPTED:
> 			/* try again from different copy */
> 			continue;
> 		0:
> 			/* good copy, rewrite it to repair bad copy */
> 			xfs_bwrite(bp);

Some day we might want to provide some controls for how long we'll retry
these reads and whether or not we automatically rewrite buffers, since
some administrators might prefer fast fail to get failover started.

(Not now though)

--D

> 			/* fallthrough */
> 		default:
> 			return bp;
> 		}
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
