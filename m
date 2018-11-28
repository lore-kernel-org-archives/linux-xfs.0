Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:1351 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726972AbeK1QUs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 11:20:48 -0500
Date: Wed, 28 Nov 2018 16:17:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v1 6/7] xfs: Rewrite retried read
Message-ID: <20181128051719.GK6311@dastard>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
 <1543376991-5764-7-git-send-email-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1543376991-5764-7-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com

On Tue, Nov 27, 2018 at 08:49:50PM -0700, Allison Henderson wrote:
> If we had to try more than one mirror to get a successful
> read, then write that buffer back to correct the bad mirro
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> ---
>  fs/xfs/xfs_buf.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f102d01..81f6491 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -847,6 +847,14 @@ xfs_buf_read_map(
>  
>  		}
>  retry_done:
> +
> +		/*
> +		 * if we had to try more than one mirror to sucessfully read
> +		 * the buffer, write the buffer back
> +		 */
> +		if (!bp->b_error && i > 0)
> +			xfs_bwrite(bp);
> +

This can go in the case statement on retry and then you don't need
to check for i > 0 or, well, bp->b_error. i.e.

		swtich (bp->b_error) {
		case -EBADCRC:
		case -EIO:
		case -EFSCORRUPTED:
			/* try again from different copy */
			continue;
		0:
			/* good copy, rewrite it to repair bad copy */
			xfs_bwrite(bp);
			/* fallthrough */
		default:
			return bp;
		}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
