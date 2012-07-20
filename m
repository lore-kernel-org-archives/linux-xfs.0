Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6KJT0RC144630 for <xfs@oss.sgi.com>; Fri, 20 Jul 2012 14:29:00 -0500
Date: Fri, 20 Jul 2012 21:28:55 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH][RFC] XFS: Fix mem leak and possible NULL deref in
	xfs_setattr_nonsize()
In-Reply-To: <alpine.LNX.2.00.1202062132410.20117@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1207202127450.23164@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202052220390.32529@swampdragon.chaosbits.net>
	<20120206062319.GB12836@dastard>
	<alpine.LNX.2.00.1202062132410.20117@swampdragon.chaosbits.net>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Raghavendra D Prabhu <raghu.prabhu13@gmail.com>

Ping ?

This issue seems to still be present. Any chance we could merge the patch 
below?

/Jesper

On Mon, 6 Feb 2012, Jesper Juhl wrote:

> On Mon, 6 Feb 2012, Dave Chinner wrote:
> 
> > On Sun, Feb 05, 2012 at 10:23:44PM +0100, Jesper Juhl wrote:
> > > In xfs_setattr_nonsize(), xfs_trans_alloc() gets its memory from
> > > _xfs_trans_alloc() which gets it from kmem_zone_zalloc() which may
> > > fail and return NULL. So this:
> > > 
> > > 	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
> > > 
> > > may result in a NULL 'tp'.
> > > If it does, then the call:
> > > 
> > > 	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
> > > 
> > > with a NULL 'tp' will explode, since xfs_trans_reserve() dereferences
> > > its first argument unconditionally.
> > 
> > xfs_trans_alloc() can't fail. It will sleep forever until the memory
> > allocation succeeds.
> > 
> > There's 35 other places in XFS where this xfs_trans_alloc/
> > xfs_trans_reserve pattern occurs - none of them check whether tp is
> > null, either.
> > 
> > > And if the memory allocation for 'tp' goes well (and thus
> > > xfs_trans_reserve() does not explode) then we may leak the memory
> > > allocated to 'tp' if xfs_trans_reserve() returns error.
> > 
> > yes, that's a problem, though will only happen if a filesystem
> > shutdown occurs between the start of the function and that check.
> > 
> > > 
> > > I believe this patch should fix both issues, but I'm not intimate with
> > > the XFS code at all, so there can easily be something I overlooked or
> > > something that should be done differently than what I did.
> > 
> > Only need to fix the leak of tp.
> > 
> Ok.
> Thank you for the detailed explanation.
> I believe the patch below should do the trick.
> 
> 
> From: Jesper Juhl <jj@chaosbits.net>
> Date: Sun, 5 Feb 2012 22:11:30 +0100
> Subject: [PATCH] XFS: Fix mem leak in xfs_setattr_nonsize()
> 
> If the memory allocation for 'tp' goes well then we will leak the
> memory allocated to 'tp' if xfs_trans_reserve() returns error.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  fs/xfs/xfs_iops.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index ab30253..2fc1600 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -576,8 +576,10 @@ xfs_setattr_nonsize(
>  
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_SETATTR_NOT_SIZE);
>  	error = xfs_trans_reserve(tp, 0, XFS_ICHANGE_LOG_RES(mp), 0, 0, 0);
> -	if (error)
> +	if (error) {
> +		xfs_trans_cancel(tp, 0);
>  		goto out_dqrele;
> +	}
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
