Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C4BA97FA6
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 14:31:31 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 42739AC004
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 12:31:31 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id tL8kTgooI4AdKI0z (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 12:31:27 -0800 (PST)
Date: Mon, 9 Feb 2015 15:31:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/6] xfs: use i_mmaplock on read faults
Message-ID: <20150209203121.GI18336@laptop.bfoster>
References: <1423083859-28439-1-git-send-email-david@fromorbit.com>
	<1423083859-28439-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1423083859-28439-3-git-send-email-david@fromorbit.com>
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

On Thu, Feb 05, 2015 at 08:04:15AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Take the i_mmaplock over read page faults. These come through the
> ->fault callout, so we need to wrap the generic implementation
> with the i_mmaplock. While there, add tracepoints for the read
> fault as it passes through XFS.
> 
> This gives us a lock order of mmap_sem -> i_mmaplock -> page_lock
> -> i_lock.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_file.c  | 28 +++++++++++++++++++++++++++-
>  fs/xfs/xfs_trace.h |  2 ++
>  2 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 712d312..6cc1b7d 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1369,6 +1369,32 @@ xfs_file_llseek(
>  	}
>  }
>  
> +/*
> + * Locking for serialisation of IO during page faults. This results in a lock
> + * ordering of:
> + *
> + * mmap_sem (MM)
> + *   i_mmap_lock (XFS - truncate serialisation)
> + *     page_lock (MM)
> + *       i_lock (XFS - extent map serialisation)
> + */
> +STATIC int
> +xfs_filemap_fault(
> +	struct vm_area_struct	*vma,
> +	struct vm_fault		*vmf)
> +{
> +	struct xfs_inode	*ip = XFS_I(vma->vm_file->f_mapping->host);
> +	int			error;
> +
> +	trace_xfs_filemap_fault(ip);
> +
> +	xfs_ilock(ip, XFS_MMAPLOCK_SHARED);
> +	error = filemap_fault(vma, vmf);
> +	xfs_iunlock(ip, XFS_MMAPLOCK_SHARED);
> +
> +	return error;
> +}
> +
>  const struct file_operations xfs_file_operations = {
>  	.llseek		= xfs_file_llseek,
>  	.read		= new_sync_read,
> @@ -1401,7 +1427,7 @@ const struct file_operations xfs_dir_file_operations = {
>  };
>  
>  static const struct vm_operations_struct xfs_file_vm_ops = {
> -	.fault		= filemap_fault,
> +	.fault		= xfs_filemap_fault,
>  	.map_pages	= filemap_map_pages,
>  	.page_mkwrite	= xfs_vm_page_mkwrite,
>  	.remap_pages	= generic_file_remap_pages,
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 51372e3..c496153 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -685,6 +685,8 @@ DEFINE_INODE_EVENT(xfs_inode_set_eofblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_clear_eofblocks_tag);
>  DEFINE_INODE_EVENT(xfs_inode_free_eofblocks_invalid);
>  
> +DEFINE_INODE_EVENT(xfs_filemap_fault);
> +
>  DECLARE_EVENT_CLASS(xfs_iref_class,
>  	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
>  	TP_ARGS(ip, caller_ip),
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
