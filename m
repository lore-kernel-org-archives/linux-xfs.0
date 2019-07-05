Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:46154 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbfGEPxH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Jul 2019 11:53:07 -0400
Subject: Re: [PATCH 8/9] man: create a separate GETBMAPX/GETBMAPA/GETBMAP
 ioctl manpage
References: <156104944877.1174403.14568482035189263260.stgit@magnolia>
 <156104950296.1174403.15218317280608955242.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <06724ca8-8a13-7e2b-eb68-295ed316e95e@sandeen.net>
Date: Fri, 5 Jul 2019 10:53:05 -0500
MIME-Version: 1.0
In-Reply-To: <156104950296.1174403.15218317280608955242.stgit@magnolia>
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
> Create a separate manual page for the xfs BMAP ioctls so we can document
> how they work.

Same drill ... ;)

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  man/man2/ioctl_xfs_getbmap.2  |    1 
>  man/man2/ioctl_xfs_getbmapa.2 |    1 
>  man/man2/ioctl_xfs_getbmapx.2 |  172 +++++++++++++++++++++++++++++++++++++++++
>  man/man3/xfsctl.3             |   61 ++-------------
>  4 files changed, 184 insertions(+), 51 deletions(-)
>  create mode 100644 man/man2/ioctl_xfs_getbmap.2
>  create mode 100644 man/man2/ioctl_xfs_getbmapa.2
>  create mode 100644 man/man2/ioctl_xfs_getbmapx.2
> 
> 
> diff --git a/man/man2/ioctl_xfs_getbmap.2 b/man/man2/ioctl_xfs_getbmap.2
> new file mode 100644
> index 00000000..909402fc
> --- /dev/null
> +++ b/man/man2/ioctl_xfs_getbmap.2
> @@ -0,0 +1 @@
> +.so man2/ioctl_xfs_getbmapx.2
> diff --git a/man/man2/ioctl_xfs_getbmapa.2 b/man/man2/ioctl_xfs_getbmapa.2
> new file mode 100644
> index 00000000..909402fc
> --- /dev/null
> +++ b/man/man2/ioctl_xfs_getbmapa.2
> @@ -0,0 +1 @@
> +.so man2/ioctl_xfs_getbmapx.2
> diff --git a/man/man2/ioctl_xfs_getbmapx.2 b/man/man2/ioctl_xfs_getbmapx.2
> new file mode 100644
> index 00000000..cf21ca32
> --- /dev/null
> +++ b/man/man2/ioctl_xfs_getbmapx.2
> @@ -0,0 +1,172 @@
> +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> +.\"
> +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> +.\" SPDX-License-Identifier: GPL-2.0+
> +.\" %%%LICENSE_END
> +.TH IOCTL-XFS-GETBMAPX 2 2019-06-17 "XFS"
> +.SH NAME
> +ioctl_xfs_getbmapx \- query extent information for an open file
> +.SH SYNOPSIS
> +.br
> +.B #include <xfs/xfs_fs.h>
> +.PP
> +.BI "int ioctl(int " fd ", XFS_IOC_GETBMAP, struct getbmap *" arg );
> +.br
> +.BI "int ioctl(int " fd ", XFS_IOC_GETBMAPA, struct getbmap *" arg );
> +.br
> +.BI "int ioctl(int " fd ", XFS_IOC_GETBMAPX, struct getbmapx *" arg );
> +.SH DESCRIPTION
> +Get the block map for a segment of a file in an XFS file system.
> +The mapping information is conveyed in a structure of the following form:

"conveyed via an array of structures of the following form"

(otherwise below we suddenly refer to "the array" which might leave some heads scratching)

> +.PP
> +.in +4n
> +.nf
> +struct getbmap {
> +	__s64   bmv_offset;
> +	__s64   bmv_block;
> +	__s64   bmv_length;
> +	__s32   bmv_count;
> +	__s32   bmv_entries;
> +};
> +.fi
> +.in
> +.PP
> +The
> +.B XFS_IOC_GETBMAPX
> +ioctl uses a larger version of that structure:
> +.PP
> +.in +4n
> +.nf
> +struct getbmapx {
> +	__s64   bmv_offset;
> +	__s64   bmv_block;
> +	__s64   bmv_length;
> +	__s32   bmv_count;
> +	__s32   bmv_entries;
> +	__s32   bmv_iflags;
> +	__s32   bmv_oflags;
> +	__s32   bmv_unused1;
> +	__s32   bmv_unused2;
> +};
> +.fi
> +.in
> +.PP
> +All sizes and offsets in the structure are in units of 512 bytes.
> +.PP
> +The first structure in the array is a header and the remaining structures in
> +the array contain block map information on return.
> +The header controls iterative calls to the command and should be filled out as
> +follows:
> +.TP
> +.I bmv_offset
> +The file offset of the area of interest in the file.
> +.TP
> +.I bmv_length
> +The length of the area of interest in the file.
> +If this value is set to -1, the length of the interesting area is the rest of
> +the file.
> +.TP
> +.I bmv_count
> +The length of the array, including this header.

"The number of elements in the array, including this header.  The minimum value is 2."

> +.TP
> +.I bmv_entries
> +The number of entries actually filled in by the call.
> +This does not need to be filled out before the call.

I also wonder if we should say something about how to know when iterative
calls are done.  Perhaps:

"This value may be zero if no extents were found in the requested
range, or if iterated calls have reached the end of the requested
range"

> +.TP
> +.I bmv_iflags
> +For the
> +.B XFS_IOC_GETBMAPX
> +function, this is a bitmask containing a combination of the following flags:
> +.RS 0.4i
> +.TP
> +.B BMV_IF_ATTRFORK
> +Return information about the extended attribute fork.
> +.TP
> +.B BMV_IF_PREALLOC
> +Return information about unwritten pre-allocated segments.
> +.TP
> +.B BMV_IF_DELALLOC
> +Return information about delayed allocation reservation segments.
> +.TP
> +.B BMV_IF_NO_HOLES
> +Do not return information about holes.
> +.RE
> +.PD 1
> +.PP
> +The other
> +.I bmv_*
> +fields in the header are ignored.
> +.PP
> +On return from a call, the header is updated so that the command can be
> +reused to obtain more information without re-initializing the structures.

Perhaps:

"On successful return from a call, the offset and length values in the header
are updated so that the command can be reused to obtain more information."


> +The remainder of the array will be filled out by the call as follows:

"The remaining elements of the array will be filled out ..."

> +
> +.TP
> +.I bmv_offset
> +File offset of segment.
> +.TP
> +.I bmv_block
> +Physical starting block of segment.
> +If this is -1, then the segment is a hole.
> +.TP
> +.I bmv_length
> +Length of segment.
> +.TP
> +.I bmv_oflags
> +The
> +.B XFS_IOC_GETBMAPX
> +function will fill this field with a combination of the following flags:
> +.RS 0.4i
> +.TP
> +.B BMV_OF_PREALLOC
> +The segment is an unwritten pre-allocation.
> +.TP
> +.B BMV_OF_DELALLOC
> +The segment is a delayed allocation reservation.
> +.TP
> +.B BMV_OF_LAST
> +This segment is the last in the file.
> +.TP
> +.B BMV_OF_SHARED
> +This segment shares blocks with other files.
> +.RE
> +.PD 1
> +.PP
> +The other
> +.I bmv_*
> +fields are ignored in the array of outputted records.

"are unused in the array of output records."

-Eric

> +.PP
> +The
> +.B XFS_IOC_GETBMAPA
> +command is identical to
> +.B XFS_IOC_GETBMAP
> +except that information about the attribute fork of the file is returned.
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
> index 89975a3c..077dd411 100644
> --- a/man/man3/xfsctl.3
> +++ b/man/man3/xfsctl.3
> @@ -144,59 +144,17 @@ See
>  .BR ioctl_xfs_fsgetxattr (2)
>  for more information.
>  
> -.TP
> -.B XFS_IOC_GETBMAP
> -Get the block map for a segment of a file in an XFS file system.
> -The final argument points to an arry of variables of type
> -.BR "struct getbmap" .
> -All sizes and offsets in the structure are in units of 512 bytes.
> -The structure fields include:
> -.B bmv_offset
> -(file offset of segment),
> -.B bmv_block
> -(starting block of segment),
> -.B bmv_length
> -(length of segment),
> -.B bmv_count
> -(number of array entries, including the first), and
> -.B bmv_entries
> -(number of entries filled in).
> -The first structure in the array is a header, and the remaining
> -structures in the array contain block map information on return.
> -The header controls iterative calls to the
> +.PP
> +.nf
>  .B XFS_IOC_GETBMAP
> -command.
> -The caller fills in the
> -.B bmv_offset
> -and
> -.B bmv_length
> -fields of the header to indicate the area of interest in the file,
> -and fills in the
> -.B bmv_count
> -field to indicate the length of the array.
> -If the
> -.B bmv_length
> -value is set to \-1 then the length of the interesting area is the rest
> -of the file.
> -On return from a call, the header is updated so that the command can be
> -reused to obtain more information, without re-initializing the structures.
> -Also on return, the
> -.B bmv_entries
> -field of the header is set to the number of array entries actually filled in.
> -The non-header structures will be filled in with
> -.BR bmv_offset ,
> -.BR bmv_block ,
> -and
> -.BR bmv_length .
> -If a region of the file has no blocks (is a hole in the file) then the
> -.B bmv_block
> -field is set to \-1.
> -
> -.TP
>  .B XFS_IOC_GETBMAPA
> -Identical to
> -.B XFS_IOC_GETBMAP
> -except that information about the attribute fork of the file is returned.
> +.fi
> +.PD 0
> +.TP
> +.B XFS_IOC_GETBMAPX
> +See
> +.BR ioctl_getbmap (2)
> +for more information.
>  
>  .PP
>  .B XFS_IOC_RESVSP
> @@ -429,6 +387,7 @@ as they are not of general use to applications.
>  .BR ioctl_xfs_fsinumbers (2),
>  .BR ioctl_xfs_fscounts (2),
>  .BR ioctl_xfs_getresblks (2),
> +.BR ioctl_xfs_getbmap (2),
>  .BR fstatfs (2),
>  .BR statfs (2),
>  .BR xfs (5),
> 
