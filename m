Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3AE887F75
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2015 08:44:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BBB85AC008
	for <xfs@oss.sgi.com>; Fri, 24 Jul 2015 06:44:27 -0700 (PDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id NBqYN5L5WtgD73Th for
	<xfs@oss.sgi.com>; Fri, 24 Jul 2015 06:44:26 -0700 (PDT)
Date: Fri, 24 Jul 2015 09:44:22 -0400
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4 v2] xfs: call dax_fault on read page faults for DAX
Message-ID: <20150724134422.GV13681@linux.intel.com>
References: <1437440945-23457-1-git-send-email-david@fromorbit.com>
	<1437440945-23457-2-git-send-email-david@fromorbit.com>
	<20150721135758.GO13681@linux.intel.com>
	<20150724013121.GG3902@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150724013121.GG3902@dastard>
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

On Fri, Jul 24, 2015 at 11:31:21AM +1000, Dave Chinner wrote:
> New patch below.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> xfs: call dax_fault on read page faults for DAX
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> When modifying the patch series to handle the XFS MMAP_LOCK nesting
> of page faults, I botched the conversion of the read page fault
> path, and so it is only every calling through the page cache. Re-add
> the necessary __dax_fault() call for such files.
> 
> Because the get_blocks callback on read faults may not set up the
> mapping buffer correctly to allow unwritten extent completion to be
> run, we need to allow callers of __dax_fault() to pass a null
> complete_unwritten() callback. The DAX code always zeros the
> unwritten page when it is read faulted so there are no stale data
> exposure issues with not doing the conversion. The only downside
> will be the potential for increased CPU overhead on repeated read
> faults of the same page. If this proves to be a problem, then the
> filesystem needs to fix it's get_block callback and provide a
> convert_unwritten() callback to the read fault path.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

> ---
>  fs/dax.c          | 14 ++++++++++++--
>  fs/xfs/xfs_file.c | 21 +++++++++++++++------
>  2 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index c3e21cc..a7f77e1 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -319,6 +319,12 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
>   * @vma: The virtual memory area where the fault occurred
>   * @vmf: The description of the fault
>   * @get_block: The filesystem method used to translate file offsets to blocks
> + * @complete_unwritten: The filesystem method used to convert unwritten blocks
> + *	to written so the data written to them is exposed. This is required for
> + *	required by write faults for filesystems that will return unwritten
> + *	extent mappings from @get_block, but it is optional for reads as
> + *	dax_insert_mapping() will always zero unwritten blocks. If the fs does
> + *	not support unwritten extents, the it should pass NULL.
>   *
>   * When a page fault occurs, filesystems may call this helper in their
>   * fault handler for DAX files. __dax_fault() assumes the caller has done all
> @@ -437,8 +443,12 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
>  	 * as for normal BH based IO completions.
>  	 */
>  	error = dax_insert_mapping(inode, &bh, vma, vmf);
> -	if (buffer_unwritten(&bh))
> -		complete_unwritten(&bh, !error);
> +	if (buffer_unwritten(&bh)) {
> +		if (complete_unwritten)
> +			complete_unwritten(&bh, !error);
> +		else
> +			WARN_ON_ONCE(!(vmf->flags & FAULT_FLAG_WRITE));
> +	}
>  
>   out:
>  	if (error == -ENOMEM)
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index f0e8249..db4acc1 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1514,18 +1514,27 @@ xfs_filemap_fault(
>  	struct vm_area_struct	*vma,
>  	struct vm_fault		*vmf)
>  {
> -	struct xfs_inode	*ip = XFS_I(file_inode(vma->vm_file));
> +	struct inode		*inode = file_inode(vma->vm_file);
>  	int			ret;
>  
> -	trace_xfs_filemap_fault(ip);
> +	trace_xfs_filemap_fault(XFS_I(inode));
>  
>  	/* DAX can shortcut the normal fault path on write faults! */
> -	if ((vmf->flags & FAULT_FLAG_WRITE) && IS_DAX(VFS_I(ip)))
> +	if ((vmf->flags & FAULT_FLAG_WRITE) && IS_DAX(inode))
>  		return xfs_filemap_page_mkwrite(vma, vmf);
>  
> -	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> -	ret = filemap_fault(vma, vmf);
> -	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> +	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
> +	if (IS_DAX(inode)) {
> +		/*
> +		 * we do not want to trigger unwritten extent conversion on read
> +		 * faults - that is unnecessary overhead and would also require
> +		 * changes to xfs_get_blocks_direct() to map unwritten extent
> +		 * ioend for conversion on read-only mappings.
> +		 */
> +		ret = __dax_fault(vma, vmf, xfs_get_blocks_direct, NULL);
> +	} else
> +		ret = filemap_fault(vma, vmf);
> +	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
>  
>  	return ret;
>  }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
