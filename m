Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4QG7wKe151230 for <xfs@oss.sgi.com>; Tue, 26 May 2009 11:07:58 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 57B3D1004077
	for <xfs@oss.sgi.com>; Tue, 26 May 2009 09:14:00 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id 1d7yNbQ5NrcTHklS for <xfs@oss.sgi.com>;
	Tue, 26 May 2009 09:14:00 -0700 (PDT)
Message-ID: <4A1C13DC.5000605@sandeen.net>
Date: Tue, 26 May 2009 11:07:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: validate quota log items during log recovery
References: <20090303175427.GA20582@infradead.org>
In-Reply-To: <20090303175427.GA20582@infradead.org>
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
> Arkadiusz has been seeing really strange crashes in xfs_qm_dqcheck that
> I can only explain by a log item beeing too smal to actually fit the
                                 ^^being too small^^
> xfs_dqblk_t we're dereferencing all over xfs_qm_dqcheck.  So add
> graceful checks for NULL or too small quota items to the log recovery
> code.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_log_recover.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_log_recover.c	2009-03-02 04:15:11.410430892 +0100
> +++ xfs/fs/xfs/xfs_log_recover.c	2009-03-02 04:16:29.649444226 +0100
> @@ -1975,16 +1975,26 @@ xlog_recover_do_reg_buffer(
>  		error = 0;
>  		if (buf_f->blf_flags &
>  		   (XFS_BLI_UDQUOT_BUF|XFS_BLI_PDQUOT_BUF|XFS_BLI_GDQUOT_BUF)) {
> +			if (item->ri_buf[i].i_addr == NULL ||
> +			    item->ri_buf[i].i_len < sizeof(xfs_dqblk_t)) {
> +				cmn_err(CE_ALERT,
> +	"XFS: dquot too small (%d) in xlog_recover_do_reg_buffer.",
> +						item->ri_buf[i].i_len);

Shouldn't this differentiate between i_addr == NULL and i_len too small,
though?  While we're at it anyway...

Maybe:

+	"XFS: dquot null addr (%p) or len too small (%d) in %s."
+	item->ri_buf[i].i_addr, item->ri_buf[i].i_len, __func__);

? (not hardcoding function name may be good too)

> +				goto next;
> +			}
>  			error = xfs_qm_dqcheck((xfs_disk_dquot_t *)
>  					       item->ri_buf[i].i_addr,
>  					       -1, 0, XFS_QMOPT_DOWARN,
>  					       "dquot_buf_recover");
> +			if (error)
> +				goto next;

I guess we can't do much else, but what happens in the end, when we skip
a buffer...

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
> @@ -2615,7 +2625,15 @@ xlog_recover_do_dquot_trans(
>  		return (0);
>  
>  	recddq = (xfs_disk_dquot_t *)item->ri_buf[1].i_addr;
> -	ASSERT(recddq);
> +
> +	if (item->ri_buf[1].i_addr == NULL ||
> +	    item->ri_buf[1].i_len < sizeof(xfs_dqblk_t)) {
> +		cmn_err(CE_ALERT,
> +	"XFS: dquot too small (%d) in xlog_recover_do_dquot_trans.",
> +			item->ri_buf[1].i_len);

Same deal here, should you differentiate on the error & use __func__ ?

-Eric

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
