Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 34E147F55
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 16:52:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 005678F8066
	for <xfs@oss.sgi.com>; Mon, 11 Aug 2014 14:52:12 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	cGYTkmKdcD9TTof7 for <xfs@oss.sgi.com>;
	Mon, 11 Aug 2014 14:52:11 -0700 (PDT)
Date: Tue, 12 Aug 2014 07:52:07 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: use-after-free on log replay failure
Message-ID: <20140811215207.GS20518@dastard>
References: <20140115014503.GQ3469@dastard>
	<CAOcd+r0R6KxmgEJNPUZ0Q5cQhsStGb=cehYE0+wKgDNU1negsA@mail.gmail.com>
	<20140119231745.GF18112@dastard>
	<4B2A412C75324EE9880358513C069476@alyakaslap>
	<9D3CBECB663B4A77B7EF74B67973310A@alyakaslap>
	<20140804230721.GA20518@dastard>
	<AC10852F403846A182491ED8071135ED@alyakaslap>
	<20140806152042.GB39990@bfoster.bfoster>
	<CAOcd+r3bC59m7Rh-3tmjrnWnF5XoPQfE=U+=hz78NcAGu+Ou1g@mail.gmail.com>
	<20140811132057.GA1186@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140811132057.GA1186@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Alex Lyakas <alex@zadarastorage.com>, xfs@oss.sgi.com

On Mon, Aug 11, 2014 at 09:20:57AM -0400, Brian Foster wrote:
> On Sun, Aug 10, 2014 at 03:20:50PM +0300, Alex Lyakas wrote:
> > On Wed, Aug 6, 2014 at 6:20 PM, Brian Foster <bfoster@redhat.com> wrote:
> > > On Wed, Aug 06, 2014 at 03:52:03PM +0300, Alex Lyakas wrote:
.....
> > >> But I believe, my analysis shows that during the mount sequence XFS does not
> > >> wait properly for all the bios to complete, before failing the mount
> > >> sequence back to the caller.
> > >>
> > >
> > > As an experiment, what about the following? Compile tested only and not
> > > safe for general use.
...
> > > diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> > > index cd7b8ca..fbcf524 100644
> > > --- a/fs/xfs/xfs_buf.c
> > > +++ b/fs/xfs/xfs_buf.c
> > > @@ -1409,19 +1409,27 @@ xfs_buf_iorequest(
> > >   * case nothing will ever complete.  It returns the I/O error code, if any, or
> > >   * 0 if there was no error.
> > >   */
> > > -int
> > > -xfs_buf_iowait(
> > > -       xfs_buf_t               *bp)
> > > +static int
> > > +__xfs_buf_iowait(
> > > +       struct xfs_buf          *bp,
> > > +       bool                    skip_error)
> > >  {
> > >         trace_xfs_buf_iowait(bp, _RET_IP_);
> > >
> > > -       if (!bp->b_error)
> > > +       if (skip_error || !bp->b_error)
> > >                 wait_for_completion(&bp->b_iowait);
> > >
> > >         trace_xfs_buf_iowait_done(bp, _RET_IP_);
> > >         return bp->b_error;
> > >  }
> > >
> > > +int
> > > +xfs_buf_iowait(
> > > +       struct xfs_buf          *bp)
> > > +{
> > > +       return __xfs_buf_iowait(bp, false);
> > > +}
> > > +
> > >  xfs_caddr_t
> > >  xfs_buf_offset(
> > >         xfs_buf_t               *bp,
> > > @@ -1866,7 +1874,7 @@ xfs_buf_delwri_submit(
> > >                 bp = list_first_entry(&io_list, struct xfs_buf, b_list);
> > >
> > >                 list_del_init(&bp->b_list);
> > > -               error2 = xfs_buf_iowait(bp);
> > > +               error2 = __xfs_buf_iowait(bp, true);
> > >                 xfs_buf_relse(bp);
> > >                 if (!error)
> > >                         error = error2;

Not waiting here on buffer error should not matter. Any buffer that
is under IO and requires completion should be referenced, and that
means it should be caught and waited on by xfs_wait_buftarg() in the
mount failure path after log recovery fails.

> > > ---
> > I think that this patch fixes the problem. I tried reproducing it like
> > 30 times, and it doesn't happen with this patch. Dropping this patch
> > reproduces the problem within 1 or 2 tries. Thanks!
> > What are next steps? How to make it "safe for general use"?
> > 
> 
> Ok, thanks for testing. I think that implicates the caller bypassing the
> expected blocking with the right sequence of log recovery I/Os and
> device failure. TBH, I'd still like to see the specifics, if possible.
> Could you come up with a generic reproducer for this? I think a metadump
> of the fs with the dirty log plus whatever device failure simulation
> hack you're using would suffice.

The real issue is we don't know exactly what code is being tested
(it's 3.8 + random bug fix backports + custom code). Even if we have
a reproducer there's no guarantee it will reproduce on a current
kernel. IOWs, we are stumbling around in the dark bashing our heads
against everything in the room, and that just wastes everyone's
time.

We need a reproducer that triggers on a current, unmodified
kernel release. You can use dm-faulty to error out all writes just
like you are doing with your custom code. See
xfstests::tests/generic/321 and common/dmflakey for to do this.
Ideally the reproducer is in a form that xfstests can use....

If you can't reproduce it on an upstream kernel, then git bisect is
your friend. It will find the commit that fixed the problem you are
seeing....

> The ideal fix is not yet clear to me.

We are not even that far along - the root cause of the bug is not at
all clear to me. :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
