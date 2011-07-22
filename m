Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MLWYlB107313 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:32:34 -0500
Subject: Re: [PATCH 03/12] xfs: Remove the macro XFS_BUF_ERROR and family
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1311369055.2771.139.camel@doink>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003254.21069.27101.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311363490.2771.98.camel@doink>
	<1311367796.3210.971.camel@chandra-lucid.beaverton.ibm.com>
	<1311369055.2771.139.camel@doink>
Date: Fri, 22 Jul 2011 16:30:30 -0500
Message-ID: <1311370230.2771.147.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: sekharan@us.ibm.com
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

Looking my message again, I think I may have gotten confused
along the way.

. . .

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

The comment above I stand by.  But the next one I think
applies to another hunk of code.

In any case, hopefully you understand what my point
is and you'll be able to update your patch accordingly.

Sorry for the confusion.

					-Alex

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


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
