Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290178;
	b=eynhQxYwc57vEETAUrKqjcFaM6SdmX2BESfbdiHQSyVMdUqxvTLlCaa3zQxzXnUJjAiZ
	 gf1UaDsB7vtsq3/zYsa8d6ngI0RaxQ4JiakMDZTs+4DuwVQs+x8hPLUQsQHw43VR1K5t7
	 PwPvqUIJ5Bspt+Uq4SKq8zmBd+Q11DOxyjeqTcE6PSEzzwaGDlxeLIoLVu0oe/Psh60/K
	 9Hp8loCDLh0o4XIAyWE3AH3/2QO03IsjnpxzZxjhPjaF/otwoISEUgK6GzmQvF2rlyZGN
	 69BszuHvG5O/8HXvOXkBWliVT5JGzD1c2eZo+xTBENnd504px6DP5So0pGAmNA+xVtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290178;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=droVfVyW/J4NWE7mh5TfQyRMSBtnbhnE555QImfVgFk=;
	b=4H7s+UOY8iCsUxxV2G27qy/crITVLFh5ygNXKNOJaSz0nU6JuMPdE4yAPFsefTUEUJWM
	 nF34rzRI+SJvWZE4nKtbs9l1yfPx08wrIXYdq3ibvVPkvU1CGr8yxcr3KgyD3tF1B/AtV
	 FdRsDx1VY97YkuYaZypGt216ki8KNjkj77xjLih5vmmclF8oNj5c4vPx7CtUzpkxhSbrh
	 qM8eaOBkeYOL1d7OXILEe92WWv//82Cb4usKBOMMNSRk69jFHKxDBk80tqOUoeOdczgcY
	 31erBYW8whXTFdbPYcQFfpXqgIP2Rpy8eErtu3pnzT3SVXp52a4ooQUcczywnPSP3HA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DmiBIKvc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47CB606A323;
	Thu, 29 Oct 2026 16:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DmiBIKvc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4021F01824;
	Thu, 29 Oct 2026 16:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290177;
	bh=droVfVyW/J4NWE7mh5TfQyRMSBtnbhnE555QImfVgFk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DmiBIKvcYo74I4nINRVqEQsM6UxXLe3ZO7GA8zAG26uGNJncRRSqNSUDEks0wZGgx
	 mg0MXafEidSkLIaGd2NGJg3kiupo02jfbEH3q/gGwzMBv2dgpTbibsi4vWdGVJrVxq
	 uq4DBpAcFJVDbbPTpzPQNg8zXt1qEHGqgF+ChOvohTFMmWOmY2f5csLygi16Yb/Gjl
	 cSxlPkxNvANPSsTWOxwtfg5wbvIUNDvKzuHyS9vnJgLASa5MsjpmzYdSXiOmQ+okEK
	 ZC47/BA3lAZeY5TM8cAva35uuaIr3dTd+2uZwlfucN7U8lvMCYSZlsAgtWLyFu/ToU
	 RZEs+od7LUSyg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:23 +0100
Subject: [PATCH v2 32/34] selftests/filesystems: test ext4 remounts in the
 emergency state
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-32-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11147; i=brauner@kernel.org;
 h=from:subject:message-id; bh=QxpEnsHCux4FRQlDy0wwCs1cyujIv0qreUa1yUPO61M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjd4vmHLk/Y3wodmOO364tX+2vbLhtnLLBcFmiy6E
 Lw2YbbGjY5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJnBVn+Gf2t7vgaNvlOyti
 PW+pXlcJct9SpsCZe9db9uDxU/+PtTgz/FPSv/tH6tilUMXEnM/u1ZvKT34Qr8jw7klVTbshxXG
 7jgkA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add tests for remounting ext4 after FS_IOC_SHUTDOWN with the default and
the nologflush flags and after an error with and without a journal:

- option-only remount doesn't make it read-only, the error state alone
  reports ST_RDONLY
- remount to read-only works and writes nothing
- remount to read-write fails with EROFS

The tests need root, loop devices and mkfs.ext4.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../selftests/filesystems/sb_rdonly/.gitignore     |   1 +
 .../selftests/filesystems/sb_rdonly/Makefile       |   2 +-
 .../testing/selftests/filesystems/sb_rdonly/config |   1 +
 .../sb_rdonly/ext4_emergency_remount_test.c        | 305 +++++++++++++++++++++
 4 files changed, 308 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/filesystems/sb_rdonly/.gitignore b/tools/testing/selftests/filesystems/sb_rdonly/.gitignore
index 96daf47a494f..7445dbe15229 100644
--- a/tools/testing/selftests/filesystems/sb_rdonly/.gitignore
+++ b/tools/testing/selftests/filesystems/sb_rdonly/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 emergency_ro_test
 gfs2_withdraw_test
+ext4_emergency_remount_test
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/Makefile b/tools/testing/selftests/filesystems/sb_rdonly/Makefile
index 89d72fcf8600..acd1d70d0fe2 100644
--- a/tools/testing/selftests/filesystems/sb_rdonly/Makefile
+++ b/tools/testing/selftests/filesystems/sb_rdonly/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-TEST_GEN_PROGS := emergency_ro_test gfs2_withdraw_test
+TEST_GEN_PROGS := emergency_ro_test gfs2_withdraw_test ext4_emergency_remount_test
 
 CFLAGS += -Wall -O2 -g $(KHDR_INCLUDES)
 
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/config b/tools/testing/selftests/filesystems/sb_rdonly/config
index ab660b588e6d..d98bd667314b 100644
--- a/tools/testing/selftests/filesystems/sb_rdonly/config
+++ b/tools/testing/selftests/filesystems/sb_rdonly/config
@@ -1,5 +1,6 @@
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_EXT2_FS=y
+CONFIG_EXT4_FS=y
 CONFIG_GFS2_FS=y
 CONFIG_JFS_FS=y
 CONFIG_NILFS2_FS=y
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/ext4_emergency_remount_test.c b/tools/testing/selftests/filesystems/sb_rdonly/ext4_emergency_remount_test.c
new file mode 100644
index 000000000000..5c541bb68ef7
--- /dev/null
+++ b/tools/testing/selftests/filesystems/sb_rdonly/ext4_emergency_remount_test.c
@@ -0,0 +1,305 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ext4 refused every change of the read-only state in its emergency state and
+ * emergency remount (sysrq u) WARNed. Check that after a shutdown or an error
+ * a remount can go read-only without writing anything, not back to read-write,
+ * and that option-only remounts work. sysrq u itself can't be tested here, the
+ * plain remount goes through the same path minus SB_FORCE.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
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
+#define IMG_SIZE	(128 << 20)
+
+#ifndef FS_IOC_SHUTDOWN
+#define FS_IOC_SHUTDOWN _IOR('X', 125, __u32)
+#endif
+#ifndef FS_SHUTDOWN_FLAGS_DEFAULT
+#define FS_SHUTDOWN_FLAGS_DEFAULT 0x0
+#endif
+#ifndef FS_SHUTDOWN_FLAGS_NOLOGFLUSH
+#define FS_SHUTDOWN_FLAGS_NOLOGFLUSH 0x2
+#endif
+
+enum how { HOW_SHUTDOWN, HOW_ERROR };
+
+FIXTURE(ext4_emergency) {
+	char dir[64];
+	char img[96];
+	char mnt[96];
+	char dev[32];
+	int loop;
+	int loop_fd;
+	bool mounted;
+};
+
+FIXTURE_VARIANT(ext4_emergency) {
+	const char *mkfs;
+	enum how how;
+	__u32 shutdown_flags;
+	const char *state;	/* the state option shown in the mount options */
+};
+
+FIXTURE_VARIANT_ADD(ext4_emergency, shutdown) {
+	.mkfs = "mkfs.ext4 -q -F -b 4096",
+	.how = HOW_SHUTDOWN,
+	.shutdown_flags = FS_SHUTDOWN_FLAGS_NOLOGFLUSH,
+	.state = "shutdown",
+};
+
+/* the journal stays live, going read-only must not write it */
+FIXTURE_VARIANT_ADD(ext4_emergency, shutdown_default) {
+	.mkfs = "mkfs.ext4 -q -F -b 4096",
+	.how = HOW_SHUTDOWN,
+	.shutdown_flags = FS_SHUTDOWN_FLAGS_DEFAULT,
+	.state = "shutdown",
+};
+
+FIXTURE_VARIANT_ADD(ext4_emergency, error) {
+	.mkfs = "mkfs.ext4 -q -F -b 4096",
+	.how = HOW_ERROR,
+	.state = "emergency_ro",
+};
+
+FIXTURE_VARIANT_ADD(ext4_emergency, error_nojournal) {
+	.mkfs = "mkfs.ext4 -q -F -b 4096 -O ^has_journal",
+	.how = HOW_ERROR,
+	.state = "emergency_ro",
+};
+
+static bool mount_option(const char *mnt, const char *opt)
+{
+	char line[4096], needle[128];
+	bool found = false;
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
+		/* the superblock options follow the separator */
+		super = strstr(line, " - ");
+		if (super && strstr(super, opt))
+			found = true;
+	}
+	fclose(f);
+	return found;
+}
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
+/* Sectors written to the loop device so far, -1 on error. */
+static long long written(int loop)
+{
+	unsigned long long v[7];
+	char path[64];
+	FILE *f;
+	int n;
+
+	snprintf(path, sizeof(path), "/sys/block/loop%d/stat", loop);
+	f = fopen(path, "r");
+	if (!f)
+		return -1;
+	n = fscanf(f, "%llu %llu %llu %llu %llu %llu %llu",
+		   &v[0], &v[1], &v[2], &v[3], &v[4], &v[5], &v[6]);
+	fclose(f);
+	return n == 7 ? (long long)v[6] : -1;
+}
+
+static int enter_emergency(FIXTURE_DATA(ext4_emergency) *self,
+			   const FIXTURE_VARIANT(ext4_emergency) *variant)
+{
+	char path[128];
+	int fd, ret;
+
+	if (variant->how == HOW_SHUTDOWN) {
+		__u32 flags = variant->shutdown_flags;
+
+		fd = open(self->mnt, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+		if (fd < 0)
+			return -1;
+		ret = ioctl(fd, FS_IOC_SHUTDOWN, &flags);
+		close(fd);
+		return ret;
+	}
+
+	/* ext4_error() through the test knob, errors=remount-ro reacts */
+	snprintf(path, sizeof(path), "/sys/fs/ext4/loop%d/trigger_fs_error", self->loop);
+	fd = open(path, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	ret = write(fd, "selftest", 8) == 8 ? 0 : -1;
+	close(fd);
+	return ret;
+}
+
+static void ext4_emergency_cleanup(FIXTURE_DATA(ext4_emergency) *self)
+{
+	if (self->mounted)
+		umount2(self->mnt, MNT_DETACH);
+	if (self->loop_fd >= 0)
+		close(self->loop_fd);	/* LO_FLAGS_AUTOCLEAR detaches it */
+	unlink(self->img);
+	rmdir(self->mnt);
+	rmdir(self->dir);
+}
+
+FIXTURE_SETUP(ext4_emergency)
+{
+	struct loop_config cfg = { .info.lo_flags = LO_FLAGS_AUTOCLEAR };
+	char cmd[256], path[128];
+	int ctl, fd, ret;
+
+	self->loop = -1;
+	self->loop_fd = -1;
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
+	snprintf(self->dir, sizeof(self->dir), "/tmp/ext4_emergency.XXXXXX");
+	ASSERT_NE(mkdtemp(self->dir), NULL);
+	snprintf(self->img, sizeof(self->img), "%s/img", self->dir);
+	snprintf(self->mnt, sizeof(self->mnt), "%s/mnt", self->dir);
+	ASSERT_EQ(mkdir(self->mnt, 0700), 0);
+
+	fd = open(self->img, O_RDWR | O_CREAT | O_CLOEXEC, 0600);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(ftruncate(fd, IMG_SIZE), 0);
+	snprintf(cmd, sizeof(cmd), "%s %s >/dev/null 2>&1", variant->mkfs, self->img);
+	if (system(cmd)) {
+		close(fd);
+		ext4_emergency_cleanup(self);
+		SKIP(return, "mkfs.ext4 failed or is not available");
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
+	ret = mount(self->dev, self->mnt, "ext4", 0, "errors=remount-ro");
+	if (ret && errno == ENODEV) {
+		ext4_emergency_cleanup(self);
+		SKIP(return, "kernel lacks ext4");
+	}
+	ASSERT_EQ(ret, 0);
+	self->mounted = true;
+
+	snprintf(path, sizeof(path), "%s/f", self->mnt);
+	fd = open(path, O_RDWR | O_CREAT | O_CLOEXEC, 0644);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(write(fd, "data\n", 5), 5);
+	ASSERT_EQ(fsync(fd), 0);
+	close(fd);
+}
+
+FIXTURE_TEARDOWN(ext4_emergency)
+{
+	ext4_emergency_cleanup(self);
+}
+
+TEST_F_TIMEOUT(ext4_emergency, remount, 60)
+{
+	long long w0, w1;
+	struct statvfs sv;
+	int ret;
+
+	ASSERT_EQ(enter_emergency(self, variant), 0);
+	ASSERT_TRUE(mount_option(self->mnt, variant->state));
+
+	/* nothing below may write, get whatever is still dirty out first */
+	sync();
+	w0 = written(self->loop);
+	ASSERT_GE(w0, 0);
+
+	/* only options change, the error state alone reports ST_RDONLY */
+	ASSERT_EQ(mount(NULL, self->mnt, NULL, MS_REMOUNT, "errors=remount-ro"), 0);
+	ASSERT_EQ(statvfs(self->mnt, &sv), 0);
+	ASSERT_EQ(!!(sv.f_flag & ST_RDONLY), variant->how == HOW_ERROR);
+
+	/* going read-only works */
+	ret = mount(NULL, self->mnt, NULL, MS_REMOUNT | MS_RDONLY, NULL);
+	ASSERT_EQ(ret, 0) TH_LOG("remount read-only: %s", strerror(errno));
+	ASSERT_TRUE(super_rdonly(self->mnt));
+	ASSERT_TRUE(mount_option(self->mnt, variant->state));
+
+	/* without writing anything */
+	w1 = written(self->loop);
+	ASSERT_EQ(w1, w0) TH_LOG("%lld sectors written by the remounts", w1 - w0);
+
+	/* going back to read-write doesn't */
+	ret = mount(NULL, self->mnt, NULL, MS_REMOUNT, NULL);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EROFS);
+	ASSERT_TRUE(super_rdonly(self->mnt));
+
+	ASSERT_EQ(umount(self->mnt), 0);
+	self->mounted = false;
+}
+
+TEST_HARNESS_MAIN

-- 
2.53.0

