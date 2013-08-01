Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 878CA7CBF
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 20:08:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DEEA7AC003
	for <xfs@oss.sgi.com>; Wed, 31 Jul 2013 18:08:04 -0700 (PDT)
Date: Wed, 31 Jul 2013 21:07:52 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/3] fs: Introduce new flag FALLOC_FL_COLLAPSE_RANGE
Message-ID: <20130801010751.GD11378@thunk.org>
References: <1375281721-15840-1-git-send-email-linkinjeon@gmail.com>
	<20130731220154.GA11378@thunk.org> <20130801002341.GI7118@dastard>
	<20130801004645.GC11378@thunk.org> <20130801005447.GS13468@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130801005447.GS13468@dastard>
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
Cc: Namjae Jeon <linkinjeon@gmail.com>, elder@kernel.org, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, bpm@sgi.com, adilger.kernel@dilger.ca, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

On Thu, Aug 01, 2013 at 10:54:47AM +1000, Dave Chinner wrote:
> > It's not just the range that it's operating on, but also the region
> > beyond the range that's been collapsed out.
> 
> Yes, that's part of "the range that it is operating over".
> 
> > A quick eyeball of the patch didn't seem to show any code that handled
> > this, which is why I asked the question.
> 
> Right, but really it's the least of the problems I've noticed - the
> XFS code is fundamentally broken in many ways - once I've finished
> commenting on it, I'll have a quick look to see if the ext4 code has
> the same fundamental flaws....

Well, the fundamental flaw of potential races if the file being
collapsed has been mmap'ed and there is another process making changes
beyond the range that is being collapsed is I suspect one that is
going to be very hard to solve, short of not allowing the collapse
while there are any read/write mmap's for the file in question.

And I would think these sorts of VM issues should be handled with some
generic library functions, instead of reimplementing them from scratch
in each file system.

						- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
