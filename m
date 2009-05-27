Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RJ6tdG204913 for <xfs@oss.sgi.com>; Wed, 27 May 2009 14:06:55 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 884C61A2DE2B
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 12:07:06 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 9QhmhBFz1lQEGuMz for <xfs@oss.sgi.com>;
	Wed, 27 May 2009 12:07:06 -0700 (PDT)
Message-ID: <4A1D8F4D.1040902@sandeen.net>
Date: Wed, 27 May 2009 14:06:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: validate quota log items during log recovery
References: <20090303175427.GA20582@infradead.org>	<4A1C13DC.5000605@sandeen.net>
	<20090527091734.GA21958@infradead.org>
In-Reply-To: <20090527091734.GA21958@infradead.org>
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

Christoph Hellwig wrote:

> Updated patch below:
> 
> 
> Subject: xfs: validate quota log items during log recovery
> From: Christoph Hellwig <hch@lst.de>
> 
> Arkadiusz has seen really strange crashes in xfs_qm_dqcheck that
> I can only explain by a log item being too smal to actually fit the
                                             ^^small ;)
> xfs_dqblk_t we're dereferencing all over xfs_qm_dqcheck.  So add
> graceful checks for NULL or too small quota items to the log recovery
> code.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

A bit more verbose now isn't it, but oh well :)

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfs/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log_recover.c	2009-05-27 10:40:03.752821404 +0200
> +++ xfs/fs/xfs/xfs_log_recover.c	2009-05-27 10:43:23.740939498 +0200
> @@ -1975,16 +1975,30 @@ xlog_recover_do_reg_buffer(
>  		error = 0;
>  		if (buf_f->blf_flags &
>  		   (XFS_BLI_UDQUOT_BUF|XFS_BLI_PDQUOT_BUF|XFS_BLI_GDQUOT_BUF)) {
> +			if (item->ri_buf[i].i_addr == NULL) {
> +				cmn_err(CE_ALERT,
> +					"XFS: NULL dquot in %s.", __func__);
> +				goto next;
> +			}
> +			if (item->ri_buf[i].i_len < sizeof(xfs_dqblk_t)) {
> +				cmn_err(CE_ALERT,
> +					"XFS: dquot too small (%d) in %s.",
> +					item->ri_buf[i].i_len, __func__);
> +				goto next;
> +			}
>  			error = xfs_qm_dqcheck((xfs_disk_dquot_t *)
>  					       item->ri_buf[i].i_addr,
>  					       -1, 0, XFS_QMOPT_DOWARN,
>  					       "dquot_buf_recover");
> +			if (error)
> +				goto next;
>  		}
> -		if (!error)
> -			memcpy(xfs_buf_offset(bp,
> -				(uint)bit << XFS_BLI_SHIFT),	/* dest */
> -				item->ri_buf[i].i_addr,		/* source */
> -				nbits<<XFS_BLI_SHIFT);		/* length */
> +
> +		memcpy(xfs_buf_offset(bp,
> +			(uint)bit << XFS_BLI_SHIFT),	/* dest */
> +			item->ri_buf[i].i_addr,		/* source */
> +			nbits<<XFS_BLI_SHIFT);		/* length */
> + next:
>  		i++;
>  		bit += nbits;
>  	}
> @@ -2615,7 +2629,19 @@ xlog_recover_do_dquot_trans(
>  		return (0);
>  
>  	recddq = (xfs_disk_dquot_t *)item->ri_buf[1].i_addr;
> -	ASSERT(recddq);
> +
> +	if (item->ri_buf[1].i_addr == NULL) {
> +		cmn_err(CE_ALERT,
> +			"XFS: NULL dquot in %s.", __func__);
> +		return XFS_ERROR(EIO);
> +	}
> +	if (item->ri_buf[1].i_len < sizeof(xfs_dqblk_t)) {
> +		cmn_err(CE_ALERT,
> +			"XFS: dquot too small (%d) in %s.",
> +			item->ri_buf[1].i_len, __func__);
> +		return XFS_ERROR(EIO);
> +	}
> +
>  	/*
>  	 * This type of quotas was turned off, so ignore this record.
>  	 */
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
