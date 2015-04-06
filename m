Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E08929E0E
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 12:49:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2D5E68F8037
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 10:49:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cVSX7GQ0zpzyLMPs (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Apr 2015 10:49:09 -0700 (PDT)
Date: Mon, 6 Apr 2015 13:49:07 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/8] xfs: add DAX truncate support
Message-ID: <20150406174906.GD58965@bfoster.bfoster>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1427194266-2885-7-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Tue, Mar 24, 2015 at 09:51:04PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we truncate a DAX file, we need to call through the DAX page
> truncation path rather than through block_truncate_page() so that
> mappings and block zeroing are all handled correctly. Otherwise,
> truncate does not need to change.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_iops.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index 8b9e688..9ca5352 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -851,7 +851,11 @@ xfs_setattr_size(
>  	 * to hope that the caller sees ENOMEM and retries the truncate
>  	 * operation.
>  	 */
> -	error = block_truncate_page(inode->i_mapping, newsize, xfs_get_blocks);
> +	if (IS_DAX(inode))
> +		error = dax_truncate_page(inode, newsize, xfs_get_blocks_dax);
> +	else
> +		error = block_truncate_page(inode->i_mapping, newsize,
> +					    xfs_get_blocks);
>  	if (error)
>  		return error;
>  	truncate_setsize(inode, newsize);
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
