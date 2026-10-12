Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9FD4766A9;
	Mon, 12 Oct 2026 10:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791800602; cv=none; b=ZrS8aE9EFicl/Z4IsTmaar0aXIbxV9jCaQyYWXHnMZPH+upOtpaeZvo6j3smI4T4KKTtZZE5kWP1sIB32ta4AQNOUMtg4dkqBq2ooz7nD1D1rH5+KMnHz8P/jjXBhRSSnGcAY4C7a2xiOaE4O3DWK5SjwArL4l3O/sp/Mt/i5ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791800602; c=relaxed/simple;
	bh=WgCljCdoN9/ZAU+d4LfKLmBIf5uwv1dmqki5tHzqpq8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=htnEHeIjeXPub93VL0fDHdnDuFeSnalibf3l6xCNWeED/Y9qI+k/W9wT3RJzCW3dEx1Eyo4+INkpzdpL8kHX/ThwvZzmoSSMtbmKW9BuwjhM5bGQxDIhv50swek3omj7dY+SwdLg0elWxnDIAzLbZoaRRYtQRuj27XmrnoCMyUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mivIkXDg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mivIkXDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30A41F0089C;
	Mon, 12 Oct 2026 10:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800589;
	bh=x0/ndIzCuyB8PsB+j5eepGRJybRm4CWb4+qIUfnsiko=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mivIkXDgt77RJCaeQyU0nIczKWbuJDok0a5rnopSBhORBG93HfSYO7h/twTQcN3wV
	 n1IVWjP5kzm5WNEuQATSPGrQ08+AZdalGMqT0Fj6If5Hi/Vnof8zGJtM9+0Yg72IEu
	 wlkzzH+fr/FKNcl9f0Jma/ZzTpaUT90lBkMdKykcG7BdLWKrGYUTkl4FsVGjK1e2yb
	 szCyOby0uNIZErrqzWc+O/ACHHx99VFRgEJv1tRscJL7JgTpt4INEe50uG4qLRl5zh
	 X0jS2mua+FdNO93K2pZBJuhb7rNa1EQTHB2aW0Yupee61OMyzowXrW3lFvdDP4YLF0
	 PANq1x8Ysm4Rw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 12 Oct 2026 12:21:13 +0200
Subject: [PATCH RFC 28/28] selftests/filesystems: test xfs remounts after a
 shutdown
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-work-fs-sb_rdonly-v1-28-60743a3dc326@kernel.org>
References: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
In-Reply-To: <20261012-work-fs-sb_rdonly-v1-0-60743a3dc326@kernel.org>
To: Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, ntfs@lists.linux.dev, 
 ocfs2-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
 gfs2@lists.linux.dev, linux-efi@vger.kernel.org, 
 linux-mtd@lists.infradead.org, linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-3d1b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=11500; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WgCljCdoN9/ZAU+d4LfKLmBIf5uwv1dmqki5tHzqpq8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSd2TIlbjbf9n79/mZPjeyV6rKpeszuk3K6Dp86WP3oV
 pP34aOGHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPJOM3IMLF8oqMeq4vIof2m
 i4x6kljuud/4x/5wwpF6zjV3nz+oC2FkuPdn5euqm4zMCxx3KHMf/Cp2sSxA9MDMLUYJd55Lev6
 8wQUA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add tests for remounting xfs after FS_IOC_SHUTDOWN with the default, the
logflush and the nologflush flags and after a shutdown that the remount
to read-only causes itself:

- option-only remount keeps it read-write
- remount to read-only works
- remount to read-write fails with EIO

For the last variant the image lives on a tmpfs of its own. The test
punches out the log and shrinks the tmpfs so the log write during the
remount fails with ENOSPC.

The tests need root, loop devices and mkfs.xfs.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../selftests/filesystems/sb_rdonly/.gitignore     |   1 +
 .../selftests/filesystems/sb_rdonly/Makefile       |   3 +-
 .../testing/selftests/filesystems/sb_rdonly/config |   1 +
 .../sb_rdonly/xfs_shutdown_remount_test.c          | 307 +++++++++++++++++++++
 4 files changed, 311 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/filesystems/sb_rdonly/.gitignore b/tools/testing/selftests/filesystems/sb_rdonly/.gitignore
index 7445dbe15229..26bf6c87edc1 100644
--- a/tools/testing/selftests/filesystems/sb_rdonly/.gitignore
+++ b/tools/testing/selftests/filesystems/sb_rdonly/.gitignore
@@ -2,3 +2,4 @@
 emergency_ro_test
 gfs2_withdraw_test
 ext4_emergency_remount_test
+xfs_shutdown_remount_test
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/Makefile b/tools/testing/selftests/filesystems/sb_rdonly/Makefile
index acd1d70d0fe2..0998b82b95d6 100644
--- a/tools/testing/selftests/filesystems/sb_rdonly/Makefile
+++ b/tools/testing/selftests/filesystems/sb_rdonly/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
-TEST_GEN_PROGS := emergency_ro_test gfs2_withdraw_test ext4_emergency_remount_test
+TEST_GEN_PROGS := emergency_ro_test gfs2_withdraw_test ext4_emergency_remount_test \
+		  xfs_shutdown_remount_test
 
 CFLAGS += -Wall -O2 -g $(KHDR_INCLUDES)
 
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/config b/tools/testing/selftests/filesystems/sb_rdonly/config
index d98bd667314b..2ad57b999168 100644
--- a/tools/testing/selftests/filesystems/sb_rdonly/config
+++ b/tools/testing/selftests/filesystems/sb_rdonly/config
@@ -4,3 +4,4 @@ CONFIG_EXT4_FS=y
 CONFIG_GFS2_FS=y
 CONFIG_JFS_FS=y
 CONFIG_NILFS2_FS=y
+CONFIG_XFS_FS=y
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/xfs_shutdown_remount_test.c b/tools/testing/selftests/filesystems/sb_rdonly/xfs_shutdown_remount_test.c
new file mode 100644
index 000000000000..411a663d7caf
--- /dev/null
+++ b/tools/testing/selftests/filesystems/sb_rdonly/xfs_shutdown_remount_test.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Remounting xfs after a shutdown.
+ *
+ * After FS_IOC_SHUTDOWN xfs refused to go read-only because flushing the
+ * filesystem fails with EIO. Emergency remount (sysrq u) then WARNed in
+ * reconfigure_super() for every shut down xfs, a panic with panic_on_warn.
+ * Now going read-only works, also when the remount's own flush shuts xfs
+ * down, going back to read-write fails with EIO and remounts that only
+ * change options work.
+ *
+ * sysrq u itself can't be tested here, it remounts every filesystem in the
+ * system read-only. The plain remount read-only goes through the same
+ * xfs_remount_ro() path minus SB_FORCE.
+ */
+#define _GNU_SOURCE
+#include <endian.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <linux/falloc.h>
+#include <linux/fs.h>
+#include <linux/loop.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/statvfs.h>
+#include <unistd.h>
+
+#include "../../kselftest_harness.h"
+
+/* mkfs.xfs refuses filesystems smaller than 300MiB */
+#define IMG_SIZE	(512 << 20)
+
+#ifndef FS_IOC_SHUTDOWN
+#define FS_IOC_SHUTDOWN _IOR('X', 125, __u32)
+#endif
+#ifndef FS_SHUTDOWN_FLAGS_DEFAULT
+#define FS_SHUTDOWN_FLAGS_DEFAULT 0x0
+#endif
+#ifndef FS_SHUTDOWN_FLAGS_LOGFLUSH
+#define FS_SHUTDOWN_FLAGS_LOGFLUSH 0x1
+#endif
+#ifndef FS_SHUTDOWN_FLAGS_NOLOGFLUSH
+#define FS_SHUTDOWN_FLAGS_NOLOGFLUSH 0x2
+#endif
+
+FIXTURE(xfs_shutdown) {
+	char dir[64];
+	char img[96];
+	char mnt[96];
+	char dev[32];
+	int loop;
+	int loop_fd;
+	bool tmpfs;
+	bool mounted;
+};
+
+FIXTURE_VARIANT(xfs_shutdown) {
+	/* FS_IOC_SHUTDOWN flags, -1 lets the remount's own flush shut it down */
+	int shutdown_flags;
+};
+
+FIXTURE_VARIANT_ADD(xfs_shutdown, shutdown_default) {
+	.shutdown_flags = FS_SHUTDOWN_FLAGS_DEFAULT,
+};
+
+FIXTURE_VARIANT_ADD(xfs_shutdown, shutdown_logflush) {
+	.shutdown_flags = FS_SHUTDOWN_FLAGS_LOGFLUSH,
+};
+
+FIXTURE_VARIANT_ADD(xfs_shutdown, shutdown_nologflush) {
+	.shutdown_flags = FS_SHUTDOWN_FLAGS_NOLOGFLUSH,
+};
+
+FIXTURE_VARIANT_ADD(xfs_shutdown, shutdown_by_remount) {
+	.shutdown_flags = -1,
+};
+
+/* The superblock options start with its own "ro" or "rw". */
+static bool super_rdonly(const char *mnt)
+{
+	char line[4096], needle[128], fstype[64], source[256], opts[2048];
+	bool ro = false;
+	FILE *f;
+
+	f = fopen("/proc/self/mountinfo", "r");
+	if (!f)
+		return false;
+	snprintf(needle, sizeof(needle), " %s ", mnt);
+	while (fgets(line, sizeof(line), f)) {
+		char *super;
+
+		if (!strstr(line, needle))
+			continue;
+		super = strstr(line, " - ");
+		if (super && sscanf(super, " - %63s %255s %2047s",
+				    fstype, source, opts) == 3)
+			ro = !strncmp(opts, "ro", 2) && (opts[2] == ',' || !opts[2]);
+	}
+	fclose(f);
+	return ro;
+}
+
+static uint32_t get_be32(const unsigned char *p)
+{
+	uint32_t v;
+
+	memcpy(&v, p, sizeof(v));
+	return be32toh(v);
+}
+
+static uint64_t get_be64(const unsigned char *p)
+{
+	uint64_t v;
+
+	memcpy(&v, p, sizeof(v));
+	return be64toh(v);
+}
+
+/*
+ * Make the next log write fail. The image lives on our own tmpfs. Punch the
+ * internal log out of it and shrink the tmpfs to what is in use, then writing
+ * the log needs a new page and the loop device fails it with ENOSPC. xfs
+ * shuts down on the first log write error.
+ */
+static int fail_log_writes(FIXTURE_DATA(xfs_shutdown) *self)
+{
+	uint32_t blocksize, agblocks, logblocks;
+	uint64_t logstart, agno, agbno;
+	unsigned char sb[512];
+	struct statvfs sv;
+	char opts[64];
+	int fd, ret = -1;
+
+	fd = open(self->img, O_RDWR | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	/* struct xfs_dsb */
+	if (pread(fd, sb, sizeof(sb), 0) != sizeof(sb) || memcmp(sb, "XFSB", 4))
+		goto out;
+	blocksize = get_be32(sb + 4);
+	logstart = get_be64(sb + 48);
+	agblocks = get_be32(sb + 84);
+	logblocks = get_be32(sb + 96);
+	if (!logstart)
+		goto out;
+	/* sb_agblklog */
+	agno = logstart >> sb[124];
+	agbno = logstart & ((1ULL << sb[124]) - 1);
+	if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+		      (agno * agblocks + agbno) * blocksize,
+		      (uint64_t)logblocks * blocksize))
+		goto out;
+
+	/* the loop device may still allocate pages in between */
+	for (int tries = 0; tries < 10; tries++) {
+		if (statvfs(self->dir, &sv))
+			break;
+		snprintf(opts, sizeof(opts), "size=%llu",
+			 (unsigned long long)(sv.f_blocks - sv.f_bfree) * sv.f_frsize);
+		if (!mount(NULL, self->dir, NULL, MS_REMOUNT, opts)) {
+			ret = 0;
+			break;
+		}
+	}
+out:
+	close(fd);
+	return ret;
+}
+
+static void xfs_shutdown_cleanup(FIXTURE_DATA(xfs_shutdown) *self)
+{
+	if (self->mounted)
+		umount2(self->mnt, MNT_DETACH);
+	if (self->loop_fd >= 0)
+		close(self->loop_fd);	/* LO_FLAGS_AUTOCLEAR detaches it */
+	unlink(self->img);
+	rmdir(self->mnt);
+	if (self->tmpfs)
+		umount2(self->dir, MNT_DETACH);
+	rmdir(self->dir);
+}
+
+FIXTURE_SETUP(xfs_shutdown)
+{
+	struct loop_config cfg = { .info.lo_flags = LO_FLAGS_AUTOCLEAR };
+	char cmd[256], path[128];
+	int ctl, fd, ret;
+
+	self->loop = -1;
+	self->loop_fd = -1;
+	self->tmpfs = false;
+	self->mounted = false;
+
+	if (geteuid() != 0)
+		SKIP(return, "test requires CAP_SYS_ADMIN");
+	if (access("/dev/loop-control", R_OK | W_OK))
+		SKIP(return, "test requires loop devices");
+
+	ASSERT_EQ(unshare(CLONE_NEWNS), 0);
+	ASSERT_EQ(mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL), 0);
+
+	snprintf(self->dir, sizeof(self->dir), "/tmp/xfs_shutdown.XXXXXX");
+	ASSERT_NE(mkdtemp(self->dir), NULL);
+	/* fail_log_writes() needs the image on a tmpfs of our own */
+	ASSERT_EQ(mount("tmpfs", self->dir, "tmpfs", 0, "size=1g,mode=0700"), 0);
+	self->tmpfs = true;
+	snprintf(self->img, sizeof(self->img), "%s/img", self->dir);
+	snprintf(self->mnt, sizeof(self->mnt), "%s/mnt", self->dir);
+	ASSERT_EQ(mkdir(self->mnt, 0700), 0);
+
+	fd = open(self->img, O_RDWR | O_CREAT | O_CLOEXEC, 0600);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(ftruncate(fd, IMG_SIZE), 0);
+	snprintf(cmd, sizeof(cmd), "mkfs.xfs -q -f %s >/dev/null 2>&1", self->img);
+	if (system(cmd)) {
+		close(fd);
+		xfs_shutdown_cleanup(self);
+		SKIP(return, "mkfs.xfs failed or is not available");
+	}
+
+	ctl = open("/dev/loop-control", O_RDWR | O_CLOEXEC);
+	ASSERT_GE(ctl, 0);
+	cfg.fd = fd;
+	/* another user can grab the free device first */
+	for (int tries = 0;; tries++) {
+		self->loop = ioctl(ctl, LOOP_CTL_GET_FREE);
+		ASSERT_GE(self->loop, 0);
+		snprintf(self->dev, sizeof(self->dev), "/dev/loop%d", self->loop);
+		self->loop_fd = open(self->dev, O_RDWR | O_CLOEXEC);
+		ASSERT_GE(self->loop_fd, 0);
+		if (!ioctl(self->loop_fd, LOOP_CONFIGURE, &cfg))
+			break;
+		ASSERT_EQ(errno, EBUSY);
+		ASSERT_LT(tries, 10);
+		close(self->loop_fd);
+		self->loop_fd = -1;
+	}
+	close(ctl);
+	close(fd);
+
+	ret = mount(self->dev, self->mnt, "xfs", 0, NULL);
+	if (ret && errno == ENODEV) {
+		xfs_shutdown_cleanup(self);
+		SKIP(return, "kernel lacks xfs");
+	}
+	ASSERT_EQ(ret, 0);
+	self->mounted = true;
+
+	snprintf(path, sizeof(path), "%s/f", self->mnt);
+	fd = open(path, O_RDWR | O_CREAT | O_CLOEXEC, 0644);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(write(fd, "data\n", 5), 5);
+	ASSERT_EQ(fsync(fd), 0);
+	/* leave something dirty for the shutdown */
+	ASSERT_EQ(write(fd, "more\n", 5), 5);
+	close(fd);
+}
+
+FIXTURE_TEARDOWN(xfs_shutdown)
+{
+	xfs_shutdown_cleanup(self);
+}
+
+TEST_F_TIMEOUT(xfs_shutdown, remount, 60)
+{
+	struct statvfs sv;
+	int fd, ret;
+
+	if (variant->shutdown_flags < 0) {
+		ASSERT_EQ(fail_log_writes(self), 0);
+	} else {
+		__u32 flags = variant->shutdown_flags;
+
+		fd = open(self->mnt, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+		ASSERT_GE(fd, 0);
+		ASSERT_EQ(ioctl(fd, FS_IOC_SHUTDOWN, &flags), 0);
+		close(fd);
+	}
+
+	/* only options change */
+	ASSERT_EQ(mount(NULL, self->mnt, NULL, MS_REMOUNT, NULL), 0);
+	ASSERT_EQ(statvfs(self->mnt, &sv), 0);
+	ASSERT_FALSE(!!(sv.f_flag & ST_RDONLY));
+
+	/* going read-only works */
+	ret = mount(NULL, self->mnt, NULL, MS_REMOUNT | MS_RDONLY, NULL);
+	ASSERT_EQ(ret, 0) TH_LOG("remount read-only: %s", strerror(errno));
+	ASSERT_TRUE(super_rdonly(self->mnt));
+
+	/* going back to read-write doesn't, also not after the remount's shutdown */
+	ret = mount(NULL, self->mnt, NULL, MS_REMOUNT, NULL);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EIO);
+	ASSERT_TRUE(super_rdonly(self->mnt));
+
+	ASSERT_EQ(umount(self->mnt), 0);
+	self->mounted = false;
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0

