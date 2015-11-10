Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F06237F37
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 09:42:19 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DCDBC8F8040
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 07:42:19 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id fsbVRZsGNRX82HVB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Nov 2015 07:42:18 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 57051C0AEE5E
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 15:42:18 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-67.bos.redhat.com [10.18.41.67])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id tAAFgHTm013564
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 10:42:18 -0500
Date: Tue, 10 Nov 2015 10:42:16 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/8] xfs: return start block of first bad log record
	during recovery
Message-ID: <20151110154216.GE21670@bfoster.bfoster>
References: <1447100475-33465-1-git-send-email-bfoster@redhat.com>
	<1447100475-33465-5-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1447100475-33465-5-git-send-email-bfoster@redhat.com>
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

On Mon, Nov 09, 2015 at 03:21:11PM -0500, Brian Foster wrote:
> Each log recovery pass walks from the tail block to the head block and
> processes records appropriately based on the associated log pass type.
> There are various failure conditions that can occur through this
> sequence, such as I/O errors, CRC errors, etc. Log torn write detection
> will perform CRC verification near the head of the log to detect torn
> writes and trim torn records from the log appropriately.
> 
> As it is, xlog_do_recovery_pass() only returns an error code in the
> event of CRC failure, which isn't enough information to trim the head of
> the log. Update xlog_do_recovery_pass() to optionally return the start
> block of the associated record when an error occurs. This patch contains
> no functional changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_log_recover.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index c2bf307..2ef0880 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4239,10 +4239,12 @@ xlog_do_recovery_pass(
>  	struct xlog		*log,
>  	xfs_daddr_t		head_blk,
>  	xfs_daddr_t		tail_blk,
> -	int			pass)
> +	int			pass,
> +	xfs_daddr_t		*first_bad)	/* out: first bad log rec */
>  {
>  	xlog_rec_header_t	*rhead;
>  	xfs_daddr_t		blk_no;
> +	xfs_daddr_t		rhead_blk;
>  	char			*offset;
>  	xfs_buf_t		*hbp, *dbp;
>  	int			error = 0, h_size, h_len;
> @@ -4251,6 +4253,7 @@ xlog_do_recovery_pass(
>  	struct hlist_head	rhash[XLOG_RHASH_SIZE];
>  
>  	ASSERT(head_blk != tail_blk);
> +	rhead_blk = 0;
>  
>  	/*
>  	 * Read the header of the tail block and get the iclog buffer size from
> @@ -4325,7 +4328,7 @@ xlog_do_recovery_pass(
>  	}
>  
>  	memset(rhash, 0, sizeof(rhash));
> -	blk_no = tail_blk;
> +	blk_no = rhead_blk = tail_blk;
>  	if (tail_blk > head_blk) {
>  		/*
>  		 * Perform recovery around the end of the physical log.
> @@ -4436,7 +4439,9 @@ xlog_do_recovery_pass(
>  						     pass);
>  			if (error)
>  				goto bread_err2;
> +
>  			blk_no += bblks;
> +			rhead_blk = blk_no;
>  		}
>  
>  		ASSERT(blk_no >= log->l_logBBsize);

There's a rewind of blk_no (not shown in this patch) between the above
loop and the subsequent loop to handle wrapping around the end of the
log. We need to update rhead_blk there as well. Otherwise, if the first
record processed in the following loop is bad, rhead_blk can still point
beyond the end of the log and thus throw off all of the recovery bits
that follow.

Brian

> @@ -4464,13 +4469,19 @@ xlog_do_recovery_pass(
>  		error = xlog_recover_process(log, rhash, rhead, offset, pass);
>  		if (error)
>  			goto bread_err2;
> +
>  		blk_no += bblks + hblks;
> +		rhead_blk = blk_no;
>  	}
>  
>   bread_err2:
>  	xlog_put_bp(dbp);
>   bread_err1:
>  	xlog_put_bp(hbp);
> +
> +	if (error && first_bad)
> +		*first_bad = rhead_blk;
> +
>  	return error;
>  }
>  
> @@ -4508,7 +4519,7 @@ xlog_do_log_recovery(
>  		INIT_LIST_HEAD(&log->l_buf_cancel_table[i]);
>  
>  	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
> -				      XLOG_RECOVER_PASS1);
> +				      XLOG_RECOVER_PASS1, NULL);
>  	if (error != 0) {
>  		kmem_free(log->l_buf_cancel_table);
>  		log->l_buf_cancel_table = NULL;
> @@ -4519,7 +4530,7 @@ xlog_do_log_recovery(
>  	 * When it is complete free the table of buf cancel items.
>  	 */
>  	error = xlog_do_recovery_pass(log, head_blk, tail_blk,
> -				      XLOG_RECOVER_PASS2);
> +				      XLOG_RECOVER_PASS2, NULL);
>  #ifdef DEBUG
>  	if (!error) {
>  		int	i;
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
