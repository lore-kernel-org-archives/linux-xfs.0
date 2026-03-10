Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4500E1547C0
	for <linux-xfs@vger.kernel.org>; Tue, 10 Mar 2026 03:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114546; cv=none; b=quGBqnBSaQeNMRkdU6EKVoMJgdiDupQeyqnmja3c3voGXgGVegyRdbBo/rA/je1Q5PDmdTK0SOLc1KBFiaimiw299ufuEOg1ydN2CNu4zx2VHiAMyuTm+11rokZgAq5wmchQiQDgwKKBlTDKZtOS/BNqRG04+sQnwMUYi64wqs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114546; c=relaxed/simple;
	bh=1abo6QJ2LwJsRhANT6reVJZXWeIrXzeuXG7GGcIWkts=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cnUbGSKE5I4gp9Rlc78Evv4tqO9UAFmtt0J3PVWJlMxDiRMnMEwboxQdwN/mcFqZDmAaBk6D/nNYyS0EsDvPjiIvexqoCe93UOu5w3pe2XmOZs7+N4VXIJPK+juZ8VgDU8VEJaqRVbYoL+Gwl/RAc+igr0InoXexiP2ddqMYz74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pqNgKSbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pqNgKSbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A90BC19423;
	Tue, 10 Mar 2026 03:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114546;
	bh=1abo6QJ2LwJsRhANT6reVJZXWeIrXzeuXG7GGcIWkts=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pqNgKSbzSoRDRcYrhePxI3PJunjQFrgBFLxNmIW0WhFkgRrKlUbccNmsajnByrMu+
	 nEZP00SLHtmzDwhOI3t2+FX0ZZ+QU/ItfOwmNMkC0E2XSJbetD9q+eRgdcE2RqJHVt
	 1KNtIxcWSv9l3IYlnp+pwNbycyXvOE1o9lgbJnwbDpesLRg5gHw7noYHLOphPTn6vM
	 KbiN+c98bIJ9DnVym10PXAPp8/hqMK9/Asj65VPFCDAzqkkkZKi6dmz0+Vk+CkPKtE
	 ven88FvQ4C4KcS1dtiy/8wSAF3wa1M+C/46pMYOHvHlcndVgNNf+UuZnfc/MQbXpFF
	 Rq2O5zn8z05Fg==
Date: Mon, 09 Mar 2026 20:49:05 -0700
Subject: [PATCH 25/28] xfs_io: add listmount and statmount commands
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <177311401912.1183235.4457290707960864446.stgit@frogsfrogsfrogs>
In-Reply-To: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add two new commands: one to list all mounts via statmount, now that we
use this in xfs_healer_start, and another to statmount each open file.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/io.h           |    6 +
 io/Makefile       |    5 +
 io/init.c         |    1 
 io/listmount.c    |  361 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |   66 ++++++++++
 5 files changed, 439 insertions(+)
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
index 79d5e172b8f31f..e25742b635396e 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -90,6 +90,11 @@ ifeq ($(HAVE_GETFSMAP),yes)
 CFILES += fsmap.c
 endif
 
+ifeq ($(HAVE_LISTMOUNT),yes)
+CFILES += listmount.c
+LCFLAGS += -DHAVE_LISTMOUNT
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
index 00000000000000..af4ebaf7861250
--- /dev/null
+++ b/io/listmount.c
@@ -0,0 +1,361 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2026 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+
+#include "libfrog/flagmap.h"
+#include "libfrog/statmount.h"
+#include "command.h"
+#include "input.h"
+#include "init.h"
+#include "io.h"
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
+dump_mountinfo(
+	const struct statmount	*smbuf,
+	bool			rawflag)
+{
+	char			buf[4096];
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
+}
+
+static inline bool
+match_mount(
+	const struct statmount	*smbuf,
+	const char		*fstype)
+{
+	char			real_fstype[256];
+
+	if (!fstype)
+		return true;
+
+	if (!(smbuf->mask & STATMOUNT_FS_TYPE))
+		return false;
+
+	if (smbuf->mask & STATMOUNT_FS_SUBTYPE)
+		snprintf(real_fstype, sizeof(fstype), "%s.%s",
+				smbuf->str + smbuf->fs_type,
+				smbuf->str + smbuf->fs_subtype);
+	else
+		snprintf(real_fstype, sizeof(fstype), "%s",
+				smbuf->str + smbuf->fs_type);
+
+	return strcmp(fstype, real_fstype) == 0;
+}
+
+static void
+listmount_help(void)
+{
+	printf(_(
+"\n"
+" List all mounted filesystems.\n"
+"\n"
+" -f   -- statmount mask flags to set.  Defaults to all possible flags.\n"
+" -i   -- only list mounts below this mount id.  Defaults to the rootdir.\n"
+" -n   -- path to a procfs mount namespace file.\n"
+" -r   -- do not decode flags fields into strings.\n"
+" -t   -- only display mount info for this fs type.\n"
+));
+}
+
+#define NR_MNT_IDS		7
+
+static int
+listmount_f(
+	int			argc,
+	char			**argv)
+{
+	uint64_t		mnt_ids[NR_MNT_IDS];
+	uint64_t		cursor = LISTMOUNT_INIT_CURSOR;
+	uint64_t		statmount_flags = -1ULL;
+	uint64_t		mnt_id = LSMT_ROOT;
+	struct statmount	*smbuf;
+	const char		*fstype = NULL;
+	unsigned long long	rows = 0;
+	const size_t		smbuf_size = libfrog_statmount_sizeof(4096);
+	int			mnt_ns_fd = DEFAULT_MOUNTNS_FD;
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
+			mnt_id = strtoull(optarg, NULL, 0);
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
+	smbuf = malloc(smbuf_size);
+	if (!smbuf) {
+		perror("malloc");
+		return 1;
+	}
+
+	if (fstype)
+		statmount_flags |= STATMOUNT_FS_TYPE | STATMOUNT_FS_SUBTYPE;
+
+	while ((ret = libfrog_listmount(mnt_id, mnt_ns_fd, &cursor,
+					mnt_ids, NR_MNT_IDS)) > 0) {
+		for (c = 0; c < ret; c++) {
+			ret = libfrog_statmount(mnt_ids[c], mnt_ns_fd,
+					statmount_flags, smbuf, smbuf_size);
+			if (ret) {
+				perror("statmount");
+				goto out_smbuf;
+			}
+
+			if (!match_mount(smbuf, fstype))
+				continue;
+
+			printf("mnt_id[%llu]: 0x%llx\n",
+					(unsigned long long)rows++,
+					(unsigned long long)mnt_ids[c]);
+
+			dump_mountinfo(smbuf, rawflag);
+		}
+	}
+
+	if (ret < 0)
+		perror("listmount");
+
+out_smbuf:
+	free(smbuf);
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
+static void
+statmount_help(void)
+{
+	printf(_(
+"\n"
+" Print statmount information for the open file.\n"
+"\n"
+" -f   -- statmount mask flags to set.  Defaults to all possible flags.\n"
+" -r   -- do not decode flags fields into strings.\n"
+));
+}
+
+static int
+statmount_f(
+	int			argc,
+	char			**argv)
+{
+	uint64_t		statmount_flags = -1ULL;
+	struct statmount	*smbuf;
+	const size_t		smbuf_size = libfrog_statmount_sizeof(4096);
+	int			rawflag = 0;
+	int			c;
+	int			ret;
+
+	while ((c = getopt(argc, argv, "f:r")) > 0) {
+		switch (c) {
+		case 'f':
+			errno = 0;
+			statmount_flags = strtoull(optarg, NULL, 0);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			break;
+		case 'r':
+			rawflag++;
+			break;
+		default:
+			listmount_help();
+			return 1;
+		}
+	}
+
+	smbuf = malloc(smbuf_size);
+	if (!smbuf) {
+		perror("malloc");
+		return 1;
+	}
+
+	ret = libfrog_fstatmount(file->fd, statmount_flags, smbuf, smbuf_size);
+	if (ret) {
+		perror("statmount");
+		goto out_smbuf;
+	}
+
+	printf("path: %s\n", file->name);
+
+	dump_mountinfo(smbuf, rawflag);
+
+out_smbuf:
+	free(smbuf);
+	return 0;
+}
+
+static const struct cmdinfo statmount_cmd = {
+	.name		= "statmount",
+	.cfunc		= statmount_f,
+	.argmin		= -1,
+	.argmax		= -1,
+	.flags		= CMD_FOREIGN_OK | CMD_NOMAP_OK,
+	.oneline	= N_("statmount the open file"),
+	.help		= statmount_help,
+};
+
+void
+listmount_init(void)
+{
+	add_command(&listmount_cmd);
+	add_command(&statmount_cmd);
+}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 2090cd4c0b2641..61defcc377163a 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -1766,6 +1766,72 @@ .SH FILESYSTEM COMMANDS
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
+
+.TP
+.BI "statmount [ \-f " mask " ] [ \-r ]"
+Print information about the mounted filesystem for each open file.
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
+.B \-r
+Print raw bitmasks instead of converting them to strings.
+
+.RE
+.PD
 
 .SH OTHER COMMANDS
 .TP

