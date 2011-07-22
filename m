Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MKo54W105737 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 15:50:06 -0500
Received: from e33.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B8FC180D791
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 13:50:04 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id McriNxGF7XkfTXS7 for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 13:50:04 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6MKgLS5017344
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:42:21 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6MKo1hh179902 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:50:01 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6MEnXbI006733
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 08:49:34 -0600
Subject: Re: [PATCH 03/12] xfs: Remove the macro XFS_BUF_ERROR and family
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1311363490.2771.98.camel@doink>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003254.21069.27101.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311363490.2771.98.camel@doink>
Date: Fri, 22 Jul 2011 13:49:56 -0700
Message-ID: <1311367796.3210.971.camel@chandra-lucid.beaverton.ibm.com>
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
Cc: xfs@oss.sgi.com

Thanks for the review Alex.

See below for comments.

On Fri, 2011-07-22 at 14:38 -0500, Alex Elder wrote:
> On Thu, 2011-07-21 at 17:32 -0700, Chandra Seetharaman wrote:
> > Remove the definitions and usage of the macros XFS_BUF_ERROR,
> > XFS_BUF_GETERROR and XFS_BUF_ISERROR.
> > 
> > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> 
> Nice work on this.  It is clear it was thoughtfully
> done.
> 
> I have two things that need to be fixed.  If you do that
> you can consider this signed off by me.xfs_buf_geterror
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> . . .
> 
> > diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
> > index 837f311..e7e35fb 100644
> > --- a/fs/xfs/quota/xfs_dquot.c
> > +++ b/fs/xfs/quota/xfs_dquot.c
> > @@ -403,7 +403,8 @@ xfs_qm_dqalloc(
> >  			       dqp->q_blkno,
> >  			       mp->m_quotainfo->qi_dqchunklen,
> >  			       0);
> > -	if (!bp || (error = XFS_BUF_GETERROR(bp)))
> > +	error = xfs_buf_geterror(bp);
> > +	if (error)
> >  		goto error1;
> >  	/*
> >  	 * Make a chunk of dquots out of this buffer and log
> 
> This results in behavior that differs from before.
> Previously, error would have value 0 following
> the call to xfs_trans_get_buf() here, meaning that
> (at error1:) xfs_qm_dqalloc() would return 0 in
> this case.  Now it will return ENOMEM.
> 
> I think what you have done may be correct, but
> since the change does more than the simple
> macro transformation you intend, this change
> should be done in a separate commit.
> 
> So either:
> - post a new patch (preferably before this
>   whole series) that makes this code return
>   ENOMEM if xfs_trans_get_buf() returns a
>   null pointer, then update this patch accordingly;

Will it this way and resent the patch
xfs_buf_geterror
> - or just change this patch to return 0 instead
>   of  ENOMEM if xfs_trans_get_buf() returns a
>   null pointer.
> 
> . . .
> 
> > diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> > index 88d1214..97daa35 100644
> > --- a/fs/xfs/xfs_vnodeops.c
> > +++ b/fs/xfs/xfs_vnodeops.c
> > @@ -83,7 +83,7 @@ xfs_readlink_bmap(
> >  
> >  		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt),
> >  				  XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK);
> 
> xfs_buf_read() can return NULL here, so to match
> the existing behavior you should call xfs_buf_geterror()
> here.
> 
> > -		error = XFS_BUF_GETERROR(bp);
> > +		error = bp->b_error;
> >  		if (error) {
> >  			xfs_ioerror_alert("xfs_readlink",
> >  				  ip->i_mount, bp, XFS_BUF_ADDR(bp));

I did the change consciously. If bp were NULL, error would have been set
to ENOMEM, and xfs_ioerror_alert() and xfs_buf_relse(), would have
accessed bp and tripped anyways. So, I felt using the indirection
(xfs_buf_geterror()) is not adding any value, hence set error by
directly accessing b_error.

There are more place like these.

What do you think of this option

Leave this as is (with b_error), and send another patch to check for bp
after xfs_buf_read() in all places (if you want this option, what do you
think error should be set to, I see both EIO and ENOMEM used. I think it
should be the same always).

If you don't like that option I can revert to xfs_buf_geterror() too.

> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
