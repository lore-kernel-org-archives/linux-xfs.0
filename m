Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 27BAB7CA0
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 14:50:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD3AD304032
	for <xfs@oss.sgi.com>; Thu,  5 May 2016 12:50:41 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ZOH0lwesDR24pYcm (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 05 May 2016 12:50:39 -0700 (PDT)
Date: Thu, 5 May 2016 12:50:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/3] document the XFS_IOC_GETFSMAPX ioctl
Message-ID: <20160505195011.GA2905@birch.djwong.org>
References: <20160505194754.GA2785@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160505194754.GA2785@birch.djwong.org>
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
To: Mark Fasheh <mfasheh@suse.de>, Josef Bacik <jbacik@fb.com>, Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>, Ross Zwisler <ross.zwisler@linux.intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-api@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs <xfs@oss.sgi.com>

Document the new XFS_IOC_GETFSMAPX that returns the physical layout
of a (disk-based) filesystem.

(Yes, the leading 'X' needs to fall off...)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man2/ioctl_getfsmapx.2 |  253 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 253 insertions(+)
 create mode 100644 man2/ioctl_getfsmapx.2

diff --git a/man2/ioctl_getfsmapx.2 b/man2/ioctl_getfsmapx.2
new file mode 100644
index 0000000..b79a8e5
--- /dev/null
+++ b/man2/ioctl_getfsmapx.2
@@ -0,0 +1,253 @@
+.\" Copyright (C) 2016 Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(VERBATIM)
+.\" This program is free software; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License as
+.\" published by the Free Software Foundation.
+.\"
+.\" This program is distributed in the hope that it would be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public License
+.\" along with this program; if not, write the Free Software Foundation,
+.\" Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+.\" %%%LICENSE_END
+.TH IOCTL-XFS_IOC_GETFSMAPX 2 2016-05-05 "Linux" "Linux Programmer's Manual"
+.SH NAME
+ioctl_getfsmapx \- retrieve the physical layout of the filesystem
+.SH SYNOPSIS
+.br
+.B #include <sys/ioctl.h>
+.br
+.B #include <linux/fs.h>
+.sp
+.BI "int ioctl(int " fd ", XFS_IOC_GETFSMAPX, struct getfsmapx * " arg );
+.SH DESCRIPTION
+This
+.BR ioctl (2)
+retrieves physical extent mappings for a filesystem.  This information can
+be used to discover which files are mapped to a physical block, examine
+free space, or find known bad blocks, among other things.
+
+The sole argument to this ioctl should be an array of the following
+structure:
+.in +4n
+.nf
+
+struct getfsmapx {
+	__s64		fmv_device;	/* device id */
+	__s64		fmv_block;	/* starting block */
+	__s64		fmv_owner;	/* owner id */
+	__s64		fmv_offset;	/* file offset of segment */
+	__s64		fmv_length;	/* length of segment, blocks */
+	__s32		fmv_oflags;	/* mapping flags */
+	__s32		fmv_iflags;	/* control flags (1st structure) */
+	__s32		fmv_count;	/* # of entries in array incl. input */
+	__s32		fmv_entries;	/* # of entries filled in (output). */
+	__s64		fmv_unused1;	/* future use, must be zero */
+};
+
+.fi
+.in
+The array must contain at least two elements.  The first two array
+elements specify the lowest and highest reverse-mapping keys, respectively,
+for which userspace would like physical mapping information.  A reverse
+mapping key consists of the tuple (device, block, owner, offset).  The
+owner and offset fields are part of the key because some filesystems
+support sharing physical blocks between multiple files and therefore may
+return multiple mappings for a given physical block.
+
+.SS Fields of struct getfsmapx
+.PP
+The
+.I fmv_device
+field contains a 64-bit cookie to uniquely identify the underlying storage
+device if the filesystem supports multiple devices.  If not, the field
+should be
+.BR FMV_DEV_DEFAULT "."
+
+.PP
+The
+.I fmv_block
+field contains the 512-byte sector address of the extent.
+
+.PP
+The
+.I fmv_owner
+field contains the owner of the extent.  This is generally an inode
+number, though if
+.B FMV_OF_SPECIAL_OWNER
+is set in the
+.I fmv_oflags
+field, then the owner value is one of the following special values:
+.TP
+.B FMV_OWN_FREE
+Free space.
+.TP
+.B FMV_OWN_UNKNOWN
+This extent has an unknown owner.
+.TP
+.B FMV_OWN_FS
+Static filesystem metadata.
+.TP
+.B FMV_OWN_LOG
+The filesystem journal.
+.TP
+.B FMV_OWN_AG
+Allocation group metadata.
+.TP
+.B FMV_OWN_INOBT
+The inode index, if one is provided.
+.TP
+.B FMV_OWN_INODES
+Inodes.
+.TP
+.B FMV_OWN_REFC
+Reference counting indexes.
+.TP
+.B FMV_OWN_COW
+This extent is being used to stage a copy-on-write.
+.TP
+.B FMV_OWN_DEFECTIVE:
+This extent has been marked defective either by the filesystem or the
+underlying device.
+
+.PP
+The
+.I fmv_offset
+field contains the logical address of the reverse mapping record, in units
+of 512-byte blocks.  This field has no meaning if the
+.BR FMV_OF_SPECIAL_OWNER " or " FMV_OF_EXTENT_MAP
+flags are set in
+.IR fmv_oflags "."
+
+.PP
+The
+.I fmv_length
+field contains the length of the extent, in units of 512-byte blocks.
+This field must be zero in the second array element.
+
+.PP
+The
+.I fmv_oflags
+field is a bitmask of extent state flags.  The bits are:
+.TP
+.B FMV_OF_PREALLOC
+The extent is allocated but not yet written.
+.TP
+.B FMV_OF_ATTR_FORK
+This extent contains extended attribute data.
+.TP
+.B FMV_OF_EXTENT_MAP
+This extent contains extent map information for the owner.
+.TP
+.B FMV_OF_SHARED
+Parts of this extent may be shared.
+.TP
+.B FMV_OF_SPECIAL_OWNER
+The
+.I fmv_owner
+field contains a special value instead of an inode number.
+.TP
+.B FMV_OF_LAST
+This is the last record in the filesystem.
+
+.PP
+The
+.I fmv_iflags
+field is a bitmask passed to the kernel to alter the output.  There are no
+flags defined, so this value must be zero in the first two array elements.
+
+.PP
+The
+.I fmv_count
+field contains the number of elements in the array being passed to the
+kernel.  This count must include the two control elements at the start of
+the array.  The value must be specified in the first array element; in the
+second element this field must be zero.
+
+If this value is 2,
+.I fmv_entries
+will be set to the number of records that would have been returned had
+the array been large enough; no extent information will be returned.
+
+.PP
+The
+.I fmv_entries
+field contains the number of elements in the array that contain useful
+information if the ioctl returns a non-error value.  This value includes
+the two control elements at the start of the array and is only set in the
+first array element; in the second, this field must be zero.
+
+.PP
+The
+.I fmv_unused1
+field must be zero in the first two array elements.
+
+.SS Array Elements
+.PP
+The key fields (fmv_device, fmv_block, fmv_owner, fmv_offset) of the first
+element of the array specify the lowest extent record in the keyspace that
+the caller wants returned.  For example, if the key is set to
+(FMV_DEV_DEFAULT, 36, 0, 0), the filesystem will only return records for
+extents starting at or above sector 36 on disk.  For convenience, the
+.I fmv_length
+field will be added to the
+.IR fmv_block " and " fmv_offset
+fields as appropriate so that the (fmv_device, fmv_block, fmv_owner,
+fmv_offset, fmv_length) fields in the last array element can be copied
+into the first element to seed the next ioctl call.
+
+The key fields of the second element of the array specify the highest
+extent record in the keyspace that the caller wants returned.  Returning
+to our example above, if that example key were instead passed in via the
+second array element, the filesystem will not return records for extents
+going past sector 36 on disk.  For convenience, the four key fields can be
+set to ~0 (all ones) to signify "end of filesystem".
+
+If
+.I fmv_count
+in the first element of the array is 2, then
+.I fmv_entries
+in the first element of the array will be set to the number of extent
+records found in the filesystem.  Otherwise,
+.I fmv_entries
+will be set to the number of extents actually returned, and the subsequent
+array elements will be filled out with extent information.  In these
+subsequent array elements, the fields
+.IR fmv_iflags ", " fmv_count ", " fmv_entries ", and " fmv_unused1
+will be set to zero by the filesystem.
+
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EINVAL
+The array is not long enough, or a non-zero value was passed in one of the
+fields that must be zero.
+.TP
+.B EFAULT
+The pointer passed in was not mapped to a valid memory address.
+.TP
+.B EBADF
+.IR fd
+is not open for reading.
+.TP
+.B EPERM
+This query is not allowed.
+.TP
+.B EOPNOTSUPP
+The filesystem does not support this command.
+
+.SH CONFORMING TO
+This API is Linux-specific.  Not all filesystems support it.
+.fi
+.in
+.SH SEE ALSO
+.BR ioctl (2)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
