Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MLX8u1107348 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:33:08 -0500
Received: from e33.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 916EB180D7ED
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:33:07 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151]) by
	cuda.sgi.com with ESMTP id uGbSab9eFrvr1jfy for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:33:07 -0700 (PDT)
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6MLPPHY024854
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 15:25:25 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6MLVfM9095714 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 15:31:42 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6MFVecu020070
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 09:31:40 -0600
Subject: Re: [PATCH 03/12] xfs: Remove the macro XFS_BUF_ERROR and family
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1311369055.2771.139.camel@doink>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003254.21069.27101.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311363490.2771.98.camel@doink>
	<1311367796.3210.971.camel@chandra-lucid.beaverton.ibm.com>
	<1311369055.2771.139.camel@doink>
Date: Fri, 22 Jul 2011 14:31:39 -0700
Message-ID: <1311370299.3210.980.camel@chandra-lucid.beaverton.ibm.com>
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

On Fri, 2011-07-22 at 16:10 -0500, Alex Elder wrote:
> On Fri, 2011-07-22 at 13:49 -0700, Chandra Seetharaman wrote:
> > Thanks for the review Alex.
> > 
> > See below for comments.
> > 
> > On Fri, 2011-07-22 at 14:38 -0500, Alex Elder wrote:
> > > On Thu, 2011-07-21 at 17:32 -0700, Chandra Seetharaman wrote:
> > > > Remove the definitions and usage of the macros XFS_BUF_ERROR,
> 
> . . .
> 
> > > > diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
> > > > index 837f311..e7e35fb 100644
> > > > --- a/fs/xfs/quota/xfs_dquot.c
> > > > +++ b/fs/xfs/quota/xfs_dquot.c
> > > > @@ -403,7 +403,8 @@ xfs_qm_dqalloc(
> > > >  			       dqp->q_blkno,
> > > >  			       mp->m_quotainfo->qi_dqchunklen,
> > > >  			       0);
> > > > -	if (!bp || (error = XFS_BUF_GETERROR(bp)))
> > > > +	error = xfs_buf_geterror(bp);
> > > > +	if (error)
> > > >  		goto error1;
> > > >  	/*
> > > >  	 * Make a chunk of dquots out of this buffer and log
> > > 
> > > This results in behavior that differs from before.
> > > Previously, error would have value 0 following
> > > the call to xfs_trans_get_buf() here, meaning that
> > > (at error1:) xfs_qm_dqalloc() would return 0 in
> > > this case.  Now it will return ENOMEM.
> > > 
> > > I think what you have done may be correct, but
> > > since the change does more than the simple
> > > macro transformation you intend, this change
> > > should be done in a separate commit.
> > > 
> > > So either:
> > > - post a new patch (preferably before this
> > >   whole series) that makes this code return
> > >   ENOMEM if xfs_trans_get_buf() returns a
> > >   null pointer, then update this patch accordingly;
> > 
> > Will it this way and resent the patch
> > xfs_buf_geterror
> 
> I don't grok that "sentence" and I'm not sure whether
> you are referring to the one above or below.
> 

Sorry, something got eaten up...

I meant to say, "will do it this way and resend the patch".

> > > - or just change this patch to return 0 instead
> > >   of  ENOMEM if xfs_trans_get_buf() returns a
> > >   null pointer.
> > > 
> > > . . .
> > > 
> > > > diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> > > > index 88d1214..97daa35 100644
> > > > --- a/fs/xfs/xfs_vnodeops.c
> > > > +++ b/fs/xfs/xfs_vnodeops.c
> > > > @@ -83,7 +83,7 @@ xfs_readlink_bmap(
> > > >  
> > > >  		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt),
> > > >  				  XBF_LOCK | XBF_MAPPED | XBF_DONT_BLOCK);
> > > 
> > > xfs_buf_read() can return NULL here, so to match
> > > the existing behavior you should call xfs_buf_geterror()
> > > here.
> > > 
> > > > -		error = XFS_BUF_GETERROR(bp);
> > > > +		error = bp->b_error;
> > > >  		if (error) {
> > > >  			xfs_ioerror_alert("xfs_readlink",
> > > >  				  ip->i_mount, bp, XFS_BUF_ADDR(bp));
> > 
> > I did the change consciously. If bp were NULL, error would have been set
> > to ENOMEM, and xfs_ioerror_alert() and xfs_buf_relse(), would have
> > accessed bp and tripped anyways. So, I felt using the indirection
> > (xfs_buf_geterror()) is not adding any value, hence set error by
> > directly accessing b_error.
> 
> But you are dereferencing a possibly null pointer in the
> code you added.  Yes, the code that was already there
> should not dereference it either, but that's no excuse
> for you to do it.  (And fix the other code while you're
> there, or make a note to get it fixed later.)
> 
> The reason it's important here is that the value of error
> gets passed back to the caller, and although I didn't
> go very far back to see what effect it has, a quick look
> showed that it might lead to different behavior.  As I
> said, it might be *correct* behavior, but in any case it's
> different, so it belongs in its own commit.
> 
> > There are more place like these.
> 
> I noticed you doing this sort of thing in a bunch of other
> spots in your patch, and in all of them they seemed to
> follow a test that ensured the buffer pointer was non-null
> (or it was implicit, because some *prior* dereference of
> the pointer would have been a problem) therefore simply
> checking bp->b_error was a fine replacement.
> 
> But in this one spot, it's a bit different, so I called
> attention to it.
> 
> If you are convinced I'm mistaken and this will produce
> results identical to before, say so and I'll take a
> closer look. 
> 
> > What do you think of this option
> > 
> > Leave this as is (with b_error), and send another patch to check for bp
> > after xfs_buf_read() in all places (if you want this option, what do you
> > think error should be set to, I see both EIO and ENOMEM used. I think it
> > should be the same always).
> > 
> > If you don't like that option I can revert to xfs_buf_geterror() too.
> 
> I think using xfs_buf_geterror() is the easiest thing
> to do right now.  Changing it such that xfs_readlink_bmap()
> returns ENOMEM in the event xfs_buf_read() here returns a null
> pointer sounds like a reasonable thing to do, but do it in
> a separate patch that focuses on that change and why it's
> correct.  And (despite what I said earlier) I guess do it
> *after* we've got this series in.  I'm about ready to get
> it committed once you get it updated.

I will do it the way you suggested and send a separate patch fixing the
incorrect dereferences.

Thanks

chandra
> 
> 					-Alex
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
