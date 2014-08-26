Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5EB8E7F51
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 16:38:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4D3448F8054
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 14:38:25 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	l8sfu2DaWxAEAU2u for <xfs@oss.sgi.com>;
	Tue, 26 Aug 2014 14:38:23 -0700 (PDT)
Date: Wed, 27 Aug 2014 07:38:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/6] xfs: mmap write/read leaves bad state on pages
Message-ID: <20140826213808.GL20518@dastard>
References: <1408597754-13526-1-git-send-email-david@fromorbit.com>
	<1408597754-13526-2-git-send-email-david@fromorbit.com>
	<20140821195632.GA10335@quack.suse.cz>
	<20140821223332.GO26465@dastard>
	<20140826160630.GA9341@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140826160630.GA9341@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: clm@fb.com, xfs@oss.sgi.com

On Tue, Aug 26, 2014 at 06:06:30PM +0200, Jan Kara wrote:
> On Fri 22-08-14 08:33:32, Dave Chinner wrote:
> > On Thu, Aug 21, 2014 at 09:56:32PM +0200, Jan Kara wrote:
> > > On Thu 21-08-14 15:09:09, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > generic/263 is failing fsx at this point with a page spanning
> > > > EOF that cannot be invalidated. The operations are:
> > > > 
> > > > 1190 mapwrite   0x52c00 thru    0x5e569 (0xb96a bytes)
> > > > 1191 mapread    0x5c000 thru    0x5d636 (0x1637 bytes)
> > > > 1192 write      0x5b600 thru    0x771ff (0x1bc00 bytes)
> > > > 
> > > > where 1190 extents EOF from 0x54000 to 0x5e569. When the direct IO
> > > > write attempts to invalidate the cached page over this range, it
> > > > fails with -EBUSY and so we fire this assert:
> > > > 
> > > > XFS: Assertion failed: ret < 0 || ret == count, file: fs/xfs/xfs_file.c, line: 676
> > > > 
> > > > because the kernel is trying to fall back to buffered IO on the
> > > > direct IO path (which XFS does not do).
> > > > 
> > > > The real question is this: Why can't that page be invalidated after
> > > > it has been written to disk an cleaned?
....
> > > As Anton has pointed out other filesystems solve the same issue by clearing
> > > the dirty bits beyond EOF in their writepage() function. Also since we
> > > zero-out the tail of the page in writepage() (even in XFS as I checked),
> > > this kind of makes sense to me and has smaller overhead than special
> > > set_page_dirty()...
> > 
> > Yes, and that's where I started - block_write_full_page and so
> > I ended up with this first:
> > 
> > diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> > index 2a316ad..a9d6afc 100644
> > --- a/fs/xfs/xfs_aops.c
> > +++ b/fs/xfs/xfs_aops.c
> > @@ -1057,8 +1073,24 @@ xfs_vm_writepage(
> >  	do {
> >  		int new_ioend = 0;
> >  
> > -		if (offset >= end_offset)
> > +		/*
> > +		 * If the buffer is fully beyond EOF, we need to mark it clean
> > +		 * otherwise we'll leave stale dirty buffers in memory. See the
> > +		 * comment above in the EOF handling about Charlie Foxtrots.
> > +		 */
> > +		if (offset >= end_offset) {
> > +			clear_buffer_dirty(bh);
> > +			ASSERT(!buffer_delay(bh));
> > +			ASSERT(!buffer_mapped(bh));
> > +
> > +			/*
> > +			 * Page is not uptodate until buffers under IO have been
> > +			 * fully processed.
> > +			 */
> > +			uptodate = 0;
> > +			continue;
> > -			break;
> > +		}
> > +
> >  		if (!buffer_uptodate(bh))
> >  			uptodate = 0;
> >  
> > 
> > But this doesn't solve the invalidation failures - it merely covers
> > up a symptom of the underlying problem. i.e. fsx went from
> > failing invalidate on the EOF page at operation #1192 to failing
> > invalidate on the EOF page at operation #9378.
> >
> > The I realised that flush/wait/invalidate is actually racy against
> > mmap, so writepage clearing dirty buffer flags on buffers beyond EOF
> > is not a solution to the problem - it can still occur. So I added
>   Hum, I have to say I don't quite understand this. I agree with you that
> clearing dirty bits in .writepage() is racy wrt mmap. However I don't see
> how fsx can ever trigger this. For flush/wait/invalidate to fail, someone
> would have to write to the mapping somewhere between flush and invalidate.
> However fsx is singlethreaded so I don't see how that can happen.

Right, I was talking about the general problem, not necessarily the
specific fsx problem I was seeing. i.e. clearing dirty buffers
beyond EOF in writepage is not a robust solution, so regardless of
whatever other problems there are, it's not a solution we can rely
on.

....

> > At which point I realised that I'm playing whack-a-mole with a
> > fundamental problem: buffers beyond EOF cannot be written, so
> > dirtying them in the first place is just fundamentally wrong. In XFS we'll
> > zero them on disk during an extend operation (either in write,
> > truncate or prealloc), so we're not going to leaak stale data by not
> > marking them dirty.  They may not even be allocated, so we can't
> > assume that we can write them. So, rather than trying to handle this
> > dirty-buffers-beyond-EOF case in every situation where we might trip
> > over it, let's just prevent it from happening in the first place.
>   Sure I understand that. I'm now trying to understand why noone else sees
> the problem (we do run xfstests for ext4 and blocksize < page size) and
> whether there's something we might want to do for other filesystems as
> well.

Right, I don't understand where it's coming from, either.

I know there are still problems with stray delalloc blocks even
after making this change because xfs/297 is still tripping over
delayed allocation blocks where there should be none during direct
IO. i.e. this avoids the EOF issues that the direct IO invalidation
changes expose, but I still haven't been able to find the underlying
cause that is still triggering problems within EOF.

This is the disadvantage of smart people writing smart code - most
people (me included) are simply too dumb to be able to debug it. And
so when shit goes wrong, we're left to wonder where the paddle was
hidden...

> I wonder if there isn't something special going on with XFS
> redirtying the page because xfs_imap_valid() returned EAGAIN but looking
> into the code I don't see how that could happen.

To tell the truth, I'm fed up with having to deal repeatedly with
bufferhead coherency problems and not being able to find the root
cause. We just keep finding problem after problem after problem and
there's no end in sight. So I'm much more inclined to spend time
removing bufferheads from XFS than I am to try to find a needle in a
very large haystack....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
