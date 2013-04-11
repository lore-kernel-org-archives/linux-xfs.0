Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C368D7F37
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 15:08:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7CCD18F8094
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 13:08:21 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id V11pXm10cgEBR9p5 for <xfs@oss.sgi.com>;
	Thu, 11 Apr 2013 13:08:19 -0700 (PDT)
Date: Thu, 11 Apr 2013 22:08:17 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] xfs: Avoid pathological backwards allocation
Message-ID: <20130411200817.GA9379@quack.suse.cz>
References: <1365680691-5330-1-git-send-email-jack@suse.cz>
	<20130411125003.GA31207@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130411125003.GA31207@dastard>
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
Cc: Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>, tinguely@sgi.com, xfs@oss.sgi.com

On Thu 11-04-13 22:50:03, Dave Chinner wrote:
> On Thu, Apr 11, 2013 at 01:44:51PM +0200, Jan Kara wrote:
> > Writing a large file using direct IO in 16 MB chunks sometimes results
> > in a pathological allocation pattern where 16 MB chunks of large free
> > extent are allocated to a file in a reversed order. So extents of a file
> > look for example as:
> > 
> >  ext logical physical expected length flags
> >    0        0        13          4550656
> >    1  4550656 188136807   4550668 12562432
> >    2 17113088 200699240 200699238 622592
> >    3 17735680 182046055 201321831   4096
> >    4 17739776 182041959 182050150   4096
> >    5 17743872 182037863 182046054   4096
> >    6 17747968 182033767 182041958   4096
> >    7 17752064 182029671 182037862   4096
> > ...
> > 6757 45400064 154381644 154389835   4096
> > 6758 45404160 154377548 154385739   4096
> > 6759 45408256 252951571 154381643  73728 eof
> > 
> > This happens because XFS_ALLOCTYPE_THIS_BNO allocation fails (the last
> > extent in the file cannot be further extended) so we fall back to
> > XFS_ALLOCTYPE_NEAR_BNO allocation which picks end of a large free
> > extent as the best place to continue the file. Since the chunk at the
> > end of the free extent again cannot be further extended, this behavior
> > repeats until the whole free extent is consumed in a reversed order.
> > 
> > For data allocations this backward allocation isn't beneficial so make
> > xfs_alloc_compute_diff() pick start of a free extent instead of its end
> > for them. That avoids the backward allocation pattern.
> > 
> > Based on idea by Dave Chinner <dchinner@redhat.com>.
> 
> Can you add a reference to the previous discussion thread here?
> I had to go back and read it to remind myself of how we ended up
> with this solution, so I think that we need to capture that
> information in this commit message somehow. A url to an archive
> (such as on oss.sgi.com) is probably the simplest way to do this.
  OK, added.

> > CC: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/xfs/xfs_alloc.c |   22 ++++++++++++++++------
> >  1 files changed, 16 insertions(+), 6 deletions(-)
> > 
> >   BTW, I've tested With this patch applied I really cannot reproduce the
> > problematic allocation pattern anymore.
> > 
> > diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> > index 0ad2325..64c6247 100644
> > --- a/fs/xfs/xfs_alloc.c
> > +++ b/fs/xfs/xfs_alloc.c
> > @@ -173,6 +173,7 @@ xfs_alloc_compute_diff(
> >  	xfs_agblock_t	wantbno,	/* target starting block */
> >  	xfs_extlen_t	wantlen,	/* target length */
> >  	xfs_extlen_t	alignment,	/* target alignment */
> > +	char		userdata,	/* are we allocating data? */
> >  	xfs_agblock_t	freebno,	/* freespace's starting block */
> >  	xfs_extlen_t	freelen,	/* freespace's length */
> >  	xfs_agblock_t	*newbnop)	/* result: best start block from free */
> > @@ -187,7 +188,12 @@ xfs_alloc_compute_diff(
> >  	ASSERT(freelen >= wantlen);
> >  	freeend = freebno + freelen;
> >  	wantend = wantbno + wantlen;
> > -	if (freebno >= wantbno) {
> > +	/*
> > +	 * We want to allocate from the start of a free extent if it is past
> > +	 * the desired block or if we are allocating user data and the free
> > +	 * extent is before desired block.
> > +	 */
> 
> I think this probably needs a little more detail as to why we we do
> this for user data. i.e. to carve from the front edge of the free
> extent to allow for contiguous allocation from the remaining free
> space if the file grows in the short term.
  I agree. I expanded the comment a bit.

> > +	if (freebno >= wantbno || (userdata && freeend < wantend)) {
> >  		if ((newbno1 = roundup(freebno, alignment)) >= freeend)
> >  			newbno1 = NULLAGBLOCK;
> 
> So this is the meat of the change. We have this:
> 
>     freebno				freeend
> 	+---------------------------------+
> 					  +-----+
> 					   prev +----------+
> 					      wantbno    wantend
> 
> and for user data this will now return:
> 
>     freebno				freeend
> 	+---------------------------------+
> 					  +-----+
> 	+--------+                         prev +----------+
>     newbno1				      wantbno    wantend
> 
> I wondered for a minute about how alignment affected the extent
> returned by taking this different branch, but I'm the behaviour is
> no different compared to carving an aligned chunk from the rear of
> the free extent. If the extent is short, we get the same result
> whether we try to carve it from the front or rear of the free space.
  Yes, I came to the same conclusion when I was thinking about this when
writing the patch.

> OK, what if we have:
> 
>     freebno				freeend
> 	+---------------------------------+
> 				     +----------+
> 				  wantbno    wantend
> 
> The existing code treats that the same as wantbno > freeend case
> above, so we should treat it the same and carve from the front edge.
> So the (freeend < wantend) check is sane, as is "<" for the
> comparison. If the watned range fits within the freespace block,
> then we should still carve that from the end of the freespace extent
> as that was what was wanted.
> 
> IOWs, the code change looks good, and as such:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
  Thanks. I'll send v2 with the updates you suggested shortly.

> However, I think this probably needs to sit in the dev tree for a
> little while before we release it on the world. I don't think that
> pushing this for 3.10 is wise as we need a bit of time to determine
> if there are unintended side effects from this change under
> accelerated aging workloads first. I'd like to be conservative on
> this as the allocation primitives being touched are devilishly
> complex and getting this wrong will have permanent impact on
> filesystems...
  I agree. I don't really hurry with pushing this to Linus. We will likely
carry the change in our SUSE kernel and if it gets merged in forseeable
future that's all I care about :)

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
