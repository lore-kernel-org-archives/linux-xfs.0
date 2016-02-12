Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 83CCD7F3F
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 16:49:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 184ADAC002
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 14:49:39 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	RL3xFZbz5eyc0bpB for <xfs@oss.sgi.com>;
	Fri, 12 Feb 2016 14:49:36 -0800 (PST)
Date: Sat, 13 Feb 2016 09:49:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/32] dio: unwritten conversion bug tests
Message-ID: <20160212224932.GZ14668@dastard>
References: <20160211233916.2202.40961.stgit@birch.djwong.org>
	<20160211234037.2202.93885.stgit@birch.djwong.org>
	<20160212035253.GX14668@dastard> <20160212152231.GA7928@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160212152231.GA7928@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: xfs@oss.sgi.com, fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>

On Fri, Feb 12, 2016 at 10:22:31AM -0500, Theodore Ts'o wrote:
> On Fri, Feb 12, 2016 at 02:52:53PM +1100, Dave Chinner wrote:
> > On Thu, Feb 11, 2016 at 03:40:37PM -0800, Darrick J. Wong wrote:
> > > Check that we don't expose old disk contents when a directio write to
> > > an unwritten extent fails due to IO errors.  This primarily affects
> > > XFS and ext4.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > aiocp.c: In function 'main':
> > aiocp.c:407:1: warning: format '%d' expects argument of type 'int', but argument 3 has type 'off_t' [-Wformat=]
> >  printf("tocopy=%d len=%d blk=%d\n", tocopy, length, aio_blksize);
> >  ^
> > 
> > Followup patch is fine, I'll commit as is.
> 
> Dave, given that Darrick's patches is going to cause more
> _scratch_mount occurences, how quickly do you plan to commit his
> patchset?  Should I wait until he makes his change before I do the
> s/_scratch_mount/_scratch_cycle_mount/ change?  Should I make that
> change, and let you fix it up the commit?

I had to head out suddenly yestrday afternoon, just after I sent
above email. Only just got back in front of the computer, so I'll be
pushing it out once the new pull has run through a sanity check.

If you can respin the patch once I've done that, it would be greatly
appreciated.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
