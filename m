Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1176D8015
	for <xfs@oss.sgi.com>; Wed, 19 Feb 2014 00:36:09 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 97DE0AC007
	for <xfs@oss.sgi.com>; Tue, 18 Feb 2014 22:36:08 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 7p2RvqP0ccHDw4jr (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 18 Feb 2014 22:36:07 -0800 (PST)
Message-ID: <530450C6.6030209@oracle.com>
Date: Wed, 19 Feb 2014 14:35:50 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/9] xfs: skip pointless CRC updates after verifier
	failures
References: <1392767549-25574-1-git-send-email-sandeen@redhat.com>
	<1392767549-25574-4-git-send-email-sandeen@redhat.com>
In-Reply-To: <1392767549-25574-4-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com


On 02/19 2014 07:52 AM, Eric Sandeen wrote:
> Most write verifiers don't update CRCs after the verifier
> has failed and the buffer has been marked in error.  These
> two didn't, but should.
> 
> Add returns to the verifier failure block,
> since the buffer won't be written anyway.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
>  fs/xfs/xfs_alloc_btree.c  |    1 +
>  fs/xfs/xfs_ialloc_btree.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
> index 1308542..144d3b0 100644
> --- a/fs/xfs/xfs_alloc_btree.c
> +++ b/fs/xfs/xfs_alloc_btree.c
> @@ -373,6 +373,7 @@ xfs_allocbt_write_verify(
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
>  				     bp->b_target->bt_mount, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		return;
>  	}
>  	xfs_btree_sblock_calc_crc(bp);
>  
> diff --git a/fs/xfs/xfs_ialloc_btree.c b/fs/xfs/xfs_ialloc_btree.c
> index c8fa5bb..0028c50 100644
> --- a/fs/xfs/xfs_ialloc_btree.c
> +++ b/fs/xfs/xfs_ialloc_btree.c
> @@ -261,6 +261,7 @@ xfs_inobt_write_verify(
>  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW,
>  				     bp->b_target->bt_mount, bp->b_addr);
>  		xfs_buf_ioerror(bp, EFSCORRUPTED);
> +		return;
>  	}
>  	xfs_btree_sblock_calc_crc(bp);

Looks good to me.

Reviewed-by: Jie Liu <jeff.liu@oracle.com>


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
