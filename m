Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2B8917F56
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 09:30:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9B528F8035
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2015 07:30:05 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0cMzFWAhxi2m4ssb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 29 Oct 2015 07:30:04 -0700 (PDT)
Date: Thu, 29 Oct 2015 10:30:02 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 5/6] xfs: add ->pfn_mkwrite support for DAX
Message-ID: <20151029143002.GG11663@bfoster.bfoster>
References: <1445225238-30413-1-git-send-email-david@fromorbit.com>
	<1445225238-30413-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1445225238-30413-6-git-send-email-david@fromorbit.com>
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

On Mon, Oct 19, 2015 at 02:27:17PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> ->pfn_mkwrite support is needed so that when a page with allocated
> backing store takes a write fault we can check that the fault has
> not raced with a truncate and is pointing to a region beyond the
> current end of file.
> 
> This also allows us to update the timestamp on the inode, too, which
> fixes a generic/080 failure.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c  | 35 +++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_trace.h |  1 +
>  2 files changed, 36 insertions(+)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 403151a..e7cf9ec 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1577,11 +1577,46 @@ xfs_filemap_pmd_fault(
>  	return ret;
>  }
>  
> +/*
> + * pfn_mkwrite was originally inteneded to ensure we capture time stamp
> + * updates on write faults. In reality, it's need to serialise against
> + * truncate similar to page_mkwrite. Hence we open-code dax_pfn_mkwrite()
> + * here and cycle the XFS_MMAPLOCK_SHARED to ensure we serialise the fault
> + * barrier in place.
> + */
> +static int
> +xfs_filemap_pfn_mkwrite(
> +	struct vm_area_struct	*vma,
> +	struct vm_fault		*vmf)
> +{
> +
> +	struct inode		*inode = file_inode(vma->vm_file);
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	int			ret = VM_FAULT_NOPAGE;
> +	loff_t			size;
> +
> +	trace_xfs_filemap_pfn_mkwrite(ip);
> +
> +	sb_start_pagefault(inode->i_sb);
> +	file_update_time(vma->vm_file);
> +
> +	/* check if the faulting page hasn't raced with truncate */
> +	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> +	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	if (vmf->pgoff >= size)
> +		ret = VM_FAULT_SIGBUS;
> +	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> +	sb_end_pagefault(inode->i_sb);
> +	return ret;
> +
> +}
> +
>  static const struct vm_operations_struct xfs_file_vm_ops = {
>  	.fault		= xfs_filemap_fault,
>  	.pmd_fault	= xfs_filemap_pmd_fault,
>  	.map_pages	= filemap_map_pages,
>  	.page_mkwrite	= xfs_filemap_page_mkwrite,
> +	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
>  };
>  
>  STATIC int
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 957f5cc..877079eb 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -689,6 +689,7 @@ DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
>  DEFINE_INODE_EVENT(xfs_filemap_fault);
>  DEFINE_INODE_EVENT(xfs_filemap_pmd_fault);
>  DEFINE_INODE_EVENT(xfs_filemap_page_mkwrite);
> +DEFINE_INODE_EVENT(xfs_filemap_pfn_mkwrite);
>  
>  DECLARE_EVENT_CLASS(xfs_iref_class,
>  	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
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
