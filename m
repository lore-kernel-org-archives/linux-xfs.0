Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 19:27:58 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M3Rrfm027790
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 19:27:54 -0800
Received: from mail.sceen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AB41604CFA
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 19:28:19 -0800 (PST)
Received: from mail.sceen.net (sceen.net [213.41.243.68]) by cuda.sgi.com with ESMTP id Y5kBCUuGoMA6pSj7 for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 19:28:19 -0800 (PST)
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH, mainline-only] remove dmapi cruft in xfs_file.c
In-Reply-To: <20080208044405.GB15013@lst.de> (Christoph Hellwig's message of
	"Fri, 8 Feb 2008 05:44:06 +0100")
References: <20080208044405.GB15013@lst.de>
Date: Fri, 22 Feb 2008 14:26:53 +1100
Message-ID: <nccir0h1xj6.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com


Hey Lachy, can you push that to git@oss (it makes no sense in dev) ?

Thanks.

Christoph Hellwig <hch@lst.de> writes:

> The dmapi cruft in xfs_file.c is totally out of date in mainline vs
> CVS, and at this point just removing this code which can't be used on
> mainline at all seems to be the best option to keep it maintainable.
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Niv Sardi <xaiki@sgi.com>
>
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_file.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_file.c	2008-02-08 05:30:57.000000000 +0100
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_file.c	2008-02-08 05:31:26.000000000 +0100
> @@ -43,9 +43,6 @@
>  #include <linux/smp_lock.h>
>  
>  static struct vm_operations_struct xfs_file_vm_ops;
> -#ifdef CONFIG_XFS_DMAPI
> -static struct vm_operations_struct xfs_dmapi_file_vm_ops;
> -#endif
>  
>  STATIC_INLINE ssize_t
>  __xfs_file_read(
> @@ -202,22 +199,6 @@ xfs_file_fsync(
>  			(xfs_off_t)0, (xfs_off_t)-1);
>  }
>  
> -#ifdef CONFIG_XFS_DMAPI
> -STATIC int
> -xfs_vm_fault(
> -	struct vm_area_struct	*vma,
> -	struct vm_fault	*vmf)
> -{
> -	struct inode	*inode = vma->vm_file->f_path.dentry->d_inode;
> -	bhv_vnode_t	*vp = vn_from_inode(inode);
> -
> -	ASSERT_ALWAYS(vp->v_vfsp->vfs_flag & VFS_DMI);
> -	if (XFS_SEND_MMAP(XFS_VFSTOM(vp->v_vfsp), vma, 0))
> -		return VM_FAULT_SIGBUS;
> -	return filemap_fault(vma, vmf);
> -}
> -#endif /* CONFIG_XFS_DMAPI */
> -
>  /*
>   * Unfortunately we can't just use the clean and simple readdir implementation
>   * below, because nfs might call back into ->lookup from the filldir callback
> @@ -386,11 +367,6 @@ xfs_file_mmap(
>  	vma->vm_ops = &xfs_file_vm_ops;
>  	vma->vm_flags |= VM_CAN_NONLINEAR;
>  
> -#ifdef CONFIG_XFS_DMAPI
> -	if (XFS_M(filp->f_path.dentry->d_inode->i_sb)->m_flags & XFS_MOUNT_DMAPI)
> -		vma->vm_ops = &xfs_dmapi_file_vm_ops;
> -#endif /* CONFIG_XFS_DMAPI */
> -
>  	file_accessed(filp);
>  	return 0;
>  }
> @@ -437,52 +413,6 @@ xfs_file_ioctl_invis(
>  	return error;
>  }
>  
> -#ifdef CONFIG_XFS_DMAPI
> -#ifdef HAVE_VMOP_MPROTECT
> -STATIC int
> -xfs_vm_mprotect(
> -	struct vm_area_struct *vma,
> -	unsigned int	newflags)
> -{
> -	struct inode	*inode = vma->vm_file->f_path.dentry->d_inode;
> -	struct xfs_mount *mp = XFS_M(inode->i_sb);
> -	int		error = 0;
> -
> -	if (mp->m_flags & XFS_MOUNT_DMAPI) {
> -		if ((vma->vm_flags & VM_MAYSHARE) &&
> -		    (newflags & VM_WRITE) && !(vma->vm_flags & VM_WRITE))
> -			error = XFS_SEND_MMAP(mp, vma, VM_WRITE);
> -	}
> -	return error;
> -}
> -#endif /* HAVE_VMOP_MPROTECT */
> -#endif /* CONFIG_XFS_DMAPI */
> -
> -#ifdef HAVE_FOP_OPEN_EXEC
> -/* If the user is attempting to execute a file that is offline then
> - * we have to trigger a DMAPI READ event before the file is marked as busy
> - * otherwise the invisible I/O will not be able to write to the file to bring
> - * it back online.
> - */
> -STATIC int
> -xfs_file_open_exec(
> -	struct inode	*inode)
> -{
> -	struct xfs_mount *mp = XFS_M(inode->i_sb);
> -
> -	if (unlikely(mp->m_flags & XFS_MOUNT_DMAPI)) {
> -		if (DM_EVENT_ENABLED(XFS_I(inode), DM_EVENT_READ)) {
> -			bhv_vnode_t *vp = vn_from_inode(inode);
> -
> -			return -XFS_SEND_DATA(mp, DM_EVENT_READ,
> -						vp, 0, 0, 0, NULL);
> -		}
> -	}
> -
> -	return 0;
> -}
> -#endif /* HAVE_FOP_OPEN_EXEC */
> -
>  /*
>   * mmap()d file has taken write protection fault and is being made
>   * writable. We can set the page state up correctly for a writable
> @@ -551,13 +481,3 @@ static struct vm_operations_struct xfs_f
>  	.fault		= filemap_fault,
>  	.page_mkwrite	= xfs_vm_page_mkwrite,
>  };
> -
> -#ifdef CONFIG_XFS_DMAPI
> -static struct vm_operations_struct xfs_dmapi_file_vm_ops = {
> -	.fault		= xfs_vm_fault,
> -	.page_mkwrite	= xfs_vm_page_mkwrite,
> -#ifdef HAVE_VMOP_MPROTECT
> -	.mprotect	= xfs_vm_mprotect,
> -#endif
> -};
> -#endif /* CONFIG_XFS_DMAPI */
>

-- 
Niv Sardi
