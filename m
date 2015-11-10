Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 550C97F37
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 07:45:25 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E1525AC004
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 05:45:21 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Sn4SmNAyDyavnEqO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Nov 2015 05:45:20 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (Postfix) with ESMTPS id 0F385A381D
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 13:45:20 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-67.bos.redhat.com [10.18.41.67])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tAADjJS5020459
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 08:45:19 -0500
Date: Tue, 10 Nov 2015 08:45:18 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 7/8] xfs: detect and trim torn writes during log recovery
Message-ID: <20151110134518.GD21670@bfoster.bfoster>
References: <1447100475-33465-1-git-send-email-bfoster@redhat.com>
	<1447100475-33465-8-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1447100475-33465-8-git-send-email-bfoster@redhat.com>
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
To: xfs@oss.sgi.com

On Mon, Nov 09, 2015 at 03:21:14PM -0500, Brian Foster wrote:
> Certain types of storage, such as persistent memory, do not provide
> sector atomicity for writes. This means that if a crash occurs while XFS
> is writing log records, only part of those records might make it to the
> storage. This is problematic because log recovery uses the cycle value
> packed at the top of each log block to locate the head/tail of the log.
> This can lead to CRC verification failures during log recovery and an
> unmountable fs for a filesystem that is otherwise consistent.
> 
> Update log recovery to incorporate log record CRC verification as part
> of the head/tail discovery process. Once the head is located via the
> traditional algorithm, run a CRC-only pass over the records up to the
> head of the log. If CRC verification fails, assume that the records are
> torn as a matter of policy and trim the head block back to the start of
> the first bad record.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_log_recover.c | 298 ++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 279 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1b3f8fe..83fd7ca 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
...
> +STATIC int
> +xlog_verify_head(
> +	struct xlog		*log,
> +	xfs_daddr_t		*head_blk,	/* in/out: unverified head */
> +	xfs_daddr_t		*tail_blk,	/* out: tail block */
> +	struct xfs_buf		*bp,
> +	xfs_daddr_t		*rhead_blk,	/* start blk of last record */
> +	struct xlog_rec_header	**rhead,	/* ptr to last record */
> +	bool			*wrapped)	/* last rec. wraps phys. log */
> +{
> +	struct xlog_rec_header	*tmp_rhead;
> +	struct xfs_buf		*tmp_bp;
> +	xfs_daddr_t		first_bad;
> +	xfs_daddr_t		tmp_rhead_blk;
> +	int			found;
> +	int			error;
> +	bool			tmp_wrapped;
> +
> +	/*
> +	 * Search backwards through the log looking for the log record header
> +	 * block. This wraps all the way back around to the head so something is
> +	 * seriously wrong if we can't find it.
> +	 */
> +	found = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, bp, rhead_blk,
> +				      rhead, wrapped);
> +	if (found < 0)
> +		return found;
> +	if (!found) {
> +		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
> +		return -EIO;
> +	}
> +
> +	*tail_blk = BLOCK_LSN(be64_to_cpu((*rhead)->h_tail_lsn));
> +
> +	/*
> +	 * Now that we have a tail block, check the head of the log for torn
> +	 * writes. Search again until we hit the tail or the maximum number of
> +	 * log record I/Os that could have been in flight at one time. Use a
> +	 * temporary buffer so we don't trash the rhead/bp pointer from the
> +	 * call above.
> +	 */
> +	tmp_bp = xlog_get_bp(log, 1);
> +	if (!tmp_bp)
> +		return -ENOMEM;
> +	error = xlog_rseek_logrec_hdr(log, *head_blk, *tail_blk,
> +				      XLOG_MAX_ICLOGS, tmp_bp, &tmp_rhead_blk,
> +				      &tmp_rhead, &tmp_wrapped);
> +	xlog_put_bp(tmp_bp);
> +	if (error < 0)
> +		return error;
> +
> +	/*
> +	 * Now run a CRC verification pass over the records starting at the
> +	 * block found above to the current head. If a CRC failure occurs, the
> +	 * log block of the first bad record is saved in first_bad.
> +	 */
> +	error = xlog_do_recovery_pass(log, *head_blk, tmp_rhead_blk,
> +				      XLOG_RECOVER_CRCPASS, &first_bad);
> +	if (error == -EFSBADCRC && first_bad != *tail_blk) {

I started playing around with an alternate error injection mechanism
that actually writes out an invalid crc record, aborts on log write
completion and shuts down the fs. With that, I hit an interesting
problem with the first_bad != *tail_blk check in that we don't fix up
the head if the first record written after a covered log is torn and
points to itself as the tail. We end up failing the mount (which is what
would happen currently, anyways), but this should probably be fixed up.

Unfortunately I didn't sufficiently document why I had that check there.
I suspect it is a remnant of an old version that didn't update the tail
when the head was truncated back (before I fully grokked what was
necessary here), and then ran into issues further along when the head ==
tail. This version obviously updates and verifies the tail once it finds
a valid head so I can probably just kill the check. Perhaps I'll replace
it with a head == tail check after the head/tail update to simply bail
out and let normal recovery try to run.

Brian

> +		/*
> +		 * We've hit a potential torn write. Reset the error and warn
> +		 * about it.
> +		 */
> +		error = 0;
> +		xfs_warn(log->l_mp,
> +"WARNING: torn write (CRC failure) detected at block 0x%llx, recovery truncated",
> +			 first_bad);
> +
> +		/*
> +		 * Get the header block and buffer pointer for the last good
> +		 * record before the bad record.
> +		 *
> +		 * Note that xlog_find_tail() clears the blocks at the new head
> +		 * (i.e., the records with invalid CRC) if the cycle number
> +		 * matches the the current cycle.
> +		 */
> +		found = xlog_rseek_logrec_hdr(log, first_bad, *tail_blk, 1, bp,
> +					      rhead_blk, rhead, wrapped);
> +		if (found < 0)
> +			return found;
> +		if (found == 0)		/* XXX: right thing to do here? */
> +			return -EIO;
> +
> +		/*
> +		 * Reset the head block to the starting block of the first bad
> +		 * log record and set the tail block based on the last good
> +		 * record.
> +		 */
> +		*head_blk = first_bad;
> +		*tail_blk = BLOCK_LSN(be64_to_cpu((*rhead)->h_tail_lsn));
> +
> +		/*
> +		 * Now verify the tail based on the updated head. This is
> +		 * required because the torn writes trimmed from the head could
> +		 * have been written over the tail of a previous record. Return
> +		 * any errors since recovery cannot proceed if the tail is
> +		 * corrupt.
> +		 *
> +		 * XXX: This leaves a gap in truly robust protection from torn
> +		 * writes in the log. If the head is behind the tail, the tail
> +		 * pushes forward to create some space and then a crash occurs
> +		 * causing the writes into the previous record's tail region to
> +		 * tear, log recovery isn't able to recover.
> +		 *
> +		 * How likely is this to occur? If possible, can we do something
> +		 * more intelligent here? Is it safe to push the tail forward if
> +		 * we can determine that the tail is within the range of the
> +		 * torn write (e.g., the kernel can only overwrite the tail if
> +		 * it has actually been pushed forward)? Alternatively, could we
> +		 * somehow prevent this condition at runtime?
> +		 */
> +		error = xlog_verify_tail(log, *head_blk, *tail_blk);
> +	}
> +
> +	return error;
> +}
> +
> +/*
>   * Find the sync block number or the tail of the log.
>   *
>   * This will be the block number of the last record to have its
> @@ -966,9 +1233,10 @@ xlog_find_tail(
>  	xlog_op_header_t	*op_head;
>  	char			*offset = NULL;
>  	xfs_buf_t		*bp;
> -	int			error, i, found;
> +	int			error;
>  	xfs_daddr_t		umount_data_blk;
>  	xfs_daddr_t		after_umount_blk;
> +	xfs_daddr_t		rhead_blk;
>  	xfs_lsn_t		tail_lsn;
>  	int			hblks;
>  	bool			wrapped = false;
> @@ -995,24 +1263,16 @@ xlog_find_tail(
>  	}
>  
>  	/*
> -	 * Search backwards through the log looking for the log record header
> -	 * block. This wraps all the way back around to the head so something is
> -	 * seriously wrong if we can't find it.
> +	 * Trim the head block back to skip over torn records. We can have
> +	 * multiple log I/Os in flight at any time, so we assume CRC failures
> +	 * back through the previous several records are torn writes and skip
> +	 * them.
>  	 */
>  	ASSERT(*head_blk < INT_MAX);
> -	found = xlog_rseek_logrec_hdr(log, *head_blk, *head_blk, 1, bp, &i,
> -				      &rhead, &wrapped);
> -	if (found < 0) {
> -		error = found;
> +	error = xlog_verify_head(log, head_blk, tail_blk, bp, &rhead_blk,
> +				 &rhead, &wrapped);
> +	if (error)
>  		goto done;
> -	}
> -	if (!found) {
> -		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
> -		xlog_put_bp(bp);
> -		ASSERT(0);
> -		return -EIO;
> -	}
> -	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
>  
>  	/*
>  	 * Reset log values according to the state of the log when we
> @@ -1024,7 +1284,7 @@ xlog_find_tail(
>  	 * written was complete and ended exactly on the end boundary
>  	 * of the physical log.
>  	 */
> -	log->l_prev_block = i;
> +	log->l_prev_block = rhead_blk;
>  	log->l_curr_block = (int)*head_blk;
>  	log->l_curr_cycle = be32_to_cpu(rhead->h_cycle);
>  	if (wrapped)
> @@ -1062,12 +1322,12 @@ xlog_find_tail(
>  	} else {
>  		hblks = 1;
>  	}
> -	after_umount_blk = (i + hblks + (int)
> +	after_umount_blk = (rhead_blk + hblks + (int)
>  		BTOBB(be32_to_cpu(rhead->h_len))) % log->l_logBBsize;
>  	tail_lsn = atomic64_read(&log->l_tail_lsn);
>  	if (*head_blk == after_umount_blk &&
>  	    be32_to_cpu(rhead->h_num_logops) == 1) {
> -		umount_data_blk = (i + hblks) % log->l_logBBsize;
> +		umount_data_blk = (rhead_blk + hblks) % log->l_logBBsize;
>  		error = xlog_bread(log, umount_data_blk, 1, bp, &offset);
>  		if (error)
>  			goto done;
> -- 
> 2.1.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
