Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49620 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfFRTWw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 15:22:52 -0400
Date: Tue, 18 Jun 2019 12:22:46 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 3/9] libxfs: break out the bulkstat manpage
Message-ID: <20190618192246.GK5387@magnolia>
References: <155993574034.2343530.12919951702156931143.stgit@magnolia>
 <155993575992.2343530.15511255417353913747.stgit@magnolia>
 <bc6c48c9-fce3-d377-5f0c-843e5c456f5f@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc6c48c9-fce3-d377-5f0c-843e5c456f5f@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 14, 2019 at 06:02:03PM -0500, Eric Sandeen wrote:
> On 6/7/19 2:29 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Break out the bulkstat ioctl into a separate manpage so that we can
> > document how it works.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  man/man2/ioctl_xfs_fsbulkstat.2 |  212 +++++++++++++++++++++++++++++++++++++++
> >  man/man3/xfsctl.3               |   87 +---------------
> >  2 files changed, 219 insertions(+), 80 deletions(-)
> >  create mode 100644 man/man2/ioctl_xfs_fsbulkstat.2
> > 
> > 
> > diff --git a/man/man2/ioctl_xfs_fsbulkstat.2 b/man/man2/ioctl_xfs_fsbulkstat.2
> > new file mode 100644
> > index 00000000..8908631a
> > --- /dev/null
> > +++ b/man/man2/ioctl_xfs_fsbulkstat.2
> > @@ -0,0 +1,212 @@
> > +.\" Copyright (c) 2019, Oracle.  All rights reserved.
> > +.\"
> > +.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
> > +.\" SPDX-License-Identifier: GPL-2.0+
> > +.\" %%%LICENSE_END
> > +.TH IOCTL-XFS-FSBULKSTAT 2 2019-04-11 "XFS"
> > +.SH NAME
> > +ioctl_xfs_fsbulkstat \- query information for a batch of XFS inodes
> > +.SH SYNOPSIS
> > +.br
> > +.B #include <xfs/xfs_fs.h>
> > +.PP
> > +.BI "int ioctl(int " fd ", XFS_IOC_FSBULKSTAT, struct xfs_fsop_bulkreq *" arg );
> > +.PP
> 
> .br   *shrug* maybe not, seems like you have a plan here ;)

Fixed.
> 
> > +.BI "int ioctl(int " fd ", XFS_IOC_FSBULKSTAT_SINGLE, struct xfs_fsop_bulkreq *" arg );
> > +.SH DESCRIPTION
> > +Query stat information for a bunch of XFS inodes.
> 
> s/bunch/group/ or s/a bunch of//

Fixed.

> 
> > +These ioctls use
> > +.B struct xfs_fsop_bulkreq
> > +to set up a bulk transfer with the kernel:
> > +.PP
> > +.in +4n
> > +.nf
> > +struct xfs_fsop_bulkreq {
> > +	__u64             *lastip;
> > +	__s32             count;
> > +	void              *ubuffer;
> > +	__s32             *ocount;
> > +};
> > +.fi
> > +.in
> > +.PP
> > +.I lastip
> > +points to a value that will receive the number of the "last inode".
> 
> can it be NULL?

Yes; fixed.

> > +For
> > +.BR FSBULKSTAT ,
> > +this should be set to one less than the number of the first inode for which the
> > +caller wants information, or zero to start with the first inode in the
> > +filesystem.
> > +For
> > +.BR FSBULKSTAT_SINGLE ,
> > +this should be set to the number of the inode for which the caller wants
> > +information.
> > +After the call, this value will be set to the number of the last inode for
> > +which information was supplied.
> > +This field will not be updated if
> > +.I ocount
> > +is NULL.
> > +.PP
> > +.I count
> > +is the number of inodes to examine.
> 
> and the size of the area pointed to by *ubuffer?
> (I guess that's covered in the *ubuffer description)

I'll reiterate it.

> > +This value must be set to 1 for
> > +.BR FSBULKSTAT_SINGLE .
> > +.PP
> > +.I ocount
> > +points to a value that will receive the number of records returned.
> > +If this value is NULL, then neither
> > +.I ocount
> > +nor
> > +.I lastip
> > +will be updated.
> > +.PP
> > +.I ubuffer
> > +points to a memory buffer where information will be copied.
> 
> into which inode information will be copied?

Fixed.

> > +This buffer must be an array of
> > +.B struct xfs_bstat
> > +which is described below.
> > +The array must have at least
> > +.I count
> > +elements.
> > +.PP
> > +.in +4n
> > +.nf
> > +struct xfs_bstat {
> > +	__u64             bs_ino;
> > +	__u16             bs_mode;
> > +	__u16             bs_nlink;
> > +	__u32             bs_uid;
> > +	__u32             bs_gid;
> > +	__u32             bs_rdev;
> > +	__s32             bs_blksize;
> > +	__s64             bs_size;
> > +	struct xfs_bstime bs_atime;
> > +	struct xfs_bstime bs_mtime;
> > +	struct xfs_bstime bs_ctime;
> > +	int64_t           bs_blocks;
> > +	__u32             bs_xflags;
> > +	__s32             bs_extsize;
> > +	__s32             bs_extents;
> > +	__u32             bs_gen;
> > +	__u16             bs_projid_lo;
> > +	__u16             bs_forkoff;
> > +	__u16             bs_projid_hi;
> > +	unsigned char     bs_pad[6];
> > +	__u32             bs_cowextsize;
> > +	__u32             bs_dmevmask;
> > +	__u16             bs_dmstate;
> > +	__u16             bs_aextents;
> > +};
> > +.fi
> > +.in
> > +.PP
> 
> The structure members are as follows:

Ok.

> > +.I bs_ino
> > +is the number of this inode record.
> 
> is the inode number for this record

Ok.

> > +.PP
> > +.I bs_mode
> > +is the file type and mode.
> > +.PP
> > +.I bs_nlink
> > +is the number of hard links to this inode.
> > +.PP
> > +.I bs_uid
> > +is the user id.
> > +.PP
> > +.I bs_gid
> > +is the group id.
> > +.PP
> > +.I bs_rdev
> > +is the encoded device id if this is a special file.
> > +.PP
> > +.I bs_blksize
> > +is the size of a data block for this file, in units of bytes.
> > +.PP
> > +.I bs_size
> > +is the size of the file, in bytes.
> > +.PP
> > +.I bs_atime
> > +is the last time this file was accessed.
> > +.PP
> > +.I bs_mtime
> > +is the last time the contents of this file were modified.
> > +.PP
> > +.I bs_ctime
> > +is the last time this inode record was modified.
> > +.PP
> > +.I bs_blocks
> > +is the number of filesystem blocks allocated to this file, including metadata.
> > +.PP
> > +.I bs_xflags
> > +tell us what extended flags are set this inode.
> 
> contains the extended flags which are set in this inode
> 
> > +These flags are the same values as those set in the
> > +.I fsx_xflags
> > +field of
> > +.BR "struct fsxattr" ;
> > +please see the
> > +.BR ioctl_fsgetxattr (2)
> > +manpage for more information.
> 
> I dig it but you made an ioctl_xfs_fsgetxattr(2) manpage...

Fixed.

> (I forget, how do we alias manpages?)
> 
> also this should go in SEE ALSO

Fixed.

> > +
> > +.PD 1
> > +.PP
> > +.I bs_extsize
> > +is the extent size hint for this file, in bytes.
> > +.PP
> > +.I bs_extents
> > +is the number of storage space extents associated with this file's data.
> 
> storage space extents sounds odd...
> 
> is the number of data extents in this file.

"storage mappings" instead of "data extents"?

> > +.PP
> > +.I bs_gen
> > +is the generation number of the inode record.
> > +.PP
> > +.I bs_projid_lo
> > +is the lower 16-bits of the project id.
> > +.PP
> > +.I bs_forkoff
> > +is the offset of the attribute fork in the inode record, in bytes.
> > +.PP
> > +.I bs_projid_hi
> > +is the upper 16-bits of the project id.
> > +.PP
> > +.I bs_pad[6]
> > +is zeroed.
> > +.PP
> > +.I bs_cowextsize
> > +is the Copy on Write extent size hint for this file, in bytes.
> > +.PP
> > +.I bs_dmevmask
> > +is unused on Linux.
> > +.PP
> > +.I bs_dmstate
> > +is unused on Linux.
> > +.PP
> > +.I bs_aextents
> > +is the number of storage space extents associated with this file's extended
> > +attributes.
> 
> is the number of extended attribute extents in this file?  *shrug*

"...the number of storage mappings associated with the extended attributes..." ?

--D

> > +.SH RETURN VALUE
> > +On error, \-1 is returned, and
> > +.I errno
> > +is set to indicate the error.
> > +.PP
> > +.SH ERRORS
> > +Error codes can be one of, but are not limited to, the following:
> > +.TP
> > +.B EFAULT
> > +The kernel was not able to copy into the userspace buffer.
> > +.TP
> > +.B EFSBADCRC
> > +Metadata checksum validation failed while performing the query.
> > +.TP
> > +.B EFSCORRUPTED
> > +Metadata corruption was encountered while performing the query.
> > +.TP
> > +.B EINVAL
> > +One of the arguments was not valid.
> > +.TP
> > +.B EIO
> > +An I/O error was encountered while performing the query.
> > +.TP
> > +.B ENOMEM
> > +There was insufficient memory to perform the query.
> > +.SH CONFORMING TO
> > +This API is specific to XFS filesystem on the Linux kernel.
> > +.SH SEE ALSO
> > +.BR ioctl (2)
> > diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
> > index 1237eac6..94a6ad4b 100644
> > --- a/man/man3/xfsctl.3
> > +++ b/man/man3/xfsctl.3
> > @@ -399,92 +399,18 @@ An output
> >  .B ocount
> >  value of zero means that the inode table has been exhausted.
> >  
> > -.TP
> > -.B XFS_IOC_FSBULKSTAT
> > -This interface is used to extract inode information (stat
> > -information) "in bulk" from a filesystem.  It is intended to
> > -be called iteratively, to obtain information about the entire
> > -set of inodes in a filesystem.
> > -The information is passed in and out via a structure of type
> > -.B xfs_fsop_bulkreq_t
> > -pointed to by the final argument.
> > -.B lastip
> > -is a pointer to a variable containing the last inode number returned,
> > -initially it should be zero.
> > -.B icount
> > -indicates the size of the array of structures specified by
> > -.B ubuffer.
> > -.B ubuffer
> > -is the address of an array of structures of type
> > -.BR xfs_bstat_t .
> > -Many of the elements in the structure are the same as for the stat
> > -structure.
> > -The structure has the following elements:
> > -.B bs_ino
> > -(inode number),
> > -.B bs_mode
> > -(type and mode),
> > -.B bs_nlink
> > -(number of links),
> > -.B bs_uid
> > -(user id),
> > -.B bs_gid
> > -(group id),
> > -.B bs_rdev
> > -(device value),
> > -.B bs_blksize
> > -(block size of the filesystem),
> > -.B bs_size
> > -(file size in bytes),
> > -.B bs_atime
> > -(access time),
> > -.B bs_mtime
> > -(modify time),
> > -.B bs_ctime
> > -(inode change time),
> > -.B bs_blocks
> > -(number of blocks used by the file),
> > -.B bs_xflags
> > -(extended flags),
> > -.B bs_extsize
> > -(extent size),
> > -.B bs_extents
> > -(number of extents),
> > -.B bs_gen
> > -(generation count),
> > -.B bs_projid_lo
> > -(project id - low word),
> > -.B bs_projid_hi
> > -(project id - high word, used when projid32bit feature is enabled),
> > -.B bs_dmevmask
> > -(DMIG event mask),
> > -.B bs_dmstate
> > -(DMIG state information), and
> > -.B bs_aextents
> > -(attribute extent count).
> > -.B ocount
> > -is a pointer to a count of returned values, filled in by the call.
> > -An output
> > -.B ocount
> > -value of zero means that the inode table has been exhausted.
> > -
> > -.TP
> > -.B XFS_IOC_FSBULKSTAT_SINGLE
> > -This interface is a variant of the
> > -.B XFS_IOC_FSBULKSTAT
> > -interface, used to obtain information about a single inode.
> > -for an open file in the filesystem of interest.
> > -The same structure is used to pass information in and out of
> > -the kernel, except no output count parameter is used (should
> > -be initialized to zero).
> > -An error is returned if the inode number is invalid.
> > -
> >  .TP
> >  .B XFS_IOC_FSGEOMETRY
> >  See
> >  .BR ioctl_xfs_fsop_geometry (2)
> >  for more information.
> >  
> > +.TP
> > +.BR XFS_IOC_FSBULKSTAT " or " XFS_IOC_FSBULKSTAT_SINGLE
> > +See
> > +.BR ioctl_xfs_fsbulkstat (2)
> > +for more information.
> > +
> >  .PP
> >  .nf
> >  .B XFS_IOC_THAW
> > @@ -509,6 +435,7 @@ as they are not of general use to applications.
> >  .SH SEE ALSO
> >  .BR ioctl_xfs_fsgetxattr (2),
> >  .BR ioctl_xfs_fsop_geometry (2),
> > +.BR ioctl_xfs_fsbulkstat (2),
> >  .BR fstatfs (2),
> >  .BR statfs (2),
> >  .BR xfs (5),
> > 
