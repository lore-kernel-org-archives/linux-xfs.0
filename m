Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C3B43E483;
	Tue, 16 Jun 2026 14:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618984; cv=none; b=StyUJlw7gaR83Sci/L/zyx61lw/QrnP2YaBnoSxXWAGIPkIB+k8HFIJF0nd2gMp8UxaCL7XhDQT5irgdI6Q8GS6Tpd3t5cWiOXIQX0v0iEjFtFxqJTKTbiN2Qt4YYlUayQ+pn9w6ztnZuzkOr79SUKWYFhIq5qMDVUiBnEQKEAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618984; c=relaxed/simple;
	bh=bUlyKlQEIDC+ooT/76BgARuSUwExW7lF9qoA1/7mnKE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IUgQm01Eo1cZQ8wDLw6PfNPc3cgDRP1gukSm4TFtdo5YjzX0xWcXeIz0Y5QgLSvM5T74QRg8BkC+dVk8iYI2gZCvmJRBnEy4KI7YcE0/dOpdeKFI5P2cvnfzGm/1kP6iufDvI/j4LtVFlmm4GAasMCQy3xIImR47mn46zKbwE/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R21HKyqx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R21HKyqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9211F00A3A;
	Tue, 16 Jun 2026 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618983;
	bh=Hnq/c353kAl87K4UdosPy5fyXTR7Sb7grea3tPyWRUA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=R21HKyqxQoOZhA2o4e8Ui3qqOoyIvR6UeBMnGed1KoIxsSk9kuVanj/nlHQdx8b1R
	 d9hC2PNyq23gQ7m1OET2m+OP1czV0VcrLqbTsBU2dU3lB58F7gAijoS+VM/OPn1+Y7
	 L61fiOEF2HAX1Mf/zO+YiV6T0CGZCaAPb1bMwa1AnyKgy12PndI/3ArwKBnOMwJX+J
	 +sKr47XJPwiCPHNdU6aKrjIkmtS6d59LtZwlHObyGlkltD/QSGakUXWJLJgu3ZFfdR
	 LUvJsypOhZJO2mVBbrVXxYYUfAV1Xa+mugkFBTisvbFA/jBr4aqfHiaLeeEsoFqyA0
	 7fmERGvfrVh9A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 16 Jun 2026 16:08:34 +0200
Subject: [PATCH RFC v2 18/18] selftests/filesystems: add ustat() coverage
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260616-work-super-bdev_holder_global-v2-18-7df6b864028e@kernel.org>
References: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
In-Reply-To: <20260616-work-super-bdev_holder_global-v2-0-7df6b864028e@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
 linux-btrfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, 
 linux-ext4@vger.kernel.org, Gao Xiang <xiang@kernel.org>, 
 linux-erofs@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5547; i=brauner@kernel.org;
 h=from:subject:message-id; bh=bUlyKlQEIDC+ooT/76BgARuSUwExW7lF9qoA1/7mnKE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZRtzfK1ZzQHF6Ea/OxbsPdnn99+/5bZNZsqgyzufif
 //F2otMO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZSOJ/hn8qOO9xX9T/82FOR
 3X/k0iGbc+cunZHN8vV7YfA6Imii9j+G/16KaryOfFZzjERaNKvfPX8csFno4Y3nAcebtCq//Nr
 wnwsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

user_get_super() is now backed by the global device-to-superblock table
instead of a walk of the super_blocks list. ustat(2) is its most direct
user-visible consumer but nothing in the tree exercises it.

Add a small regression test: the device number of a mounted tmpfs (an
anonymous device, registered in the table by sget_fc()) must resolve,
it must stop resolving after the unmount (the entry is dropped again in
kill_super_notify()), and bogus device numbers keep reporting EINVAL.

The test passes on kernels before the conversion: it pins down the
semantics the table-backed lookup must preserve.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/filesystems/.gitignore   |   1 +
 tools/testing/selftests/filesystems/Makefile     |   2 +-
 tools/testing/selftests/filesystems/ustat_test.c | 135 +++++++++++++++++++++++
 3 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/filesystems/.gitignore b/tools/testing/selftests/filesystems/.gitignore
index 64ac0dfa46b7..1bd53d54553c 100644
--- a/tools/testing/selftests/filesystems/.gitignore
+++ b/tools/testing/selftests/filesystems/.gitignore
@@ -5,3 +5,4 @@ fclog
 file_stressor
 anon_inode_test
 kernfs_test
+ustat_test
diff --git a/tools/testing/selftests/filesystems/Makefile b/tools/testing/selftests/filesystems/Makefile
index 85427d7f19b9..bbdd40b167fa 100644
--- a/tools/testing/selftests/filesystems/Makefile
+++ b/tools/testing/selftests/filesystems/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 CFLAGS += $(KHDR_INCLUDES)
-TEST_GEN_PROGS := devpts_pts file_stressor anon_inode_test kernfs_test fclog
+TEST_GEN_PROGS := devpts_pts file_stressor anon_inode_test kernfs_test fclog ustat_test
 TEST_GEN_PROGS_EXTENDED := dnotify_test
 
 include ../lib.mk
diff --git a/tools/testing/selftests/filesystems/ustat_test.c b/tools/testing/selftests/filesystems/ustat_test.c
new file mode 100644
index 000000000000..d429fd18d779
--- /dev/null
+++ b/tools/testing/selftests/filesystems/ustat_test.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Test ustat(2): looking up superblocks by device number.
+ *
+ * ustat() resolves a device number to a mounted superblock via
+ * user_get_super(). Check that the device number of a mounted tmpfs (an
+ * anonymous device) resolves, that it stops resolving once the filesystem
+ * is unmounted and that bogus device numbers report EINVAL.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <sched.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+#include <unistd.h>
+
+#include "../kselftest_harness.h"
+
+/* struct ustat is not exported through UAPI, mirror include/linux/types.h. */
+struct ustat_buf {
+	int		f_tfree;
+	unsigned long	f_tinode;
+	char		f_fname[6];
+	char		f_fpack[6];
+	/* slack in case an architecture lays the struct out differently */
+	char		pad[64];
+};
+
+#ifdef __NR_ustat
+
+/*
+ * The kernel decodes @dev with new_decode_dev(), which matches the low 32
+ * bits of the st_dev encoding stat(2) returns for any major below 4096.
+ */
+static int sys_ustat(unsigned int dev, struct ustat_buf *buf)
+{
+	return syscall(__NR_ustat, dev, buf);
+}
+
+static int write_string(const char *path, const char *string)
+{
+	ssize_t len = strlen(string);
+	int fd;
+
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -1;
+	if (write(fd, string, len) != len) {
+		close(fd);
+		return -1;
+	}
+	return close(fd);
+}
+
+/* Enter namespaces in which mounting a tmpfs instance is allowed. */
+static int setup_namespaces(void)
+{
+	uid_t uid = getuid();
+	gid_t gid = getgid();
+	char map[64];
+
+	if (unshare(CLONE_NEWNS | (uid ? CLONE_NEWUSER : 0)))
+		return -1;
+
+	if (uid) {
+		if (write_string("/proc/self/setgroups", "deny"))
+			return -1;
+		snprintf(map, sizeof(map), "0 %d 1", uid);
+		if (write_string("/proc/self/uid_map", map))
+			return -1;
+		snprintf(map, sizeof(map), "0 %d 1", gid);
+		if (write_string("/proc/self/gid_map", map))
+			return -1;
+	}
+
+	return mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL);
+}
+
+TEST(resolves_mounted_superblock)
+{
+	char dir[] = "/tmp/ustat_test.XXXXXX";
+	struct ustat_buf ub;
+	struct stat st;
+
+	ASSERT_NE(NULL, mkdtemp(dir));
+
+	if (setup_namespaces()) {
+		rmdir(dir);
+		SKIP(return, "cannot set up namespaces: %s", strerror(errno));
+	}
+
+	ASSERT_EQ(0, mount("ustat_test", dir, "tmpfs", 0, NULL));
+	ASSERT_EQ(0, stat(dir, &st));
+
+	memset(&ub, 0xff, sizeof(ub));
+	ASSERT_EQ(0, sys_ustat(st.st_dev, &ub))
+		TH_LOG("ustat(%u): %s", (unsigned int)st.st_dev,
+		       strerror(errno));
+
+	ASSERT_EQ(0, umount(dir));
+
+	/* The unmount removed the superblock, the device is gone. */
+	ASSERT_EQ(-1, sys_ustat(st.st_dev, &ub));
+	ASSERT_EQ(EINVAL, errno);
+
+	rmdir(dir);
+}
+
+TEST(bogus_device_numbers)
+{
+	struct ustat_buf ub;
+
+	ASSERT_EQ(-1, sys_ustat(0, &ub));
+	ASSERT_EQ(EINVAL, errno);
+
+	/* major 4095, minor 1048575: nothing plausible lives there */
+	ASSERT_EQ(-1, sys_ustat((0xfffu << 8) | 0xffu | (0xfff00u << 12), &ub));
+	ASSERT_EQ(EINVAL, errno);
+}
+
+#else /* !__NR_ustat */
+
+TEST(unsupported)
+{
+	SKIP(return, "ustat(2) is not available on this architecture");
+}
+
+#endif /* __NR_ustat */
+
+TEST_HARNESS_MAIN

-- 
2.47.3

