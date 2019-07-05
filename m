Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43060 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727918AbfGEPPl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 11:15:41 -0400
Subject: Re: [PATCH 6/9] man: create a separate FSCOUNTS ioctl manpage
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
 <156104948638.1174403.13393187882783073949.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <7fffd033-5f5f-beba-53c7-cac61e090f26@sandeen.net>
Date: Fri, 5 Jul 2019 10:15:39 -0500
MIME-Version: 1.0
In-Reply-To: <156104948638.1174403.13393187882783073949.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/20/19 11:51 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a separate manual page for the xfs FSCOUNTS ioctl so we can
> document how it works.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man2/ioctl_xfs_fscounts.2 |   69 +++++++++++++++++++++++++++++++++++++++++
>  man/man3/xfsctl.3             |   14 +++++---
>  2 files changed, 77 insertions(+), 6 deletions(-)
>  create mode 100644 man/man2/ioctl_xfs_fscounts.2
> 
> 
> diff --git a/man/man2/ioctl_xfs_fscounts.2 b/man/man2/ioctl_xfs_fscounts.2
> new file mode 100644
> index 00000000..eb7df89c
> --- /dev/null
> +++ b/man/man2/ioctl_xfs_fscounts.2
> @@ -0,0 +1,69 @@
> +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> +.\"
> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> +.\" SPDX-License-Identifier: GPL-2.0+
> +.\" %%%LICENSE_END
> +.TH IOCTL-XFS-FSCOUNTS 2 2019-06-17 "XFS"
> +.SH NAME
> +ioctl_xfs_fscounts \- query XFS summary counter information
> +.SH SYNOPSIS
> +.br
> +.B #include <xfs/xfs_fs.h>
> +.PP
> +.BI "int ioctl(int " fd ", XFS_IOC_FSCOUNTS, struct xfs_fsop_counts *" arg );
> +.SH DESCRIPTION
> +Query the raw filesystem summary counters.
> +Unlike
> +.BR statvfs (3),
> +the values returned here are the raw values, which do not reflect any
> +alterations or limits set by project quotas.
> +The counter information is conveyed in a structure of the following form:
> +.PP
> +.in +4n
> +.nf
> +struct xfs_fsop_counts {
> +	__u64   freedata;
> +	__u64   freertx;
> +	__u64   freeino;
> +	__u64   allocino;
> +};
> +.fi
> +.in
> +.PP
> +The fields of this structure are as follows:
> +.PP
> +.I freedata
> +is the number of free filesystem blocks on the data device.
> +.PP
> +.I freertx
> +is the number of free extents on the realtime device.
> +.PP
> +.I freeino
> +is the number of inode records that are not in use within the space that has
> +been allocated for them.
> +.PP
> +.I allocino
> +is the number of inode records for which space has been allocated.
> +.SH RETURN VALUE
> +On error, \-1 is returned, and
> +.I errno
> +is set to indicate the error.
> +.PP
> +.SH ERRORS
> +Error codes can be one of, but are not limited to, the following:
> +.TP
> +.B EFSBADCRC
> +Metadata checksum validation failed while performing the query.
> +.TP
> +.B EFSCORRUPTED
> +Metadata corruption was encountered while performing the query.
> +.TP
> +.B EINVAL
> +The specified allocation group number is not valid for this filesystem.
> +.TP
> +.B EIO
> +An I/O error was encountered while performing the query.
> +.SH CONFORMING TO
> +This API is specific to XFS filesystem on the Linux kernel.
> +.SH SEE ALSO
> +.BR ioctl (2)
> diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> index c14f7d33..ee3188ec 100644
> --- a/man/man3/xfsctl.3
> +++ b/man/man3/xfsctl.3
> @@ -390,6 +390,12 @@ See
>  .BR ioctl_xfs_scrub_metadata (2)
>  for more information.
>  
> +.TP
> +.B XFS_IOC_FSCOUNTS
> +See
> +.BR ioctl_xfs_fscounts (2)
> +for more information.
> +
>  .PP
>  .nf
>  .B XFS_IOC_THAW
> @@ -398,16 +404,11 @@ for more information.
>  .B XFS_IOC_SET_RESBLKS
>  .B XFS_IOC_FSGROWFSDATA
>  .B XFS_IOC_FSGROWFSLOG
> -.B XFS_IOC_FSGROWFSRT
>  .fi
>  .TP
> -.B XFS_IOC_FSCOUNTS
> +.B XFS_IOC_FSGROWFSRT
>  These interfaces are used to implement various filesystem internal
>  operations on XFS filesystems.
> -For
> -.B XFS_FS_COUNTS
> -(get filesystem dynamic global information), the output structure is of type
> -.BR xfs_fsop_counts_t .
>  The remainder of these operations will not be described further
>  as they are not of general use to applications.
>  
> @@ -417,6 +418,7 @@ as they are not of general use to applications.
>  .BR ioctl_xfs_fsbulkstat (2),
>  .BR ioctl_xfs_scrub_metadata (2),
>  .BR ioctl_xfs_fsinumbers (2),
> +.BR ioctl_xfs_fscounts (2),
>  .BR fstatfs (2),
>  .BR statfs (2),
>  .BR xfs (5),
> 
