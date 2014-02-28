Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 604E27F3F
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 11:52:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49048304043
	for <xfs@oss.sgi.com>; Fri, 28 Feb 2014 09:52:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id EBms2JAKlhRoElmU for <xfs@oss.sgi.com>;
	Fri, 28 Feb 2014 09:52:21 -0800 (PST)
Message-ID: <5310CCD4.4090706@sandeen.net>
Date: Fri, 28 Feb 2014 11:52:20 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] metadump: contiguous metadata object need to be split
References: <1393568723-982-1-git-send-email-david@fromorbit.com>
	<1393568723-982-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1393568723-982-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 2/28/14, 12:25 AM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On crc enabled filesystems with obfuscation enabled we need to be
> able to recalculate the CRCs on individual buffers.
> process_single_fsb_objects() reads a contiguous range of single
> block objects as a singel buffer, and hence we cannot correctly
> recalculate the CRCs on them.
> 
> Split the loop up into individual buffer reads, processing and
> writes rather than a single read, multiple block processing and a
> single write.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good to me.

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  db/metadump.c | 46 ++++++++++++++++++++++++----------------------
>  1 file changed, 24 insertions(+), 22 deletions(-)
> 
> diff --git a/db/metadump.c b/db/metadump.c
> index 5baf83d..14902a7 100644
> --- a/db/metadump.c
> +++ b/db/metadump.c
> @@ -1331,29 +1331,27 @@ process_single_fsb_objects(
>  	int		ret = 0;
>  	int		i;
>  
> -	push_cur();
> -	set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s), c * blkbb,
> -			DB_RING_IGN, NULL);
> +	for (i = 0; i < c; i++) {
> +		push_cur();
> +		set_cur(&typtab[btype], XFS_FSB_TO_DADDR(mp, s), blkbb,
> +				DB_RING_IGN, NULL);
>  
> -	if (!iocur_top->data) {
> -		xfs_agnumber_t	agno = XFS_FSB_TO_AGNO(mp, s);
> -		xfs_agblock_t	agbno = XFS_FSB_TO_AGBNO(mp, s);
> +		if (!iocur_top->data) {
> +			xfs_agnumber_t	agno = XFS_FSB_TO_AGNO(mp, s);
> +			xfs_agblock_t	agbno = XFS_FSB_TO_AGBNO(mp, s);
>  
> -		print_warning("cannot read %s block %u/%u (%llu)",
> -				typtab[btype].name, agno, agbno, s);
> -		if (stop_on_read_error)
> -			ret = -EIO;
> -		goto out_pop;
> +			print_warning("cannot read %s block %u/%u (%llu)",
> +					typtab[btype].name, agno, agbno, s);
> +			if (stop_on_read_error)
> +				ret = -EIO;
> +			goto out_pop;
>  
> -	}
> +		}
>  
> -	if (dont_obfuscate) {
> -		ret = write_buf(iocur_top);
> -		goto out_pop;
> -	}
> +		if (dont_obfuscate)
> +			goto write;
>  
> -	dp = iocur_top->data;
> -	for (i = 0; i < c; i++) {
> +		dp = iocur_top->data;
>  		switch (btype) {
>  		case TYP_DIR2:
>  			if (o >= mp->m_dirleafblk)
> @@ -1371,13 +1369,17 @@ process_single_fsb_objects(
>  		default:
>  			break;
>  		}
> +
> +write:
> +		ret = write_buf(iocur_top);
> +out_pop:
> +		pop_cur();
> +		if (ret)
> +			break;
>  		o++;
> -		dp += mp->m_sb.sb_blocksize;
> +		s++;
>  	}
> -	ret = write_buf(iocur_top);
>  
> -out_pop:
> -	pop_cur();
>  	return ret;
>  }
>  
> -- 1.9.0 _______________________________________________ xfs mailing list xfs@oss.sgi.com http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
