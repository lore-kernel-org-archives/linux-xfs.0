Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q96HaKuq012208 for <xfs@oss.sgi.com>; Sat, 6 Oct 2012 12:36:20 -0500
Date: Sat, 6 Oct 2012 12:37:45 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [patch v4 00/13] xfs: remove the xfssyncd mess
Message-ID: <20121006173745.GP13214@sgi.com>
References: <20121005171853.985930109@sgi.com> <20121006013122.GF23644@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121006013122.GF23644@dastard>
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
Cc: xfs@oss.sgi.com

Hi Dave,

On Sat, Oct 06, 2012 at 11:31:22AM +1000, Dave Chinner wrote:
> On Fri, Oct 05, 2012 at 12:18:53PM -0500, Ben Myers wrote:
> > Hi Dave,
> > 
> > Here I am reposting your xfssyncd series.  I want to make sure that
> > we're all on the same page.  In particular, are we all happy with patch
> > 6, 'xfs: xfs_sync_data is redundant'?
> > 
> > Version 4:
> > - updated 'xfs: xfs_sync_data is redundant' with cleanups to the 
> >   xfs_flush_inodes interface as per Christoph's request,
> > - updated 'xfs: xfs_sync_data is redundant', folding in changes from 
> >   http://oss.sgi.com/archives/xfs/2012-10/msg00036.html 
> > - fixed a minor typo in xfs: 'syncd workqueue is no more', renaming the 
> >   log worker from 'xfs-reclaim' to 'xfs-log'.
> > 
> > I was going to rush this in for the 3.7 merge window.  However in the
> > light of the issues with patch 6 and Linus's comment here:
> > http://lkml.org/lkml/2012/9/30/152 and Stephen's comment here:
> > https://lkml.org/lkml/2012/9/23/144, I think it wiser to behave.  3.7
> > is stable without this series, so I will merge it for 3.8.
> > 
> > Once we have an agreement that patch 6 is ready I will pull this in to the
> > master branch first thing after the 3.7-rc1 merge from upstream.
> 
> <sigh>
> 
> Seriously?

Take it as good news.  Brian found the regression and put the brakes on before
I pulled it in.  My regret in this is that SGI didn't find it first.  We have a
very stable 3.7 release, one less regression, and a full release cycle to test
this series in the master branch.  That is a pretty good outcome for XFS users.

> Why am I only finding out that there needs to be more
> rework to patches in this series after someone else reposted them?

You aren't.  There are currently two pending suggestions for the series, and
apparently one has been around for awhile:

1) 'xfs: sync work is now only periodic log work'
HCH: "I still think queueing the work item here if we return a failure is
the wrong thing to do."

This issue was mentioned before I reposted your series:
http://oss.sgi.com/archives/xfs/2012-09/msg00046.html From Mark on Sep 4
http://oss.sgi.com/archives/xfs/2012-09/msg00465.html From HCH on Sep 28

That is just a missed opportunity after the initial suggestion from Mark.  It
happens.  I had planned to pull it in anyway. That is probably not the best
judgement on my part.

2) 'xfs: xfs_sync_data is redundant.'
HCH: (on xfs_flush_inodes) "It's more than a trivial wrapper now, so I'd
suggest to move out of line to e.g.  xfs_super.c"

This one is my fault.  I might have considered moving xfs_flush_inodes out of
xfs_mount.h when I folded your other patch in.  I hope you don't mind fixing
that up.

> And that this is the cause of it missing the merge window?

The regression is the only reason this missed the merge window.  I was ready to
push the series to -next when Brian pulled the cord.

According Linus and Stephens comments we should have content in -next by -rc7.
Clearly there is some flex in that system but I have no desire to find its
limit, and I think that this experience proves their point.  Lesson learned!  I
will be more conservative regarding the merge window in the future.

I'm giving this series some soak time with the new fix.  I can't pull it in
with the new fix for the regression until we have some testing.  Once we have
some confidence in it I will push it up to oss.  

My understanding is that work for 3.8 should not be added to -next during the
merge window for 3.7-rc1, so you have plenty of time to address
Mark&Christoph's concern.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
