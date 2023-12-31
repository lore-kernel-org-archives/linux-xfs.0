Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA14C154
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BpJwzlFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A507C433C9;
	Sun, 31 Dec 2023 23:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704064798;
	bh=HNd0bgulWfNjZJSWfh3MGvjffDN9Ozyp0WRp9kIV1Ko=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BpJwzlFkGbzIlKiQoXW/hNbL4hZ8F+AzO2Ml8kz4fMz1mKnqFpatDSAm4fBRjgG5B
	 a9hkNFK/P0yNTVjWDOFUacZEmYM3Aw5UyvexLXyB0hpYSiGw1JcaSZeVgFGkfIjj22
	 2GHGvV9emAIs6XILTxpBOvuzVzIIY2uawD06pR7LX3wPvq4MJUu1sDv4TagDL+1+4R
	 p4IrLx06nSDAs35PqREBtVJQUPN/stN/yMab4MA6WuJUHAAbviIoxMAF62JEnpiVEr
	 0qEXGQKCEhn0eESumy8KleidZ+afBS+51rCpOTb/SrZeDGi+xAF3M+fqIPvRdtYLWA
	 JtMYAFONFA4aA==
Date: Sun, 31 Dec 2023 15:19:57 -0800
Subject: [PATCH 01/10] xfs: introduce vectored scrub mode
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405007856.1806194.7426360300744176144.stgit@frogsfrogsfrogs>
In-Reply-To: <170405007836.1806194.11810681886556560484.stgit@frogsfrogsfrogs>
References: <170405007836.1806194.11810681886556560484.stgit@frogsfrogsfrogs>
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

Introduce a variant on XFS_SCRUB_METADATA that allows for vectored mode.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h                      |   10 ++
 libxfs/xfs_fs_staging.h              |   32 ++++++
 man/man2/ioctl_xfs_scrubv_metadata.2 |  168 ++++++++++++++++++++++++++++++++++
 3 files changed, 210 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_scrubv_metadata.2


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 2499a20f5f7..77fbca573e1 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -725,6 +725,15 @@ struct xfs_scrub_metadata {
 /* Number of scrub subcommands. */
 #define XFS_SCRUB_TYPE_NR	29
 
+/*
+ * This special type code only applies to the vectored scrub implementation.
+ *
+ * If any of the previous scrub vectors recorded runtime errors or have
+ * sv_flags bits set that match the OFLAG bits in the barrier vector's
+ * sv_flags, set the barrier's sv_ret to -ECANCELED and return to userspace.
+ */
+#define XFS_SCRUB_TYPE_BARRIER	(-1U)
+
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
 
@@ -813,6 +822,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
+/*	XFS_IOC_SCRUBV_METADATA -- staging 60	   */
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
 /*	XFS_IOC_GETPARENTS ---- staging 62         */
 
diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
index e0650af0558..69d29f213af 100644
--- a/libxfs/xfs_fs_staging.h
+++ b/libxfs/xfs_fs_staging.h
@@ -170,4 +170,36 @@ xfs_getparents_rec(
 
 #define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
 
+/* Vectored scrub calls to reduce the number of kernel transitions. */
+
+struct xfs_scrub_vec {
+	__u32 sv_type;		/* XFS_SCRUB_TYPE_* */
+	__u32 sv_flags;		/* XFS_SCRUB_FLAGS_* */
+	__s32 sv_ret;		/* 0 or a negative error code */
+	__u32 sv_reserved;	/* must be zero */
+};
+
+/* Vectored metadata scrub control structure. */
+struct xfs_scrub_vec_head {
+	__u64 svh_ino;		/* inode number. */
+	__u32 svh_gen;		/* inode generation. */
+	__u32 svh_agno;		/* ag number. */
+	__u32 svh_flags;	/* XFS_SCRUB_VEC_FLAGS_* */
+	__u16 svh_rest_us;	/* wait this much time between vector items */
+	__u16 svh_nr;		/* number of svh_vecs */
+	__u64 svh_reserved;	/* must be zero */
+
+	struct xfs_scrub_vec svh_vecs[];
+};
+
+#define XFS_SCRUB_VEC_FLAGS_ALL		(0)
+
+static inline size_t sizeof_xfs_scrub_vec(unsigned int nr)
+{
+	return sizeof(struct xfs_scrub_vec_head) +
+		nr * sizeof(struct xfs_scrub_vec);
+}
+
+#define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 60, struct xfs_scrub_vec_head)
+
 #endif /* __XFS_FS_STAGING_H__ */
diff --git a/man/man2/ioctl_xfs_scrubv_metadata.2 b/man/man2/ioctl_xfs_scrubv_metadata.2
new file mode 100644
index 00000000000..05a4adaba48
--- /dev/null
+++ b/man/man2/ioctl_xfs_scrubv_metadata.2
@@ -0,0 +1,168 @@
+.\" Copyright (c) 2023-2024 Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0-or-later
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-SCRUBV-METADATA 2 2023-08-18 "XFS"
+.SH NAME
+ioctl_xfs_scrubv_metadata \- check a lot of XFS filesystem metadata
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.br
+.B #include <xfs/xfs_fs_staging.h>
+.PP
+.BI "int ioctl(int " dest_fd ", XFS_IOC_SCRUBV_METADATA, struct xfs_scrub_vec_head *" arg );
+.SH DESCRIPTION
+This XFS ioctl asks the kernel driver to examine several pieces of filesystem
+metadata for errors or suboptimal metadata.
+Multiple scrub types can be invoked to target a single filesystem object.
+See
+.BR ioctl_xfs_scrub_metadata (2)
+for a discussion of metadata validation, and documentation of the various
+.B XFS_SCRUB_TYPE
+and
+.B XFS_SCRUB_FLAGS
+values referenced below.
+
+The types and location of the metadata to scrub are conveyed as a vector with
+a header of the following form:
+.PP
+.in +4n
+.nf
+
+struct xfs_scrub_vec_head {
+	__u64 svh_ino;
+	__u32 svh_gen;
+	__u32 svh_agno;
+	__u32 svh_flags;
+	__u16 svh_rest_us;
+	__u16 svh_nr;
+	__u64 svh_reserved;
+
+	struct xfs_scrub_vec svh_vecs[];
+};
+.fi
+.in
+.PP
+The field
+.IR svh_ino ,
+.IR svh_gen ,
+and
+.IR svh_agno
+correspond to the
+.IR sm_ino ,
+.IR sm_gen ,
+and
+.IR sm_agno
+fields of the regular scrub ioctl.
+Exactly one filesystem object can be specified in a single call.
+The kernel will proceed with each vector in
+.I svh_vecs
+until progress is no longer possible.
+
+The field
+.I svh_rest_us
+specifies an amount of time to pause between each scrub invocation to give
+the system a chance to process other requests.
+
+The field
+.I svh_nr
+specifies the number of vectors in the
+.I svh_recs
+flex array.
+
+.PP
+The field
+.I svh_reserved
+must be zero.
+
+Each vector has the following form:
+.PP
+.in +4n
+.nf
+
+struct xfs_scrub_vec {
+	__u32 sv_type;
+	__u32 sv_flags;
+	__s32 sv_ret;
+	__u32 sv_reserved;
+};
+.fi
+.in
+
+.PP
+The fields
+.I sv_type
+and
+.I sv_flags
+indicate the type of metadata to check and the behavioral changes that
+userspace will permit of the kernel.
+The
+.I sv_flags
+field will be updated upon completion of the scrub call.
+See the documentation of
+.B XFS_SCRUB_TYPE_*
+and
+.B XFS_SCRUB_[IO]FLAG_*
+values in
+.BR ioctl_xfs_scrub_metadata (2)
+for a detailed description of their purpose.
+
+.PP
+If a vector's
+.I sv_type
+field is set to the value
+.BR XFS_SCRUB_TYPE_BARRIER ,
+the kernel will stop processing vectors and return to userspace if a scrubber
+flags corruption by setting one of the
+.B XFS_SCRUB_OFLAG_*
+values in
+.I sv_flags
+or
+returns an operation error in
+.IR sv_ret .
+Otherwise, the kernel returns only after processing all vectors.
+
+The
+.I sv_ret
+field is set to the return value of the scrub function.
+See the RETURN VALUE
+section of the
+.BR ioctl_xfs_scrub_metadata (2)
+manual page for more information.
+
+The
+.B sv_reserved
+field must be zero.
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
+One or more of the arguments specified is invalid.
+.TP
+.B EINTR
+The operation was interrupted.
+.TP
+.B ENOMEM
+There was not sufficient memory to perform the scrub or repair operation.
+.TP
+.B EFAULT
+A memory fault was encountered while reading or writing the vector.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH NOTES
+These operations may block other filesystem operations for a long time.
+A calling process can stop the operation by being sent a fatal
+signal, but non-fatal signals are blocked.
+.SH SEE ALSO
+.BR ioctl (2)
+.BR ioctl_xfs_scrub_metadata (2)
+.BR xfs_scrub (8)
+.BR xfs_repair (8)

