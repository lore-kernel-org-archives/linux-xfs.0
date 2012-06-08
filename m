Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q58N6L3l014036 for <xfs@oss.sgi.com>; Fri, 8 Jun 2012 18:06:22 -0500
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	6tWnCN5CfrfObN1Z for <xfs@oss.sgi.com>;
	Fri, 08 Jun 2012 16:06:20 -0700 (PDT)
Date: Sat, 9 Jun 2012 09:06:16 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Hole punching and mmap races
Message-ID: <20120608230616.GA25389@dastard>
References: <20120519014024.GZ25351@dastard>
	<20120524123538.GA5632@quack.suse.cz>
	<20120605055150.GF4347@dastard>
	<20120605231530.GB4402@quack.suse.cz>
	<20120606000636.GG22848@dastard>
	<20120606095827.GA6304@quack.suse.cz>
	<20120606133616.GL22848@dastard>
	<20120607215835.GB393@quack.suse.cz>
	<20120608005700.GW4347@dastard>
	<20120608213629.GA1365@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120608213629.GA1365@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, Hugh Dickins <hughd@google.com>, xfs@oss.sgi.com

On Fri, Jun 08, 2012 at 11:36:29PM +0200, Jan Kara wrote:
> On Fri 08-06-12 10:57:00, Dave Chinner wrote:
> > On Thu, Jun 07, 2012 at 11:58:35PM +0200, Jan Kara wrote:
> > > On Wed 06-06-12 23:36:16, Dave Chinner wrote:
> > > Also we could implement the common case of locking a range
> > > containing single page by just taking page lock so we save modification of
> > > interval tree in the common case and generally make the tree smaller (of
> > > course, at the cost of somewhat slowing down cases where we want to lock
> > > larger ranges).
> > 
> > That seems like premature optimistion to me, and all the cases I
> > think we need to care about are locking large ranges of the tree.
> > Let's measure what the overhead of tracking everything in a single
> > tree is first so we can then see what needs optimising...
>   Umm, I agree that initially we probably want just to have the mapping
> range lock ability, stick it somewhere to IO path and make things work.
> Then we can look into making it faster / merging with page lock.
> 
> However I disagree we care most about locking large ranges. For all
> buffered IO and all page faults we need to lock a range containing just a
> single page. We cannot lock more due to locking constraints with mmap_sem.

Not sure I understand what that constraint is - I hav ebeen thinking
that the buffered IO range lok would be across the entire IO, not
individual pages.

As it is, if we want to do multipage writes (and we do), we have to
be able to lock a range of the mapping in the buffered IO path at a
time...

> So the places that will lock larger ranges are: direct IO, truncate, punch
> hole. Writeback actually doesn't seem to need any additional protection at
> least as I've sketched out things so far.

AFAICT, writeback needs protection against punching holes, just like
mmap does, because they use the same "avoid truncated pages"
mechanism.

> So single-page ranges matter at least as much as longer ranges. That's why
> I came up with that page lock optimisation and merging...

I agree they are common, but lets measure the overhead first before
trying to optimise/special case certain behaviours....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
