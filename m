Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9B3DB7F51
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 07:36:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 89EA68F8037
	for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 05:36:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id p7gy5DMsIVI5Lqd8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Aug 2014 05:36:10 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s7LCa874024322
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 21 Aug 2014 08:36:09 -0400
Date: Thu, 21 Aug 2014 08:36:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: deduplicate xlog_do_recovery_pass()
Message-ID: <20140821123604.GA64112@bfoster.bfoster>
References: <53F5651C.8030206@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53F5651C.8030206@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Aug 20, 2014 at 10:18:52PM -0500, Eric Sandeen wrote:
> In xlog_do_recovery_pass(), there are 2 distinct cases:
> non-wrapped and wrapped log recovery.
> 
> If we find a wrapped log, we recover around the end
> of the log, and then handle the rest of recovery
> exactly as in the non-wrapped case - using exactly the same
> (duplicated) code.
> 
> Rather than having the same code in both cases, we can
> get the wrapped portion out of the way first if needed,
> and then recover the non-wrapped portion of the log.
> 
> There should be no functional change here, just code
> reorganization & deduplication.
> 
> The patch looks a bit bigger than it really is; the last
> hunk is whitespace changes (un-indenting).
> 
> Tested with xfstests "check -g log" on a stock configuration.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

Looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> 
>  xfs_log_recover.c |   81 ++++++++++++++++++------------------------------------
>  1 file changed, 27 insertions(+), 54 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 1fd5787..08d3569 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -4132,41 +4132,13 @@ xlog_do_recovery_pass(
>  	}
>  
>  	memset(rhash, 0, sizeof(rhash));
> -	if (tail_blk <= head_blk) {
> -		for (blk_no = tail_blk; blk_no < head_blk; ) {
> -			error = xlog_bread(log, blk_no, hblks, hbp, &offset);
> -			if (error)
> -				goto bread_err2;
> -
> -			rhead = (xlog_rec_header_t *)offset;
> -			error = xlog_valid_rec_header(log, rhead, blk_no);
> -			if (error)
> -				goto bread_err2;
> -
> -			/* blocks in data section */
> -			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
> -			error = xlog_bread(log, blk_no + hblks, bblks, dbp,
> -					   &offset);
> -			if (error)
> -				goto bread_err2;
> -
> -			error = xlog_unpack_data(rhead, offset, log);
> -			if (error)
> -				goto bread_err2;
> -
> -			error = xlog_recover_process_data(log,
> -						rhash, rhead, offset, pass);
> -			if (error)
> -				goto bread_err2;
> -			blk_no += bblks + hblks;
> -		}
> -	} else {
> +	blk_no = tail_blk;
> +	if (tail_blk > head_blk) {
>  		/*
>  		 * Perform recovery around the end of the physical log.
>  		 * When the head is not on the same cycle number as the tail,
> -		 * we can't do a sequential recovery as above.
> +		 * we can't do a sequential recovery.
>  		 */
> -		blk_no = tail_blk;
>  		while (blk_no < log->l_logBBsize) {
>  			/*
>  			 * Check for header wrapping around physical end-of-log
> @@ -4280,34 +4252,35 @@ xlog_do_recovery_pass(
>  
>  		ASSERT(blk_no >= log->l_logBBsize);
>  		blk_no -= log->l_logBBsize;
> +	}
>  
> -		/* read first part of physical log */
> -		while (blk_no < head_blk) {
> -			error = xlog_bread(log, blk_no, hblks, hbp, &offset);
> -			if (error)
> -				goto bread_err2;
> +	/* read first part of physical log */
> +	while (blk_no < head_blk) {
> +		error = xlog_bread(log, blk_no, hblks, hbp, &offset);
> +		if (error)
> +			goto bread_err2;
>  
> -			rhead = (xlog_rec_header_t *)offset;
> -			error = xlog_valid_rec_header(log, rhead, blk_no);
> -			if (error)
> -				goto bread_err2;
> +		rhead = (xlog_rec_header_t *)offset;
> +		error = xlog_valid_rec_header(log, rhead, blk_no);
> +		if (error)
> +			goto bread_err2;
>  
> -			bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
> -			error = xlog_bread(log, blk_no+hblks, bblks, dbp,
> -					   &offset);
> -			if (error)
> -				goto bread_err2;
> +		/* blocks in data section */
> +		bblks = (int)BTOBB(be32_to_cpu(rhead->h_len));
> +		error = xlog_bread(log, blk_no+hblks, bblks, dbp,
> +				   &offset);
> +		if (error)
> +			goto bread_err2;
>  
> -			error = xlog_unpack_data(rhead, offset, log);
> -			if (error)
> -				goto bread_err2;
> +		error = xlog_unpack_data(rhead, offset, log);
> +		if (error)
> +			goto bread_err2;
>  
> -			error = xlog_recover_process_data(log, rhash,
> -							rhead, offset, pass);
> -			if (error)
> -				goto bread_err2;
> -			blk_no += bblks + hblks;
> -		}
> +		error = xlog_recover_process_data(log, rhash,
> +						rhead, offset, pass);
> +		if (error)
> +			goto bread_err2;
> +		blk_no += bblks + hblks;
>  	}
>  
>   bread_err2:
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
