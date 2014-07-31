Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CBCE17F8D
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 07:27:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39DD0AC003
	for <xfs@oss.sgi.com>; Thu, 31 Jul 2014 05:27:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sl7kNu2HUKQ8wQuL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 31 Jul 2014 05:27:21 -0700 (PDT)
Date: Thu, 31 Jul 2014 08:27:16 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4] xfs: catch buffers written without verifiers attached
Message-ID: <20140731122716.GB43383@bfoster.bfoster>
References: <1406768509-32556-1-git-send-email-david@fromorbit.com>
	<1406768509-32556-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1406768509-32556-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 31, 2014 at 11:01:46AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> We recently had a bug where buffers were slipping through log
> recovery without any verifier attached to them. This was resulting
> in on-disk CRC mismatches for valid data. Add some warning code to
> catch this occurrence so that we catch such bugs during development
> rather than not being aware they exist.
> 
> Note that we cannot do this verification unconditionally as non-CRC
> filesystems don't always attach verifiers to the buffers being
> written. e.g. during log recovery we cannot identify all the
> different types of buffers correctly on non-CRC filesystems, so we
> can't attach the correct verifiers in all cases and so we don't
> attach any. Hence we don't want on non-CRC filesystems to avoid
> spamming the logs with false indications.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf.c | 14 ++++++++++++++
>  fs/xfs/xfs_log.c |  8 +++++++-
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a6dc83e..cd7b8ca 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1330,6 +1330,20 @@ _xfs_buf_ioapply(
>  						   SHUTDOWN_CORRUPT_INCORE);
>  				return;
>  			}
> +		} else if (bp->b_bn != XFS_BUF_DADDR_NULL) {
> +			struct xfs_mount *mp = bp->b_target->bt_mount;
> +
> +			/*
> +			 * non-crc filesystems don't attach verifiers during
> +			 * log recovery, so don't warn for such filesystems.
> +			 */
> +			if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +				xfs_warn(mp,
> +					"%s: no ops on block 0x%llx/0x%x",
> +					__func__, bp->b_bn, bp->b_length);
> +				xfs_hex_dump(bp->b_addr, 64);
> +				dump_stack();
> +			}
>  		}
>  	} else if (bp->b_flags & XBF_READ_AHEAD) {
>  		rw = READA;
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 149a4a5..ca4fd5b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1378,8 +1378,14 @@ xlog_alloc_log(
>  
>  	xlog_get_iclog_buffer_size(mp, log);
>  
> +	/*
> +	 * Use a NULL block for the extra log buffer used during splits so that
> +	 * it will trigger errors if we ever try to do IO on it without first
> +	 * having set it up properly.
> +	 */
>  	error = -ENOMEM;
> -	bp = xfs_buf_alloc(mp->m_logdev_targp, 0, BTOBB(log->l_iclog_size), 0);
> +	bp = xfs_buf_alloc(mp->m_logdev_targp, XFS_BUF_DADDR_NULL,
> +			   BTOBB(log->l_iclog_size), 0);
>  	if (!bp)
>  		goto out_free_log;
>  
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
