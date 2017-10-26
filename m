Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750884AbdJZKVJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Oct 2017 06:21:09 -0400
Date: Thu, 26 Oct 2017 06:21:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH v2 1/3] xfs: more robust recovery xlog buffer validation
Message-ID: <20171026102107.GA3063@bfoster.bfoster>
References: <20171025185705.64983-1-bfoster@redhat.com>
 <20171025185705.64983-2-bfoster@redhat.com>
 <20171025221208.GS5483@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171025221208.GS5483@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 25, 2017 at 03:12:08PM -0700, Darrick J. Wong wrote:
> On Wed, Oct 25, 2017 at 02:57:03PM -0400, Brian Foster wrote:
> > mkfs has a historical problem where it can format very small
> > filesystems with too small of a physical log. Under certain
> > conditions, log recovery of an associated filesystem can end up
> > passing garbage parameter values to some of the cycle and log record
> > verification functions due to bugs in log recovery not dealing with
> > such filesystems properly. This results in attempts to read from
> > bogus/underflowed log block addresses.
> > 
> > Since the buffer read may ultimately succeed, log recovery can
> > proceed with bogus data and otherwise go off the rails and crash.
> > One example of this is a negative last_blk being passed to
> > xlog_find_verify_log_record() causing us to skip the loop, pass a
> > NULL head pointer to xlog_header_check_mount() and crash.
> > 
> > Improve the xlog buffer verification to address this problem. We
> > already verify xlog buffer length, so update this mechanism to also
> > sanity check for a valid log relative block address and otherwise
> > return an error. Pass a fixed, valid log block address from
> > xlog_get_bp() since the target address will be validated when the
> > buffer is read. This ensures that any bogus log block address/length
> > calculations lead to graceful mount failure rather than risking a
> > crash or worse if recovery proceeds with bogus data.
> > 
> > Reported-by: Zorro Lang <zlang@redhat.com>
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_log_recover.c | 38 ++++++++++++++++++++++++--------------
> >  1 file changed, 24 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index ee34899..54494ab 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -85,17 +85,21 @@ struct xfs_buf_cancel {
> >   */
> >  
> >  /*
> > - * Verify the given count of basic blocks is valid number of blocks
> > - * to specify for an operation involving the given XFS log buffer.
> > - * Returns nonzero if the count is valid, 0 otherwise.
> > + * Verify the log-relative block number and length in basic blocks are valid for
> > + * an operation involving the given XFS log buffer. Returns true if the fields
> > + * are valid, false otherwise.
> >   */
> > -
> > -static inline int
> > -xlog_buf_bbcount_valid(
> > +static inline bool
> > +xlog_verify_bp(
> >  	struct xlog	*log,
> > +	xfs_daddr_t	blk_no,
> >  	int		bbcount)
> >  {
> > -	return bbcount > 0 && bbcount <= log->l_logBBsize;
> > +	if (blk_no < 0 || blk_no >= log->l_logBBsize)
> > +		return false;
> > +	if (bbcount <= 0 || bbcount > log->l_logBBsize)
> > +		return false;
> 
> Shouldn't this be (blk_no + bbcount) > log->l_logBBsize, since the
> blk_no/bbcount parameters identify an extent within the log?
> 

Yes, I suppose we can do that since we pass blk_no = 0 from the get_bp()
case. The new invocations pass the blockcount of the requested I/O
operation (as opposed to the buffer size, which is probably what I was
thinking), so that seems reasonable to me.

Brian

> --D
> 
> > +	return true;
> >  }
> >  
> >  /*
> > @@ -110,7 +114,11 @@ xlog_get_bp(
> >  {
> >  	struct xfs_buf	*bp;
> >  
> > -	if (!xlog_buf_bbcount_valid(log, nbblks)) {
> > +	/*
> > +	 * Pass log block 0 since we don't have an addr yet, buffer will be
> > +	 * verified on read.
> > +	 */
> > +	if (!xlog_verify_bp(log, 0, nbblks)) {
> >  		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
> >  			nbblks);
> >  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
> > @@ -180,9 +188,10 @@ xlog_bread_noalign(
> >  {
> >  	int		error;
> >  
> > -	if (!xlog_buf_bbcount_valid(log, nbblks)) {
> > -		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
> > -			nbblks);
> > +	if (!xlog_verify_bp(log, blk_no, nbblks)) {
> > +		xfs_warn(log->l_mp,
> > +			 "Invalid log block/length (0x%llx, 0x%x) for buffer",
> > +			 blk_no, nbblks);
> >  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
> >  		return -EFSCORRUPTED;
> >  	}
> > @@ -265,9 +274,10 @@ xlog_bwrite(
> >  {
> >  	int		error;
> >  
> > -	if (!xlog_buf_bbcount_valid(log, nbblks)) {
> > -		xfs_warn(log->l_mp, "Invalid block length (0x%x) for buffer",
> > -			nbblks);
> > +	if (!xlog_verify_bp(log, blk_no, nbblks)) {
> > +		xfs_warn(log->l_mp,
> > +			 "Invalid log block/length (0x%llx, 0x%x) for buffer",
> > +			 blk_no, nbblks);
> >  		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
> >  		return -EFSCORRUPTED;
> >  	}
> > -- 
> > 2.9.5
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
