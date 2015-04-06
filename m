Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1CA7A29DFB
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 12:48:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F143A304032
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 10:48:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SyN5UJOzKxBlSnT7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Apr 2015 10:48:47 -0700 (PDT)
Date: Mon, 6 Apr 2015 13:48:43 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/8] xfs: mmap lock needs to be inside freeze protection
Message-ID: <20150406174843.GA58965@bfoster.bfoster>
References: <1427194266-2885-1-git-send-email-david@fromorbit.com>
	<1427194266-2885-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1427194266-2885-2-git-send-email-david@fromorbit.com>
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

On Tue, Mar 24, 2015 at 09:50:59PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Lock ordering for the new mmap lock needs to be:
> 
> mmap_sem
>   sb_start_pagefault
>     i_mmap_lock
>       page lock
>         <fault processsing>
> 
> Right now xfs_vm_page_mkwrite gets this the wrong way around,
> While technically it cannot deadlock due to the current freeze
> ordering, it's still a landmine that might explode if we change
> anything in future. Hence we need to nest the locks correctly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index dc5f609..a4c882e 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1449,15 +1449,20 @@ xfs_filemap_page_mkwrite(
>  	struct vm_fault		*vmf)
>  {
>  	struct xfs_inode	*ip = XFS_I(vma->vm_file->f_mapping->host);
> -	int			error;
> +	int			ret;
>  
>  	trace_xfs_filemap_page_mkwrite(ip);
>  
> +	sb_start_pagefault(VFS_I(ip)->i_sb);
> +	file_update_time(vma->vm_file);
>  	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> -	error = block_page_mkwrite(vma, vmf, xfs_get_blocks);
> +
> +	ret = __block_page_mkwrite(vma, vmf, xfs_get_blocks);
> +
>  	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> +	sb_end_pagefault(VFS_I(ip)->i_sb);
>  
> -	return error;
> +	return block_page_mkwrite_return(ret);
>  }
>  
>  const struct file_operations xfs_file_operations = {
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
