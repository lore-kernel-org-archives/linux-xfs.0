Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9C9D27F52
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 16:50:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D5D66AC005
	for <xfs@oss.sgi.com>; Thu, 31 Oct 2013 14:50:24 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7lbzk55JZiME2csT for <xfs@oss.sgi.com>;
	Thu, 31 Oct 2013 14:50:22 -0700 (PDT)
Date: Fri, 1 Nov 2013 08:50:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 15/30] db: separate out straight buffer IO from map based
	IO.
Message-ID: <20131031215020.GN4446@dastard>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-16-git-send-email-david@fromorbit.com>
	<20131031145609.GO22359@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131031145609.GO22359@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Oct 31, 2013 at 07:56:09AM -0700, Christoph Hellwig wrote:
> On Wed, Oct 30, 2013 at 03:31:06PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > First step in converting to libxfs based IO.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> The patch description is a little too short, there's not real
> explanation of what it actually does.

I can fix that.

> 
> > -	if (read_bbs(XFS_SB_DADDR, 1, &bufp, NULL)) {
> > +	if (read_buf(XFS_SB_DADDR, 1, bufp)) {
> 
> E.g. why isn't this already using the normal libxfs routines?
> 
> (there probably is an explanation but I don't quite see it yet..)

Because the first step is to get rid of the dependency on a basic
block map array interface for all callers. i.e. this patch separates
out the read/write functions into contiguous buffer IO and
non-contiguous buffer IO to match the two libxfs_buf IO interfaces.

> >  int
> > +read_buf(
> > +	xfs_daddr_t	bbno,
> > +	int		count,
> > +	void		*bufp)
> > +{
> 
> Is read_buf really a good name for something that is a trivial pread
> wrapper and doesn't deal with buffers?  Should the function have some
> comments explaining when to use it?  The same also applies to the write
> side.

It ends up going away - it's just a temporary step in switching over
to the libxfs code. i.e. this changes the API without changing the
implementation.

> > +static void
> > +write_cur_buf(void)
> > +{
> > +	int ret;
> > +
> > +	ret = write_buf(iocur_top->bb, iocur_top->blen, iocur_top->buf);
> > +
> > +	if (ret == -1)
> > +		dbprintf(_("incomplete write, block: %lld\n"),
> > +			 (iocur_base + iocur_sp)->bb);
> > +	else if (ret != 0)
> > +		dbprintf(_("write error: %s\n"), strerror(ret));
> > +
> > +	/* re-read buffer from disk */
> > +	ret = read_buf(iocur_top->bb, iocur_top->blen, iocur_top->buf);
> > +	if (ret == -1)
> > +		dbprintf(_("incomplete read, block: %lld\n"),
> > +			 (iocur_base + iocur_sp)->bb);
> > +	else if (ret != 0)
> > +		dbprintf(_("read error: %s\n"), strerror(ret));
> > +}
> 
> What is the point of the write and re-read cycle?

That's just what the current code does - I'm not changing the logic
of operation here. I can add patches at the end of the series to do
this - I assume it was intended to catch bad writes (e.g. media
errors) back in the days of Irix...

> > +	for (j = 0; j < count; j++) {
> > +		bbno = bbmap->b[j];
> >  		if (lseek64(x.dfd, bbno << BBSHIFT, SEEK_SET) < 0) {
> >  			rval = errno;
> >  			dbprintf(_("can't seek in filesystem at bb %lld\n"), bbno);
> >  			return rval;
> >  		}
> > -		c = BBTOB(bbmap ? 1 : count);
> > +		c = BBTOB(1);
> >  		i = (int)write(x.dfd, (char *)bufp + BBTOB(j), c);
> 
> Shoiuldn't this use the write_buf helper above?

Possibly, but this is just removing the single contiguous buffer
case from the implementation now that it is never called in that
way. The entire implemenation is converted to libxfs_buf*map IO
calls later on, so there's not much point modifying it further at
this point.

> And read_buf here?

Same again.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
