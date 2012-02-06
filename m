Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16LRxZg166451 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 15:27:59 -0600
Date: Tue, 7 Feb 2012 08:27:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH][RFC] XFS: Fix mem leak and possible NULL deref in
	xfs_setattr_nonsize()
Message-ID: <20120206212754.GC12836@dastard>
References: <alpine.LNX.2.00.1202052220390.32529@swampdragon.chaosbits.net>
	<20120206091100.GA4350@Xye>
	<alpine.LNX.2.00.1202062145240.20117@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202062145240.20117@swampdragon.chaosbits.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jesper Juhl <jj@chaosbits.net>
Cc: Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Raghavendra D Prabhu <raghu.prabhu13@gmail.com>

On Mon, Feb 06, 2012 at 09:51:54PM +0100, Jesper Juhl wrote:
> On Mon, 6 Feb 2012, Raghavendra D Prabhu wrote:
> > As far as second one is concerned, looks fine, though this one should also do
> > the same.
> > 
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index ab30253..d331f5b 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -730,9 +730,9 @@ xfs_setattr_nonsize(
> >         return 0;
> > 
> > out_trans_cancel:
> > -       xfs_trans_cancel(tp, 0);
> >         xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > out_dqrele:
> > +       xfs_trans_cancel(tp, 0);
> >         xfs_qm_dqrele(udqp);
> >         xfs_qm_dqrele(gdqp);
> >         return error;
> > 
> 
> Thank you for the feedback.
> 
> I worry about the fact that this suddenly calls xfs_trans_cancel() without 
> holding the lock. I don't know if that's actually significant though. 

You're right to worry about it, because it is significant.

The transaction needs to be cancelled before we unlock the inode
because the transaction cancel cleans up state on the inode if the
inode has been joined to the transaction.  Unlocking the inode
before the transaction is cancelled means some other transaction can
lock the inode and join it to a new transaction before the old one
is cleaned up. Then Bad Stuff Happens.

IOWs, the above change is not safe to make.

> If it *is* significant, then I think the patch I just submitted in reply to 
> Dave Chinner is better since there we do the alloc and cancel before even 
> taking the lock at all in the leaky case and all other case have 
> identical behaviour as before.

I'll go check it out.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
