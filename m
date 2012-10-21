Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9LMUnmV255495 for <xfs@oss.sgi.com>; Sun, 21 Oct 2012 17:30:49 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	dqQQORk1qYdovgvV for <xfs@oss.sgi.com>;
	Sun, 21 Oct 2012 15:32:29 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1TQ43q-0002QT-Et
	for xfs@oss.sgi.com; Mon, 22 Oct 2012 09:31:58 +1100
Date: Mon, 22 Oct 2012 09:31:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests 250 fail on newer kernels
Message-ID: <20121021223158.GA2739@dastard>
References: <20121019173730.GA23018@andromeda.usersys.redhat.com>
	<20121019215343.GX2739@dastard>
	<20121020112405.GA652@andromeda.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121020112405.GA652@andromeda.usersys.redhat.com>
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
To: xfs@oss.sgi.com

On Sat, Oct 20, 2012 at 08:24:05AM -0300, Carlos Maiolino wrote:
> On Sat, Oct 20, 2012 at 08:53:43AM +1100, Dave Chinner wrote:
> > On Fri, Oct 19, 2012 at 02:37:30PM -0300, Carlos Maiolino wrote:
> > > Hi,
> > > 
> > > reviewing a patch to xfstests250, I ran it against newer kernels (3.6.0+ and
> > > 3.7.0-rc1) and noticed it is failing. i.e. btree is getting corrupted. 
> > 
> > It's been failing on mainline kernels for a long time. In fact, i
> > think it's been failing since it was created. But it's not failing
> > due to btree corruption - it's failing because mkfs is not leaving
> > enough space in the AG that contains the log for sanity checks to
> > pass. i.e. that there are always a minimum of 4 blocks of freespace
> > in an AG.
> > 
> > This is not actually a problem - the log takes the entire AG, so
> > allocation will never occur in it, so having less than 4 blocks of
> > free space in the AG is just noise in this case. It's never bubbled
> > to the top of my list to fix...
> > 
> > > I'm going to take a look at it, but let me know if anybody has already
> > > found/fixed it.
> > 
> > If it is failing the check_scratch_fs stage, then it is most likely
> > the above issue. The corrupted btree problem that the test was
> > writen for caused the system to ASSERT fail or crash - i.e. it
> > didn't even run to the point of checking the fs....
> > 
> Yep, that was my point, it's failing on check_scratch_fs stage. The btree
> problem has been fixed since it is not triggering the ASSERT. Didn't know it is
> failing since its creation :)
> 
> I can add it to my todo list if you want some stuff out of yours

You can - the simplest thing to do might be just to fix the log size
for the mkfs command to 15MB (i.e. smaller than the AG size) so that
mkfs doesn't use all the space in the AG...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
