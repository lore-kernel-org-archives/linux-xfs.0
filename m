Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BBC377F5A
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 09:34:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B42FE8F8052
	for <xfs@oss.sgi.com>; Wed,  1 Apr 2015 07:34:34 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id v9mqGWxR0g0xezN1 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Apr 2015 07:34:29 -0700 (PDT)
Date: Wed, 1 Apr 2015 16:34:23 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/8] xfs: mmap lock needs to be inside freeze protection
Message-ID: <20150401143423.GO26339@quack.suse.cz>
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

On Tue 24-03-15 21:50:59, Dave Chinner wrote:
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
  Looks good to me. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
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
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
