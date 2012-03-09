Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q290HFfa110026 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 18:17:15 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WGIHEBHni0VQAFRW for <xfs@oss.sgi.com>;
	Thu, 08 Mar 2012 16:17:13 -0800 (PST)
Date: Fri, 9 Mar 2012 11:17:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: df bigger than ls?
Message-ID: <20120309001710.GR5091@dastard>
References: <20120307155439.GA23360@nsrc.org> <20120307171619.GA23557@nsrc.org>
	<4F57A32A.5010704@sandeen.net> <20120308021054.GM3592@dastard>
	<20120308162348.GT7762@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120308162348.GT7762@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Brian Candler <B.Candler@pobox.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Thu, Mar 08, 2012 at 10:23:48AM -0600, Ben Myers wrote:
> On Thu, Mar 08, 2012 at 01:10:54PM +1100, Dave Chinner wrote:
> > On Wed, Mar 07, 2012 at 12:04:26PM -0600, Eric Sandeen wrote:
> > > and repeat the above test 3 times, the 3rd run gets ENOSPC, and
> > > the last file written comes up short, while the first one retains
> > > all it's extra preallocated space:
> > > 
> > > # du -hc bigfile* 2.0G	bigfile1 1.1G	bigfile2 907M
> > > bigfile3
> > > 
> > > Dave, is this working as intended?
> > 
> > Yes. Your problem is that you have a very small filesystem, which is
> > not the case that we optimise XFS for. :/
> 
> I have seen a similar problem on some very large filesystems too.

So report the problems to the list, don't keep them to yourself. If
we don't hear about problems, then as far as we are concerned they
don't exist.

> This
> is not just dependent upon the size of the filesystem, but also the
> workload.  I think it is also a big problem for folks using quotas.

Nobody has reported significant quota problems, either....

> Alex and I discussed this problem briefly awhile ago.  What is the best
> way to lose when you hit ENOSPC (project quotas) or EDQUOT in
> xfs_iomap_write_delay?  You want to be fair; one user hitting his quota
> shouldn't be able to steal some other user's block reservations unless
> you really are near ENOSPC for the entire filesystem.  
> 
> I suggested something like... track inodes with preallocated block
> reservations in LRU order and by dquot, so that the poor fella who is at
> EDQUOT will first clean up the preallocations that resulted in quota
> being enforced, try again, and then work on preallocations of other
> users only if it can help in his situation.  IIRC Alex shut me down when
> he heard LRU.  ;)

And I agree with Alex. Nothing additional needs to be tracked on top
of inodes with speculative prealloc. Just the search filter would
need to be different (i.e. only select inodes with a specific dquot
attached).

> Now that block reservations count toward quotas the symptom will
> probably be a little different.

Block reservations have always counted towards quotas, it's just
that they were never reported.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
