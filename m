Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:43188 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbfGEPQ5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 11:16:57 -0400
Subject: Re: [PATCH 5/9] man: create a separate INUMBERS ioctl manpage
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
 <156104948000.1174403.11692931049872468663.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <ba312282-189d-df3c-72f6-53d93781e7b1@sandeen.net>
Date: Fri, 5 Jul 2019 10:16:56 -0500
MIME-Version: 1.0
In-Reply-To: <156104948000.1174403.11692931049872468663.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/20/19 11:51 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a separate manual page for the xfs INUMBERS ioctl so we can
> document how it works.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

modulo small change to move "last inode". to "last inode."

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
>  man/man2/ioctl_xfs_fsinumbers.2 |  122 +++++++++++++++++++++++++++++++++++++++
>  man/man3/xfsctl.3               |   34 +----------
>  2 files changed, 126 insertions(+), 30 deletions(-)
>  create mode 100644 man/man2/ioctl_xfs_fsinumbers.2
> 
> 
> diff --git a/man/man2/ioctl_xfs_fsinumbers.2 b/man/man2/ioctl_xfs_fsinumbers.2
> new file mode 100644
> index 00000000..04f32109
> --- /dev/null
> +++ b/man/man2/ioctl_xfs_fsinumbers.2
> @@ -0,0 +1,122 @@
> +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> +.\"
> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> +.\" SPDX-License-Identifier: GPL-2.0+
> +.\" %%%LICENSE_END
> +.TH IOCTL-XFS-FSINUMBERS 2 2019-06-17 "XFS"
> +.SH NAME
> +ioctl_xfs_fsinumbers \- extract a list of valid inode numbers from an XFS filesystem
> +.SH SYNOPSIS
> +.br
> +.B #include <xfs/xfs_fs.h>
> +.PP
> +.BI "int ioctl(int " fd ", XFS_IOC_FSINUMBERS, struct xfs_fsop_bulkreq *" arg );
> +.SH DESCRIPTION
> +Queries inode allocation information from an XFS filesystem.
> +It is intended to be called iteratively to obtain the entire set of inodes.
> +These ioctls use
> +.B struct xfs_fsop_bulkreq
> +to set up a bulk transfer with the kernel:
> +.PP
> +.in +4n
> +.nf
> +struct xfs_fsop_bulkreq {
> +	__u64   *lastip;
> +	__s32   count;
> +	void    *ubuffer;
> +	__s32   *ocount;
> +};
> +.fi
> +.in
> +.PP
> +.I lastip
> +points to a value that will receive the number of the "last inode".
> +This should be set to one less than the number of the first inode for which the
> +caller wants information, or zero to start with the first inode in the
> +filesystem.
> +After the call, this value will be set to the number of the last inode for
> +which information is supplied.
> +This field will not be updated if
> +.I ocount
> +is NULL.
> +.PP
> +.I count
> +is the number of elements in the
> +.B ubuffer
> +array and therefore the number of inode groups for which to return allocation
> +information.
> +.PP
> +.I ocount
> +points to a value that will receive the number of records returned.
> +An output value of zero means that there are no more inode groups left to
> +enumerate.
> +If this value is NULL, then neither
> +.I ocount
> +nor
> +.I lastip
> +will be updated.
> +.PP
> +.I ubuffer
> +points to a memory buffer where inode group information will be copied.
> +This buffer must be an array of
> +.B struct xfs_inogrp
> +which is described below.
> +The array must have at least
> +.I count
> +elements.
> +.PP
> +.in +4n
> +.nf
> +struct xfs_inogrp {
> +	__u64   xi_startino;
> +	__s32   xi_alloccount;
> +	__u64   xi_allocmask;
> +}
> +.fi
> +.in
> +.PP
> +This structure describes inode usage information for a group of 64 consecutive
> +inode numbers.
> +The fields are as follows:
> +.PP
> +.I xi_startino
> +is the first inode number of this group.
> +.PP
> +.I xi_alloccount
> +is the number of bits that are set in
> +.IR xi_allocmask .
> +This is the number of inodes allocated in this group.
> +.PP
> +.I xi_allocmask
> +is a bitmask of inodes that are allocated in this inode group.
> +The bitmask is 64 bits long, and the least significant bit corresponds to inode
> +.BR xi_startino .
> +.SH RETURN VALUE
> +On error, \-1 is returned, and
> +.I errno
> +is set to indicate the error.
> +.PP
> +.SH ERRORS
> +Error codes can be one of, but are not limited to, the following:
> +.TP
> +.B EFAULT
> +The kernel was not able to copy into the userspace buffer.
> +.TP
> +.B EFSBADCRC
> +Metadata checksum validation failed while performing the query.
> +.TP
> +.B EFSCORRUPTED
> +Metadata corruption was encountered while performing the query.
> +.TP
> +.B EINVAL
> +One of the arguments was not valid.
> +.TP
> +.B EIO
> +An I/O error was encountered while performing the query.
> +.TP
> +.B ENOMEM
> +There was insufficient memory to perform the query.
> +.SH CONFORMING TO
> +This API is specific to XFS filesystem on the Linux kernel.
> +.SH SEE ALSO
> +.BR ioctl (2)
> diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> index 78fad975..c14f7d33 100644
> --- a/man/man3/xfsctl.3
> +++ b/man/man3/xfsctl.3
> @@ -368,36 +368,9 @@ can be any open file in the XFS filesystem in question.
>  .PP
>  .TP
>  .B XFS_IOC_FSINUMBERS
> -This interface is used to extract a list of valid inode numbers from an
> -XFS filesystem.
> -It is intended to be called iteratively, to obtain the entire set of inodes.
> -The information is passed in and out via a structure of type
> -.B xfs_fsop_bulkreq_t
> -pointed to by the final argument.
> -.B lastip
> -is a pointer to a variable containing the last inode number returned,
> -initially it should be zero.
> -.B icount
> -is the size of the array of structures specified by
> -.BR ubuffer .
> -.B ubuffer
> -is the address of an array of structures, of type
> -.BR xfs_inogrp_t .
> -This structure has the following elements:
> -.B xi_startino
> -(starting inode number),
> -.B xi_alloccount
> -(count of bits set in xi_allocmask), and
> -.B xi_allocmask
> -(mask of allocated inodes in this group).
> -The bitmask is 64 bits long, and the least significant bit corresponds to inode
> -.B xi_startino.
> -Each bit is set if the corresponding inode is in use.
> -.B ocount
> -is a pointer to a count of returned values, filled in by the call.
> -An output
> -.B ocount
> -value of zero means that the inode table has been exhausted.
> +See
> +.BR ioctl_xfs_fsinumbers (2)
> +for more information.
>  
>  .TP
>  .B XFS_IOC_FSGEOMETRY
> @@ -443,6 +416,7 @@ as they are not of general use to applications.
>  .BR ioctl_xfs_fsop_geometry (2),
>  .BR ioctl_xfs_fsbulkstat (2),
>  .BR ioctl_xfs_scrub_metadata (2),
> +.BR ioctl_xfs_fsinumbers (2),
>  .BR fstatfs (2),
>  .BR statfs (2),
>  .BR xfs (5),
> 
