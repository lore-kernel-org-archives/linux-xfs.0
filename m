Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4AB397F8A
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 20:13:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 34937304039
	for <xfs@oss.sgi.com>; Sun, 26 Jul 2015 18:13:52 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	C5LJAFyQaUJAHWP3 for <xfs@oss.sgi.com>;
	Sun, 26 Jul 2015 18:13:47 -0700 (PDT)
Date: Mon, 27 Jul 2015 11:13:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: validate iclog size and log record length in log
	recovery
Message-ID: <20150727011306.GA24249@dastard>
References: <1437500697-62180-1-git-send-email-bfoster@redhat.com>
	<20150721175934.GI23013@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150721175934.GI23013@bfoster.bfoster>
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

On Tue, Jul 21, 2015 at 01:59:34PM -0400, Brian Foster wrote:
> On Tue, Jul 21, 2015 at 01:44:57PM -0400, Brian Foster wrote:
> > Each log record header contains an h_size value which represents the
> > size of the iclog buffers when the record was logged and an h_len value
> > which identifies the length of the particular log record. Log recovery
> > uses both fields to determine the size of the log buffers to use for
> > recovery and to correctly process each log record.
> > 
> > Neither field is completely validated during recovery, however. While
> > on-disk corruptions might be detected by CRC verification, we are still
> > susceptible to errors such as excessively sized buffer allocations and
> > overruns of the log record header and data buffers.
> > 
> > Update the xlog_valid_rec_header() function to validate the record
> > h_size and h_len fields against a new max_size parameter. The maximum
> > size value is passed as a parameter because the value differs depending
> > on whether we are trying to identify the iclog size or actually
> > processing a log record. In the former case, validate that neither field
> > exceeds the maximum supported iclog size of XFS. Once the iclog size is
> > identified and log record buffers allocated, validate all records to be
> > processed against the iclog size to ensure that buffer overrun cannot
> > occur.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> > 
> > Here's a stab at addressing the log record field validation issues Dave
> > calls out here:
> > 
> > 	http://oss.sgi.com/pipermail/xfs/2015-July/042557.html
> > 
> > This is still undergoing some testing, but I've not hit any problems so
> > far...
> > 
> 
> ... aaaaannd sure enough I managed to hit an assert blow up within a
> couple minutes of sending this out. ;)
> 
> 	kernel: XFS: Assertion failed: 0, file: fs/xfs/xfs_log_recover.c, line: 2005
> 
> I'm not yet sure whether it is related. It seems somewhat strange if it
> is. I'll see if it's reproducible with and without these patches.
> Thoughts appreciated on this change in the meantime...

Any update on this assert failure?


> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index 01dd228..98c420a 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -4078,13 +4078,22 @@ xlog_unpack_data(
> >  	return 0;
> >  }
> >  
> > +/*
> > + * Sanity check a log record header. The caller provides the maximum iclog size
> > + * and record length since validity depends on the context. For example, the
> > + * first record is used to allocate buffers and thus is validated against the
> > + * maximum supported iclog size. Subsequent records must be validated against
> > + * the identified iclog size to avoid overflow of the record buffers.
> > + */
> >  STATIC int
> >  xlog_valid_rec_header(
> >  	struct xlog		*log,
> >  	struct xlog_rec_header	*rhead,
> > -	xfs_daddr_t		blkno)
> > +	xfs_daddr_t		blkno,
> > +	int			max_size)
> >  {
> >  	int			hlen;
> > +	int			hsize;
> >  
> >  	if (unlikely(rhead->h_magicno != cpu_to_be32(XLOG_HEADER_MAGIC_NUM))) {
> >  		XFS_ERROR_REPORT("xlog_valid_rec_header(1)",
> > @@ -4099,14 +4108,21 @@ xlog_valid_rec_header(
> >  		return -EIO;
> >  	}
> >  
> > +	hsize = be32_to_cpu(rhead->h_size);

be32_to_cpu() returns an unsigned value, so the hsize/hlen variables
can de declared as u32/uint32_t, and then

> > +	if (unlikely(hsize <= 0 || hsize > max_size)) {

The comparison for < 0 can go away.

Also, I don't think that unlikely() provides any value here - it
makes the code harder to read, it's not a performance sensitive
path, and, IIRC, gcc already weights branches that end in a return
statement as "unlikely".

> > +		xfs_warn(log->l_mp, "%s: invalid iclog size (%d).", __func__,
> > +			 hsize);
> > +		return -EFSCORRUPTED;
> > +	}
> > +
> >  	/* LR body must have data or it wouldn't have been written */
> >  	hlen = be32_to_cpu(rhead->h_len);
> > -	if (unlikely( hlen <= 0 || hlen > INT_MAX )) {
> > +	if (unlikely(hlen <= 0 || hlen > max_size)) {
> >  		XFS_ERROR_REPORT("xlog_valid_rec_header(2)",
> >  				XFS_ERRLEVEL_LOW, log->l_mp);
> >  		return -EFSCORRUPTED;
> >  	}
> > -	if (unlikely( blkno > log->l_logBBsize || blkno > INT_MAX )) {
> > +	if (unlikely(blkno > log->l_logBBsize || blkno > INT_MAX)) {
> >  		XFS_ERROR_REPORT("xlog_valid_rec_header(3)",
> >  				XFS_ERRLEVEL_LOW, log->l_mp);
> >  		return -EFSCORRUPTED;
> > @@ -4159,7 +4175,8 @@ xlog_do_recovery_pass(
> >  			goto bread_err1;
> >  
> >  		rhead = (xlog_rec_header_t *)offset;
> > -		error = xlog_valid_rec_header(log, rhead, tail_blk);
> > +		error = xlog_valid_rec_header(log, rhead, tail_blk,
> > +					      XLOG_MAX_RECORD_BSIZE);

For v1 logs this is XLOG_BIG_RECORD_BSIZE, not
XLOG_MAX_RECORD_BSIZE.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
