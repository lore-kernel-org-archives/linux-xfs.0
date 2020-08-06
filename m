Return-Path: <SRS0=zhh1=BQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C44C433DF
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 19:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83159221E2
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Aug 2020 19:52:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DqKwVVbM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgHFTwv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Aug 2020 15:52:51 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52600 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFTwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Aug 2020 15:52:50 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076Jm9UF107539;
        Thu, 6 Aug 2020 19:52:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=pB+G112FZz5v5NUJe9J401h5GZcAjzlEEGp2GdaehSQ=;
 b=DqKwVVbMIKLntwInFqFHO/fXby1qqvBwsVPvRZBwJl/iIMu7yC8q6auWP4fgFDT0gBMX
 A8+a8zAUe5eBZdqSPJO1PALvScrFQlNqGC5d+86NerwDaFiVqIkVkxe03e7CALVP3Hru
 KPbphx4XhN27p+jw0U/oZAvtZAwJFRmfD6qf3lodlE4Gxfi2RbDnmWQ9SSeBKiskYslt
 C9XX6vzWg/Pu6V/mj5BN26BArNysxvh0fk6qEDpfvI0+Yq+FpA61pSb+DYTLumXMa7oi
 TPJo91x5ULuJZwPLbi+HZGgymPnPaJXpe1q2aUbCMBtE/G/Cg4m/QOvfJctgzA3BKn3k 5Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32r6ep510q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 19:52:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076JnABS040985;
        Thu, 6 Aug 2020 19:52:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32qy8p1vu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 19:52:44 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 076JqhsU018523;
        Thu, 6 Aug 2020 19:52:43 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 12:52:43 -0700
Date:   Thu, 6 Aug 2020 12:52:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: move custom interface definitions out of
 xfs_fs.h
Message-ID: <20200806195242.GC6096@magnolia>
References: <df0d78d0-eada-374a-2720-897fb75bd34b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df0d78d0-eada-374a-2720-897fb75bd34b@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=26 malwarescore=0
 spamscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=26 bulkscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008060127
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Aug 06, 2020 at 12:36:48PM -0700, Eric Sandeen wrote:
> There are several definitions and structures present in the userspace
> copy of libxfs/xfs_fs.h which support older, custom xfs interfaces
> which are now common definitions in the vfs.
> 
> Move them into their own compat header to minimize the shared file
> differences.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Hooray for shoving all the cobwebs behind the stereo! :)
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/include/Makefile b/include/Makefile
> index a80867e4..3031fb5c 100644
> --- a/include/Makefile
> +++ b/include/Makefile
> @@ -35,6 +35,7 @@ HFILES = handle.h \
>  	linux.h \
>  	xfs.h \
>  	xqm.h \
> +	xfs_fs_compat.h \
>  	xfs_arch.h
>  
>  LSRCFILES = platform_defs.h.in builddefs.in buildmacros buildrules install-sh
> diff --git a/include/xfs.h b/include/xfs.h
> index f673d92e..af0d36ce 100644
> --- a/include/xfs.h
> +++ b/include/xfs.h
> @@ -39,6 +39,8 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
>  #endif
>  
>  #include <xfs/xfs_types.h>
> +/* Include deprecated/compat pre-vfs xfs-specific symbols */
> +#include <xfs/xfs_fs_compat.h>
>  #include <xfs/xfs_fs.h>
>  
>  #endif	/* __XFS_H__ */
> diff --git a/include/xfs_fs_compat.h b/include/xfs_fs_compat.h
> new file mode 100644
> index 00000000..154a802d
> --- /dev/null
> +++ b/include/xfs_fs_compat.h
> @@ -0,0 +1,88 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +/*
> + * Copyright (c) 1995-2005 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + */
> +#ifndef __XFS_FS_COMPAT_H__
> +#define __XFS_FS_COMPAT_H__
> +
> +/*
> + * Backwards-compatible definitions and structures for public kernel interfaces
> + */
> +
> +/*
> + * Flags for the bs_xflags/fsx_xflags field in XFS_IOC_FS[GS]ETXATTR[A]
> + * These are for backwards compatibility only. New code should
> + * use the kernel [4.5 onwards] defined FS_XFLAG_* definitions directly.
> + */
> +#define	XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
> +#define	XFS_XFLAG_PREALLOC	FS_XFLAG_PREALLOC
> +#define	XFS_XFLAG_IMMUTABLE	FS_XFLAG_IMMUTABLE
> +#define	XFS_XFLAG_APPEND	FS_XFLAG_APPEND
> +#define	XFS_XFLAG_SYNC		FS_XFLAG_SYNC
> +#define	XFS_XFLAG_NOATIME	FS_XFLAG_NOATIME
> +#define	XFS_XFLAG_NODUMP	FS_XFLAG_NODUMP
> +#define	XFS_XFLAG_RTINHERIT	FS_XFLAG_RTINHERIT
> +#define	XFS_XFLAG_PROJINHERIT	FS_XFLAG_PROJINHERIT
> +#define	XFS_XFLAG_NOSYMLINKS	FS_XFLAG_NOSYMLINKS
> +#define	XFS_XFLAG_EXTSIZE	FS_XFLAG_EXTSIZE
> +#define	XFS_XFLAG_EXTSZINHERIT	FS_XFLAG_EXTSZINHERIT
> +#define	XFS_XFLAG_NODEFRAG	FS_XFLAG_NODEFRAG
> +#define	XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM
> +#define	XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR
> +
> +/*
> + * Don't use this.
> + * Use struct file_clone_range
> + */
> +struct xfs_clone_args {
> +	__s64 src_fd;
> +	__u64 src_offset;
> +	__u64 src_length;
> +	__u64 dest_offset;
> +};
> +
> +/*
> + * Don't use these.
> + * Use FILE_DEDUPE_RANGE_SAME / FILE_DEDUPE_RANGE_DIFFERS
> + */
> +#define XFS_EXTENT_DATA_SAME	0
> +#define XFS_EXTENT_DATA_DIFFERS	1
> +
> +/* Don't use this. Use file_dedupe_range_info */
> +struct xfs_extent_data_info {
> +	__s64 fd;		/* in - destination file */
> +	__u64 logical_offset;	/* in - start of extent in destination */
> +	__u64 bytes_deduped;	/* out - total # of bytes we were able
> +				 * to dedupe from this file */
> +	/* status of this dedupe operation:
> +	 * < 0 for error
> +	 * == XFS_EXTENT_DATA_SAME if dedupe succeeds
> +	 * == XFS_EXTENT_DATA_DIFFERS if data differs
> +	 */
> +	__s32 status;		/* out - see above description */
> +	__u32 reserved;
> +};
> +
> +/*
> + * Don't use this.
> + * Use struct file_dedupe_range
> + */
> +struct xfs_extent_data {
> +	__u64 logical_offset;	/* in - start of extent in source */
> +	__u64 length;		/* in - length of extent */
> +	__u16 dest_count;	/* in - total elements in info array */
> +	__u16 reserved1;
> +	__u32 reserved2;
> +	struct xfs_extent_data_info info[0];
> +};
> +
> +/*
> + * Don't use these.
> + * Use FICLONE/FICLONERANGE/FIDEDUPERANGE
> + */
> +#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
> +#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
> +#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
> +
> +#endif	/* __XFS_FS_COMPAT_H__ */
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 36fae384..84bcffa8 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -23,27 +23,6 @@ struct dioattr {
>  };
>  #endif
>  
> -/*
> - * Flags for the bs_xflags/fsx_xflags field in XFS_IOC_FS[GS]ETXATTR[A]
> - * These are for backwards compatibility only. New code should
> - * use the kernel [4.5 onwards] defined FS_XFLAG_* definitions directly.
> - */
> -#define	XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
> -#define	XFS_XFLAG_PREALLOC	FS_XFLAG_PREALLOC
> -#define	XFS_XFLAG_IMMUTABLE	FS_XFLAG_IMMUTABLE
> -#define	XFS_XFLAG_APPEND	FS_XFLAG_APPEND
> -#define	XFS_XFLAG_SYNC		FS_XFLAG_SYNC
> -#define	XFS_XFLAG_NOATIME	FS_XFLAG_NOATIME
> -#define	XFS_XFLAG_NODUMP	FS_XFLAG_NODUMP
> -#define	XFS_XFLAG_RTINHERIT	FS_XFLAG_RTINHERIT
> -#define	XFS_XFLAG_PROJINHERIT	FS_XFLAG_PROJINHERIT
> -#define	XFS_XFLAG_NOSYMLINKS	FS_XFLAG_NOSYMLINKS
> -#define	XFS_XFLAG_EXTSIZE	FS_XFLAG_EXTSIZE
> -#define	XFS_XFLAG_EXTSZINHERIT	FS_XFLAG_EXTSZINHERIT
> -#define	XFS_XFLAG_NODEFRAG	FS_XFLAG_NODEFRAG
> -#define	XFS_XFLAG_FILESTREAM	FS_XFLAG_FILESTREAM
> -#define	XFS_XFLAG_HASATTR	FS_XFLAG_HASATTR
> -
>  /*
>   * Structure for XFS_IOC_GETBMAP.
>   * On input, fill in bmv_offset and bmv_length of the first structure
> @@ -858,47 +837,6 @@ struct xfs_scrub_metadata {
>  #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
> -/* reflink ioctls; these MUST match the btrfs ioctl definitions */
> -/* from struct btrfs_ioctl_clone_range_args */
> -struct xfs_clone_args {
> -	__s64 src_fd;
> -	__u64 src_offset;
> -	__u64 src_length;
> -	__u64 dest_offset;
> -};
> -
> -/* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl definitions */
> -#define XFS_EXTENT_DATA_SAME	0
> -#define XFS_EXTENT_DATA_DIFFERS	1
> -
> -/* from struct btrfs_ioctl_file_extent_same_info */
> -struct xfs_extent_data_info {
> -	__s64 fd;		/* in - destination file */
> -	__u64 logical_offset;	/* in - start of extent in destination */
> -	__u64 bytes_deduped;	/* out - total # of bytes we were able
> -				 * to dedupe from this file */
> -	/* status of this dedupe operation:
> -	 * < 0 for error
> -	 * == XFS_EXTENT_DATA_SAME if dedupe succeeds
> -	 * == XFS_EXTENT_DATA_DIFFERS if data differs
> -	 */
> -	__s32 status;		/* out - see above description */
> -	__u32 reserved;
> -};
> -
> -/* from struct btrfs_ioctl_file_extent_same_args */
> -struct xfs_extent_data {
> -	__u64 logical_offset;	/* in - start of extent in source */
> -	__u64 length;		/* in - length of extent */
> -	__u16 dest_count;	/* in - total elements in info array */
> -	__u16 reserved1;
> -	__u32 reserved2;
> -	struct xfs_extent_data_info info[0];
> -};
> -
> -#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
> -#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_clone_args)
> -#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_extent_data)
>  
>  #ifndef HAVE_BBMACROS
>  /*
> 
