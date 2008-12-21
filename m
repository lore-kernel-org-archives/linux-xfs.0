Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBLGbeUL023605 for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 10:37:41 -0600
Date: Sun, 21 Dec 2008 17:36:33 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 9/13] fs/xfs: Remove redundant test
In-Reply-To: <494E6846.8070800@sandeen.net>
Message-ID: <Pine.LNX.4.64.0812211736150.9555@pc-004.diku.dk>
References: <Pine.LNX.4.64.0812211640360.9555@pc-004.diku.dk>
	<494E6846.8070800@sandeen.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-masters@oss.sgi.com, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

> Looks fine to me, though a similar test under the #ifdef DEBUG can
> probably also be removed.

Indeed.  I will send an updated patch.

julia

> -Eric
> 
> > ---
> >  fs/xfs/xfs_trans_buf.c              |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> > index 8ee2f8c..22afe29 100644
> > --- a/fs/xfs/xfs_trans_buf.c
> > +++ b/fs/xfs/xfs_trans_buf.c
> > @@ -307,7 +307,7 @@ xfs_trans_read_buf(
> >  			return (flags & XFS_BUF_TRYLOCK) ?
> >  					EAGAIN : XFS_ERROR(ENOMEM);
> >  
> > -		if ((bp != NULL) && (XFS_BUF_GETERROR(bp) != 0)) {
> > +		if (XFS_BUF_GETERROR(bp) != 0) {
> >  			xfs_ioerror_alert("xfs_trans_read_buf", mp,
> >  					  bp, blkno);
> >  			error = XFS_BUF_GETERROR(bp);
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
