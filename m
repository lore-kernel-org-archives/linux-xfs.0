Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 66CB77F54
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 16:45:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44B738F8035
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2014 14:45:39 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	utWag1MlLlfSJVzE for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2014 14:45:37 -0800 (PST)
Date: Wed, 3 Dec 2014 09:45:18 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: lobotomise xfs_trans_read_buf_map()
Message-ID: <20141202224518.GG18131@dastard>
References: <1417473290-17544-1-git-send-email-david@fromorbit.com>
	<20141202165930.GA28571@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141202165930.GA28571@infradead.org>
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

On Tue, Dec 02, 2014 at 08:59:30AM -0800, Christoph Hellwig wrote:
> On Tue, Dec 02, 2014 at 09:34:50AM +1100, Dave Chinner wrote:
> > The only way we can find a buffer that has not had IO completed on
> > it is if it had readahead issued on it, but we never do readahead on
> > buffers that we have already joined into a transaction. Hence this
> > condition cannot occur, and buffers locked and joined into a
> > transaction should always be marked done and not under IO.
> 
> Should we add an ASSERT that would trigger when someone tries
> to issue readahead on a buffer with b_transp set?

Perhaps so.

> >  	bp = xfs_buf_read_map(target, map, nmaps, flags, ops);
> > -	if (bp == NULL) {
> > -		*bpp = NULL;
> > -		return (flags & XBF_TRYLOCK) ?
> > -					0 : -ENOMEM;
> > +	if (!bp) {
> > +		if (!(flags & XBF_TRYLOCK))
> > +			return -ENOMEM;
> > +		return tp ? 0 : -EAGAIN;
> 
> Can you fix the inconsistent return for the trylock case in a follow on
> patch?  This difference doesn't look intentional to me, and I would
> be surprised if it's correctly handled in the callers.

Ok, I'll do an audit and make this common in a follow up patch. Just
to confirm:

		if (!(flags & XBF_TRYLOCK))
			return -ENOMEM;
		return -EAGAIN;

is what you want to see, right?

> >  	}
> > +
> >  	if (bp->b_error) {
> >  		error = bp->b_error;
> > +		if (!XFS_FORCED_SHUTDOWN(mp))
> > +			xfs_buf_ioerror_alert(bp, __func__);
> > +		bp->b_flags &= ~XBF_DONE;
> >  		xfs_buf_stale(bp);
> > -		XFS_BUF_DONE(bp);
> 
> The old non-tp case did a XFS_BUF_UNDONE, which you open code here,
> while the with-tp case did a XFS_BUF_DONE.  I think this change needs
> a little explanation.

Consistency. A read failed on the buffer, so the contents are
undefined. XBF_DONE implies the contents of the buffer are valid
and so setting XBF_DONE is wrong. Further, the buffer is marked
stale, again indicating that the contents are invalid and that it
should never be written. This makes the XBF_DONE value redundant.

Hence it doesn't matter whether it is transaction context or not,
XBF_DONE should not be set on a stale buffer that failed a read....

I'll add a comment explaining this.

> 
> >  #ifdef DEBUG
> > -	if (xfs_do_error && !(tp->t_flags & XFS_TRANS_DIRTY)) {
> > +	if (xfs_do_error && (!tp || !(tp->t_flags & XFS_TRANS_DIRTY))) {
> >  		if (xfs_error_target == target) {
> >  			if (((xfs_req_num++) % xfs_error_mod) == 0) {
> > -				xfs_force_shutdown(tp->t_mountp,
> > -						   SHUTDOWN_META_IO_ERROR);
> >  				xfs_buf_relse(bp);
> > -				xfs_debug(mp, "Returning trans error!");
> > +				xfs_debug(mp, "Returning error!");
> >  				return -EIO;
> >  			}
> >  		}
> 
> I would suggest to kill this xfs_do_error error code, it's the last
> use of the never initialized xfs_do_error and xfs_error_target
> variables.

I was in two minds w.r.t. killing that code. My initial patch did
kill it, but I didn't in this rework. I'll update the patch to kill
it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
