Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16KpP9j164379 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 14:51:25 -0600
Date: Mon, 6 Feb 2012 21:51:54 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH][RFC] XFS: Fix mem leak and possible NULL deref in
	xfs_setattr_nonsize()
In-Reply-To: <20120206091100.GA4350@Xye>
Message-ID: <alpine.LNX.2.00.1202062145240.20117@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202052220390.32529@swampdragon.chaosbits.net>
	<20120206091100.GA4350@Xye>
MIME-Version: 1.0
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
To: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
Cc: Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>

On Mon, 6 Feb 2012, Raghavendra D Prabhu wrote:

> Hi,
> 
> 
> * On Sun, Feb 05, 2012 at 10:23:44PM +0100, Jesper Juhl <jj@chaosbits.net>
> wrote:
> > In xfs_setattr_nonsize(), xfs_trans_alloc() gets its memory from
> > _xfs_trans_alloc() which gets it from kmem_zone_zalloc() which may
> > fail and return NULL. So this:
> > 
> > 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
> > 
> > may result in a NULL 'tp'.
> > If it does, then the call:
> > 
> > 	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
> > 
> > with a NULL 'tp' will explode, since xfs_trans_reserve() dereferences
> > its first argument unconditionally.
> > 
> > And if the memory allocation for 'tp' goes well (and thus
> > xfs_trans_reserve() does not explode) then we may leak the memory
> > allocated to 'tp' if xfs_trans_reserve() returns error.
> > 
> > I believe this patch should fix both issues, but I'm not intimate with
> > the XFS code at all, so there can easily be something I overlooked or
> > something that should be done differently than what I did.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> > fs/xfs/xfs_iops.c |    7 ++++++-
> > 1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > Note:
> >  Please review carefully before applying.
> >  Especially since I don't currently have any XFS filesystems to test
> >  this on, nor any clear idea of a good way to actually test this if I
> >  had. So this patch is compile tested only on my end.
> > 
> > diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> > index ab30253..194c9d7 100644
> > --- a/fs/xfs/xfs_iops.c
> > +++ b/fs/xfs/xfs_iops.c
> > @@ -575,9 +575,14 @@ xfs_setattr_nonsize(
> > 	}
> > 
> > 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
> > +	if (!tp)
> > +		goto out_dqrele;
> > +
> > 	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
> > -	if (error)
> > +	if (error) {
> > +		xfs_trans_cancel(tp, 0);
> > 		goto out_dqrele;
> > +	}
> > 
> > 	xfs_ilock(ip, XFS_ILOCK_EXCL);
> > 
> > -- 
> > 1.7.9
> > 
> > 
> > Please CC me on replies.
> > 
[...]
> 
> The first one won't be triggered because kmem_zone_alloc (the last one in call
> chain) checks for 
>     if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> 
> whereas xfs_trans_alloc  calls _xfs_trans_alloc with KM_SLEEP, also all other
> callers of _xfs_trans_alloc call it with KM_SLEEP (except one which calls with
> KM_NOFS), so it looks like we are safe there, it keeps spinning till it finds
> mem.
> 
Good.

> 
> As far as second one is concerned, looks fine, though this one should also do
> the same.
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ab30253..d331f5b 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -730,9 +730,9 @@ xfs_setattr_nonsize(
>         return 0;
> 
> out_trans_cancel:
> -       xfs_trans_cancel(tp, 0);
>         xfs_iunlock(ip, XFS_ILOCK_EXCL);
> out_dqrele:
> +       xfs_trans_cancel(tp, 0);
>         xfs_qm_dqrele(udqp);
>         xfs_qm_dqrele(gdqp);
>         return error;
> 

Thank you for the feedback.

I worry about the fact that this suddenly calls xfs_trans_cancel() without 
holding the lock. I don't know if that's actually significant though. 

If it *is* significant, then I think the patch I just submitted in reply to 
Dave Chinner is better since there we do the alloc and cancel before even 
taking the lock at all in the leaky case and all other case have 
identical behaviour as before.
If it is *not* significant then your patch is probably better since that 
means one less thing done while holding a lock.

But I don't know enough XFS details to say which it is, so I'll leave it 
to someone else to pick the best patch of the two for this.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
