Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793290165;
	b=GIhjhdQA/ZP9TD+KrUWJPQ3+/Gb2xP0QnUVOWVX5APlbnIFKOKDhXzk+gs81EmvBsH2H
	 vgdOSSyJpVS0Tlx02UwT2s/35DPZSP0TnSMSg3YPB44s3ytz8u+IZDCX5ZKAbcU9RjE6Z
	 3tI2yRy06idr2YgSI1/2of1JNTsobQyNgFsImF3bX8C0mQruAvDuxiIwfd0IB7h2NKysf
	 l7p3XPbLVTHoA6dJOOrkn83v6EzbpNpK6BQBlDTsZLIO6YhOAsoZS8MdYwjBzO2ipVHM3
	 hkMj05xXDnplPvd040c4kVsxbb/6YZ0EEDy9ue4L1PWXaKCjwZUjmDHo2MEjEzTNSfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793290165;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=UvRjOpAqBKVGIWsRJRWXKmdNPonoHXR1Byt9ZMUIO6s=;
	b=zALYJ0Q/Dry5o7G3ZsRdaVWEmjRFdtJCRATCyC8KlAy2L0wlcqFN9a+clv9QOvHPuWa+
	 cSJk8dT6jgYz2ptcAWzsuVokp2gg1a4961NZ03vzbESjXcSkQW8lDB9rTRvqB4C5H0FbY
	 Ybi6Yojn9mWwqI6FCs5Mp4KWMfkZ9SFbb8y5mg7SXLxnQnfdFtAUhU2KRU9a8/5DWe0uD
	 VViihoWGOoCqsfz7niL4nNpsfRcnzW4KGEtP2+1B1QYu4yxlLjayXJCAfsiQs+kRXP5Tf
	 RjhQaQ7o43hQFyyPsATZKhCXv5QdIFPZrs52dbW4h1k34W01iG7ySbiA6FzXccsZr4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o28nhjh6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB0A60A6F6B;
	Thu, 29 Oct 2026 16:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o28nhjh6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114E71F01816;
	Thu, 29 Oct 2026 16:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793290164;
	bh=UvRjOpAqBKVGIWsRJRWXKmdNPonoHXR1Byt9ZMUIO6s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=o28nhjh6Rw6VUPt1oxGFuHirpp1CcK0mdYDgEczHpIKghFTpak5Dw3Zvt6tAe3I6N
	 V11P7LQFU19lu/1bd+I0SyTIag5Zwo65i9HNQsffDpu7iSzY897Mfdl09X7qQ0tGys
	 qG0xJeI4jbncni5/mG41oRi89tAd4+St1LlHOy/9xeYRMIGeAmHPOUQz3eMNqYrcyG
	 EIYPjWKvo7yhRsAD4bB2n0UMmEjm+f3Hks+5IzJu9ubt/FC+JHIptAd02wt/4UY0dV
	 uCL6+qGqzHVZD0UpSRseukYa0jm4GlCbvxr+3/1WpQS0IrqYpDG0eCJfeaywQohvfs
	 vQPfqW7xecUJg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 29 Oct 2026 17:07:20 +0100
Subject: [PATCH v2 29/34] selftests/filesystems: test filesystem errors
 while frozen
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
Message-Id: <20261029-work-fs-sb_rdonly-v2-29-2f44f64f0b66@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=28969; i=brauner@kernel.org;
 h=from:subject:message-id; bh=cei66jsxbGRtO1IMNg52s9zqVNkslLobwjFBvWuffis=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ9zjeomC/i/e69oaD3HqYVMvKSocztN6UvTXf5bVF0P
 jnN4e/njlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIkc8Wf4HygxZ37nJeMPN1jU
 ijyypRrrmJrnPPqyzash7OU7Xt0JHQz/vTecPfGCn9lg+Uxpiy9ZSo1cOwU/7u6LsN0Uw+BhNrW
 IHwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

Add tests for filesystems that hit an error while they are frozen:

- ext2, jfs and nilfs2: look up a file in a corrupted directory while
  frozen and thaw
- the superblock shows "ro", statfs() reports ST_RDONLY and statmount()
  SB_RDONLY
- create, write, chmod, mkdir, rename, unlink, truncate and write opens
  fail with EROFS instead of blocking, also after another freeze
- remounting read-only works, read-write fails with EROFS
- remount read-only and umount after a write, fsync fails with EROFS
- gfs2: withdraw while frozen and thaw, writes fail instead of blocking
  and freezing a withdrawn gfs2 fails

Everything skips without root, loop devices, the filesystem or its mkfs
tool.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/Makefile                   |   1 +
 .../selftests/filesystems/sb_rdonly/.gitignore     |   3 +
 .../selftests/filesystems/sb_rdonly/Makefile       |   6 +
 .../testing/selftests/filesystems/sb_rdonly/config |   5 +
 .../filesystems/sb_rdonly/emergency_ro_test.c      | 560 +++++++++++++++++++++
 .../filesystems/sb_rdonly/gfs2_withdraw_test.c     | 318 ++++++++++++
 .../selftests/filesystems/sb_rdonly/settings       |   1 +
 7 files changed, 894 insertions(+)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 6c77beba0956..507fecdccda6 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -55,6 +55,7 @@ TARGETS += filesystems/fscontext_ns
 TARGETS += filesystems/xattr
 TARGETS += filesystems/mntns_unbindable
 TARGETS += filesystems/umount_propagation
+TARGETS += filesystems/sb_rdonly
 TARGETS += firmware
 TARGETS += fpu
 TARGETS += ftrace
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/.gitignore b/tools/testing/selftests/filesystems/sb_rdonly/.gitignore
new file mode 100644
index 000000000000..96daf47a494f
--- /dev/null
+++ b/tools/testing/selftests/filesystems/sb_rdonly/.gitignore
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+emergency_ro_test
+gfs2_withdraw_test
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/Makefile b/tools/testing/selftests/filesystems/sb_rdonly/Makefile
new file mode 100644
index 000000000000..89d72fcf8600
--- /dev/null
+++ b/tools/testing/selftests/filesystems/sb_rdonly/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+TEST_GEN_PROGS := emergency_ro_test gfs2_withdraw_test
+
+CFLAGS += -Wall -O2 -g $(KHDR_INCLUDES)
+
+include ../../lib.mk
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/config b/tools/testing/selftests/filesystems/sb_rdonly/config
new file mode 100644
index 000000000000..ab660b588e6d
--- /dev/null
+++ b/tools/testing/selftests/filesystems/sb_rdonly/config
@@ -0,0 +1,5 @@
+CONFIG_BLK_DEV_LOOP=y
+CONFIG_EXT2_FS=y
+CONFIG_GFS2_FS=y
+CONFIG_JFS_FS=y
+CONFIG_NILFS2_FS=y
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/emergency_ro_test.c b/tools/testing/selftests/filesystems/sb_rdonly/emergency_ro_test.c
new file mode 100644
index 000000000000..de442b8ee709
--- /dev/null
+++ b/tools/testing/selftests/filesystems/sb_rdonly/emergency_ro_test.c
@@ -0,0 +1,560 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Filesystems that hit an error while frozen used to set SB_RDONLY and left
+ * thaw_super() with the s_writers rwsems locked. Freeze, read a corrupted
+ * directory, thaw and check that nothing blocks, that modifications fail with
+ * EROFS and that a remount can go read-only but not back to read-write.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/fs.h>
+#include <linux/loop.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/statvfs.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "../../kselftest_harness.h"
+#include "../statmount/statmount.h"
+
+/* ext2 and nilfs2 directory entry names, jfs dtree names must fit 11 chars */
+#define MARKER		"sbrdonlyQ7Zk2Lp9"
+#define MARKER_JFS	"sbrdonlyjfs"
+
+enum layout { LAYOUT_EXT2, LAYOUT_NILFS2, LAYOUT_JFS };
+
+FIXTURE(emergency_ro) {
+	char dir[64];
+	char img[96];
+	char mnt[96];
+	char dev[64];
+	int loop_fd;
+	bool mounted;
+	bool wedged;	/* writers are blocked for good, leave it mounted */
+};
+
+FIXTURE_VARIANT(emergency_ro) {
+	const char *fstype;
+	const char *mkfs;
+	const char *opts;
+	off_t size;
+	enum layout layout;
+};
+
+FIXTURE_VARIANT_ADD(emergency_ro, ext2) {
+	.fstype = "ext2",
+	.mkfs = "mkfs.ext2 -q -F -b 4096",
+	.opts = "errors=remount-ro",
+	.size = 64 << 20,
+	.layout = LAYOUT_EXT2,
+};
+
+FIXTURE_VARIANT_ADD(emergency_ro, jfs) {
+	.fstype = "jfs",
+	.mkfs = "mkfs.jfs -q",
+	.opts = "errors=remount-ro",
+	.size = 256 << 20,
+	.layout = LAYOUT_JFS,
+};
+
+FIXTURE_VARIANT_ADD(emergency_ro, nilfs2) {
+	.fstype = "nilfs2",
+	.mkfs = "mkfs.nilfs2 -q -f",
+	.opts = "errors=remount-ro",
+	.size = 512 << 20,
+	.layout = LAYOUT_NILFS2,
+};
+
+static const char *at(const char *mnt, const char *rel)
+{
+	static char buf[4][PATH_MAX];
+	static unsigned int next;
+	char *p = buf[next++ % 4];
+
+	snprintf(p, PATH_MAX, "%s/%s", mnt, rel);
+	return p;
+}
+
+static bool have_fs(const char *fstype)
+{
+	char line[128], cmd[128];
+	bool found = false;
+	FILE *f;
+
+	for (int tries = 0; tries < 2 && !found; tries++) {
+		f = fopen("/proc/filesystems", "r");
+		if (!f)
+			return false;
+		while (fgets(line, sizeof(line), f)) {
+			char *name = strrchr(line, '\t');
+
+			name = name ? name + 1 : line;
+			name[strcspn(name, "\n")] = '\0';
+			if (!strcmp(name, fstype))
+				found = true;
+		}
+		fclose(f);
+		if (!found) {
+			snprintf(cmd, sizeof(cmd), "modprobe -q %s", fstype);
+			if (system(cmd))
+				break;
+		}
+	}
+	return found;
+}
+
+/*
+ * With CONFIG_EXT4_USE_FOR_EXT2 ext4 serves "ext2" with its own emergency
+ * state. Real ext2 doesn't register /sys/fs/ext4 or /proc/fs/ext4.
+ */
+static bool served_by_ext4(const char *dev)
+{
+	const char *name = strrchr(dev, '/') + 1;
+	char path[128];
+
+	snprintf(path, sizeof(path), "/sys/fs/ext4/%s", name);
+	if (!access(path, F_OK))
+		return true;
+	snprintf(path, sizeof(path), "/proc/fs/ext4/%s", name);
+	return !access(path, F_OK);
+}
+
+static bool have_tool(const char *mkfs)
+{
+	char cmd[128];
+	int len = strcspn(mkfs, " ");
+
+	snprintf(cmd, sizeof(cmd), "command -v %.*s >/dev/null 2>&1", len, mkfs);
+	return system(cmd) == 0;
+}
+
+static int write_file(const char *path, const char *data)
+{
+	int fd = open(path, O_CREAT | O_WRONLY | O_TRUNC, 0644);
+	ssize_t len = strlen(data);
+
+	if (fd < 0)
+		return -1;
+	if (write(fd, data, len) != len || fsync(fd)) {
+		close(fd);
+		return -1;
+	}
+	return close(fd);
+}
+
+static uint16_t le16(const unsigned char *p) { return p[0] | p[1] << 8; }
+static uint32_t le32(const unsigned char *p) { return le16(p) | (uint32_t)le16(p + 2) << 16; }
+static uint64_t le64(const unsigned char *p) { return le32(p) | (uint64_t)le32(p + 4) << 32; }
+
+/*
+ * Corrupt the entry of the marker file in directory d, found by searching the
+ * device for its name. ext2 and nilfs2: rec_len := 0 (2 bytes before the
+ * name_len byte). jfs: the entry sits in the dtree root inside d's dinode at
+ * offset 224 (32 byte slots, the name at +6), freecnt := -128. Returns the
+ * number of corrupted entries.
+ */
+static int corrupt(int fd, enum layout layout, ino_t dir_ino, ino_t mark_ino)
+{
+	const size_t chunk = 1 << 22, overlap = 4096;
+	unsigned char *buf, pat[2 * sizeof(MARKER)];
+	size_t patlen = 0;
+	off_t size, off;
+	int hits = 0;
+
+	if (layout == LAYOUT_JFS) {
+		for (const char *m = MARKER_JFS; *m; m++) {
+			pat[patlen++] = *m;
+			pat[patlen++] = 0;	/* UCS-2 little endian */
+		}
+	} else {
+		patlen = strlen(MARKER);
+		memcpy(pat, MARKER, patlen);
+	}
+
+	/* drop cached blocks, nilfs2 writes its logs around the page cache */
+	if (ioctl(fd, BLKFLSBUF, 0))
+		return -1;
+	buf = malloc(chunk + overlap);
+	if (!buf)
+		return -1;
+	size = lseek(fd, 0, SEEK_END);
+	for (off = 0; off < size; off += chunk) {
+		off_t base = off >= (off_t)overlap ? off - overlap : 0;
+		ssize_t n = pread(fd, buf, chunk + (off - base), base);
+
+		if (n <= 0)
+			break;
+		for (size_t i = off - base; i + patlen <= (size_t)n; i++) {
+			unsigned char *p = buf + i, zero[2] = { 0, 0 };
+			off_t pos = base + i;
+
+			if (memcmp(p, pat, patlen))
+				continue;
+
+			if (layout == LAYOUT_EXT2) {
+				if (i < 8 || le32(p - 8) != mark_ino || p[-2] != patlen)
+					continue;
+				if (pwrite(fd, zero, 2, pos - 4) != 2)
+					goto out;
+				hits++;
+			} else if (layout == LAYOUT_NILFS2) {
+				if (i < 12 || le64(p - 12) != mark_ino || p[-2] != patlen)
+					continue;
+				if (pwrite(fd, zero, 2, pos - 4) != 2)
+					goto out;
+				hits++;
+			} else {
+				off_t entry = pos - 6, dino, slot;
+				unsigned char d[512], bad = 0x80;
+
+				if (i < 6 || le32(p - 6) != mark_ino ||
+				    p[-1] != strlen(MARKER_JFS))
+					continue;
+				slot = ((entry - 224) % 512) / 32;
+				if ((entry - 224) % 32 || slot < 1 || slot > 8)
+					continue;
+				dino = entry - 224 - 32 * slot;
+				if (pread(fd, d, sizeof(d), dino) != sizeof(d))
+					goto out;
+				/* di_fileset is FILESYSTEM_I, di_number is d */
+				if (le32(d + 4) != 16 || le32(d + 8) != dir_ino)
+					continue;
+				if (pwrite(fd, &bad, 1, dino + 224 + 18) != 1)
+					goto out;
+				hits++;
+			}
+		}
+	}
+out:
+	free(buf);
+	if (fsync(fd))
+		return -1;
+	return hits;
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
+/* statmount() has to agree with the superblock options in mountinfo. */
+static bool statmount_rdonly(int fd)
+{
+	struct statmount sm;
+
+	if (statmount(0, 0, fd, STATMOUNT_SB_BASIC, &sm, sizeof(sm),
+		      STATMOUNT_BY_FD))
+		return false;
+	return sm.sb_flags & MS_RDONLY;
+}
+
+/* Run fn() in a child, it must neither block on s_writers nor fail. */
+static int run_child(int (*fn)(const char *, int), const char *mnt, int prefd)
+{
+	int status, fd;
+	pid_t pid;
+
+	pid = fork();
+	if (pid < 0)
+		return -1;
+	if (!pid) {
+		/* a child stuck in sb_start_write() mustn't hold the runner's pipe */
+		fd = open("/dev/null", O_RDWR);
+		if (fd >= 0) {
+			dup2(fd, 0);
+			dup2(fd, 1);
+			dup2(fd, 2);
+		}
+		_exit(fn(mnt, prefd));
+	}
+
+	for (int i = 0; i < 100; i++) {
+		if (waitpid(pid, &status, WNOHANG) == pid)
+			return WIFEXITED(status) ? WEXITSTATUS(status) : 255;
+		usleep(100000);
+	}
+	/* stuck in sb_start_write(), cannot be killed */
+	return -ETIMEDOUT;
+}
+
+/* Every modification fails with EROFS, returns the number of mismatches. */
+static int modify_all(const char *mnt, int prefd)
+{
+	int bad = 0, fd;
+
+	fd = open(at(mnt, "w/new"), O_CREAT | O_WRONLY, 0644);
+	bad += !(fd < 0 && errno == EROFS);
+	bad += !(pwrite(prefd, "x", 1, 0) < 0 && errno == EROFS);
+	bad += !(chmod(at(mnt, "f"), 0600) && errno == EROFS);
+	bad += !(mkdir(at(mnt, "w/dir"), 0755) && errno == EROFS);
+	bad += !(rename(at(mnt, "f"), at(mnt, "w/f")) && errno == EROFS);
+	bad += !(unlink(at(mnt, "f")) && errno == EROFS);
+	bad += !(truncate(at(mnt, "f"), 0) && errno == EROFS);
+	fd = open(at(mnt, "f"), O_WRONLY);
+	bad += !(fd < 0 && errno == EROFS);
+	return bad;
+}
+
+FIXTURE_SETUP(emergency_ro)
+{
+	struct loop_config cfg = { .info.lo_flags = LO_FLAGS_AUTOCLEAR };
+	int ctl, nr, img_fd;
+	char cmd[256];
+
+	self->loop_fd = -1;
+	self->mounted = false;
+	self->wedged = false;
+	self->dir[0] = '\0';
+
+	if (geteuid())
+		SKIP(return, "needs root");
+	if (!have_fs(variant->fstype))
+		SKIP(return, "no %s support", variant->fstype);
+	if (!have_tool(variant->mkfs))
+		SKIP(return, "no %.*s", (int)strcspn(variant->mkfs, " "), variant->mkfs);
+	ctl = open("/dev/loop-control", O_RDWR | O_CLOEXEC);
+	if (ctl < 0)
+		SKIP(return, "no loop devices");
+
+	strcpy(self->dir, "/tmp/sb_rdonly_XXXXXX");
+	ASSERT_NE(mkdtemp(self->dir), NULL);
+	snprintf(self->img, sizeof(self->img), "%s/img", self->dir);
+	snprintf(self->mnt, sizeof(self->mnt), "%s/mnt", self->dir);
+	ASSERT_EQ(mkdir(self->mnt, 0755), 0);
+
+	img_fd = open(self->img, O_CREAT | O_RDWR, 0600);
+	ASSERT_GE(img_fd, 0);
+	ASSERT_EQ(ftruncate(img_fd, variant->size), 0);
+	cfg.fd = img_fd;
+	/* another user can grab the free device first */
+	for (int tries = 0;; tries++) {
+		nr = ioctl(ctl, LOOP_CTL_GET_FREE);
+		ASSERT_GE(nr, 0);
+		snprintf(self->dev, sizeof(self->dev), "/dev/loop%d", nr);
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
+	close(img_fd);
+
+	snprintf(cmd, sizeof(cmd), "%s %s >/dev/null 2>&1", variant->mkfs, self->dev);
+	ASSERT_EQ(system(cmd), 0);
+}
+
+FIXTURE_TEARDOWN(emergency_ro)
+{
+	if (self->mounted) {
+		if (self->wedged)
+			TH_LOG("leaving %s mounted, its writers are blocked", self->mnt);
+		else if (umount2(self->mnt, MNT_DETACH))
+			TH_LOG("umount %s: %s", self->mnt, strerror(errno));
+		else
+			self->mounted = false;
+	}
+	if (self->loop_fd >= 0)
+		close(self->loop_fd);	/* LO_FLAGS_AUTOCLEAR detaches it */
+	if (!self->dir[0])
+		return;
+	unlink(self->img);
+	if (!self->mounted) {
+		rmdir(self->mnt);
+		rmdir(self->dir);
+	}
+}
+
+static const char *marker(const FIXTURE_VARIANT(emergency_ro) *variant)
+{
+	return variant->layout == LAYOUT_JFS ? "d/" MARKER_JFS : "d/" MARKER;
+}
+
+/* Populate, corrupt the marker entry offline and mount again. */
+static bool prepare(struct __test_metadata *_metadata,
+		    FIXTURE_DATA(emergency_ro) *self,
+		    const FIXTURE_VARIANT(emergency_ro) *variant)
+{
+	const char *opts = variant->opts;
+	const char *mark = marker(variant);
+	struct stat st;
+	ino_t dir_ino, mark_ino;
+	int ret;
+
+	ASSERT_EQ(mount(self->dev, self->mnt, variant->fstype, 0, opts), 0);
+	self->mounted = true;
+	if (variant->layout == LAYOUT_EXT2 && served_by_ext4(self->dev))
+		return false;
+	ASSERT_EQ(mkdir(at(self->mnt, "d"), 0755), 0);
+	ASSERT_EQ(mkdir(at(self->mnt, "w"), 0755), 0);
+	ASSERT_EQ(write_file(at(self->mnt, mark), "marker\n"), 0);
+	ASSERT_EQ(write_file(at(self->mnt, "f"), "data\n"), 0);
+	sync();
+	/* nilfs2 only checksums the last log at mount, keep d's block out of it */
+	ASSERT_EQ(write_file(at(self->mnt, "z"), "later\n"), 0);
+	sync();
+	ASSERT_EQ(stat(at(self->mnt, "d"), &st), 0);
+	dir_ino = st.st_ino;
+	ASSERT_EQ(stat(at(self->mnt, mark), &st), 0);
+	mark_ino = st.st_ino;
+	ASSERT_EQ(umount(self->mnt), 0);
+	self->mounted = false;
+
+	ret = corrupt(self->loop_fd, variant->layout, dir_ino, mark_ino);
+	ASSERT_GE(ret, 1) {
+		TH_LOG("marker entry not found on %s", self->dev);
+	}
+
+	ASSERT_EQ(mount(self->dev, self->mnt, variant->fstype, 0, opts), 0);
+	self->mounted = true;
+	return true;
+}
+
+TEST_F_TIMEOUT(emergency_ro, freeze_error_thaw, 120)
+{
+	const char *opts = variant->opts;
+	const char *mark = marker(variant);
+	struct statvfs sv;
+	struct stat st;
+	int prefd, rootfd, ret;
+
+	if (!prepare(_metadata, self, variant))
+		SKIP(return, "ext2 is served by ext4 (CONFIG_EXT4_USE_FOR_EXT2)");
+
+	prefd = open(at(self->mnt, "f"), O_RDWR);
+	ASSERT_GE(prefd, 0);
+	rootfd = open(self->mnt, O_RDONLY | O_DIRECTORY);
+	ASSERT_GE(rootfd, 0);
+	ASSERT_FALSE(statmount_rdonly(rootfd));
+
+	ASSERT_EQ(ioctl(rootfd, FIFREEZE, 0), 0);
+	/* reads still go to the device and find the corruption */
+	ret = stat(at(self->mnt, mark), &st);
+	EXPECT_EQ(ret, -1);
+	EXPECT_EQ(errno, EIO);
+	ASSERT_EQ(ioctl(rootfd, FITHAW, 0), 0);
+
+	/* the error made it read-only for the VFS, SB_RDONLY stays clear */
+	ASSERT_EQ(statvfs(self->mnt, &sv), 0);
+	ASSERT_TRUE(!!(sv.f_flag & ST_RDONLY));
+	ASSERT_TRUE(super_rdonly(self->mnt));
+	ASSERT_TRUE(statmount_rdonly(rootfd));
+
+	ret = run_child(modify_all, self->mnt, prefd);
+	if (ret == -ETIMEDOUT)
+		self->wedged = true;
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("%s", ret == -ETIMEDOUT ? "a writer is blocked after thaw" :
+			"a modification did not fail with EROFS");
+	}
+
+	/* freezing still works and doesn't leave writers blocked */
+	ASSERT_EQ(ioctl(rootfd, FIFREEZE, 0), 0);
+	ASSERT_EQ(ioctl(rootfd, FITHAW, 0), 0);
+	ret = run_child(modify_all, self->mnt, prefd);
+	if (ret == -ETIMEDOUT)
+		self->wedged = true;
+	ASSERT_EQ(ret, 0);
+
+	/* remount keeps refusing, read-only works, read-write doesn't */
+	close(prefd);
+	ASSERT_EQ(mount(NULL, self->mnt, NULL, MS_REMOUNT, opts), 0);
+	EXPECT_TRUE(super_rdonly(self->mnt));
+	ret = open(at(self->mnt, "w/new2"), O_CREAT | O_WRONLY, 0644);
+	EXPECT_EQ(ret, -1);
+	EXPECT_EQ(errno, EROFS);
+	ASSERT_EQ(mount(NULL, self->mnt, NULL, MS_REMOUNT | MS_RDONLY, opts), 0);
+	EXPECT_TRUE(super_rdonly(self->mnt));
+	ret = mount(NULL, self->mnt, NULL, MS_REMOUNT, opts);
+	EXPECT_EQ(ret, -1);
+	EXPECT_EQ(errno, EROFS);
+
+	close(rootfd);
+	ASSERT_EQ(umount(self->mnt), 0);
+	self->mounted = false;
+}
+
+/* Allocate blocks without syncing them, then hit the error. */
+static int write_then_error(struct __test_metadata *_metadata,
+			    FIXTURE_DATA(emergency_ro) *self,
+			    const FIXTURE_VARIANT(emergency_ro) *variant)
+{
+	static char buf[64 << 10];
+	struct stat st;
+	int fd;
+
+	memset(buf, 'x', sizeof(buf));
+	fd = open(at(self->mnt, "g"), O_CREAT | O_RDWR, 0644);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(write(fd, buf, sizeof(buf)), (ssize_t)sizeof(buf));
+	EXPECT_EQ(stat(at(self->mnt, marker(variant)), &st), -1);
+	ASSERT_TRUE(super_rdonly(self->mnt));
+	return fd;
+}
+
+/* jfs BUG()ed on uncommitted tlocks when umount followed a remount,ro */
+TEST_F_TIMEOUT(emergency_ro, error_remount_ro, 120)
+{
+	if (!prepare(_metadata, self, variant))
+		SKIP(return, "ext2 is served by ext4 (CONFIG_EXT4_USE_FOR_EXT2)");
+
+	close(write_then_error(_metadata, self, variant));
+	ASSERT_EQ(mount(NULL, self->mnt, NULL, MS_REMOUNT | MS_RDONLY,
+			variant->opts), 0);
+	EXPECT_TRUE(super_rdonly(self->mnt));
+	ASSERT_EQ(umount(self->mnt), 0);
+	self->mounted = false;
+}
+
+/* fsync() mustn't claim an inode is on disk that writeback refused */
+TEST_F_TIMEOUT(emergency_ro, error_fsync, 120)
+{
+	int fd, ret;
+
+	if (!prepare(_metadata, self, variant))
+		SKIP(return, "ext2 is served by ext4 (CONFIG_EXT4_USE_FOR_EXT2)");
+
+	fd = write_then_error(_metadata, self, variant);
+	sync();
+	ret = fsync(fd);
+	EXPECT_EQ(ret, -1);
+	EXPECT_EQ(errno, EROFS);
+	close(fd);
+	ASSERT_EQ(umount(self->mnt), 0);
+	self->mounted = false;
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/gfs2_withdraw_test.c b/tools/testing/selftests/filesystems/sb_rdonly/gfs2_withdraw_test.c
new file mode 100644
index 000000000000..1b946cac37e8
--- /dev/null
+++ b/tools/testing/selftests/filesystems/sb_rdonly/gfs2_withdraw_test.c
@@ -0,0 +1,318 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * gfs2 used to set SB_RDONLY on withdraw. Withdrawn while frozen it couldn't
+ * be thawed and once it was the s_writers rwsems stayed locked. Freeze a
+ * lock_nolock gfs2, withdraw it through sysfs, thaw it and check that writers
+ * fail instead of blocking. Paths stop working after the withdraw so all of
+ * it goes through file descriptors opened before.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/fs.h>
+#include <linux/loop.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/statvfs.h>
+#include <sys/sysmacros.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <dirent.h>
+#include <unistd.h>
+
+#include "../../kselftest_harness.h"
+
+FIXTURE(gfs2) {
+	char dir[64];
+	char img[96];
+	char mnt[96];
+	char dev[64];
+	char table[32];
+	char sysfs[PATH_MAX];
+	int loop_fd;
+	bool mounted;
+	bool wedged;	/* frozen or writers blocked for good, leave it mounted */
+};
+
+static bool have_fs(const char *fstype)
+{
+	char line[128], cmd[128];
+	bool found = false;
+	FILE *f;
+
+	for (int tries = 0; tries < 2 && !found; tries++) {
+		f = fopen("/proc/filesystems", "r");
+		if (!f)
+			return false;
+		while (fgets(line, sizeof(line), f)) {
+			char *name = strrchr(line, '\t');
+
+			name = name ? name + 1 : line;
+			name[strcspn(name, "\n")] = '\0';
+			if (!strcmp(name, fstype))
+				found = true;
+		}
+		fclose(f);
+		if (!found) {
+			snprintf(cmd, sizeof(cmd), "modprobe -q %s", fstype);
+			if (system(cmd))
+				break;
+		}
+	}
+	return found;
+}
+
+/* gfs2 shows the withdraw in sysfs, not in the mount options. */
+static bool withdrawn(FIXTURE_DATA(gfs2) *self)
+{
+	char path[PATH_MAX + 16], buf[8] = "";
+	FILE *f;
+
+	snprintf(path, sizeof(path), "%s/withdraw", self->sysfs);
+	f = fopen(path, "r");
+	if (!f)
+		return false;
+	if (!fgets(buf, sizeof(buf), f))
+		buf[0] = '\0';
+	fclose(f);
+	return buf[0] == '1';
+}
+
+/* Find the gfs2 sysfs directory of the mounted filesystem by its device. */
+static int find_sysfs(FIXTURE_DATA(gfs2) *self, char *dir, size_t len)
+{
+	char path[PATH_MAX], want[32], have[32];
+	struct dirent *d;
+	struct stat st;
+	int ret = -1;
+	DIR *sys;
+	FILE *f;
+
+	if (stat(self->mnt, &st))
+		return -1;
+	snprintf(want, sizeof(want), "%u:%u\n", major(st.st_dev), minor(st.st_dev));
+	sys = opendir("/sys/fs/gfs2");
+	if (!sys)
+		return -1;
+	while ((d = readdir(sys))) {
+		if (d->d_name[0] == '.')
+			continue;
+		snprintf(path, sizeof(path), "/sys/fs/gfs2/%s/id", d->d_name);
+		f = fopen(path, "r");
+		if (!f)
+			continue;
+		if (fgets(have, sizeof(have), f) && !strcmp(have, want)) {
+			snprintf(dir, len, "/sys/fs/gfs2/%s", d->d_name);
+			ret = 0;
+		}
+		fclose(f);
+		if (!ret)
+			break;
+	}
+	closedir(sys);
+	return ret;
+}
+
+static int withdraw(FIXTURE_DATA(gfs2) *self)
+{
+	char path[PATH_MAX + 16];
+	int fd, ret;
+
+	/* paths on the filesystem stop working after the withdraw */
+	if (find_sysfs(self, self->sysfs, sizeof(self->sysfs)))
+		return -1;
+	snprintf(path, sizeof(path), "%s/withdraw", self->sysfs);
+	fd = open(path, O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return -1;
+	ret = write(fd, "1", 1) == 1 ? 0 : -1;
+	close(fd);
+	/* do_withdraw() runs from a work item and waits up to 5s for the log */
+	sleep(8);
+	return ret;
+}
+
+/* Writes through fd must fail, not block on s_writers. */
+static int modify_fd(int fd)
+{
+	int bad = 0;
+
+	bad += !(pwrite(fd, "x", 1, 0) < 0);
+	bad += !(fchmod(fd, 0600) < 0);
+	bad += !(ftruncate(fd, 0) < 0);
+	return bad;
+}
+
+/* Run modify_fd() in a child: 0, the number of mismatches or -ETIMEDOUT. */
+static int run_child(int fd)
+{
+	int status, null;
+	pid_t pid;
+
+	pid = fork();
+	if (pid < 0)
+		return -1;
+	if (!pid) {
+		/* a child stuck in sb_start_write() mustn't hold the runner's pipe */
+		null = open("/dev/null", O_RDWR);
+		if (null >= 0) {
+			dup2(null, 0);
+			dup2(null, 1);
+			dup2(null, 2);
+		}
+		_exit(modify_fd(fd));
+	}
+
+	for (int i = 0; i < 100; i++) {
+		if (waitpid(pid, &status, WNOHANG) == pid)
+			return WIFEXITED(status) ? WEXITSTATUS(status) : 255;
+		usleep(100000);
+	}
+	/* stuck in sb_start_write(), cannot be killed */
+	return -ETIMEDOUT;
+}
+
+FIXTURE_SETUP(gfs2)
+{
+	struct loop_config cfg = { .info.lo_flags = LO_FLAGS_AUTOCLEAR };
+	int ctl, nr, img_fd;
+	char cmd[384];
+
+	self->loop_fd = -1;
+	self->mounted = false;
+	self->wedged = false;
+	self->dir[0] = '\0';
+	self->sysfs[0] = '\0';
+
+	if (geteuid())
+		SKIP(return, "needs root");
+	if (!have_fs("gfs2"))
+		SKIP(return, "no gfs2 support");
+	if (system("command -v mkfs.gfs2 >/dev/null 2>&1"))
+		SKIP(return, "no mkfs.gfs2");
+	ctl = open("/dev/loop-control", O_RDWR | O_CLOEXEC);
+	if (ctl < 0)
+		SKIP(return, "no loop devices");
+
+	strcpy(self->dir, "/tmp/sb_rdonly_XXXXXX");
+	ASSERT_NE(mkdtemp(self->dir), NULL);
+	snprintf(self->img, sizeof(self->img), "%s/img", self->dir);
+	snprintf(self->mnt, sizeof(self->mnt), "%s/mnt", self->dir);
+	/* the lock table names the sysfs directory, keep it unique */
+	snprintf(self->table, sizeof(self->table), "sbrdonly:t%d", getpid() % 100000);
+	ASSERT_EQ(mkdir(self->mnt, 0755), 0);
+
+	img_fd = open(self->img, O_CREAT | O_RDWR, 0600);
+	ASSERT_GE(img_fd, 0);
+	ASSERT_EQ(ftruncate(img_fd, 256 << 20), 0);
+	cfg.fd = img_fd;
+	/* another user can grab the free device first */
+	for (int tries = 0;; tries++) {
+		nr = ioctl(ctl, LOOP_CTL_GET_FREE);
+		ASSERT_GE(nr, 0);
+		snprintf(self->dev, sizeof(self->dev), "/dev/loop%d", nr);
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
+	close(img_fd);
+
+	snprintf(cmd, sizeof(cmd),
+		 "mkfs.gfs2 -O -p lock_nolock -j 1 -t %s %s >/dev/null 2>&1",
+		 self->table, self->dev);
+	ASSERT_EQ(system(cmd), 0);
+}
+
+FIXTURE_TEARDOWN(gfs2)
+{
+	if (self->mounted) {
+		if (self->wedged)
+			TH_LOG("leaving %s mounted, it is frozen or its writers are blocked",
+			       self->mnt);
+		else if (umount2(self->mnt, MNT_DETACH))
+			TH_LOG("umount %s: %s", self->mnt, strerror(errno));
+		else
+			self->mounted = false;
+	}
+	if (self->loop_fd >= 0)
+		close(self->loop_fd);	/* LO_FLAGS_AUTOCLEAR detaches it */
+	if (!self->dir[0])
+		return;
+	unlink(self->img);
+	if (!self->mounted) {
+		rmdir(self->mnt);
+		rmdir(self->dir);
+	}
+}
+
+TEST_F_TIMEOUT(gfs2, withdraw_while_frozen, 120)
+{
+	struct statvfs sv;
+	char path[PATH_MAX];
+	int fd, prefd, rootfd, ret;
+
+	ASSERT_EQ(mount(self->dev, self->mnt, "gfs2", 0, NULL), 0);
+	self->mounted = true;
+	snprintf(path, sizeof(path), "%s/f", self->mnt);
+	fd = open(path, O_CREAT | O_WRONLY, 0644);
+	ASSERT_GE(fd, 0);
+	ASSERT_EQ(write(fd, "data\n", 5), 5);
+	ASSERT_EQ(fsync(fd), 0);
+	close(fd);
+	prefd = open(path, O_RDWR);
+	ASSERT_GE(prefd, 0);
+	rootfd = open(self->mnt, O_RDONLY | O_DIRECTORY);
+	ASSERT_GE(rootfd, 0);
+
+	ASSERT_EQ(ioctl(rootfd, FIFREEZE, 0), 0);
+	ret = withdraw(self);
+	if (ret)
+		ioctl(rootfd, FITHAW, 0);
+	ASSERT_EQ(ret, 0);
+	EXPECT_TRUE(withdrawn(self));
+
+	ret = ioctl(rootfd, FITHAW, 0);
+	if (ret)
+		self->wedged = true;
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("FITHAW: %s, a withdrawn gfs2 stays frozen", strerror(errno));
+	}
+	ASSERT_EQ(fstatvfs(rootfd, &sv), 0);
+	ASSERT_FALSE(!!(sv.f_flag & ST_RDONLY)) {
+		TH_LOG("the withdraw set SB_RDONLY on the frozen filesystem");
+	}
+
+	ret = run_child(prefd);
+	if (ret == -ETIMEDOUT)
+		self->wedged = true;
+	ASSERT_EQ(ret, 0) {
+		TH_LOG("%s", ret == -ETIMEDOUT ? "a writer is blocked after thaw" :
+			"a modification did not fail");
+	}
+
+	/* freezing a withdrawn filesystem fails and leaves it thawed */
+	EXPECT_NE(ioctl(rootfd, FIFREEZE, 0), 0);
+	ret = run_child(prefd);
+	if (ret == -ETIMEDOUT)
+		self->wedged = true;
+	ASSERT_EQ(ret, 0);
+
+	close(prefd);
+	close(rootfd);
+	ASSERT_EQ(umount(self->mnt), 0);
+	self->mounted = false;
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/filesystems/sb_rdonly/settings b/tools/testing/selftests/filesystems/sb_rdonly/settings
new file mode 100644
index 000000000000..694d70710ff0
--- /dev/null
+++ b/tools/testing/selftests/filesystems/sb_rdonly/settings
@@ -0,0 +1 @@
+timeout=300

-- 
2.53.0

