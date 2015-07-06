Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2157B7F54
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 13:49:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F17DB3040DF
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 11:49:42 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Gpp6s0dkdNMr9dB4 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Jul 2015 11:49:41 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 5AE6B9158D
	for <xfs@oss.sgi.com>; Mon,  6 Jul 2015 18:49:40 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-63.bos.redhat.com [10.18.41.63])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t66IndY1021550
	for <xfs@oss.sgi.com>; Mon, 6 Jul 2015 14:49:40 -0400
Date: Mon, 6 Jul 2015 15:02:41 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] xfs: handle torn writes during log head/tail discovery
Message-ID: <20150706190241.GA19240@bfoster.bfoster>
References: <1436207194-35671-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1436207194-35671-1-git-send-email-bfoster@redhat.com>
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

On Mon, Jul 06, 2015 at 02:26:34PM -0400, Brian Foster wrote:
> Persistent memory without block translation table (btt) support provides
> a block device suitable for filesystems, but does not provide the sector
> write atomicity guarantees typical of block storage. This is a problem
> for log recovery on XFS. The on-disk log record structure already
> includes a CRC and thus can detect torn writes. The problem is that such
> a failure isn't detected until log recovery is already in progress and
> therefore results in a hard error and mount failure.
> 
> Update the log head/tail discovery algorithm to detect and trim off a
> torn log record from the end (from a recovery perspective) of the log.
> Once the head is determined from the log cycle information and we have a
> pointer to the last record to be recovered, read and verify the CRC of
> said record before we initiate actual recovery. If CRC verification
> fails, assume the record is torn and reset the head to the start of the
> torn record. We reverse seek for the previous log record header from
> that point and attempt recovery up through that record.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
> 
> Hi all,
> 
> As far as I'm aware, the torn log write problem is the only major gap we
> have to safely run XFS w/ crc=1 on non-btt pmem devices. This is an RFC
> to attempt to address that problem. I used a custom hack to actually
> reproduce such torn writes on a ramdisk to primarily help me understand
> the problem, but I was able to use the same hack to sanity test this
> approach under the basic corruption case (this is generally untested,
> otherwise).
> 
> This could obviously use some cleanup, but is the approach sane? I'm
> curious if this should also be tied to DAX enablement so as to not
> interfere with unrelated corruption handling (IOW, with what logic is it
> reasonable enough to assume a crc failure of the final record == torn
> write?). I'm also wondering if this should be tied to a new mount option
> rather than make this behavior implicit. Any other thoughts?
> 

It occurs to me that this may also need to grow some logic for all the
log wrapping and whatnot that is handled in xlog_do_recovery_pass().
I'll need to stare at that some more, but FWIW, I did have another hack
that added a "dummy" recovery pass that only verified CRCs and walked
backwards until verification succeeded. It was ugly as is and quite
honestly just another hack to help me try and understand what was going
on. That said, perhaps cleaning it up and doing something like a dummy
crc verify pass from the log head/tail discovery code and _only_ over
the range of the final record might be a reasonable alternative. That
would allow reuse of the existing code for any of those wrap around
cases that might need to be handled. Anyways, thoughts or other ideas
appreciated.

Brian

> Brian
> 
>  fs/xfs/xfs_log_recover.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 87 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 01dd228..6015d02 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -62,6 +62,9 @@ xlog_recover_check_summary(
>  #define	xlog_recover_check_summary(log)
>  #endif
>  
> +STATIC int
> +xlog_validate_logrec_crc(struct xlog *, xfs_daddr_t);
> +
>  /*
>   * This structure is used during recovery to record the buf log items which
>   * have been canceled and should not be replayed.
> @@ -898,6 +901,7 @@ xlog_find_tail(
>  	xfs_daddr_t		after_umount_blk;
>  	xfs_lsn_t		tail_lsn;
>  	int			hblks;
> +	bool			skipped_last = false;
>  
>  	found = 0;
>  
> @@ -925,6 +929,7 @@ xlog_find_tail(
>  	/*
>  	 * Search backwards looking for log record header block
>  	 */
> +retry:
>  	ASSERT(*head_blk < INT_MAX);
>  	for (i = (int)(*head_blk) - 1; i >= 0; i--) {
>  		error = xlog_bread(log, i, 1, bp, &offset);
> @@ -962,6 +967,31 @@ xlog_find_tail(
>  		return -EIO;
>  	}
>  
> +	/*
> +	 * Now that we think we've found the log head, we have to check that the
> +	 * last log record wasn't torn when written out to the log. This is
> +	 * possible on devices without sector atomicity guarantees (e.g., pmem).
> +	 *
> +	 * Verify the CRC of the last log record that was written. If the CRC is
> +	 * invalid, point the head at the start of this record and retry the
> +	 * above backwards log record header search. We'll try the recovery up
> +	 * through this record. Note that we only walk backwards once since this
> +	 * is only intended to handle the torn write on power loss case.
> +	 *
> +	 * TODO: mount option? tied to DAX?
> +	 */
> +	if (xfs_sb_version_hascrc(&log->l_mp->m_sb) && !skipped_last) {
> +		error = xlog_validate_logrec_crc(log, i);
> +		if (error == -EFSBADCRC) {
> +			skipped_last = true;
> +			*head_blk = i;
> +			xfs_warn(log->l_mp,
> +	"WARNING: Torn write? Attempting recovery up to previous record.");
> +			goto retry;
> +		} else if (error)
> +			goto done;
> +	}
> +
>  	/* find blk_no of tail of log */
>  	rhead = (xlog_rec_header_t *)offset;
>  	*tail_blk = BLOCK_LSN(be64_to_cpu(rhead->h_tail_lsn));
> @@ -4607,6 +4637,63 @@ xlog_recover_finish(
>  	return 0;
>  }
>  
> +/*
> + * Read and CRC validate a full log record. This is used to detect torn log
> + * writes during head/tail discovery.
> + */
> +STATIC int
> +xlog_validate_logrec_crc(
> +	struct xlog		*log,
> +	xfs_daddr_t		rec_blk)
> +{
> +	int			hblks, bblks;
> +	struct xlog_rec_header	*rhead;
> +	struct xfs_buf		*hbp = NULL;
> +	struct xfs_buf		*dbp = NULL;
> +	int			error;
> +	char			*offset;
> +
> +	hblks = 1;	/* XXX */
> +
> +	/* read and validate the log record header */
> +	hbp = xlog_get_bp(log, 1);
> +	if (!hbp)
> +		return -ENOMEM;
> +	error = xlog_bread(log, rec_blk, hblks, hbp, &offset);
> +	if (error)
> +		goto out;
> +
> +	rhead = (struct xlog_rec_header *) offset;
> +
> +	error = xlog_valid_rec_header(log, rhead, rec_blk);
> +	if (error)
> +		goto out;
> +
> +	/* read the full record and verify the CRC */
> +	/* XXX: factor out from do_recovery_pass() ? */
> +	dbp = xlog_get_bp(log, BTOBB(be32_to_cpu(rhead->h_size)));
> +	if (!dbp)
> +		goto out;
> +
> +	bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
> +	error = xlog_bread(log, rec_blk+hblks, bblks, dbp, &offset);
> +	if (error)
> +		goto out;
> +
> +	/*
> +	 * If the CRC validation fails, convert the return code so the caller
> +	 * can distinguish from unrelated errors.
> +	 */
> +	error = xlog_unpack_data_crc(rhead, offset, log);
> +	if (error)
> +		error = -EFSBADCRC;
> +out:
> +	if (dbp)
> +		xlog_put_bp(dbp);
> +	if (hbp)
> +		xlog_put_bp(hbp);
> +	return error;
> +}
>  
>  #if defined(DEBUG)
>  /*
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
