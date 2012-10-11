Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9BM7ULx247060 for <xfs@oss.sgi.com>; Thu, 11 Oct 2012 17:07:31 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	DHTnXSY7Cj7oQoIN for <xfs@oss.sgi.com>;
	Thu, 11 Oct 2012 15:09:01 -0700 (PDT)
Date: Fri, 12 Oct 2012 09:08:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/19] xfs: verify dquot blocks as they are read from disk
Message-ID: <20121011220843.GI2739@dastard>
References: <1349754670-32009-1-git-send-email-david@fromorbit.com>
	<1349754670-32009-11-git-send-email-david@fromorbit.com>
	<20121011214805.GI6346@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121011214805.GI6346@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Oct 11, 2012 at 05:48:05PM -0400, Christoph Hellwig wrote:
> On Tue, Oct 09, 2012 at 02:51:01PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Add a dquot buffer verify callback function and pass it into the
> > buffer read functions. This checks all the dquots in a buffer, but
> > cannot completely verify the dquot ids are correct. Also, errors
> > cannot be repaired, so an additional function is added to repair bad
> > dquots in the buffer if such an error is detected in a context where
> > repair is allowed.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> But after the first half dozen of callback I have a question:
> 
> > +		if (error) {
> > +			XFS_CORRUPTION_ERROR("xfs_dquot_read_verify",
> > +					     XFS_ERRLEVEL_LOW, mp, d);
> > +			xfs_buf_ioerror(bp, EFSCORRUPTED);
> > +			break;
> > +		}
> > +	}
> > +	bp->b_iodone = NULL;
> > +	xfs_buf_ioend(bp, 0);
> 
> It seems we always call xfs_buf_ioerror on errors, and then always
> do a
> 
> 	bp->b_iodone = NULL;
> 	xfs_buf_ioend(bp, 0);
> 
> for each callback.  What is the reason we can't take these two into the
> core buffer cache code?

I could, but that
requires changing all the iodone callbacks to function
that way. There is no reason a b_iodone function can't set another
b_iodone function to be called (i.e. chained completions), and
moving the bp->b_iodone = NULL; into the xfs_buf_ioend() code will
essentially prevent that. So I'm simply avoiding having to do
unnecessary extra work and validation by doing it this way.

Further, the next set of patches that introduce write verifiers
factor the read verifier into a verify function and two wrappers:

verify()
{
}

write_verify()
{
	verify(bp);
}

read_verify()
{
	verify(bp);
	bp->b_pre_io = write_verify;
	bp->b_iodone = NULL;
	xfs_buf_ioend(bp, 0);
}

And when CRC validation is added, it becomes:

write_verify()
{
	verify(bp);
	calc_crc(bp, crc_offset);
}

read_verify()
{
	verify_crc(bp, crc_offset);
	verify();
	bp->b_pre_io = write_verify;
	bp->b_iodone = NULL;
	xfs_buf_ioend(bp, 0);
}

So you can see that there is different processing for the read and
write operations, so handing the iodone/ioend processing in the read
verifier isn't a big deal.

If we want to change how we execute iodone processing, then I think
it's better to wait till all this falls out and we can tailor the
solution with the full set of use cases in view....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
