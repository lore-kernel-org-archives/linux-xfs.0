Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8T64QcW025718 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 01:04:26 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7451A1884631
	for <xfs@oss.sgi.com>; Tue, 28 Sep 2010 23:05:23 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	cSnAGYXgd4jwrEax for <xfs@oss.sgi.com>;
	Tue, 28 Sep 2010 23:05:23 -0700 (PDT)
Date: Wed, 29 Sep 2010 16:05:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: The segment fault with NULL point using when recovering failure
Message-ID: <20100929060509.GL5665@dastard>
References: <AANLkTimR-dBLmQQ-Nh0mmjHJMfFidePKxfO6P76y48n8@mail.gmail.com>
	<20100917014412.GK24409@dastard>
	<AANLkTi=mGBXYLgwL96VqtF+8eMCxu83mz0V5719YPrkH@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <AANLkTi=mGBXYLgwL96VqtF+8eMCxu83mz0V5719YPrkH@mail.gmail.com>
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
To: Mike Gao <ygao.linux@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

[Mike, please don't top-post responses - it makes it really hard to
quote properly. ]

On Fri, Sep 24, 2010 at 10:53:43AM -0500, Mike Gao wrote:
> On Thu, Sep 16, 2010 at 8:44 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Wed, Sep 15, 2010 at 10:59:07AM -0500, Mike Gao wrote:
> > > xlog_recover_process_iunlinks(
> > >     xlog_t        *log)
> > > {
> > >                 /*
> > >                  * Reacquire the agibuffer and continue around
> > >                  * the loop. This should never fail as we know
> > >                  * the buffer was good earlier on.
> > >                  */
> > >                 error = xfs_read_agi(mp, NULL, agno, &agibp);
> > >                 ASSERT(error == 0);
> > >                 agi = XFS_BUF_TO_AGI(agibp);
> > >
> > > }
> > > If no defined DEBUG, ASSERT will not work and agibp could be ZERO if
> > there
> > > is a error in xfs_read_agi.
> > > And the comment shouldn't say it never fail because  xfs_read_agi will
> > > return error in function and it does when there is forced shutdown.
> >
> > Have you seen a failure here?
>
> I am curious about how this happens.

What, how a failure happens there? The ASSERT is saying that a
failure should never happen there....

> This error is caused by log recovery when mount try to fill super block. As
> super block is protected by log or Journaling, it shouldn't be corrupted or
> can't be recovery by journaling.

I'm not sure I follow you here - the above is reading an AGI, not a
superblock. What is the stack trace that you've seen?

> Anyway, this is reported as XFS INTERNAL ERROR.
> 
> XFS internal error XFS_WANT_CORRUPTED_GOTO at line 4147 of file
> fs/xfs/xfs_bmap.c.  Caller 0x871b9c26

That is from a corrupted bmap btree, which has no connection to
the AGI. I'm confused by what problems you are trying to report.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
