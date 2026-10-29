Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290186;
	b=Zfy1Ayi0tBi1P9WGRsgSqy+KffjvKoHR+B8V1Q7OjR3ALJzLf+PfaCQdJHrIVhgjQdyu
	 0A/FH3GboR9zKafNO2qXiSdQnE/O0Pd52QBpgghwn3QfgveBT0oHWIFWMqXRU/HYozXfp
	 mWY8dIcSZqu/ukSEIDBaNZLIeDAo3WLL2FEgQ/G6EkQmh1zJ2ZQtqnf3Pg4L70RANiF7k
	 FbY+rKIJzMytTDQ9eaTKT/V0Macy/yrpEJc7HzogTnWTiZT5LIhkDgI/QxHI2HUabz6zk
	 7Xy9F5YkW9L0TCbrgDnnisSNFGTAlqWwMBLfFait9vmuWrw9ZQ9oWvNWNeZJytewYjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290186;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=k/JaVVqCIjBjwcZ4Ktq0cqt6WTLnv5uHe8dvAAAN/MI=;
	b=N2B9r0DCQfW08RCCMl3uLWF5llvxO/K5Obdls9pkIICH2st5jnoqaemF4t7SyLTtqRa/
	 ocHYQtZ9HLL5OO5LWd8/a9R3AYkEI9VA5SmhaPBejwIK/7jyyBoYKLk4kVMHE+8Xfe0Jy
	 kNy4DyrkzIGWzCwzt9XCDsoftm1zA8OUwd+yaiV8uKScQs1OpykB6Sm6ttReCr5rJBK0m
	 lvp5OvAOfeXaTp2TJS8KbTlabs6qJNClBI1h/v0koghPKGTShDImcMfgAtuVFx9/3acTK
	 wiVPP4IqIViFgPoZYHwFDyStj/ly9H/npGQrOqwnX390EYcYe2MDQaYVVhU1UwuQTQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KIWlCk7A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469F8606A33E;
	Thu, 29 Oct 2026 16:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KIWlCk7A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870A31F031E1;
	Thu, 29 Oct 2026 16:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290186;
	bh=k/JaVVqCIjBjwcZ4Ktq0cqt6WTLnv5uHe8dvAAAN/MI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KIWlCk7AAJ2etTqUPf+UdcSsuMQuZHztzBRdcCGj27/lOxeGr5s2jXCZKUnct1Hqq
	 u5XAaC7A1gbXRFYN//rzwBw44pCdOv6XKEZnPNidM4AS000LBTp1JaUTSwelZg75v1
	 1v6U3BCWVAwmPqodxjhWjrHf2ygSXLcPRlmoMpXiseljbpwhkV4CraSn3ri/a0CzoO
	 reSvsImFDP2+2el6B0AQRGIzkPw01/7bPt0yBtT7y19A7eoygxGFOvKE0H+mRI7efO
	 c1Ti9Rr52z8ZG3rgoTtor5WIZO8sAPlyY/LQ7w0y879e0gl9ALerXcHaSyVpMhAQdB
	 JB8ShTo3zTMSQ==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:25 +0100
Subject: [PATCH v2 34/34] selftests/filesystems: test xfs remounts after a
 shutdown
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-work-fs-sb_rdonly-v2-34-2f44f64f0b66@kernel.org>
References: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
In-Reply-To: <20261029-work-fs-sb_rdonly-v2-0-2f44f64f0b66@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=11137; i=brauner@kernel.org;
 h=from:subject:message-id; bh=/Voe/wFwqfK8+ON5qhwC5PvGjQ85ofAqpLXJMC6O98s=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjd4wrdORilhoSWvYNZB2e59widt47JWxGwyfiYtP
 v3leqOHHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOZKsDwv5A/2aVg45/UMv5j
 XM0N7+My+WsFHXfEyVziSPY2DDrdycjwYilHyLqj3f4LHiTYP3fQuphzZfIXv89s3/8xT/nNFar
 IDgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add tests for remounting xfs after FS_IOC_SHUTDOWN with the default, the
logflush and the nologflush flags and after a shutdown that the remount
to read-only causes itself:

- option-only remount keeps it read-write
- remount to read-only works
- remount to read-write fails with EIO

The image lives on a tmpfs of its own. For the last variant the test
punches out the log and shrinks the tmpfs so the log write during the
remount fails with ENOSPC.

The tests need root, loop devices and mkfs.xfs.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../selftests/filesystems/sb_rdonly/.gitignore     |   1 +
 .../selftests/filesystems/sb_rdonly/Makefile       |   3 +-
 .../testing/selftests/filesystems/sb_rdonly/config |   2 +
 .../sb_rdonly/xfs_shutdown_remount_test.c          | 299 +++++++++++++++++++++
 4 files changed, 304 insertions(+), 1 deletion(-)

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
index d98bd667314b..fdb9dd69e701 100644
--- a/tools/testing/selftests/filesystems/sb_rdonly/config
+++ b/tools/testing/selftests/filesystems/sb_rdonly/config
@@ -4,3 +4,5 @@ CONFIG_EXT4_FS=y
 CONFIG_GFS2_FS=y
 CONFIG_JFS_FS=y
 CONFIG_NILFS2_FS=y
+CONFIG_TMPFS=y
+CONFIG_XFS_FS=y
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/xfs_shutdown_remount_test.c b/tools/testing/selftests/filesystems/sb_rdonly/xfs_shutdown_remount_test.c
new file mode 100644
index 000000000000..6d296e2c916c
--- /dev/null
+++ b/tools/testing/selftests/filesystems/sb_rdonly/xfs_shutdown_remount_test.c
@@ -0,0 +1,299 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * A shut down xfs refused to go read-only and emergency remount (sysrq u)
+ * WARNed. Check that the remount works, also when its own flush shuts xfs
+ * down, that going back to read-write fails with EIO and that option-only
+ * remounts work. sysrq u itself can't be tested here, the plain remount goes
+ * through the same path minus SB_FORCE.
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
+ * Make the next log write fail: punch the log out of the image on our tmpfs
+ * and shrink the tmpfs to what is in use, so the log write needs a page it
+ * can't get and fails with ENOSPC.
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

