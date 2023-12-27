Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1CC7ED
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OynA42NP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98642C433C7;
	Mon,  1 Jan 2024 00:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069583;
	bh=EU3eSBxdmThdxlxW40GvIEIECQBHRey50jrjagnhtS8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OynA42NPW+rr2XClxZ2SJbHxYJUs9Rg6i7rCsE8CBHI5FVV8Ep93wlpc1zGBFNIaT
	 NQlnh2R/UyT7OwoEEO4RYYTYzOhKEWiJuOb+ITYUBhGIU46XlCvprh74snDbw5DW9x
	 ofSOnfvd3nVKs/YyXqk7skS2QPf31cKmulUvCdxi5PegQ2FxNXtdbxMgr3AiQVRubp
	 pOgmkXpl1v9y9qVDFSpIgKvwKXmNfaV5p0yhJ+C466aLjmhO/ruFzcm9H9bHTLtW7u
	 XyytWaH76CaZfTjg5/AsMUO03Y7R1uqRyYVyQrcwj5XKdQwldRxfhvbxOqzCuUV22O
	 1y4egTZCjgBbw==
Date: Sun, 31 Dec 2023 16:39:43 +9900
Subject: [PATCH 1/2] xfs: export reference count information to userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405019974.1820694.12989281155330489787.stgit@frogsfrogsfrogs>
In-Reply-To: <170405019960.1820694.6724336371015732540.stgit@frogsfrogsfrogs>
References: <170405019960.1820694.6724336371015732540.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Export refcount info to userspace so we can prototype a sharing-aware
defrag/fs rearranging tool.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs_staging.h             |   82 ++++++++++++
 man/man2/ioctl_xfs_getfsrefcounts.2 |  239 +++++++++++++++++++++++++++++++++++
 2 files changed, 321 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_getfsrefcounts.2


diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
index 9f0c03103f0..f7d872f8a88 100644
--- a/libxfs/xfs_fs_staging.h
+++ b/libxfs/xfs_fs_staging.h
@@ -221,4 +221,86 @@ struct xfs_rtgroup_geometry {
 
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 63, struct xfs_rtgroup_geometry)
 
+/*
+ *	Structure for XFS_IOC_GETFSREFCOUNTS.
+ *
+ *	The memory layout for this call are the scalar values defined in struct
+ *	xfs_getfsrefs_head, followed by two struct xfs_getfsrefs that describe
+ *	the lower and upper bound of mappings to return, followed by an array
+ *	of struct xfs_getfsrefs mappings.
+ *
+ *	fch_iflags control the output of the call, whereas fch_oflags report
+ *	on the overall record output.  fch_count should be set to the length
+ *	of the fch_recs array, and fch_entries will be set to the number of
+ *	entries filled out during each call.  If fch_count is zero, the number
+ *	of refcount mappings will be returned in fch_entries, though no
+ *	mappings will be returned.  fch_reserved must be set to zero.
+ *
+ *	The two elements in the fch_keys array are used to constrain the
+ *	output.  The first element in the array should represent the lowest
+ *	disk mapping ("low key") that the user wants to learn about.  If this
+ *	value is all zeroes, the filesystem will return the first entry it
+ *	knows about.  For a subsequent call, the contents of
+ *	fsrefs_head.fch_recs[fsrefs_head.fch_count - 1] should be copied into
+ *	fch_keys[0] to have the kernel start where it left off.
+ *
+ *	The second element in the fch_keys array should represent the highest
+ *	disk mapping ("high key") that the user wants to learn about.  If this
+ *	value is all ones, the filesystem will not stop until it runs out of
+ *	mapping to return or runs out of space in fch_recs.
+ *
+ *	fcr_device can be either a 32-bit cookie representing a device, or a
+ *	32-bit dev_t if the FCH_OF_DEV_T flag is set.  fcr_physical and
+ *	fcr_length are expressed in units of bytes.  fcr_owners is the number
+ *	of owners.
+ */
+struct xfs_getfsrefs {
+	__u32		fcr_device;	/* device id */
+	__u32		fcr_flags;	/* mapping flags */
+	__u64		fcr_physical;	/* device offset of segment */
+	__u64		fcr_owners;	/* number of owners */
+	__u64		fcr_length;	/* length of segment */
+	__u64		fcr_reserved[4];	/* must be zero */
+};
+
+struct xfs_getfsrefs_head {
+	__u32		fch_iflags;	/* control flags */
+	__u32		fch_oflags;	/* output flags */
+	__u32		fch_count;	/* # of entries in array incl. input */
+	__u32		fch_entries;	/* # of entries filled in (output). */
+	__u64		fch_reserved[6];	/* must be zero */
+
+	struct xfs_getfsrefs	fch_keys[2];	/* low and high keys for the mapping search */
+	struct xfs_getfsrefs	fch_recs[];	/* returned records */
+};
+
+/* Size of an fsrefs_head with room for nr records. */
+static inline unsigned long long
+xfs_getfsrefs_sizeof(
+	unsigned int	nr)
+{
+	return sizeof(struct xfs_getfsrefs_head) + nr * sizeof(struct xfs_getfsrefs);
+}
+
+/* Start the next fsrefs query at the end of the current query results. */
+static inline void
+xfs_getfsrefs_advance(
+	struct xfs_getfsrefs_head	*head)
+{
+	head->fch_keys[0] = head->fch_recs[head->fch_entries - 1];
+}
+
+/*	fch_iflags values - set by XFS_IOC_GETFSREFCOUNTS caller in the header. */
+/* no flags defined yet */
+#define FCH_IF_VALID		0
+
+/*	fch_oflags values - returned in the header segment only. */
+#define FCH_OF_DEV_T		(1U << 0)	/* fcr_device values will be dev_t */
+
+/*	fcr_flags values - returned for each non-header segment */
+#define FCR_OF_LAST		(1U << 0)	/* segment is the last in the dataset */
+
+/* XXX stealing XFS_IOC_GETBIOSIZE */
+#define XFS_IOC_GETFSREFCOUNTS		_IOWR('X', 47, struct xfs_getfsrefs_head)
+
 #endif /* __XFS_FS_STAGING_H__ */
diff --git a/man/man2/ioctl_xfs_getfsrefcounts.2 b/man/man2/ioctl_xfs_getfsrefcounts.2
new file mode 100644
index 00000000000..2c7cfada190
--- /dev/null
+++ b/man/man2/ioctl_xfs_getfsrefcounts.2
@@ -0,0 +1,239 @@
+.\" Copyright (c) 2021-2024 Oracle.  All rights reserved.
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
+.TH IOCTL-XFS-GETFSREFCOUNTS 2 2023-05-08 "XFS"
+.SH NAME
+ioctl_xfs_getfsrefcounts \- retrieve the number of owners of space in the filesystem
+.SH SYNOPSIS
+.nf
+.B #include <sys/ioctl.h>
+.br
+.B #include <xfs/xfs_fs_staging.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_GETFSREFCOUNTS, struct xfs_fsrefs_head * " arg );
+.fi
+.SH DESCRIPTION
+This
+.BR ioctl (2)
+operation retrieves the number of owners for space extents in a filesystem.
+This information can be used to discover the sharing factor of physical media,
+among other things.
+.PP
+The sole argument to this operation should be a pointer to a single
+.IR "struct xfs_getfsrefs_head" ":"
+.PP
+.in +4n
+.EX
+struct xfs_getfsrefs {
+    __u32 fcr_device;      /* Device ID */
+    __u32 fcr_flags;       /* Mapping flags */
+    __u64 fcr_physical;    /* Device offset of segment */
+    __u64 fcr_owners;      /* Number of Owners */
+    __u64 fcr_length;      /* Length of segment */
+    __u64 fcr_reserved[4]; /* Must be zero */
+};
+
+struct xfs_getfsrefs_head {
+    __u32 fch_iflags;       /* Control flags */
+    __u32 fch_oflags;       /* Output flags */
+    __u32 fch_count;        /* # of entries in array incl. input */
+    __u32 fch_entries;      /* # of entries filled in (output) */
+    __u64 fch_reserved[6];  /* Must be zero */
+
+    struct xfs_getfsrefs fch_keys[2];  /* Low and high keys for
+                                  the mapping search */
+    struct xfs_getfsrefs fch_recs[];   /* Returned records */
+};
+.EE
+.in
+.PP
+The two
+.I fch_keys
+array elements specify the lowest and highest reverse-mapping
+key for which the application would like physical mapping
+information.
+A reverse mapping key consists of the tuple (device, block, owner, offset).
+The owner and offset fields are part of the key because some filesystems
+support sharing physical blocks between multiple files and
+therefore may return multiple mappings for a given physical block.
+.PP
+Filesystem mappings are copied into the
+.I fch_recs
+array, which immediately follows the header data.
+.\"
+.SS Fields of struct xfs_getfsrefs_head
+The
+.I fch_iflags
+field is a bit mask passed to the kernel to alter the output.
+No flags are currently defined, so the caller must set this value to zero.
+.PP
+The
+.I fch_oflags
+field is a bit mask of flags set by the kernel concerning the returned mappings.
+If
+.B FCH_OF_DEV_T
+is set, then the
+.I fcr_device
+field represents a
+.I dev_t
+structure containing the major and minor numbers of the block device.
+.PP
+The
+.I fch_count
+field contains the number of elements in the array being passed to the
+kernel.
+If this value is 0,
+.I fch_entries
+will be set to the number of records that would have been returned had
+the array been large enough;
+no mapping information will be returned.
+.PP
+The
+.I fch_entries
+field contains the number of elements in the
+.I fch_recs
+array that contain useful information.
+.PP
+The
+.I fch_reserved
+fields must be set to zero.
+.\"
+.SS Keys
+The two key records in
+.I fsrefs_head.fch_keys
+specify the lowest and highest extent records in the keyspace that the caller
+wants returned.
+The tuple
+.RI "(" "device" ", " "physical" ", " "flags" ")"
+can be used to index any filesystem space record.
+The format of
+.I fcr_device
+in the keys must match the format of the same field in the output records,
+as defined below.
+By convention, the field
+.I fsrefs_head.fch_keys[0]
+must contain the low key and
+.I fsrefs_head.fch_keys[1]
+must contain the high key for the request.
+.PP
+For convenience, if
+.I fcr_length
+is set in the low key, it will be added to
+.I fcr_block
+as appropriate.
+The caller can take advantage of this subtlety to set up subsequent calls
+by copying
+.I fsrefs_head.fch_recs[fsrefs_head.fch_entries \- 1]
+into the low key.
+The function
+.I fsrefs_advance
+(defined in
+.IR linux/fsrefcounts.h )
+provides this functionality.
+.\"
+.SS Fields of struct xfs_getfsrefs
+The
+.I fcr_device
+field uniquely identifies the underlying storage device.
+If the
+.B FCH_OF_DEV_T
+flag is set in the header's
+.I fch_oflags
+field, this field contains a
+.I dev_t
+from which major and minor numbers can be extracted.
+If the flag is not set, this field contains a value that must be unique
+for each unique storage device.
+.PP
+The
+.I fcr_physical
+field contains the disk address of the extent in bytes.
+.PP
+The
+.I fcr_owners
+field contains the number of owners of this extent.
+The actual owners can be queried with the
+.BR FS_IOC_GETFSMAP (2)
+ioctl.
+.PP
+The
+.I fcr_length
+field contains the length of the extent in bytes.
+.PP
+The
+.I fcr_flags
+field is a bit mask of extent state flags.
+The bits are:
+.RS 0.4i
+.TP
+.B FCR_OF_LAST
+This is the last record in the data set.
+.RE
+.PP
+The
+.I fcr_reserved
+field will be set to zero.
+.\"
+.RE
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.SH ERRORS
+The error placed in
+.I errno
+can be one of, but is not limited to, the following:
+.TP
+.B EBADF
+.IR fd
+is not open for reading.
+.TP
+.B EBADMSG
+The filesystem has detected a checksum error in the metadata.
+.TP
+.B EFAULT
+The pointer passed in was not mapped to a valid memory address.
+.TP
+.B EINVAL
+The array is not long enough, the keys do not point to a valid part of
+the filesystem, the low key points to a higher point in the filesystem's
+physical storage address space than the high key, or a nonzero value
+was passed in one of the fields that must be zero.
+.TP
+.B ENOMEM
+Insufficient memory to process the request.
+.TP
+.B EOPNOTSUPP
+The filesystem does not support this command.
+.TP
+.B EUCLEAN
+The filesystem metadata is corrupt and needs repair.
+.SH CONFORMING TO
+This API is XFS-specific.
+.SH EXAMPLES
+See
+.I io/fsrefs.c
+in the
+.I xfsprogs
+distribution for a sample program.
+.SH SEE ALSO
+.BR ioctl (2)

