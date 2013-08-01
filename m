Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 30F2C7CBF
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 21:59:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C26948F8033
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 19:59:36 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	W98XnUNe4MRYZf6Y for <xfs@oss.sgi.com>;
	Wed, 31 Jul 2013 19:59:30 -0700 (PDT)
Date: Thu, 1 Aug 2013 12:59:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130801025914.GL7118@dastard>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
	<20130731220154.GA11378@thunk.org> <20130801002341.GI7118@dastard>
	<20130801004645.GC11378@thunk.org> <20130801005447.GS13468@dastard>
	<20130801010751.GD11378@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130801010751.GD11378@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>, Namjae Jeon <linkinjeon@gmail.com>, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, Namjae Jeon <namjae.jeon@samsung.com>

On Wed, Jul 31, 2013 at 09:07:52PM -0400, Theodore Ts'o wrote:
> On Thu, Aug 01, 2013 at 10:54:47AM +1000, Dave Chinner wrote:
> > > It's not just the range that it's operating on, but also the region
> > > beyond the range that's been collapsed out.
> > 
> > Yes, that's part of "the range that it is operating over".
> > 
> > > A quick eyeball of the patch didn't seem to show any code that handled
> > > this, which is why I asked the question.
> > 
> > Right, but really it's the least of the problems I've noticed - the
> > XFS code is fundamentally broken in many ways - once I've finished
> > commenting on it, I'll have a quick look to see if the ext4 code has
> > the same fundamental flaws....
> 
> Well, the fundamental flaw of potential races if the file being
> collapsed has been mmap'ed and there is another process making changes
> beyond the range that is being collapsed is I suspect one that is
> going to be very hard to solve, short of not allowing the collapse
> while there are any read/write mmap's for the file in question.

This funtionality is not introducing any new problems w.r.t. mmap().
In terms of truncating a mmap'd file, that can already occur and
the behaviour is well known. The current patches don't do the
operations in the correct order to ensure this is handled correctly
(i.e. the inode size has to be changed before the page cache
invalidation, not after), but otherwise there is no new issues
introduced here.

The real problem is that it has the same problem as hole punching
w.r.t. not being able to serialise page faults against the extent
manipulations after the page cache invalidation has occurred.
That's what Jan Kara's range locking patches we talked about at
LSFMM will address, and so is beyond the scope of this patchset.

> And I would think these sorts of VM issues should be handled with some
> generic library functions, instead of reimplementing them from scratch
> in each file system.

Well, yes, we have one - truncate_page_cache_range(), and it's used
correctly in the ext4 patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
