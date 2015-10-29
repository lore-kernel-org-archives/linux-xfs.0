Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 05D467F61
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 09:30:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8E2E3AC002
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 07:30:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Nep9VsW4rjmjbGNb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Oct 2015 07:30:07 -0700 (PDT)
Date: Thu, 29 Oct 2015 10:30:06 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/6] xfs: xfs_filemap_pmd_fault treats read faults as
	write faults
Message-ID: <20151029143005.GH11663@bfoster.bfoster>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<1445225238-30413-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1445225238-30413-7-git-send-email-david@fromorbit.com>
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
Cc: ross.zwisler@linux.intel.com, jack@suse.cz, xfs@oss.sgi.com

On Mon, Oct 19, 2015 at 02:27:18PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The code initially committed didn't have the same checks for write
> faults as the dax_pmd_fault code and hence treats all faults as
> write faults. We can get read faults through this path because they
> is no pmd_mkwrite path for write faults similar to the normal page
> fault path. Hence we need to ensure that we only do c/mtime updates
> on write faults, and freeze protection is unnecessary for read
> faults.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index e7cf9ec..0045b0a 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1482,7 +1482,7 @@ xfs_file_llseek(
>   *
>   * mmap_sem (MM)
>   *   sb_start_pagefault(vfs, freeze)
> - *     i_mmap_lock (XFS - truncate serialisation)
> + *     i_mmaplock (XFS - truncate serialisation)
>   *       page_lock (MM)
>   *         i_lock (XFS - extent map serialisation)
>   */
> @@ -1550,6 +1550,13 @@ xfs_filemap_fault(
>  	return ret;
>  }
>  
> +/*
> + * Similar to xfs_filemap_fault(), the DAX fault path can call into here on
> + * both read and write faults. Hence we need to handle both cases. There is no
> + * ->pmd_mkwrite callout for huge pages, so we have a single function here to
> + * handle both cases here. @flags carries the information on the type of fault
> + * occuring.
> + */
>  STATIC int
>  xfs_filemap_pmd_fault(
>  	struct vm_area_struct	*vma,
> @@ -1566,13 +1573,18 @@ xfs_filemap_pmd_fault(
>  
>  	trace_xfs_filemap_pmd_fault(ip);
>  
> -	sb_start_pagefault(inode->i_sb);
> -	file_update_time(vma->vm_file);
> +	if (flags & FAULT_FLAG_WRITE) {
> +		sb_start_pagefault(inode->i_sb);
> +		file_update_time(vma->vm_file);
> +	}
> +
>  	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  	ret = __dax_pmd_fault(vma, addr, pmd, flags, xfs_get_blocks_dax_fault,
>  			      NULL);
>  	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> -	sb_end_pagefault(inode->i_sb);
> +
> +	if (flags & FAULT_FLAG_WRITE)
> +		sb_end_pagefault(inode->i_sb);
>  
>  	return ret;
>  }
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
