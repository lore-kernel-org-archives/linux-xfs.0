Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F04FE7F3F
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 07:49:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D188C8F8033
	for <xfs@oss.sgi.com>; Tue, 13 May 2014 05:49:45 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 2HxmHGZl4vCFCu3a (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 May 2014 05:49:44 -0700 (PDT)
Message-ID: <537214D7.3010305@oracle.com>
Date: Tue, 13 May 2014 20:49:27 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 4/9] xfs: correct error sign on COLLAPSE_RANGE errors
References: <1399971373-6242-1-git-send-email-david@fromorbit.com>
	<1399971373-6242-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1399971373-6242-5-git-send-email-david@fromorbit.com>
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


On 05/13 2014 16:56 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 37f98c6..830c1c9 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -837,7 +837,7 @@ xfs_file_fallocate(
>  		unsigned blksize_mask = (1 << inode->i_blkbits) - 1;
>  
>  		if (offset & blksize_mask || len & blksize_mask) {
> -			error = -EINVAL;
> +			error = EINVAL;
>  			goto out_unlock;
>  		}
>  
> @@ -846,7 +846,7 @@ xfs_file_fallocate(
>  		 * in which case it is effectively a truncate operation
>  		 */
>  		if (offset + len >= i_size_read(inode)) {
> -			error = -EINVAL;
> +			error = EINVAL;
>  			goto out_unlock;
>  		}
>  
> 

Reviewed-by: Jie Liu <jeff.liu@oracle.com>


Cheers,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
