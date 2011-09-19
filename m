Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8JIYmJf006924 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 13:34:48 -0500
Received: from e39.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB50A550C28
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 11:34:47 -0700 (PDT)
Received: from e39.co.us.ibm.com (e39.co.us.ibm.com [32.97.110.160]) by
	cuda.sgi.com with ESMTP id ghd8zjOmhsrw5Q7E for
	<xfs@oss.sgi.com>; Mon, 19 Sep 2011 11:34:47 -0700 (PDT)
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by e39.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8JIJ2IA007591
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 12:19:02 -0600
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p8JIYaQY193274 for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 12:34:36 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p8JIYLxg014118
	for <xfs@oss.sgi.com>; Mon, 19 Sep 2011 12:34:21 -0600
Subject: Re: [PATCH] xfs: check the return value of xfs_trans_get_buf()
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1316450213.2941.20.camel@doink>
References: <1315411298.9298.5.camel@chandra-lucid.austin.ibm.com>
	<1316450213.2941.20.camel@doink>
Date: Mon, 19 Sep 2011 13:34:34 -0500
Message-ID: <1316457274.9298.52.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: aelder@sgi.com
Cc: XFS Mailing List <xfs@oss.sgi.com>

Thanks for the review, Alex.

On Mon, 2011-09-19 at 11:36 -0500, Alex Elder wrote:
> On Wed, 2011-09-07 at 11:01 -0500, Chandra Seetharaman wrote:
> > Check the return value of xfs_trans_get_buf() and fail appropriately.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> Sorry it took a while to get to this.
> 
> I started following back some of the paths that
> now (with your patch) return ENOMEM where they
> might not have before.  But I soon gave up because
> it explodes a bit in the number of possibilities.
> I did verify that the places that now return ENOMEM

Yes, I did check the callers to verify that they handle errors.

> have callers that check for an error return, so I'm
> going to just trust that's OK and that you have
> ensured there aren't any spots that do something
> unwanted in the event ENOMEM gets returned.
> 
> I did find something that may be a problem, so
> I'd like you to take another look and either
> explain why it's OK, or send an update to correct
> it.
> 
> Thanks.
> 
> 					-Alex
> 
> . . .
> 
> > diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> > index c2ff0fc..a4f3624 100644
> > --- a/fs/xfs/xfs_vnodeops.c
> > +++ b/fs/xfs/xfs_vnodeops.c
> > @@ -308,6 +308,8 @@ xfs_inactive_symlink_rmt(
> >  		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
> >  			XFS_FSB_TO_DADDR(mp, mval[i].br_startblock),
> >  			XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0);
> > +		if (!bp) 
> > +			goto error1;
> 
> In this function, simply going to error1 will result
> in a 0 getting returned to the caller, because error
> had value 0 at this point.  I think you want something
> more like:

oops. overlook on my part. Sorry, about that. will fix it.

> 			if (!bp) {
> 				error = ENOMEM;
> 				goto error1;
> 			}
> 
> 
> >  		xfs_trans_binval(tp, bp);
> >  	}
> >  	/*
> > @@ -1648,7 +1650,8 @@ xfs_symlink(
> >  			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
> >  			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
> >  					       BTOBB(byte_cnt), 0);
> > -			ASSERT(!xfs_buf_geterror(bp));
> > +			if (!bp)
> > +				goto error2;
> 
> Same thing here.  I think you want to set error to
> something before the "goto error2".

Same here.
> 
> >  			if (pathlen < byte_cnt) {
> >  				byte_cnt = pathlen;
> >  			}
> > 
> > 
> > _______________________________________________
> > xfs mailing list
> > xfs@oss.sgi.com
> > http://oss.sgi.com/mailman/listinfo/xfs
> 
> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
