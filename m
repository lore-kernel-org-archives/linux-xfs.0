Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AB7897F37
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 17:56:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9217A304039
	for <xfs@oss.sgi.com>; Thu,  7 Jan 2016 15:56:03 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	7mGBq33dfqlllj5j for <xfs@oss.sgi.com>;
	Thu, 07 Jan 2016 15:56:00 -0800 (PST)
Date: Fri, 8 Jan 2016 10:55:58 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: handle dquot buffer readahead in log recovery
	correctly
Message-ID: <20160107235558.GP21461@dastard>
References: <1452052834-20605-1-git-send-email-david@fromorbit.com>
	<20160107030830.GA32200@dastard>
	<20160107124433.GA33327@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160107124433.GA33327@bfoster.bfoster>
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
Cc: xfs@oss.sgi.com

[slightly hacked up quoting order so it makes sense]

On Thu, Jan 07, 2016 at 07:44:33AM -0500, Brian Foster wrote:
> On Thu, Jan 07, 2016 at 02:08:30PM +1100, Dave Chinner wrote:
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we do dquot readahead in log recovery, we do not use a verifier
......
> > write operation as well as a read operation that marks the buffer as
> > not done if any corruption is detected.  Also make sure we don't run

Marking the buffer not done mentioned here...

.....
> >  
> >  /*
> > + * readahead errors are silent and simply leave the buffer as !done so a real
> > + * read will then be run with the xfs_dquot_buf_ops verifier. See
> > + * xfs_inode_buf_verify() for why we use EIO and ~XBF_DONE here rather than
> > + * reporting the failure.

... and here ...

> > @@ -62,11 +62,14 @@ xfs_inobp_check(
> >   * has not had the inode cores stamped into it. Hence for readahead, the buffer
> >   * may be potentially invalid.
> >   *
> > - * If the readahead buffer is invalid, we don't want to mark it with an error,
> > - * but we do want to clear the DONE status of the buffer so that a followup read
> > - * will re-read it from disk. This will ensure that we don't get an unnecessary
> > - * warnings during log recovery and we don't get unnecssary panics on debug
> > - * kernels.
> > + * If the readahead buffer is invalid, we need to mark it with an error and
> > + * clear the DONE status of the buffer so that a followup read will re-read it
> > + * from disk. We don't report the error otherwise to avoid warnings during log

... and here ...

> Do we really need to clear the flag if the I/O infrastructure doesn't
> set it until after the verifier is invoked?  It's harmless, [...]
> ... but it does look slightly confusing, without a mention in the
> comments at least.

I mentioned it 3 times. ;)

Is there something I can do to make it more obvious what the
comments are referring to?

> > + */
> > +static void
> > +xfs_dquot_buf_readahead_verify(
> > +	struct xfs_buf	*bp)
> > +{
> > +	struct xfs_mount	*mp = bp->b_target->bt_mount;
> > +
> > +	if (!xfs_dquot_buf_verify_crc(mp, bp) ||
> > +	    !xfs_dquot_buf_verify(mp, bp, 0)) {
> > +		xfs_buf_ioerror(bp, -EIO);
> > +		bp->b_flags &= ~XBF_DONE;
> 
> Do we really need to clear the flag if the I/O infrastructure doesn't
> set it until after the verifier is invoked?  It's harmless, so if the
> intent is to just be cautious or future-proof:

It's intended to cover the case that a verifier is run on a buffer
that has already been read in successfully. This doesn't occur in
the kernel code, but it most definitely does in the userspace code.
Strictly speaking it's not necessary (at the moment) for the
userspace code as it ignores the kernel buffer flags, but I figured
it's better to leave it there for documentation of expected
behaviour and to ensure we don't leave a landmine if we ever run a
readahead verifier on a buffer that is already marked as done...

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
