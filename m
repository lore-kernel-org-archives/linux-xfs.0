Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A30C97F4E
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 06:54:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8E7B2304051
	for <xfs@oss.sgi.com>; Tue,  1 Apr 2014 04:54:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KsciK53ZErrA9imn for
	<xfs@oss.sgi.com>; Tue, 01 Apr 2014 04:54:11 -0700 (PDT)
Date: Tue, 1 Apr 2014 07:54:08 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC, PATCH 0/6] xfs: delalloc, DIO and corruption....
Message-ID: <20140401115408.GA21540@bfoster.bfoster>
References: <1395396710-3824-1-git-send-email-david@fromorbit.com>
	<20140331172243.GB63718@bfoster.bfoster>
	<20140331201757.GC17603@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140331201757.GC17603@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Viro@disappointment.disaster, viro@ZenIV.linux.org.uk, Al@disappointment.disaster

On Tue, Apr 01, 2014 at 07:17:57AM +1100, Dave Chinner wrote:
> On Mon, Mar 31, 2014 at 01:22:43PM -0400, Brian Foster wrote:
> > On Fri, Mar 21, 2014 at 09:11:44PM +1100, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > This patch series mostly shuts a can of worms that Al opened when he
> > > found the cause of the generic/263 fsx failures. The fix for that is
> > > patch 6 of this series, but, well, there are a bunch of other
> > > problems that need to be fixed before making that change.
> > > 
> > > Basically, the direct Io block mapping behaviour was covering up a
> > > bunch of other bugs in the delayed allocation extent/page cache
> > > state coherency mappings. Essentially, we punch out the page cache
> > > in quite a few places without first cleaning up delayed allocation
> > > extents over that range and that exposes all sorts of nasty issues
> > > once the direct IO mapping changes are made.  All of these are
> > > existing problems, most of them are very unlikely to be seen in the
> > > wild.
> > > 
> > > This patch set passes xfstests on a 4k block size/4k page size
> > > config with out problems. However, there is still a fsx failure in
> > > generic/127 on 1k block size/4k page size configurations that I
> > > haven't yet tracked down. That test was failing occasionally before
> > > this patch set as well, so it may be a completely unrelated problem.
> > > 
> > > The sad fact of this patchset is it is mostly playing whack-a-mole
> > > with visible symptoms of bugs.  It drives home the fact that
> > > bufferheads and the keeping of internal filesystem state attached to
> > > the page cache simply isn't a verifiable architecture.  After
> > > spending several days of doing nothing else but tracking down these
> > > inconsistencies i can only conclude that the code is complex,
> > > fragile and extremely difficult to verify that behaviour is correct.
> > > As such, I doubt that the fixes are entirely correct, so I'm left
> > > with using fsx and fsstress to tell me if I've broken anything.
> > > 
> > > Eyeballs appreciated, as is test results.
> > > 
> > 
> > I had an xfstests running against this (on for-next) over the weekend
> > and it hit the following bug on xfs/297:
> > 
> > [ 6408.168767] kernel BUG at fs/xfs/xfs_aops.c:1336!
> > [ 6408.169542] invalid opcode: 0000 [#1] SMP 
> 
> Ok, so that's found another stale delalloc range where there
> shouldn't be. I know there were still problems when I left because
> generic/127 was failing on 1k block size filesystems, but I haven't
> yet had a chance to get back to determine if the bug was the broken
> code in xfs_check_page_types() that Dan Carpenter noticed. Were you
> running with that fix?
> 

Ah, good point. I was running with the check_page_type() rework, but not
the most recent fix. I'll plan to test again with that included.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
