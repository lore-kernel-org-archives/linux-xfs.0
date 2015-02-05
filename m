Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2DE388028
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 16:18:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1906E8F8059
	for <xfs@oss.sgi.com>; Thu,  5 Feb 2015 14:18:40 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	cpKHun1u4ORA5TkD for <xfs@oss.sgi.com>;
	Thu, 05 Feb 2015 14:18:38 -0800 (PST)
Date: Fri, 6 Feb 2015 09:18:25 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/7 V2] xfs: use generic percpu counters for icsb
Message-ID: <20150205221825.GU4251@dastard>
References: <1423083249-27493-1-git-send-email-david@fromorbit.com>
	<20150205140840.GB31625@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150205140840.GB31625@laptop.bfoster>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Feb 05, 2015 at 09:08:40AM -0500, Brian Foster wrote:
> On Thu, Feb 05, 2015 at 07:54:02AM +1100, Dave Chinner wrote:
> > Hi folks,
> > 
> > This is the second version of the generic per-cpu counter rework
> > patch series. The first version can be found here:
> > 
> > http://oss.sgi.com/archives/xfs/2015-02/msg00000.html
> > 
> > New in V2:
> > 
> > - drop the moving of the struct xfs_sb to xfs_super.h
> > - fixed all the little things that Christoph and Brian noted.
> > - keep the per-cpu counters in the struct xfs_mount and keep the
> >   functions to sync them with the struct xfs_sb values when read
> >   from disk or written to disk.
> > - integrated Christoph Hellwig's additional cleanup patch. This was
> >   done by:
> > 	- intergating xfs_mod_XXX factoring into the relevant percpu
> > 	  counter conversion patch
> > 	- separating out xfs_mod_frextents into it's won patch
> > 	- separating out the replacement of
> > 	  xfs_mod_incore_sb_batched
> > 	- doing all the now unused API removal in a separate patch
> > 
> > The series passes xfstests without regressions, and no scalability
> > issues have been seen in my performance tests on a 16p VM. SGI - you
> > still need to test this, though. :)
> > 
> > Thoughts, comments?
> > 
> 
> All in all this looks pretty good to me save a couple notes pointed out
> in the patches. In a quick test, this handles the imaxct overshoot
> problem Eric noted much better than the current implementation. That
> said, it's still not precise.

Right.

> My understanding is that's fine, but I wonder if we want to tack on a
> variant of Eric's original patch as well so when we still do overshoot
> imaxpct (albeit by much less than before: I reproduce an overshoot of
> <100 inodes vs several thousand) we at least report an accurate inode
> count. Thoughts?

Yes, Eric's patch is still necessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
