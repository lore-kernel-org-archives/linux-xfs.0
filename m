Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B181112CDA5
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498374; cv=none; b=UTrrgHOj/XjNZ4XRY7Z+ncha4vUWccGM6hIrHY4cyqhf5qd+eewt1LNOfCLq8AvkAz1RZUFsX3M2BT5OufEAekZQrPOKv0hk8NV8RR2Sar1oZimXi0AAno/iitj/332ID7X5oKRAAceMm7cKFKcz61VNVcdaq1Zfffh7j7RlcSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498374; c=relaxed/simple;
	bh=lZB2v0ULlB4E1ob+4xA/QgbA+4c40dveOXYInquG5iQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cQES+bBNU2Mujka8Ulmr12PGNwvSqZXk6AhuwAd++j08KhBvHXqVy+4TAcg2LZ9KgGw81zJlsmc1kN8oEKUm0aAgt7/iwPEwNaBTyI75r3q1pNjuxv+xDdYkHowyZxcZUEvRoIy934zJKHZ3+GOyRtHjNjtRVytTEnqLMBGLp8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gqfdCH6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gqfdCH6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4645BC2BC86;
	Tue,  3 Mar 2026 00:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498374;
	bh=lZB2v0ULlB4E1ob+4xA/QgbA+4c40dveOXYInquG5iQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gqfdCH6trZgVX/DIJmbyiA45XnDx6MsX94k8E57wuTDdQd89BYEmkYKSG/cU4POJR
	 L+MJFMqYWjJ3T7BTMOWsqL/fdyN61w3IHYiGOe350ln5Zzl4UKSY7Ba1rmO4Iwk0m8
	 ALYYOUmQs/p+WcHX7aZPnk2x7FA3rBwnp0yS7W4UmkgS43ppM/JoEhYA+u3hWXzb5G
	 WyaBMSyQcK21SZ3anHNZDHt6YpruoI3l6x+PpoFGzwL4SZKwkm72o/LKZWhihgnG/1
	 zU8DlAKv2qLVqEDsuWLedJypebaV+FEfowC1ql2DlfsVuhjSAi6MNh7mY7fvDW/DoX
	 aeyV6zNmW0cDA==
Date: Mon, 02 Mar 2026 16:39:33 -0800
Subject: [PATCH 22/26] xfs_io: add listmount command
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249783693.482027.14656443953017714472.stgit@frogsfrogsfrogs>
In-Reply-To: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add a command to list all mounts, now that we use this in
xfs_healer_start.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/io.h           |    6 +
 io/Makefile       |    8 +
 io/init.c         |    1 
 io/listmount.c    |  383 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |   43 ++++++
 5 files changed, 441 insertions(+)
 create mode 100644 io/listmount.c


diff --git a/io/io.h b/io/io.h
index 0f12b3cfed5e76..5f1f278d14a033 100644
--- a/io/io.h
+++ b/io/io.h
@@ -164,3 +164,9 @@ void			fsprops_init(void);
 void			aginfo_init(void);
 void			healthmon_init(void);
 void			verifymedia_init(void);
+
+#ifdef HAVE_LISTMOUNT
+void			listmount_init(void);
+#else
+# define		listmount_init()	do { } while (0)
+#endif
diff --git a/io/Makefile b/io/Makefile
index 79d5e172b8f31f..4c3359c4d4f7f4 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -90,6 +90,14 @@ ifeq ($(HAVE_GETFSMAP),yes)
 CFILES += fsmap.c
 endif
 
+ifeq ($(HAVE_LISTMOUNT),yes)
+CFILES += listmount.c
+LCFLAGS += -DHAVE_LISTMOUNT
+ ifeq ($(HAVE_LISTMOUNT_NS_FD),yes)
+  CFLAGS += -DHAVE_LISTMOUNT_NS_FD
+ endif # listmount mnt_ns_fd
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/io/init.c b/io/init.c
index f2a551ef559200..ba60cb2199639b 100644
--- a/io/init.c
+++ b/io/init.c
@@ -94,6 +94,7 @@ init_commands(void)
 	fsprops_init();
 	healthmon_init();
 	verifymedia_init();
+	listmount_init();
 }
 
 /*
diff --git a/io/listmount.c b/io/listmount.c
new file mode 100644
index 00000000000000..f600ce562e63ea
--- /dev/null
+++ b/io/listmount.c
@@ -0,0 +1,383 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2026 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+
+#include "libfrog/flagmap.h"
+#include "command.h"
+#include "input.h"
+#include "init.h"
+#include "io.h"
+
+/* copied from linux/mount.h in linux 6.18 */
+struct statmount_fixed {
+	__u32 size;		/* Total size, including strings */
+	__u32 mnt_opts;		/* [str] Options (comma separated, escaped) */
+	__u64 mask;		/* What results were written */
+	__u32 sb_dev_major;	/* Device ID */
+	__u32 sb_dev_minor;
+	__u64 sb_magic;		/* ..._SUPER_MAGIC */
+	__u32 sb_flags;		/* SB_{RDONLY,SYNCHRONOUS,DIRSYNC,LAZYTIME} */
+	__u32 fs_type;		/* [str] Filesystem type */
+	__u64 mnt_id;		/* Unique ID of mount */
+	__u64 mnt_parent_id;	/* Unique ID of parent (for root == mnt_id) */
+	__u32 mnt_id_old;	/* Reused IDs used in proc/.../mountinfo */
+	__u32 mnt_parent_id_old;
+	__u64 mnt_attr;		/* MOUNT_ATTR_... */
+	__u64 mnt_propagation;	/* MS_{SHARED,SLAVE,PRIVATE,UNBINDABLE} */
+	__u64 mnt_peer_group;	/* ID of shared peer group */
+	__u64 mnt_master;	/* Mount receives propagation from this ID */
+	__u64 propagate_from;	/* Propagation from in current namespace */
+	__u32 mnt_root;		/* [str] Root of mount relative to root of fs */
+	__u32 mnt_point;	/* [str] Mountpoint relative to current root */
+	__u64 mnt_ns_id;	/* ID of the mount namespace */
+	__u32 fs_subtype;	/* [str] Subtype of fs_type (if any) */
+	__u32 sb_source;	/* [str] Source string of the mount */
+	__u32 opt_num;		/* Number of fs options */
+	__u32 opt_array;	/* [str] Array of nul terminated fs options */
+	__u32 opt_sec_num;	/* Number of security options */
+	__u32 opt_sec_array;	/* [str] Array of nul terminated security options */
+	__u64 supported_mask;	/* Mask flags that this kernel supports */
+	__u32 mnt_uidmap_num;	/* Number of uid mappings */
+	__u32 mnt_uidmap;	/* [str] Array of uid mappings (as seen from callers namespace) */
+	__u32 mnt_gidmap_num;	/* Number of gid mappings */
+	__u32 mnt_gidmap;	/* [str] Array of gid mappings (as seen from callers namespace) */
+	__u64 __spare2[43];
+	char str[];		/* Variable size part containing strings */
+};
+
+#ifndef STATMOUNT_MNT_NS_ID
+#define STATMOUNT_MNT_NS_ID		0x00000040U	/* Want/got mnt_ns_id */
+#endif
+
+#ifndef STATMOUNT_MNT_OPTS
+#define STATMOUNT_MNT_OPTS		0x00000080U	/* Want/got mnt_opts */
+#endif
+
+#ifndef STATMOUNT_FS_SUBTYPE
+#define STATMOUNT_FS_SUBTYPE		0x00000100U	/* Want/got fs_subtype */
+#endif
+
+#ifndef STATMOUNT_SB_SOURCE
+#define STATMOUNT_SB_SOURCE		0x00000200U	/* Want/got sb_source */
+#endif
+
+#ifndef STATMOUNT_OPT_ARRAY
+#define STATMOUNT_OPT_ARRAY		0x00000400U	/* Want/got opt_... */
+#endif
+
+#ifndef STATMOUNT_OPT_SEC_ARRAY
+#define STATMOUNT_OPT_SEC_ARRAY		0x00000800U	/* Want/got opt_sec... */
+#endif
+
+#ifndef STATMOUNT_SUPPORTED_MASK
+#define STATMOUNT_SUPPORTED_MASK	0x00001000U	/* Want/got supported mask flags */
+#endif
+
+static const struct flag_map statmount_funcs[] = {
+	{ STATMOUNT_SB_BASIC,		N_("sb_basic") },
+	{ STATMOUNT_MNT_BASIC,		N_("mnt_basic") },
+	{ STATMOUNT_PROPAGATE_FROM,	N_("propagate_from") },
+	{ STATMOUNT_MNT_ROOT,		N_("mnt_root") },
+	{ STATMOUNT_MNT_POINT,		N_("mnt_point") },
+	{ STATMOUNT_FS_TYPE,		N_("fs_type") },
+	{ STATMOUNT_MNT_NS_ID,		N_("mnt_ns_id") },
+	{ STATMOUNT_MNT_OPTS,		N_("mnt_opts") },
+	{ STATMOUNT_FS_SUBTYPE,		N_("fs_subtype") },
+	{ STATMOUNT_SB_SOURCE,		N_("sb_source") },
+	{ STATMOUNT_OPT_ARRAY,		N_("opt_array") },
+	{ STATMOUNT_OPT_SEC_ARRAY,	N_("opt_sec_array") },
+	{ STATMOUNT_SUPPORTED_MASK,	N_("supported_mask") },
+	{0, NULL},
+};
+
+static const struct flag_map mount_attrs[] = {
+	{ MOUNT_ATTR_RDONLY,		N_("rdonly") },
+	{ MOUNT_ATTR_NOSUID,		N_("nosuid") },
+	{ MOUNT_ATTR_NODEV,		N_("nodev") },
+	{ MOUNT_ATTR_NOEXEC,		N_("noexec") },
+	{ MOUNT_ATTR__ATIME,		N_("atime") },
+	{ MOUNT_ATTR_RELATIME,		N_("relatime") },
+	{ MOUNT_ATTR_NOATIME,		N_("noatime") },
+	{ MOUNT_ATTR_STRICTATIME,	N_("strictatime") },
+	{ MOUNT_ATTR_NODIRATIME,	N_("nodiratime") },
+	{ MOUNT_ATTR_IDMAP,		N_("idmap") },
+	{ MOUNT_ATTR_NOSYMFOLLOW,	N_("nosymfollow") },
+	{0, NULL},
+};
+
+static const struct flag_map mount_prop_flags[] = {
+	{ MS_SHARED,			N_("shared") },
+	{ MS_SLAVE,			N_("nopeer") },
+	{ MS_PRIVATE,			N_("private") },
+	{ MS_UNBINDABLE,		N_("unbindable") },
+	{0, NULL},
+};
+
+static void
+listmount_help(void)
+{
+	printf(_(
+"\n"
+" List all mounted filesystems.\n"
+"\n"
+" -f   -- statmount mask flags to set.  Defaults to all possible flags.\n"
+" -i   -- mount id to use.  Defaults to the root of the mount namespace.\n"
+" -n   -- path to a procfs mount namespace file.\n"
+" -t   -- only display mount info for this fs type.\n"
+));
+}
+
+static int
+listmount(
+	const struct mnt_id_req	*req,
+	uint64_t		*mnt_ids,
+	size_t			nr_mnt_ids)
+{
+	return syscall(SYS_listmount, req, mnt_ids, nr_mnt_ids, 0);
+}
+
+static int
+statmount(
+	const struct mnt_id_req	*req,
+	struct statmount_fixed	*smbuf,
+	size_t			smbuf_size)
+{
+	return syscall(SYS_statmount, req, smbuf, smbuf_size, 0);
+}
+
+static void
+dump_mountinfo(
+	int			mnt_ns_fd,
+	uint64_t		statmount_flags,
+	bool			rawflag,
+	uint64_t		row_id,
+	const char		*fstype,
+	uint64_t		mnt_id)
+{
+	struct mnt_id_req	req = {
+		.size		= sizeof(req),
+		.mnt_id		= mnt_id,
+#ifdef HAVE_LISTMOUNT_NS_FD
+		.mnt_ns_fd	= mnt_ns_fd,
+#else
+		.spare		= mnt_ns_fd,
+#endif
+		.param		= statmount_flags,
+	};
+	char			buf[4096];
+	size_t			smbuf_size = getpagesize();
+	struct statmount_fixed	*smbuf = malloc(smbuf_size);
+	int			ret;
+
+	if (!smbuf) {
+		perror("malloc");
+		return;
+	}
+
+	if (fstype)
+		req.param |= STATMOUNT_FS_TYPE | STATMOUNT_FS_SUBTYPE;
+
+	ret = statmount(&req, smbuf, smbuf_size);
+	if (ret) {
+		perror("statmount");
+		goto out_smbuf;
+	}
+
+	if (fstype) {
+		char	real_fstype[256];
+
+		if (!(smbuf->mask & STATMOUNT_FS_TYPE))
+			return;
+
+		if (smbuf->mask & STATMOUNT_FS_SUBTYPE)
+			snprintf(real_fstype, sizeof(fstype), "%s.%s",
+					smbuf->str + smbuf->fs_type,
+					smbuf->str + smbuf->fs_subtype);
+		else
+			snprintf(real_fstype, sizeof(fstype), "%s",
+					smbuf->str + smbuf->fs_type);
+		if (strcmp(fstype, real_fstype))
+			return;
+	}
+
+	printf("mnt_id[%llu]: 0x%llx\n", (unsigned long long)row_id,
+			(unsigned long long)mnt_id);
+
+	if (rawflag) {
+		printf("\tmask: 0x%llx\n", (unsigned long long)smbuf->mask);
+	} else {
+		mask_to_string(statmount_funcs, smbuf->mask, ",", buf,
+				sizeof(buf));
+		printf("\tmask: {%s}\n", buf);
+	}
+
+	if (smbuf->mask & STATMOUNT_SB_BASIC) {
+		printf("\tsb_dev_major: %u\n", smbuf->sb_dev_major);
+		printf("\tsb_dev_minor: %u\n", smbuf->sb_dev_minor);
+		printf("\tsb_magic: 0x%llx\n",
+				(unsigned long long)smbuf->sb_magic);
+		printf("\tsb_flags: 0x%x\n", smbuf->sb_flags);
+	}
+
+	if (smbuf->mask & STATMOUNT_MNT_BASIC) {
+		printf("\tmnt_id: 0x%llx\n",
+				(unsigned long long)smbuf->mnt_id);
+		printf("\tmnt_parent_id: 0x%llx\n",
+				(unsigned long long)smbuf->mnt_parent_id);
+		printf("\tmnt_id_old: %u\n", smbuf->mnt_id_old);
+		printf("\tmnt_parent_id_old: %u\n", smbuf->mnt_parent_id_old);
+		if (rawflag) {
+			printf("\tmnt_attr: 0x%llx\n",
+					(unsigned long long)smbuf->mnt_attr);
+			printf("\tmnt_propagation: 0x%llx\n",
+					(unsigned long long)smbuf->mnt_propagation);
+		} else {
+			mask_to_string(mount_attrs, smbuf->mnt_attr, ",", buf,
+					sizeof(buf));
+			printf("\tmnt_attr: {%s}\n", buf);
+			mask_to_string(mount_prop_flags, smbuf->mnt_propagation,
+					",", buf, sizeof(buf));
+			printf("\tmnt_propagation: {%s}\n", buf);
+		}
+		printf("\tmnt_peer_group: 0x%llx\n",
+				(unsigned long long)smbuf->mnt_peer_group);
+		printf("\tmnt_master: 0x%llx\n",
+				(unsigned long long)smbuf->mnt_master);
+	}
+
+	if (smbuf->mask & STATMOUNT_PROPAGATE_FROM)
+		printf("\tpropagate_from: 0x%llx\n",
+				(unsigned long long)smbuf->propagate_from);
+
+	if (smbuf->mask & STATMOUNT_MNT_ROOT)
+		printf("\tmnt_root: %s\n", smbuf->str + smbuf->mnt_root);
+	if (smbuf->mask & STATMOUNT_MNT_POINT)
+		printf("\tmnt_point: %s\n", smbuf->str + smbuf->mnt_point);
+	if (smbuf->mask & STATMOUNT_FS_TYPE)
+		printf("\tfs_type: %s\n", smbuf->str + smbuf->fs_type);
+	if (smbuf->mask & STATMOUNT_FS_SUBTYPE)
+		printf("\tfs_subtype: %s\n", smbuf->str + smbuf->fs_subtype);
+
+	if (smbuf->mask & STATMOUNT_MNT_NS_ID)
+		printf("\tmnt_ns_id: 0x%llx\n",
+				(unsigned long long)smbuf->mnt_ns_id);
+
+	if (smbuf->mask & STATMOUNT_MNT_OPTS)
+		printf("\tmnt_opts: %s\n", smbuf->str + smbuf->mnt_opts);
+	if (smbuf->mask & STATMOUNT_SB_SOURCE)
+		printf("\tsb_source: %s\n", smbuf->str + smbuf->sb_source);
+
+	if (smbuf->mask & STATMOUNT_SUPPORTED_MASK) {
+		if (rawflag) {
+			printf("\tsupported_mask: 0x%llx\n",
+					(unsigned long long)smbuf->supported_mask);
+		} else {
+			mask_to_string(statmount_funcs, smbuf->supported_mask,
+					",", buf, sizeof(buf));
+			printf("\tsupported_mask: {%s}\n", buf);
+		}
+	}
+
+out_smbuf:
+	free(smbuf);
+}
+
+#define NR_MNT_IDS		7
+
+static int
+listmount_f(
+	int			argc,
+	char			**argv)
+{
+	struct mnt_id_req	req = {
+		.size		= sizeof(struct mnt_id_req),
+		.mnt_id		= LSMT_ROOT,
+	};
+	uint64_t		mnt_ids[NR_MNT_IDS];
+	uint64_t		statmount_flags = -1ULL;
+	const char		*fstype = NULL;
+	unsigned long long	rows = 0;
+	/*
+	 * Believe it or not, listmount and statmount treat a zero fd as a
+	 * null fd even though Linus roared about that with the BPF people.
+	 * Here, zero means "use the current process' mount ns".
+	 */
+	int			mnt_ns_fd = 0;
+	int			rawflag = 0;
+	int			c;
+	int			ret;
+
+	while ((c = getopt(argc, argv, "f:i:n:rt:")) > 0) {
+		switch (c) {
+		case 'f':
+			errno = 0;
+			statmount_flags = strtoull(optarg, NULL, 0);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			break;
+		case 'i':
+			errno = 0;
+			req.mnt_id = strtoull(optarg, NULL, 0);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			break;
+		case 'n':
+			mnt_ns_fd = open(optarg, O_RDONLY);
+			if (mnt_ns_fd < 0) {
+				perror(optarg);
+				return 1;
+			}
+#ifdef HAVE_LISTMOUNT_NS_FD
+			req.mnt_ns_fd = mnt_ns_fd;
+#else
+			req.spare = mnt_ns_fd;
+#endif
+			break;
+		case 'r':
+			rawflag++;
+			break;
+		case 't':
+			fstype = optarg;
+			break;
+		default:
+			listmount_help();
+			return 1;
+		}
+	}
+
+	while ((ret = listmount(&req, mnt_ids, NR_MNT_IDS)) > 0) {
+		for (c = 0; c < ret; c++)
+			dump_mountinfo(mnt_ns_fd, statmount_flags, rawflag,
+					rows++, fstype, mnt_ids[c]);
+
+		req.param = mnt_ids[ret - 1];
+	}
+
+	if (ret < 0)
+		perror("listmount");
+
+	return 0;
+}
+
+static const struct cmdinfo listmount_cmd = {
+	.name		= "listmount",
+	.cfunc		= listmount_f,
+	.argmin		= -1,
+	.argmax		= -1,
+	.flags		= CMD_NOFILE_OK | CMD_FOREIGN_OK | CMD_NOMAP_OK,
+	.oneline	= N_("list mounted filesystems"),
+	.help		= listmount_help,
+};
+
+void
+listmount_init(void)
+{
+	add_command(&listmount_cmd);
+}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 2090cd4c0b2641..2b0dbfbe848bce 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1766,6 +1766,49 @@ .SH FILESYSTEM COMMANDS
 .TP
 .BI "removefsprops " name " [ " names "... ]"
 Remove the given filesystem properties.
+.TP
+.BI "listmount [ \-f " mask " ] [ \-i " mnt_id " ] [ \-n " path " ] [ \-r ] [ \-t" fstype " ]"
+Print information about the mounted filesystems in a particular mount
+namespace.
+The information returned by this call corresponds to the information returned
+by the
+.BR statmount (2)
+system call.
+
+.RE
+.RS 1.0i
+.PD 0
+.TP
+.BI "\-f " mask
+Pass this numeric argument as the mask argument to
+.BR statmount (8).
+Defaults to all bits set, to retrieve all possible information.
+
+.TP
+.BI "\-i " mnt_id
+Only return information for mounts below this mount in the mount tree.
+Defaults to the root directory.
+
+.TP
+.BI "\-n " path
+Return information for the mount namespace given by this procfs path.
+For a given process, the path will most likely look like
+.BI /proc/ $pid /ns/mnt
+though any path can be provided.
+Defaults to the mount namespace of the
+.B xfs_io
+process itself.
+
+.TP
+.B \-r
+Print raw bitmasks instead of converting them to strings.
+
+.TP
+.BI "\-t " fstype
+Only return information for filesystems of this type.
+If not specified, no filtering is performed.
+.RE
+.PD
 
 .SH OTHER COMMANDS
 .TP

