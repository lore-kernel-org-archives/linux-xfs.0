Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q291tvXq112581 for <xfs@oss.sgi.com>; Thu, 8 Mar 2012 19:55:58 -0600
Date: Thu, 8 Mar 2012 19:56:03 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: df bigger than ls?
Message-ID: <20120309015603.GZ8545@sgi.com>
References: <20120307155439.GA23360@nsrc.org> <20120307171619.GA23557@nsrc.org>
	<4F57A32A.5010704@sandeen.net> <20120308021054.GM3592@dastard>
	<20120308162348.GT7762@sgi.com> <20120309001710.GR5091@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120309001710.GR5091@dastard>
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
Cc: Brian Candler <B.Candler@pobox.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Mar 09, 2012 at 11:17:10AM +1100, Dave Chinner wrote:
> On Thu, Mar 08, 2012 at 10:23:48AM -0600, Ben Myers wrote:
> > On Thu, Mar 08, 2012 at 01:10:54PM +1100, Dave Chinner wrote:
> > > On Wed, Mar 07, 2012 at 12:04:26PM -0600, Eric Sandeen wrote:
> Alex and I discussed this problem briefly awhile ago.  What is the best
> > way to lose when you hit ENOSPC (project quotas) or EDQUOT in
> > xfs_iomap_write_delay?  You want to be fair; one user hitting his quota
> > shouldn't be able to steal some other user's block reservations unless
> > you really are near ENOSPC for the entire filesystem.  
> > 
> > I suggested something like... track inodes with preallocated block
> > reservations in LRU order and by dquot, so that the poor fella who is at
> > EDQUOT will first clean up the preallocations that resulted in quota
> > being enforced, try again, and then work on preallocations of other
> > users only if it can help in his situation.  IIRC Alex shut me down when
> > he heard LRU.  ;)
> 
> And I agree with Alex. Nothing additional needs to be tracked on top
> of inodes with speculative prealloc. Just the search filter would
> need to be different (i.e. only select inodes with a specific dquot
> attached).

Yeah, maybe not.  A single list of inodes with speculative prealloc does
seem a good place to start.  Later maybe you would not want to
scan/filter through all of them and we could add additional lists for
dquots.  My suggestion of using LRU was because I think that the oldest
unused speculative preallocs should be the first to go.  One chronic
over-quota user shouldn't be able to punish everyone else.

> > Now that block reservations count toward quotas the symptom will
> > probably be a little different.
> 
> Block reservations have always counted towards quotas, it's just
> that they were never reported.

Aw.  My mistake.  ;)

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
