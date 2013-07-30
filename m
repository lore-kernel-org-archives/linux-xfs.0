Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 64FA57CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 18:59:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F20B7AC005
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 16:59:43 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	q2JjDHKFEnHXzFwe for <xfs@oss.sgi.com>;
	Tue, 30 Jul 2013 16:59:38 -0700 (PDT)
Date: Wed, 31 Jul 2013 09:59:36 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 22/48] xfsprogs: Add verifiers to libxfs buffer interfaces.
Message-ID: <20130730235936.GQ13468@dastard>
References: <1370564771-4929-1-git-send-email-david@fromorbit.com>
	<1370564771-4929-23-git-send-email-david@fromorbit.com>
	<20130726215820.GN3111@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130726215820.GN3111@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, Jul 26, 2013 at 04:58:20PM -0500, Ben Myers wrote:
> Dave,
> 
> On Fri, Jun 07, 2013 at 10:25:45AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Verifiers need to be used everywhere to enable calculation of CRCs
> > during writeback of modified metadata. Add then to the libxfs buffer
> > interfaces conver the internal use of devices to be buftarg aware.
> > 
> > Verifiers also require that the buffer has a back pointer to the
> > struct xfs_mount. To make this source level comaptible between
> > kernel and userspace, convert userspace to pass struct xfs_buftargs
> > around rather than a "device".
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> 
> > @@ -507,7 +527,7 @@ typedef struct xfs_inode {
> >  	xfs_mount_t		*i_mount;	/* fs mount struct ptr */
> >  	xfs_ino_t		i_ino;		/* inode number (agno/agino) */
> >  	struct xfs_imap		i_imap;		/* location for xfs_imap() */
> > -	dev_t			i_dev;		/* dev for this inode */
> > +	struct xfs_buftarg			i_dev;		/* dev for this inode */
> 
> Got a little jumpy with the tabs there...
> 
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index e9cc7b1..f91a5d0 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -200,12 +200,15 @@ libxfs_log_header(
> >  #undef libxfs_getbuf_flags
> >  #undef libxfs_putbuf
> >  
> > -xfs_buf_t	*libxfs_readbuf(dev_t, xfs_daddr_t, int, int);
> > -xfs_buf_t	*libxfs_readbuf_map(dev_t, struct xfs_buf_map *, int, int);
> > +xfs_buf_t	*libxfs_readbuf(struct xfs_buftarg *, xfs_daddr_t, int, int,
> > +				const struct xfs_buf_map *);
> 
> 				const struct xfs_buf_ops *);
> 
> > +xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
> > +				int, int, const struct xfs_buf_map *);
> 
> 					  const struct xfs_buf_ops *);

Oh, in not-compiled debug code.

> 
> > @@ -612,9 +622,9 @@ libxfs_purgebuf(xfs_buf_t *bp)
> >  {
> >  	struct xfs_bufkey key = {0};
> >  
> > -	key.device = bp->b_dev;
> > +	key.buftarg = bp->b_target;
> >  	key.blkno = bp->b_bn;
> > -	key.bblen = bp->b_bcount >> BBSHIFT;
> > +	key.bblen = bp->b_length;
> 
> Why was this change necessary?  b_bcount to b_length?  It doesn't seem to be
> related to the rest of the patch.

Sure it is - I added a length in basic blocks to the struct xfs_buf,
and the key uses length in basic blocks. I converted everything to
use basic blocks where possible, because that matches what the
kernel uses for all it's buffer interfaces.

> > @@ -767,9 +803,42 @@ __write_buf(int fd, void *buf, int len, off64_t offset, int flags)
> >  int
> >  libxfs_writebufr(xfs_buf_t *bp)
> >  {
> > -	int	fd = libxfs_device_to_fd(bp->b_dev);
> > +	int	fd = libxfs_device_to_fd(bp->b_target->dev);
> >  	int	error = 0;
> >  
> > +	/*
> > +	 * we never write buffers that are marked stale. This indicates they
> > +	 * contain data that has been invalidated, and even if the buffer is
> > +	 * dirty it must *never* be written. Verifiers are wonderful for finding
> > +	 * bugs like this. Make sure the error is obvious as to the cause.
> > +	 */
> > +	if (bp->b_flags & LIBXFS_B_STALE) {
> > +		bp->b_error = ESTALE;
> > +		return bp->b_error;
> > +	}
> 
> What led to this?

Exactly what the comment says - write verifiers were failing because
stale blocks often have invalid contents. And, of course, stale
buffers should never be written to disk as they could be overwriting
otherwise valid data.

> > +
> > +	/*
> > +	 * clear any pre-existing error status on the buffer. This can occur if
> > +	 * the buffer is corrupt on disk and the repair process doesn't clear
> > +	 * the error before fixing and writing it back.
> > +	 */
> > +	bp->b_error = 0;
> > +	if (bp->b_ops) {
> > +		bp->b_ops->verify_write(bp);
> > +		if (bp->b_error) {
> > +			fprintf(stderr,
> > +	_("%s: write verifer failed on bno 0x%llx/0x%x\n"),
> > +				__func__, (long long)bp->b_bn, bp->b_bcount);
> > +			return bp->b_error;
> > +		}
> > +	}
> > +
> > +	if (bp->b_ops) {
> > +		bp->b_ops->verify_write(bp);
> > +		if (bp->b_error)
> > +			return bp->b_error;
> > +	}
> > +
> 
> Calling the verifier twice?  Maybe I'm seeing double again...

Probably a rebase error - a patch that should have conflicted and got
a merge error didn't. Indeed, that doesn't match what is actually
in the current code base - it repeats that entire block from comment
to the end of the if statement twice - so it's pretty obvious
there's been rebase/merge issues here...

> > @@ -1353,7 +1353,8 @@ scan_ags(
> >  	}
> >  	memset(agcnts, 0, mp->m_sb.sb_agcount * sizeof(*agcnts));
> >  
> > -	create_work_queue(&wq, mp, scan_threads);
> > +	create_work_queue(&wq, mp, 1);
> > +	//create_work_queue(&wq, mp, scan_threads);
> 
> What's this all about?  Were you having trouble with a multithreaded scan?

Debug code I forgot to remove - multithreaded code can be a pain to
debug in gdb. I thought I'd re-enabled it, but obviously not.

> Looks fine for the most part...  I did get a little uncomfortable with using
> verifiers on reads in repair.  Not sure whether setting b_error = EFSCORRUPTED
> would have ill effect later.

That's why bp->b_error is zeroed before we do any IO on the buffer
again - so previous errors aren't propagated. Righ tnow the
EFSCORRUPTED error from the verifiers is ignored, but I have patches
to start having repair treat them a broken blocks (e.g. because the
CRC failed) needing repair. i.e. for repair to actually correctly
verify the filesystem is error free, it has to verify allt eh CRCs
are in tact. it doesn't currently do that....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
