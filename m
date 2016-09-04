Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A9E097CA2
	for <xfs@oss.sgi.com>; Sun,  4 Sep 2016 00:36:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 522518F8033
	for <xfs@oss.sgi.com>; Sat,  3 Sep 2016 22:36:23 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ufC9a4rFMi9lbxGJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 03 Sep 2016 22:36:20 -0700 (PDT)
Date: Sat, 3 Sep 2016 22:36:12 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 3/3] ioctl_getfsmap.2: document the GETFSMAP ioctl
Message-ID: <20160904053612.GJ8265@birch.djwong.org>
References: <147216758326.32321.8525481353986871349.stgit@birch.djwong.org>
	<147216760214.32321.8331561706153372268.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147216760214.32321.8331561706153372268.stgit@birch.djwong.org>
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
To: mtk.manpages@gmail.com
Cc: linux-man@vger.kernel.org, linux-api@vger.kernel.org, xfs <xfs@oss.sgi.com>, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, linux-fsdevel@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>

Document the new GETFSMAP ioctl that returns the physical layout of a
(disk-based) filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 man2/ioctl_getfsmap.2 |  313 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 313 insertions(+)
 create mode 100644 man2/ioctl_getfsmap.2

diff --git a/man2/ioctl_getfsmap.2 b/man2/ioctl_getfsmap.2
new file mode 100644
index 0000000..99de417
--- /dev/null
+++ b/man2/ioctl_getfsmap.2
@@ -0,0 +1,313 @@
+.\" Copyright (c) 2016, Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" This is free documentation; you can redistribute it and/or
+.\" modify it under the terms of the GNU General Public License as
+.\" published by the Free Software Foundation; either version 2 of
+.\" the License, or (at your option) any later version.
+.\"
+.\" The GNU General Public License's references to "object code"
+.\" and "executables" are to be interpreted as the output of any
+.\" document formatting or typesetting system, including
+.\" intermediate and printed output.
+.\"
+.\" This manual is distributed in the hope that it will be useful,
+.\" but WITHOUT ANY WARRANTY; without even the implied warranty of
+.\" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+.\" GNU General Public License for more details.
+.\"
+.\" You should have received a copy of the GNU General Public
+.\" License along with this manual; if not, see
+.\" <http://www.gnu.org/licenses/>.
+.\" %%%LICENSE_END
+.TH IOCTL-GETFSMAP 2 2016-09-03 "Linux" "Linux Programmer's Manual"
+.SH NAME
+ioctl_getfsmap \- retrieve the physical layout of the filesystem
+.SH SYNOPSIS
+.br
+.B #include <sys/ioctl.h>
+.br
+.B #include <linux/fs.h>
+.sp
+.BI "int ioctl(int " fd ", GETFSMAP, struct fsmap_head * " arg );
+.SH DESCRIPTION
+This
+.BR ioctl (2)
+retrieves physical extent mappings for a filesystem.
+This information can be used to discover which files are mapped to a physical
+block, examine free space, or find known bad blocks, among other things.
+
+The sole argument to this ioctl should be a pointer to a single
+.BR "struct fsmap_head" ":"
+.in +4n
+.nf
+
+struct fsmap {
+	__u32		fmr_device;	/* device id */
+	__u32		fmr_flags;	/* mapping flags */
+	__u64		fmr_physical;	/* device offset of segment */
+	__u64		fmr_owner;	/* owner id */
+	__u64		fmr_offset;	/* file offset of segment */
+	__u64		fmr_length;	/* length of segment */
+	__u64		fmr_reserved;	/* future use, must be zero */
+};
+
+struct fsmap_head {
+	__u32		fmh_iflags;	/* control flags */
+	__u32		fmh_oflags;	/* output flags */
+	__u32		fmh_count;	/* # of entries in array incl. input */
+	__u32		fmh_entries;	/* # of entries filled in (output). */
+	__u64		fmh_reserved[2];	/* must be zero */
+
+	struct fsmap	fmh_keys[2];	/* low and high keys for the mapping search */
+	struct fsmap	fmh_recs[0];	/* returned records */
+};
+
+.fi
+.in
+The two
+.I fmh_keys
+array elements specify the lowest and highest reverse-mapping
+keys, respectively, for which userspace would like physical mapping
+information.
+A reverse mapping key consists of the tuple (device, block, owner, offset).
+The owner and offset fields are part of the key because some filesystems
+support sharing physical blocks between multiple files and
+therefore may return multiple mappings for a given physical block.
+.PP
+Filesystem mappings are copied into the
+.I fmh_recs
+array, which immediately follows the header data.
+.SS Fields of struct fsmap_head
+.PP
+The
+.I fmh_iflags
+field is a bitmask passed to the kernel to alter the output.
+There are no flags defined, so this value must be zero.
+
+.PP
+The
+.I fmh_oflags
+field is a bitmask of flags that concern all output mappings.
+If
+.B FMH_OF_DEV_T
+is set, then the
+.I fmr_device
+field represents a
+.B dev_t
+structure containing the major and minor numbers of the block device.
+
+.PP
+The
+.I fmh_count
+field contains the number of elements in the array being passed to the
+kernel.
+If this value is 0,
+.I fmh_entries
+will be set to the number of records that would have been returned had
+the array been large enough;
+no mapping information will be returned.
+
+.PP
+The
+.I fmh_entries
+field contains the number of elements in the
+.I fmh_recs
+array that contain useful information.
+
+.PP
+The
+.I fmh_reserved
+fields must be set to zero.
+
+.SS Keys
+.PP
+The two key records in
+.B fsmap_head.fmh_keys
+specify the lowest and highest extent records in the keyspace that the caller
+wants returned.
+A filesystem that can share blocks between files likely requires the tuple
+.RI "(" "device" ", " "physical" ", " "owner" ", " "offset" ", " "flags" ")"
+to uniquely index any filesystem mapping record.
+Classic non-sharing filesystems might be able to identify any record with only
+.RI "(" "device" ", " "physical" ", " "flags" ")."
+For example, if the low key is set to (0, 36864, 0, 0, 0), the filesystem will
+only return records for extents starting at or above 36KiB on disk.
+If the high key is set to (0, 1048576, 0, 0, 0), only records below 1MiB will
+be returned.
+By convention, the field
+.B fsmap_head.fmh_keys[0]
+must contain the low key and
+.B fsmap_head.fmh_keys[1]
+must contain the high key for the request.
+.PP
+For convenience, if
+.B fmr_length
+is set in the low key, it will be added to
+.IR fmr_block " or " fmr_offset
+as appropriate.
+The caller can take advantage of this subtlety to set up subsequent calls
+by copying
+.B fsmap_head.fmh_recs[fsmap_head.fmh_entries - 1]
+into the low key.
+
+.SS Fields of struct fsmap
+.PP
+The
+.I fmr_device
+field contains a 32-bit cookie to uniquely identify the underlying storage
+device.
+If the
+.B FMH_OF_DEV_T
+flag is set in the header's
+.I fmh_oflags
+field, this field contains a
+.B dev_t
+from which major and minor numbers can be extracted.
+If the flag is not set, this field contains a value that must be unique
+for each unique storage device.
+
+.PP
+The
+.I fmr_physical
+field contains the disk address of the extent in bytes.
+
+.PP
+The
+.I fmr_owner
+field contains the owner of the extent.
+This is an inode number unless
+.B FMR_OF_SPECIAL_OWNER
+is set in the
+.I fmr_flags
+field, in which case the owner value is one of the following special values:
+.RS 0.4i
+.TP
+.B FMR_OWN_FREE
+Free space.
+.TP
+.B FMR_OWN_UNKNOWN
+This extent has an unknown owner.
+.TP
+.B FMR_OWN_FS
+Static filesystem metadata which exists at a fixed address.
+On XFS these are the AG superblock, AGF, AGFL, and AGI headers.
+.TP
+.B FMR_OWN_LOG
+The filesystem journal.
+.TP
+.B FMR_OWN_AG
+Allocation group metadata.
+On XFS these are the free space btrees or the reverse mapping btrees.
+.TP
+.B FMR_OWN_INOBT
+Inode indexing, if any are provided.
+On XFS these are the inode and free inode btrees.
+.TP
+.B FMR_OWN_INODES
+Inode records.
+.TP
+.B FMR_OWN_REFC
+Reference count information.
+On XFS this is the reference count btree.
+.TP
+.B FMR_OWN_COW
+This extent is being used to stage a copy-on-write.
+.TP
+.B FMR_OWN_DEFECTIVE:
+This extent has been marked defective either by the filesystem or the
+underlying device.
+.RE
+
+.PP
+The
+.I fmr_offset
+field contains the logical address in the mapping record in bytes.
+This field has no meaning if the
+.BR FMR_OF_SPECIAL_OWNER " or " FMR_OF_EXTENT_MAP
+flags are set in
+.IR fmr_flags "."
+
+.PP
+The
+.I fmr_length
+field contains the length of the extent in bytes.
+
+.PP
+The
+.I fmr_flags
+field is a bitmask of extent state flags.
+The bits are:
+.RS 0.4i
+.TP
+.B FMR_OF_PREALLOC
+The extent is allocated but not yet written.
+.TP
+.B FMR_OF_ATTR_FORK
+This extent contains extended attribute data.
+.TP
+.B FMR_OF_EXTENT_MAP
+This extent contains extent map information for the owner.
+.TP
+.B FMR_OF_SHARED
+Parts of this extent may be shared.
+.TP
+.B FMR_OF_SPECIAL_OWNER
+The
+.I fmr_owner
+field contains a special value instead of an inode number.
+.TP
+.B FMR_OF_LAST
+This is the last record in the filesystem.
+.RE
+
+.PP
+The
+.I fmr_reserved
+field will be set to zero.
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
+.TP
+.B EUCLEAN
+The filesystem metadata is corrupt and needs repair.
+.TP
+.B EBADMSG
+The filesystem has detected a checksum error in the metadata.
+.TP
+.B ENOMEM
+Insufficient memory to process the request.
+
+.SH EXAMPLE
+.TP
+Please see io/fsmap.c in the xfsprogs distribution for a sample program.
+
+.SH CONFORMING TO
+This API is Linux-specific.
+Not all filesystems support it.
+.fi
+.in
+.SH SEE ALSO
+.BR ioctl (2)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
