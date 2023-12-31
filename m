Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61648C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ae+mNWvh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B57C433C8;
	Sun, 31 Dec 2023 23:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066642;
	bh=YeqhyWHBvgYwQgxG80lthblYu4VD2gI3hewKKEcBNhk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ae+mNWvhIF6tIluIPz5QkRVn2oHWtG7IXw9rJd/yI/kO7ExXbN3RzhNSDIvg302w+
	 XZ+zWUfCcaxWrUsRLTXmPzJXdcCvb1e5ngbxNpcjIc51R7m8Wm5PG7mZmtTex+xitY
	 c4wE5z3Fd+eRlKKo0urjpI495GAY4maW+dP1lEh4gsO2/5DZxlsbrVna+wowTGn1n3
	 7fpMgH0rRq5kwXNGGngz3fvLWDsO7WMN09YZ8XpZca6DeopqBiBS822bgiyFoD67hH
	 ghozA48LFUDEeJ+JlNFdm4hE5bEJZY+JAS8Jo8lYJEUpV9pNR8Y0ODywWwN2r7jLwf
	 zHEEHSdMUusVA==
Date: Sun, 31 Dec 2023 15:50:41 -0800
Subject: [PATCH 12/52] xfs: export the geometry of realtime groups to
 userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012330.1811243.779524866380206017.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
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

Create an ioctl so that the kernel can report the status of realtime
groups to userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/util.c                         |    7 ++
 libxfs/xfs_fs.h                       |    1 
 libxfs/xfs_fs_staging.h               |   17 ++++++
 libxfs/xfs_health.h                   |    2 +
 libxfs/xfs_rtgroup.c                  |   14 +++++
 libxfs/xfs_rtgroup.h                  |    4 +
 man/man2/ioctl_xfs_rtgroup_geometry.2 |   99 +++++++++++++++++++++++++++++++++
 7 files changed, 144 insertions(+)
 create mode 100644 man/man2/ioctl_xfs_rtgroup_geometry.2


diff --git a/libxfs/util.c b/libxfs/util.c
index a3f3ad29933..76e49b8637c 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -446,6 +446,13 @@ xfs_fs_mark_healthy(
 }
 
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo) { }
+void
+xfs_rtgroup_geom_health(
+	struct xfs_rtgroup		*rtg,
+	struct xfs_rtgroup_geometry	*rgeo)
+{
+	/* empty */
+}
 void xfs_fs_mark_sick(struct xfs_mount *mp, unsigned int mask) { }
 void xfs_agno_mark_sick(struct xfs_mount *mp, xfs_agnumber_t agno,
 		unsigned int mask) { }
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index bae9ef924bf..c5bf53c6a43 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -852,6 +852,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_SCRUBV_METADATA -- staging 60	   */
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
 /*	XFS_IOC_GETPARENTS ---- staging 62         */
+/*	XFS_IOC_RTGROUP_GEOMETRY - staging 63	   */
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/libxfs/xfs_fs_staging.h b/libxfs/xfs_fs_staging.h
index 69d29f213af..1f573314877 100644
--- a/libxfs/xfs_fs_staging.h
+++ b/libxfs/xfs_fs_staging.h
@@ -202,4 +202,21 @@ static inline size_t sizeof_xfs_scrub_vec(unsigned int nr)
 
 #define XFS_IOC_SCRUBV_METADATA	_IOWR('X', 60, struct xfs_scrub_vec_head)
 
+/*
+ * Output for XFS_IOC_RTGROUP_GEOMETRY
+ */
+struct xfs_rtgroup_geometry {
+	__u32 rg_number;	/* i/o: rtgroup number */
+	__u32 rg_length;	/* o: length in blocks */
+	__u32 rg_sick;		/* o: sick things in ag */
+	__u32 rg_checked;	/* o: checked metadata in ag */
+	__u32 rg_flags;		/* i/o: flags for this ag */
+	__u32 rg_pad;		/* o: zero */
+	__u64 rg_reserved[13];	/* o: zero */
+};
+#define XFS_RTGROUP_GEOM_SICK_SUPER	(1 << 0)  /* superblock */
+#define XFS_RTGROUP_GEOM_SICK_BITMAP	(1 << 1)  /* rtbitmap for this group */
+
+#define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 63, struct xfs_rtgroup_geometry)
+
 #endif /* __XFS_FS_STAGING_H__ */
diff --git a/libxfs/xfs_health.h b/libxfs/xfs_health.h
index f5449a804c6..1e9938a417b 100644
--- a/libxfs/xfs_health.h
+++ b/libxfs/xfs_health.h
@@ -302,6 +302,8 @@ xfs_inode_is_healthy(struct xfs_inode *ip)
 
 void xfs_fsop_geom_health(struct xfs_mount *mp, struct xfs_fsop_geom *geo);
 void xfs_ag_geom_health(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
+void xfs_rtgroup_geom_health(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
 void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 
 #define xfs_metadata_is_sick(error) \
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 7003ac5c567..c503a39b0fc 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -566,3 +566,17 @@ xfs_rtgroup_unlock(
 	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
 		xfs_rtbitmap_unlock_shared(rtg->rtg_mount, XFS_RBMLOCK_BITMAP);
 }
+
+/* Retrieve rt group geometry. */
+int
+xfs_rtgroup_get_geometry(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_rtgroup_geometry *rgeo)
+{
+	/* Fill out form. */
+	memset(rgeo, 0, sizeof(*rgeo));
+	rgeo->rg_number = rtg->rtg_rgno;
+	rgeo->rg_length = rtg->rtg_blockcount;
+	xfs_rtgroup_geom_health(rtg, rgeo);
+	return 0;
+}
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 70968cf700f..e6d60425faa 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -233,6 +233,9 @@ int xfs_rtgroup_update_secondary_sbs(struct xfs_mount *mp);
 void xfs_rtgroup_lock(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		unsigned int rtglock_flags);
 void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
+
+int xfs_rtgroup_get_geometry(struct xfs_rtgroup *rtg,
+		struct xfs_rtgroup_geometry *rgeo);
 #else
 # define xfs_rtgroup_block_count(mp, rgno)	(0)
 # define xfs_rtgroup_update_super(bp, sb_bp)	((void)0)
@@ -240,6 +243,7 @@ void xfs_rtgroup_unlock(struct xfs_rtgroup *rtg, unsigned int rtglock_flags);
 # define xfs_rtgroup_update_secondary_sbs(mp)	(0)
 # define xfs_rtgroup_lock(tp, rtg, gf)		((void)0)
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
+# define xfs_rtgroup_get_geometry(rtg, rgeo)	(-EOPNOTSUPP)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */
diff --git a/man/man2/ioctl_xfs_rtgroup_geometry.2 b/man/man2/ioctl_xfs_rtgroup_geometry.2
new file mode 100644
index 00000000000..ccd931d1e17
--- /dev/null
+++ b/man/man2/ioctl_xfs_rtgroup_geometry.2
@@ -0,0 +1,99 @@
+.\" Copyright (c) 2022-2024 Oracle.  All rights reserved.
+.\"
+.\" %%%LICENSE_START(GPLv2+_DOC_FULL)
+.\" SPDX-License-Identifier: GPL-2.0-or-later
+.\" %%%LICENSE_END
+.TH IOCTL-XFS-RTGROUP-GEOMETRY 2 2022-08-18 "XFS"
+.SH NAME
+ioctl_xfs_rtgroup_geometry \- query XFS realtime group geometry information
+.SH SYNOPSIS
+.br
+.B #include <xfs/xfs_fs.h>
+.br
+.B #include <xfs/xfs_fs_staging.h>
+.PP
+.BI "int ioctl(int " fd ", XFS_IOC_RTGROUP_GEOMETRY, struct xfs_rtgroup_geometry *" arg );
+.SH DESCRIPTION
+This XFS ioctl retrieves the geometry information for a given realtime group.
+The geometry information is conveyed in a structure of the following form:
+.PP
+.in +4n
+.nf
+struct xfs_rtgroup_geometry {
+	__u32  rg_number;
+	__u32  rg_length;
+	__u32  rg_sick;
+	__u32  rg_checked;
+	__u32  rg_flags;
+	__u32  rg_pad;
+	__u64  rg_reserved[13];
+};
+.fi
+.in
+.TP
+.I rg_number
+The caller must set this field to the index of the realtime group that the
+caller wishes to learn about.
+.TP
+.I rg_length
+The length of the realtime group is returned in this field, in units of
+filesystem blocks.
+.I rg_flags
+The caller can set this field to change the operational behavior of the ioctl.
+Currently no flags are defined, so this field must be zero.
+.TP
+.IR rg_reserved " and " rg_pad
+All reserved fields will be set to zero on return.
+.PP
+The fields
+.IR rg_sick " and " rg_checked
+indicate the relative health of various realtime group metadata:
+.IP \[bu] 2
+If a given sick flag is set in
+.IR rg_sick ,
+then that piece of metadata has been observed to be damaged.
+The same bit will be set in
+.IR rg_checked .
+.IP \[bu]
+If a given sick flag is set in
+.I rg_checked
+and is not set in
+.IR rg_sick ,
+then that piece of metadata has been checked and is not faulty.
+.IP \[bu]
+If a given sick flag is not set in
+.IR rg_checked ,
+then no conclusion can be made.
+.PP
+The following flags apply to these fields:
+.RS 0.4i
+.TP
+.B XFS_RTGROUP_GEOM_SICK_SUPER
+Realtime group superblock.
+.TP
+.B XFS_RTGROUP_GEOM_SICK_BITMAP
+Realtime bitmap for this group.
+.RE
+.SH RETURN VALUE
+On error, \-1 is returned, and
+.I errno
+is set to indicate the error.
+.PP
+.SH ERRORS
+Error codes can be one of, but are not limited to, the following:
+.TP
+.B EFSBADCRC
+Metadata checksum validation failed while performing the query.
+.TP
+.B EFSCORRUPTED
+Metadata corruption was encountered while performing the query.
+.TP
+.B EINVAL
+The specified realtime group number is not valid for this filesystem.
+.TP
+.B EIO
+An I/O error was encountered while performing the query.
+.SH CONFORMING TO
+This API is specific to XFS filesystem on the Linux kernel.
+.SH SEE ALSO
+.BR ioctl (2)

