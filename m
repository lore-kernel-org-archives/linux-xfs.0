Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 08:33:18 -0700 (PDT)
Received: from over.ny.us.ibm.com (over.ny.us.ibm.com [32.97.182.150])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5PFXAdO015747
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 08:33:13 -0700
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
	by pokfb.esmtp.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l5PF3NDW006243
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 11:03:23 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5PF3MMh031305
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 11:03:22 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5PF3Hx1173796
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 09:03:17 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5PF3GIS010030
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 09:03:17 -0600
Date: Mon, 25 Jun 2007 20:33:20 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070625150320.GA8686@amitarora.in.ibm.com>
References: <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625134500.GE1951@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

I have not implemented FA_FL_FREE_ENOSPC and FA_ZERO_SPACE flags yet, as
*suggested* by Andreas in http://lkml.org/lkml/2007/6/14/323  post.
If it is decided that these flags are also needed, I will update this
patch. Thanks!

On Mon, Jun 25, 2007 at 07:15:00PM +0530, Amit K. Arora wrote:
> Implement new flags and values for mode argument.
> 
> This patch implements the new flags and values for the "mode" argument
> of the fallocate system call. It is based on the discussion between
> Andreas Dilger and David Chinner on the man page proposed (by the later)
> on fallocate.
> 
> Signed-off-by: Amit Arora <aarora@in.ibm.com>
> 
> Index: linux-2.6.22-rc4/include/linux/fs.h
> ===================================================================
> --- linux-2.6.22-rc4.orig/include/linux/fs.h
> +++ linux-2.6.22-rc4/include/linux/fs.h
> @@ -267,15 +267,16 @@ extern int dir_notify_enable;
>  #define SYNC_FILE_RANGE_WAIT_AFTER	4
> 
>  /*
> - * sys_fallocate modes
> - * Currently sys_fallocate supports two modes:
> - * FA_ALLOCATE  : This is the preallocate mode, using which an application/user
> - *		  may request (pre)allocation of blocks.
> - * FA_DEALLOCATE: This is the deallocate mode, which can be used to free
> - *		  the preallocated blocks.
> + * sys_fallocate mode flags and values
>   */
> -#define FA_ALLOCATE	0x1
> -#define FA_DEALLOCATE	0x2
> +#define FA_FL_DEALLOC	0x01 /* default is allocate */
> +#define FA_FL_KEEP_SIZE	0x02 /* default is extend/shrink size */
> +#define FA_FL_DEL_DATA	0x04 /* default is keep written data on DEALLOC */
> +
> +#define FA_ALLOCATE	0
> +#define FA_DEALLOCATE	FA_FL_DEALLOC
> +#define FA_RESV_SPACE	FA_FL_KEEP_SIZE
> +#define FA_UNRESV_SPACE	(FA_FL_DEALLOC | FA_FL_KEEP_SIZE | FA_FL_DEL_DATA)
> 
>  #ifdef __KERNEL__
> 
> Index: linux-2.6.22-rc4/fs/open.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/open.c
> +++ linux-2.6.22-rc4/fs/open.c
> @@ -356,23 +356,26 @@ asmlinkage long sys_ftruncate64(unsigned
>   * sys_fallocate - preallocate blocks or free preallocated blocks
>   * @fd: the file descriptor
>   * @mode: mode specifies if fallocate should preallocate blocks OR free
> - *	  (unallocate) preallocated blocks. Currently only FA_ALLOCATE and
> - *	  FA_DEALLOCATE modes are supported.
> + *	  (unallocate) preallocated blocks.
>   * @offset: The offset within file, from where (un)allocation is being
>   *	    requested. It should not have a negative value.
>   * @len: The amount (in bytes) of space to be (un)allocated, from the offset.
>   *
>   * This system call, depending on the mode, preallocates or unallocates blocks
>   * for a file. The range of blocks depends on the value of offset and len
> - * arguments provided by the user/application. For FA_ALLOCATE mode, if this
> + * arguments provided by the user/application. For FA_ALLOCATE and
> + * FA_RESV_SPACE modes, if the sys_fallocate()
>   * system call succeeds, subsequent writes to the file in the given range
>   * (specified by offset & len) should not fail - even if the file system
>   * later becomes full. Hence the preallocation done is persistent (valid
> - * even after reopen of the file and remount/reboot).
> + * even after reopen of the file and remount/reboot). If FA_RESV_SPACE mode
> + * is passed, the file size will not be changed even if the preallocation
> + * is beyond EOF.
>   *
>   * It is expected that the ->fallocate() inode operation implemented by the
>   * individual file systems will update the file size and/or ctime/mtime
> - * depending on the mode and also on the success of the operation.
> + * depending on the mode (change is visible to user or not - say file size)
> + * and obviously, on the success of the operation.
>   *
>   * Note: Incase the file system does not support preallocation,
>   * posix_fallocate() should fall back to the library implementation (i.e.
> @@ -398,7 +401,8 @@ asmlinkage long sys_fallocate(int fd, in
> 
>  	/* Return error if mode is not supported */
>  	ret = -EOPNOTSUPP;
> -	if (mode != FA_ALLOCATE && mode != FA_DEALLOCATE)
> +	if (!(mode == FA_ALLOCATE || mode == FA_DEALLOCATE ||
> +		mode == FA_RESV_SPACE || mode == FA_UNRESV_SPACE))
>  		goto out;
> 
>  	ret = -EBADF;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
