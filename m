Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 60EFF7F59
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 11:29:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E122FAC005
	for <xfs@oss.sgi.com>; Wed, 30 Jul 2014 09:29:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ShlXPyuXpYuJFdoN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Jul 2014 09:29:25 -0700 (PDT)
Date: Wed, 30 Jul 2014 12:29:14 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/4 V2] xfs: catch buffers written without verifiers
	attached
Message-ID: <20140730162913.GA2830@bfoster.bfoster>
References: <1406684929-11133-1-git-send-email-david@fromorbit.com>
	<1406684929-11133-2-git-send-email-david@fromorbit.com>
	<20140730023023.GM26465@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140730023023.GM26465@dastard>
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

On Wed, Jul 30, 2014 at 12:30:24PM +1000, Dave Chinner wrote:
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
>  fs/xfs/xfs_buf.c | 15 +++++++++++++++
>  fs/xfs/xfs_log.c |  7 ++++++-
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index a6dc83e..078b8be 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1330,6 +1330,21 @@ _xfs_buf_ioapply(
>  						   SHUTDOWN_CORRUPT_INCORE);
>  				return;
>  			}
> +		} else if (bp->b_bn != -1LL) {
> +			struct xfs_mount *mp = bp->b_target->bt_mount;
> +
> +			/*
> +			 * non-crc filesystems don't attach verifiers during
> +			 * log recovery, so don't warn for such filesystems.
> +			 */
> +			if (xfs_sb_version_hascrc(&mp->m_sb)) {
> +				xfs_warn(mp,
> +					"%s: no ops on block 0x%llx/0x%llx",
> +					__func__, bp->b_bn,
> +					bp->b_maps[0].bm_bn);

Are you intending to print both block number values here or the
b_bn/bm_len combo?

> +				xfs_hex_dump(bp->b_addr, 64);
> +				dump_stack();
> +			}
>  		}
>  	} else if (bp->b_flags & XBF_READ_AHEAD) {
>  		rw = READA;
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 149a4a5..9dc92b3 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1378,8 +1378,13 @@ xlog_alloc_log(
>  
>  	xlog_get_iclog_buffer_size(mp, log);
>  
> +	/*
> +	 * Use a block number of -1 for the extra log buffer used during splits
> +	 * so that it will trigger errors if we ever try to do IO on it without
> +	 * first having set it up properly.
> +	 */
>  	error = -ENOMEM;
> -	bp = xfs_buf_alloc(mp->m_logdev_targp, 0, BTOBB(log->l_iclog_size), 0);
> +	bp = xfs_buf_alloc(mp->m_logdev_targp, -1LL, BTOBB(log->l_iclog_size), 0);

How about XFS_BUF_DADDR_NULL (here and above)?

Brian

>  	if (!bp)
>  		goto out_free_log;
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
