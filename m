Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6PBYgP4056514 for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 06:34:42 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4822946FC04
	for <xfs@oss.sgi.com>; Sun, 25 Jul 2010 04:37:43 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	vHihZRoAXNr6dSrK for <xfs@oss.sgi.com>;
	Sun, 25 Jul 2010 04:37:43 -0700 (PDT)
Date: Sun, 25 Jul 2010 21:37:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/3] serialise concurrent direct IO sub-block zeroing
Message-ID: <20100725113740.GA655@dastard>
References: <1279881678-1660-1-git-send-email-david@fromorbit.com>
	<4C49EB67.6020509@sandeen.net> <20100724000946.GK32635@dastard>
	<1279969949.4737.3.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279969949.4737.3.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Sat, Jul 24, 2010 at 06:12:29AM -0500, Alex Elder wrote:
> On Sat, 2010-07-24 at 10:09 +1000, Dave Chinner wrote:
> > On Fri, Jul 23, 2010 at 02:20:07PM -0500, Eric Sandeen wrote:
> > > Dave Chinner wrote:
> > > > Patches for discussion seeing as git.kernel.org is being slow to update.
> > > > 
> > > 
> > > I can confirm that this fixes the qemu problems, too.
> > > 
> > > Also makes the install take about 30min vs. 10 ;)
> > 
> > Yeah, that's no surprise - it'll be serialising all the IO even when
> > it doesn't need to. Good to know that we've found the cause of the
> > problem, though, so we can work from here towards a more robust
> > solution.
> 
> The patchesmade test 240 in the xfstests suite pass when
> it consistently did not for me without it.
> 
> However I found that test 104 hung the two times I tried it.
> At first I thought it could have been just taking a long time
> but the fsstress processes were unkillable and shutdown
> didn't complete either.  I tried again after removing the
> patches and 104 passed again.

Yeah, the patch series was an RFC for a reason ;)

Basically that approach is not going to work. From #xfs:

[2010-07-24 11:13] <dchinner> sandeen, hch: I've reproduced the 104 hang with my test patches - it's definitely a real hang
[2010-07-24 11:19] <dchinner> it's ENOSPC related - xfs_flush_inodes() is stuck in xfs_ioend_wait(), while there is a direct IO in xfs_get_blocks_direct waiting on xfs_ioend_wait_excl
[2010-07-24 11:20] <dchinner> so everything is stuck behind xfssyncd which will never see a zero inode iocount becuse of the direct IO waiting holding a count.
[2010-07-24 11:21] <dchinner> it's fsstress running at ENOSPC that generates the problem, not the growfs operation
[2010-07-24 11:22] <dchinner> I think we can call my POC demonstration DOA in terms of fixing the problem.....
[2010-07-24 11:24] <dchinner> the locking is suspect and the wait-while-holding-on-iocount idea results in a pretty nasty landmine.
[2010-07-24 11:49] <sandeen_> hrm
[2010-07-24 11:49] <sandeen_> fwiw, I was not surprised  or compliaining about the slowness of the install ...  :)
[2010-07-24 12:08] <sandeen_> maybe we can just declare unaligned AIO unsupported
[2010-07-24 12:08] <sandeen_> change the granularity back to block sized; it'll suck really bad in -any- case
[2010-07-24 12:12] <dchinner> sandeen_: I think we're going to have to track unaligned IOs and wait on them when an overlap occurs - that will only cause slowdowns when overlaps occur
[2010-07-24 12:12] <dchinner> and it doesn't have all the nastiness that my get_blocks hack has
[2010-07-24 12:14] <dchinner> I might even be able to contain it solely within the generic dio code

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
