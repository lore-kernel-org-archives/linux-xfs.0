Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B4C0A7F4E
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 16:06:03 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 52016AC008
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 14:06:00 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XQZKuyPDYDuxvE5p (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2015 14:05:59 -0800 (PST)
Date: Wed, 21 Jan 2015 17:05:52 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/3] xfs: inode unlink does not set AGI buffer type
Message-ID: <20150121220552.GC7960@laptop.bfoster>
References: <1421800780-26008-1-git-send-email-david@fromorbit.com>
	<1421800780-26008-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1421800780-26008-3-git-send-email-david@fromorbit.com>
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
Cc: jack@suse.cz, xfs@oss.sgi.com

On Wed, Jan 21, 2015 at 11:39:39AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This leads to log recovery throwing errors like:
> 
> XFS (md0): Mounting V5 Filesystem
> XFS (md0): Starting recovery (logdev: internal)
> XFS (md0): Unknown buffer type 0!
> XFS (md0): _xfs_buf_ioapply: no ops on block 0xaea8802/0x1
> ffff8800ffc53800: 58 41 47 49 .....
> 
> Which is the AGI buffer magic number.
> 
> Ensure that we set the type appropriately in both unlink list
> addition and removal.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 573b49c..f616c8f 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2051,6 +2051,7 @@ xfs_iunlink(
>  	agi->agi_unlinked[bucket_index] = cpu_to_be32(agino);
>  	offset = offsetof(xfs_agi_t, agi_unlinked) +
>  		(sizeof(xfs_agino_t) * bucket_index);
> +	xfs_trans_buf_set_type(tp, agibp, XFS_BLFT_AGI_BUF);
>  	xfs_trans_log_buf(tp, agibp, offset,
>  			  (offset + sizeof(xfs_agino_t) - 1));
>  	return 0;
> @@ -2142,6 +2143,7 @@ xfs_iunlink_remove(
>  		agi->agi_unlinked[bucket_index] = cpu_to_be32(next_agino);
>  		offset = offsetof(xfs_agi_t, agi_unlinked) +
>  			(sizeof(xfs_agino_t) * bucket_index);
> +		xfs_trans_buf_set_type(tp, agibp, XFS_BLFT_AGI_BUF);
>  		xfs_trans_log_buf(tp, agibp, offset,
>  				  (offset + sizeof(xfs_agino_t) - 1));
>  	} else {
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
