Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46076 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbfFQRPl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jun 2019 13:15:41 -0400
Subject: Re: [PATCH 7/9] libxfs: break out the RESBLKS manpage
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993578504.2343530.9106560408928916864.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8e9a0911-94b0-e18f-c7c3-1c2728443875@sandeen.net>
Date: Mon, 17 Jun 2019 12:15:40 -0500
MIME-Version: 1.0
In-Reply-To: <155993578504.2343530.9106560408928916864.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 6/7/19 2:29 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a separate manual page for the RESBLKS ioctls so we can document
> how they work.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man2/ioctl_xfs_getresblks.2 |   65 +++++++++++++++++++++++++++++++++++++++
>  man/man3/xfsctl.3               |   14 +++++++-
>  2 files changed, 77 insertions(+), 2 deletions(-)
>  create mode 100644 man/man2/ioctl_xfs_getresblks.2
> 
> 
> diff --git a/man/man2/ioctl_xfs_getresblks.2 b/man/man2/ioctl_xfs_getresblks.2
> new file mode 100644
> index 00000000..57533927
> --- /dev/null
> +++ b/man/man2/ioctl_xfs_getresblks.2
> @@ -0,0 +1,65 @@
> +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> +.\"
> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> +.\" SPDX-License-Identifier: GPL-2.0+
> +.\" %%%LICENSE_END
> +.TH IOCTL-XFS-GETRESBLKS 2 2019-04-16 "XFS"
> +.SH NAME
> +ioctl_xfs_getresblks \- query XFS summary counter information
> +.SH SYNOPSIS
> +.br
> +.B #include <xfs/xfs_fs.h>
> +.PP
> +.BI "int ioctl(int " fd ", XFS_IOC_GET_RESBLKS, struct xfs_fsop_resblks *" arg );
> +.PP
> +.BI "int ioctl(int " fd ", XFS_IOC_SET_RESBLKS, struct xfs_fsop_resblks *" arg );
> +.SH DESCRIPTION
> +Query or set the free space reservation information.
> +These blocks are reserved by the filesystem as a last-ditch attempt to prevent

last-ditch is a bit colloquial and possibly not fun for translators?

s/a last-ditch/an/

> +metadata update failures due to insufficient space.
> +Only the system administrator can call these ioctls, because overriding the
> +defaults is extremely dangerous and should never be tried by anyone.
> +.PP
> +The reservation information is conveyed in a structure of the following form:
> +.PP
> +.in +4n
> +.nf
> +struct xfs_fsop_resblks {
> +	__u64  resblks;
> +	__u64  resblks_avail;
> +};
> +.fi
> +.in
> +.PP
> +.I resblks
> +is the number of blocks that the filesystem will try to maintain to prevent
> +critical out of space situations.
> +.PP
> +.I resblks_avail
> +is the number of reserved blocks remaining.
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
> +.TP
> +.B EPERM
> +Caller does not have permission to call this ioctl.
> +.SH CONFORMING TO
> +This API is specific to XFS filesystem on the Linux kernel.
> +.SH SEE ALSO
> +.BR ioctl (2)
> diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> index 007f7d58..25e51417 100644
> --- a/man/man3/xfsctl.3
> +++ b/man/man3/xfsctl.3
> @@ -396,12 +396,21 @@ See
>  .BR ioctl_xfs_fscounts (2)
>  for more information.
>  
> +.TP
> +.nf
> +.B XFS_IOC_GET_RESBLKS
> +.fi
> +.TP
> +.B XFS_IOC_SET_RESBLKS
> +See
> +.BR ioctl_xfs_getresblks (2)
> +for more information.
> +Save yourself a lot of frustration and avoid these ioctls.
> +
>  .PP
>  .nf
>  .B XFS_IOC_THAW
>  .B XFS_IOC_FREEZE
> -.B XFS_IOC_GET_RESBLKS
> -.B XFS_IOC_SET_RESBLKS
>  .B XFS_IOC_FSGROWFSDATA
>  .B XFS_IOC_FSGROWFSLOG
>  .fi
> @@ -418,6 +427,7 @@ as they are not of general use to applications.
>  .BR ioctl_xfs_fsbulkstat (2),
>  .BR ioctl_xfs_fsinumbers (2),
>  .BR ioctl_xfs_fscounts (2),
> +.BR ioctl_xfs_getresblks (2),
>  .BR fstatfs (2),
>  .BR statfs (2),
>  .BR xfs (5),
> 
