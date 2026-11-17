Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926090;
	b=e7l7RiMRDZmkCVrlJruRSWiGwdlSfwnFc4TzUd0HMo2hHzZHEHeHRWdFHcGnepKAN+DH
	 hco2QUbX2xnfF3dDhjThiI91IMELPfzC0rme4tpEkS6f4q25MIzOzKkWfh51Qefjp6HVt
	 DrJ1Tj3LjuswmbhSsxakHW3XDRrI7m5FArVnioI924ILH11uq3dACN0Nmph+i434ok8q8
	 hY3l7+XL6OnTF1jVy+pojTeNa9TnbbsG12jy6FaxHlbrtSQy9uWWInhdGVkapqPGt0Lys
	 4IF/k4J89ARwKihdGG1G6AV7P8hORrwaeorUhcv4vZ5IcP9pME7uRbrbGR81TNcH11Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926090;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=1PBHpMw5lf3mh7+QZWFauX4UCv3KG6JUZqdbELF3lfY=;
	b=qpvuUiQN8ljA5nf8zrWBYC1mAcbQBvedS/UiujK6NUS3popRRoXF8ppE8EBUdm7DfNZe
	 uyvioJuJ4uZ5gRfk5EBbX18aLGdpbdtKr8nYDAdA/jjguiyxCXKiP5sv3ye/dOO+fVa33
	 onYrtXRbMCkZNnRPF2IiLPjG9Kwy8N2VProwBQIYHBLbQbw3T0CsNglClxG1lOI2uA9N1
	 UJ/x/7pEvDH1k0R6RHL6GSmXwO02W2CiBSUKSnQoKxqjqd/Komv6pUpS3g0yxS4NzWFrQ
	 f1wbrLBrFDbFpypxMB7kxaAEKt294m32r+v/hm3c9+wfbXLOf7g1TQJ3F7+pXp8+Agw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=0uJOnk2M;
	arc=none smtp.remote-ip=113.46.200.222
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435D0606A895;
	Tue, 17 Nov 2026 14:34:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 435D0606A895
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=0uJOnk2M
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1PBHpMw5lf3mh7+QZWFauX4UCv3KG6JUZqdbELF3lfY=;
	b=0uJOnk2MfBlHSMlXnaqo5QpB6clHwNj2ytvhEtx/UVixDkXouCZheeOE2mr6gNQMMhnH6QFaw
	D3aRj485lKnlivYX8eD+WH3HxBatun0GMEcs66kbVW1q6DEdkysvnvgfwycTlS0TknDkzQEjwnU
	ZntMwg5+ZX/jD+998Z5SWGA=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jTS100GQHzLlTR;
	Tue, 17 Nov 2026 22:34:28 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 0C2A840580;
	Tue, 17 Nov 2026 22:34:47 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:34:41 +0800
From: Cai Xinchen <caixinchen1@huawei.com>
To: <mic@digikod.net>, <gnoack@google.com>, <paul@paul-moore.com>,
	<brauner@kernel.org>, <jack@suse.cz>, <caixinchen1@huawei.com>
CC: <amir73il@gmail.com>, <andrii@kernel.org>, <apparmor@lists.ubuntu.com>,
	<ast@kernel.org>, <axboe@kernel.dk>, <bpf@vger.kernel.org>,
	<casey@schaufler-ca.com>, <cel@kernel.org>, <cem@kernel.org>,
	<chenxiaosong@chenxiaosong.com>, <code@tyhicks.com>, <corbet@lwn.net>,
	<Dai.Ngo@oracle.com>, <dakr@kernel.org>, <daniel@iogearbox.net>,
	<dhowells@redhat.com>, <dlemoal@kernel.org>, <dmitry.kasatkin@gmail.com>,
	<driver-core@lists.linux.dev>, <dsterba@suse.com>,
	<ecryptfs@vger.kernel.org>, <eddyz87@gmail.com>, <emil@etsalapatis.com>,
	<eric.snowberg@oracle.com>, <exfat@lists.linux.dev>,
	<georgia.garcia@canonical.com>, <gregkh@linuxfoundation.org>, <hch@lst.de>,
	<hirofumi@mail.parknet.co.jp>, <hyc.lee@gmail.com>,
	<ihor.solodrai@linux.dev>, <jlayton@kernel.org>, <jmorris@namei.org>,
	<johan@kernel.org>, <john.fastabend@gmail.com>,
	<john.johansen@canonical.com>, <jolsa@kernel.org>, <kpsingh@kernel.org>,
	<linkinjeon@kernel.org>, <linux-api@vger.kernel.org>,
	<linux-block@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
	<linux-cifs@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-integrity@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-nfs@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <linux-unionfs@vger.kernel.org>,
	<linux-xfs@vger.kernel.org>, <liubaolin12138@163.com>,
	<martin.lau@linux.dev>, <mason@kernel.org>, <mathieu.desnoyers@efficios.com>,
	<matt@bobrowski.net>, <memxor@gmail.com>, <mhiramat@kernel.org>,
	<miklos@szeredi.hu>, <neil@brown.name>, <netfs@lists.linux.dev>,
	<ntfs@lists.linux.dev>, <okorniev@redhat.com>, <omosnacek@gmail.com>,
	<penguin-kernel@I-love.SAKURA.ne.jp>, <rafael@kernel.org>,
	<rdunlap@infradead.org>, <roberto.sassu@huawei.com>, <rostedt@goodmis.org>,
	<selinux@vger.kernel.org>, <senozhatsky@chromium.org>, <serge@hallyn.com>,
	<sj1557.seo@samsung.com>, <skhan@linuxfoundation.org>, <song@kernel.org>,
	<stephen.smalley.work@gmail.com>, <takedakn@nttdata.co.jp>, <tom@talpey.com>,
	<viro@zeniv.linux.org.uk>, <yonghong.song@linux.dev>, <yuezhang.mo@sony.com>,
	<zohar@linux.ibm.com>, <utilityemal77@gmail.com>, <lujialin4@huawei.com>
Subject: [PATCH -next -v4 15/17] selftests/landlock: Add tests for metadata access rights
Date: Tue, 17 Nov 2026 23:05:40 +0800
Message-ID: <20261117150542.1169451-16-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20261117150542.1169451-1-caixinchen1@huawei.com>
References: <20261117150542.1169451-1-caixinchen1@huawei.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 whupemk100010.china.huawei.com (7.152.184.41)

Add layout1 and layout2_overlay tests for the two new rights:
unhandled_metadata, write_metadata, read_metadata, fileattr,
fileattr_write_only, metadata_open_time and metadata_transfer.  They
cover the metadata system calls, the fileattr interfaces, the open-time
semantic and the transfer of file descriptors between processes.

The file descriptor-based checks reopen their files after the ruleset is
enforced, so that the rights come from the rules rather than from
descriptors opened before the sandbox, and the chown(2) no-op tests use
the effective group ID so that they also pass as non-root.

The fallback syscall numbers for file_getattr(2) and file_setattr(2) are
overridden on alpha and MIPS, which do not use the generic numbers.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 tools/testing/selftests/landlock/fs_test.c | 928 ++++++++++++++++++++-
 1 file changed, 922 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 2593db7ef25c..5dd2eeafd22a 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -26,8 +26,10 @@
 #include <sys/sendfile.h>
 #include <sys/socket.h>
 #include <sys/stat.h>
+#include <sys/syscall.h>
 #include <sys/sysmacros.h>
 #include <sys/un.h>
+#include <sys/xattr.h>
 #include <sys/vfs.h>
 #include <unistd.h>
 
@@ -4116,12 +4118,14 @@ TEST_F_FORK(ftruncate, open_and_ftruncate_in_different_processes)
 }
 
 /* Invokes the FS_IOC_GETFLAGS IOCTL and returns its errno or 0. */
-static int test_fs_ioc_getflags_ioctl(int fd)
+static int test_fs_ioc_getflags_ioctl(int fd, unsigned int *const flags)
 {
-	uint32_t flags;
+	unsigned int flags_;
 
-	if (ioctl(fd, FS_IOC_GETFLAGS, &flags) < 0)
+	if (ioctl(fd, FS_IOC_GETFLAGS, &flags_) < 0)
 		return errno;
+	if (flags)
+		*flags = flags_;
 	return 0;
 }
 
@@ -4144,7 +4148,7 @@ TEST(memfd_ftruncate_and_ioctl)
 		 * created in ways other than open(2).
 		 */
 		EXPECT_EQ(0, test_ftruncate(fd));
-		EXPECT_EQ(0, test_fs_ioc_getflags_ioctl(fd));
+		EXPECT_EQ(0, test_fs_ioc_getflags_ioctl(fd, NULL));
 
 		ASSERT_EQ(0, close(fd));
 
@@ -4175,7 +4179,7 @@ TEST_F_FORK(layout1, o_path_ftruncate_and_ioctl)
 	ASSERT_LE(0, fd);
 
 	EXPECT_EQ(EBADF, test_ftruncate(fd));
-	EXPECT_EQ(EBADF, test_fs_ioc_getflags_ioctl(fd));
+	EXPECT_EQ(EBADF, test_fs_ioc_getflags_ioctl(fd, NULL));
 
 	ASSERT_EQ(0, close(fd));
 
@@ -4191,7 +4195,7 @@ TEST_F_FORK(layout1, o_path_ftruncate_and_ioctl)
 	ASSERT_LE(0, fd);
 
 	EXPECT_EQ(EBADF, test_ftruncate(fd));
-	EXPECT_EQ(EBADF, test_fs_ioc_getflags_ioctl(fd));
+	EXPECT_EQ(EBADF, test_fs_ioc_getflags_ioctl(fd, NULL));
 
 	ASSERT_EQ(0, close(fd));
 }
@@ -10973,4 +10977,916 @@ TEST_F(trace_layout1, check_rule_fs_empty_grant)
 	free(buf);
 }
 
+/* Invokes chmod(2) and returns its errno or 0. */
+static int test_chmod(const char *const path, mode_t mode)
+{
+	if (chmod(path, mode) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes fchmod(2) and returns its errno or 0. */
+static int test_fchmod(int fd, mode_t mode)
+{
+	if (fchmod(fd, mode) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes chown(2) and returns its errno or 0. */
+static int test_chown(const char *const path, uid_t uid, gid_t gid)
+{
+	if (chown(path, uid, gid) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes fchown(2) and returns its errno or 0. */
+static int test_fchown(int fd, uid_t uid, gid_t gid)
+{
+	if (fchown(fd, uid, gid) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes lchown(2) and returns its errno or 0. */
+static int test_lchown(const char *const path, uid_t uid, gid_t gid)
+{
+	if (lchown(path, uid, gid) < 0)
+		return errno;
+	return 0;
+}
+
+/* Timestamps used by the utimensat(2) and futimens(2) test helpers. */
+static const struct timespec test_times[] = {
+	{
+		.tv_sec = 0,
+		.tv_nsec = UTIME_OMIT,
+	},
+	{
+		.tv_sec = 1,
+		.tv_nsec = 0,
+	},
+};
+
+/* Invokes utimensat(2) with explicit times and returns its errno or 0. */
+static int test_utimensat(const char *const path)
+{
+	if (utimensat(AT_FDCWD, path, test_times, 0) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes utimensat(2) with UTIME_NOW and returns its errno or 0. */
+static int test_utimensat_now(const char *const path)
+{
+	if (utimensat(AT_FDCWD, path, NULL, 0) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes futimens(2) and returns its errno or 0. */
+static int test_futimens(int fd)
+{
+	if (futimens(fd, test_times) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes setxattr(2) and returns its errno or 0. */
+static int test_setxattr(const char *const path, const char *const name,
+			 const void *const value, const size_t size)
+{
+	if (setxattr(path, name, value, size, 0) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes getxattr(2) and returns its errno or 0. */
+static int test_getxattr(const char *const path, const char *const name,
+			 void *const value, const size_t size)
+{
+	if (getxattr(path, name, value, size) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes listxattr(2) and returns its errno or 0. */
+static int test_listxattr(const char *const path, void *const list,
+			  const size_t size)
+{
+	if (listxattr(path, list, size) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes removexattr(2) and returns its errno or 0. */
+static int test_removexattr(const char *const path, const char *const name)
+{
+	if (removexattr(path, name) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes fsetxattr(2) and returns its errno or 0. */
+static int test_fsetxattr(int fd, const char *const name,
+			  const void *const value, const size_t size)
+{
+	if (fsetxattr(fd, name, value, size, 0) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes fgetxattr(2) and returns its errno or 0. */
+static int test_fgetxattr(int fd, const char *const name, void *const value,
+			  const size_t size)
+{
+	if (fgetxattr(fd, name, value, size) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes stat(2) and returns its errno or 0. */
+static int test_stat(const char *const path, struct stat *statbuf)
+{
+	if (stat(path, statbuf) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes fstat(2) and returns its errno or 0. */
+static int test_fstat(int fd, struct stat *statbuf)
+{
+	if (fstat(fd, statbuf) < 0)
+		return errno;
+	return 0;
+}
+
+TEST_F(layout1, unhandled_metadata)
+{
+	int file_fd;
+	int ruleset_fd;
+	const char *const file1 = file1_s1d1;
+	const char *const file2 = file2_s1d1;
+	const char *const dir1 = dir_s1d1;
+	struct stat statbuf;
+	const struct rule rules[] = {
+		{
+			.path = file1,
+			.access = LANDLOCK_ACCESS_FS_WRITE_FILE,
+		},
+		{
+			.path = file2,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE |
+				  LANDLOCK_ACCESS_FS_WRITE_FILE,
+		},
+		{
+			.path = dir1,
+			.access = ACCESS_RW,
+		},
+		{},
+	};
+
+	/*
+	 * READ_METADATA and WRITE_METADATA are not handled, so metadata
+	 * access should be allowed.
+	 */
+	ruleset_fd = create_ruleset(_metadata, ACCESS_RW, rules);
+	ASSERT_LE(0, ruleset_fd);
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/*
+	 * Open the file once the domain is enforced, so that the file-based
+	 * operations below go through hook_file_open() and do not inherit the
+	 * unrestricted allowed_access of a file opened without a domain.
+	 */
+	file_fd = open(file1, O_WRONLY | O_CLOEXEC);
+	ASSERT_LE(0, file_fd);
+
+	EXPECT_EQ(0, test_chmod(file1, 0644));
+	EXPECT_EQ(0, test_fchmod(file_fd, 0644));
+	EXPECT_EQ(0, test_chmod(file2, 0400));
+	EXPECT_EQ(0, test_chmod(dir1, 0700));
+
+	EXPECT_EQ(0, test_chown(file1, -1, getegid()));
+	EXPECT_EQ(0, test_fchown(file_fd, -1, getegid()));
+	EXPECT_EQ(0, test_lchown(file1, -1, getegid()));
+
+	EXPECT_EQ(0, test_utimensat(file1));
+	EXPECT_EQ(0, test_utimensat_now(file1));
+
+	EXPECT_EQ(0, test_setxattr(file1, "user.test", "a", 1));
+	EXPECT_EQ(0, test_getxattr(file1, "user.test", NULL, 0));
+	EXPECT_EQ(0, test_listxattr(file1, NULL, 0));
+	EXPECT_EQ(0, test_removexattr(file1, "user.test"));
+
+	EXPECT_EQ(0, test_stat(file1, &statbuf));
+	EXPECT_EQ(0, test_fstat(file_fd, &statbuf));
+	EXPECT_EQ(0, test_stat(dir1, &statbuf));
+
+	ASSERT_EQ(0, close(file_fd));
+}
+
+TEST_F(layout1, write_metadata)
+{
+	int file_fd, file2_fd, trunc_fd, chown_fd;
+	int ruleset_fd;
+	const char *const file1 = file1_s1d1;
+	const char *const file2 = file2_s1d1;
+	const char *const trunc_file = file1_s1d2;
+	const char *const chown_file = file2_s1d2;
+	const char *const dir1 = dir_s1d1;
+	struct stat statbuf;
+	const struct rule rules[] = {
+		{
+			.path = file1,
+			.access = LANDLOCK_ACCESS_FS_WRITE_FILE |
+				  LANDLOCK_ACCESS_FS_READ_METADATA |
+				  LANDLOCK_ACCESS_FS_WRITE_METADATA,
+		},
+		{
+			.path = file2,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE |
+				  LANDLOCK_ACCESS_FS_WRITE_FILE |
+				  LANDLOCK_ACCESS_FS_READ_METADATA,
+		},
+		{
+			.path = chown_file,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE |
+				  LANDLOCK_ACCESS_FS_WRITE_FILE |
+				  LANDLOCK_ACCESS_FS_READ_METADATA,
+		},
+		{
+			.path = trunc_file,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE |
+				  LANDLOCK_ACCESS_FS_WRITE_FILE |
+				  LANDLOCK_ACCESS_FS_READ_METADATA |
+				  LANDLOCK_ACCESS_FS_TRUNCATE,
+		},
+		{
+			.path = dir1,
+			.access = ACCESS_RW,
+		},
+		{},
+	};
+
+	ruleset_fd = create_ruleset(_metadata, ACCESS_RW |
+				    LANDLOCK_ACCESS_FS_READ_METADATA |
+				    LANDLOCK_ACCESS_FS_WRITE_METADATA |
+				    LANDLOCK_ACCESS_FS_TRUNCATE, rules);
+	ASSERT_LE(0, ruleset_fd);
+	file_fd = open(file1, O_WRONLY | O_CLOEXEC);
+	ASSERT_LE(0, file_fd);
+	file2_fd = open(file2, O_RDWR | O_CLOEXEC);
+	ASSERT_LE(0, file2_fd);
+	trunc_fd = open(trunc_file, O_RDWR | O_CLOEXEC);
+	ASSERT_LE(0, trunc_fd);
+	chown_fd = open(chown_file, O_RDWR | O_CLOEXEC);
+	ASSERT_LE(0, chown_fd);
+
+	/*
+	 * Arm the setuid bit for the setuid-clearing tests below:
+	 * writing or truncating a setuid file clears that bit
+	 * implicitly, which must not require WRITE_METADATA, whereas
+	 * an explicit chown(2) with (-1, -1) requests the same
+	 * clearing and must require it.  The clearing happens when
+	 * the caller has no CAP_FSETID, which is the case here
+	 * because tests run without capabilities (see disable_caps()
+	 * in prepare_layout()).
+	 */
+	ASSERT_EQ(0, fchmod(file_fd, 04666));
+	ASSERT_EQ(0, fchmod(file2_fd, 04666));
+	ASSERT_EQ(0, fchmod(trunc_fd, 04666));
+	ASSERT_EQ(0, fchmod(chown_fd, 04666));
+	/*
+	 * Closes the file descriptors opened before sandboxing: they carry
+	 * every access right because they were allocated before the
+	 * sandbox was enforced, so the assertions below would not check
+	 * the rules if they kept using them.
+	 */
+	ASSERT_EQ(0, close(file_fd));
+	ASSERT_EQ(0, close(file2_fd));
+	ASSERT_EQ(0, close(trunc_fd));
+	ASSERT_EQ(0, close(chown_fd));
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/*
+	 * Reopens the files while the ruleset is enforced, so that the
+	 * rights stashed at open time come from the rules: file1 gets
+	 * WRITE_METADATA, file2 and chown_file only get READ_METADATA, and
+	 * trunc_file gets TRUNCATE but no WRITE_METADATA.
+	 */
+	file_fd = open(file1, O_WRONLY | O_CLOEXEC);
+	ASSERT_LE(0, file_fd);
+	file2_fd = open(file2, O_RDWR | O_CLOEXEC);
+	ASSERT_LE(0, file2_fd);
+	trunc_fd = open(trunc_file, O_RDWR | O_CLOEXEC);
+	ASSERT_LE(0, trunc_fd);
+	chown_fd = open(chown_file, O_RDWR | O_CLOEXEC);
+	ASSERT_LE(0, chown_fd);
+
+	/*
+	 * An explicit chown(2) with (-1, -1) on a setuid file is an
+	 * explicit request to clear the setuid bit: it requires
+	 * WRITE_METADATA, which file1 has, and clears the bit.
+	 */
+	EXPECT_EQ(0, test_fchown(file_fd, -1, -1));
+	ASSERT_EQ(0, fstat(file_fd, &statbuf));
+	EXPECT_EQ(0, statbuf.st_mode & S_ISUID);
+
+	/* file1 has WRITE_METADATA: allowed */
+	EXPECT_EQ(0, test_chmod(file1, 0644));
+	EXPECT_EQ(0, test_fchmod(file_fd, 0644));
+	EXPECT_EQ(0, test_chown(file1, -1, getegid()));
+	EXPECT_EQ(0, test_fchown(file_fd, -1, getegid()));
+	EXPECT_EQ(0, test_lchown(file1, -1, getegid()));
+	EXPECT_EQ(0, test_utimensat(file1));
+	EXPECT_EQ(0, test_utimensat_now(file1));
+	EXPECT_EQ(0, test_setxattr(file1, "user.test", "a", 1));
+	EXPECT_EQ(0, test_removexattr(file1, "user.test"));
+
+	/*
+	 * Writing is not an explicit metadata change: implicit timestamp
+	 * updates and the implicit setuid-bit clearing are allowed
+	 * without WRITE_METADATA.
+	 */
+	EXPECT_EQ(1, write(file2_fd, "a", 1));
+	ASSERT_EQ(0, fstat(file2_fd, &statbuf));
+	EXPECT_EQ(0, statbuf.st_mode & S_ISUID);
+
+	/* file2 does not have WRITE_METADATA: denied */
+	EXPECT_EQ(EACCES, test_chmod(file2, 0400));
+	EXPECT_EQ(EACCES, test_chown(file2, -1, getegid()));
+	EXPECT_EQ(EACCES, test_lchown(file2, -1, getegid()));
+	EXPECT_EQ(EACCES, test_utimensat(file2));
+	EXPECT_EQ(EACCES, test_utimensat_now(file2));
+	EXPECT_EQ(EACCES, test_setxattr(file2, "user.test", "a", 1));
+	EXPECT_EQ(EACCES, test_removexattr(file2, "user.test"));
+
+	/*
+	 * Without the WRITE_METADATA right (i.e. without the right stashed
+	 * at open time), the same explicit chown(2) with (-1, -1) is
+	 * denied and leaves the setuid bit in place.
+	 */
+	EXPECT_EQ(EACCES, test_fchown(chown_fd, -1, -1));
+	ASSERT_EQ(0, fstat(chown_fd, &statbuf));
+	EXPECT_EQ(S_ISUID, statbuf.st_mode & S_ISUID);
+
+	/* dir1 does not have WRITE_METADATA: denied */
+	EXPECT_EQ(EACCES, test_chmod(dir1, 0700));
+	EXPECT_EQ(EACCES, test_chown(dir1, -1, getegid()));
+
+	/*
+	 * Truncating a setuid file implicitly clears the setuid bit as
+	 * well: this must not require WRITE_METADATA, which trunc_file
+	 * does not have, but it does require TRUNCATE.
+	 */
+	EXPECT_EQ(0, ftruncate(trunc_fd, 0));
+	ASSERT_EQ(0, fstat(trunc_fd, &statbuf));
+	EXPECT_EQ(0, statbuf.st_mode & S_ISUID);
+
+	ASSERT_EQ(0, close(file_fd));
+	ASSERT_EQ(0, close(file2_fd));
+	ASSERT_EQ(0, close(trunc_fd));
+	ASSERT_EQ(0, close(chown_fd));
+}
+
+TEST_F(layout1, read_metadata)
+{
+	int file_fd, file2_fd, sandbox_fd;
+	int ruleset_fd;
+	const char *const file1 = file1_s1d1;
+	const char *const file2 = file2_s1d1;
+	const char *const dir1 = dir_s1d1;
+	struct stat statbuf;
+	const struct rule rules[] = {
+		{
+			.path = file1,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE |
+				  LANDLOCK_ACCESS_FS_READ_METADATA,
+		},
+		{
+			.path = file2,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE |
+				  LANDLOCK_ACCESS_FS_WRITE_FILE,
+		},
+		{
+			.path = dir1,
+			.access = ACCESS_RW,
+		},
+		{},
+	};
+
+	ruleset_fd = create_ruleset(_metadata, ACCESS_RW |
+				    LANDLOCK_ACCESS_FS_READ_METADATA, rules);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, setxattr(file1, "user.test", "a", 1, 0));
+	ASSERT_EQ(0, setxattr(file2, "user.test", "a", 1, 0));
+
+	/*
+	 * A file descriptor opened before the ruleset is enforced carries
+	 * all access rights.
+	 */
+	sandbox_fd = open(file1, O_RDONLY | O_CLOEXEC);
+	ASSERT_LE(0, sandbox_fd);
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/* file1 has READ_METADATA: allowed */
+	EXPECT_EQ(0, test_stat(file1, &statbuf));
+	file_fd = open(file1, O_RDONLY | O_CLOEXEC);
+	ASSERT_LE(0, file_fd);
+	EXPECT_EQ(0, test_fstat(file_fd, &statbuf));
+	EXPECT_EQ(0, test_getxattr(file1, "user.test", NULL, 0));
+	EXPECT_EQ(0, test_listxattr(file1, NULL, 0));
+
+	/*
+	 * Reading metadata through the file descriptor opened before
+	 * sandboxing is still allowed.
+	 */
+	EXPECT_EQ(0, test_fstat(sandbox_fd, &statbuf));
+	ASSERT_EQ(0, close(sandbox_fd));
+
+	/*
+	 * file2 does not have READ_METADATA: denied, both through the path
+	 * and through a file descriptor opened while the ruleset is
+	 * enforced.
+	 */
+	EXPECT_EQ(EACCES, test_stat(file2, &statbuf));
+	file2_fd = open(file2, O_RDONLY | O_CLOEXEC);
+	ASSERT_LE(0, file2_fd);
+	EXPECT_EQ(EACCES, test_fstat(file2_fd, &statbuf));
+	EXPECT_EQ(EACCES, test_fgetxattr(file2_fd, "user.test", NULL, 0));
+	ASSERT_EQ(0, close(file2_fd));
+	EXPECT_EQ(EACCES, test_getxattr(file2, "user.test", NULL, 0));
+	EXPECT_EQ(EACCES, test_listxattr(file2, NULL, 0));
+	/* dir1 does not have READ_METADATA: denied */
+	EXPECT_EQ(EACCES, test_stat(dir1, &statbuf));
+
+	ASSERT_EQ(0, close(file_fd));
+}
+
+/* Invokes ioctl(FS_IOC_SETFLAGS) and returns its errno or 0. */
+static int test_setflags(int fd, const unsigned int flags)
+{
+	unsigned int flags_ = flags;
+
+	if (ioctl(fd, FS_IOC_SETFLAGS, &flags_) < 0)
+		return errno;
+	return 0;
+}
+
+#ifndef __NR_file_getattr
+#if defined(__alpha__)
+#define __NR_file_getattr 578
+#elif defined(__mips__)
+#define __NR_file_getattr (__NR_Linux + 468)
+#else
+#define __NR_file_getattr 468
+#endif
+#endif
+#ifndef __NR_file_setattr
+#if defined(__alpha__)
+#define __NR_file_setattr 579
+#elif defined(__mips__)
+#define __NR_file_setattr (__NR_Linux + 469)
+#else
+#define __NR_file_setattr 469
+#endif
+#endif
+
+/* Invokes file_getattr(2) and returns its errno or 0. */
+static int test_file_getattr(int dfd, const char *const path,
+			     struct file_attr *const fattr,
+			     const unsigned int at_flags)
+{
+	if (syscall(__NR_file_getattr, dfd, path, fattr, sizeof(*fattr),
+		    at_flags) < 0)
+		return errno;
+	return 0;
+}
+
+/* Invokes file_setattr(2) and returns its errno or 0. */
+static int test_file_setattr(int dfd, const char *const path,
+			     struct file_attr *const fattr,
+			     const unsigned int at_flags)
+{
+	if (syscall(__NR_file_setattr, dfd, path, fattr, sizeof(*fattr),
+		    at_flags) < 0)
+		return errno;
+	return 0;
+}
+
+TEST_F(layout1, fileattr)
+{
+	const struct rule rules[] = {
+		{
+			.path = file1_s1d1,
+			.access = LANDLOCK_ACCESS_FS_READ_METADATA |
+				  LANDLOCK_ACCESS_FS_WRITE_METADATA,
+		},
+		{},
+	};
+	struct file_attr fattr;
+	unsigned int flags;
+	int fd, fd2, ruleset_fd;
+
+	ruleset_fd = create_ruleset(
+		_metadata,
+		LANDLOCK_ACCESS_FS_READ_METADATA |
+			LANDLOCK_ACCESS_FS_WRITE_METADATA,
+		rules);
+	ASSERT_LE(0, ruleset_fd);
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/*
+	 * The file descriptor is opened while the ruleset is enforced, so it
+	 * carries the metadata rights granted by the rule.
+	 */
+	fd = open(file1_s1d1, O_RDONLY | O_CLOEXEC);
+	ASSERT_LE(0, fd);
+
+	/* Allowed file: FS_IOC_GETFLAGS */
+	flags = 0;
+	EXPECT_EQ(0, test_fs_ioc_getflags_ioctl(fd, &flags));
+	EXPECT_EQ(0, flags & FS_NODUMP_FL);
+
+	/* Allowed file: FS_IOC_SETFLAGS */
+	EXPECT_EQ(0, test_setflags(fd, FS_NODUMP_FL));
+	flags = 0;
+	EXPECT_EQ(0, test_fs_ioc_getflags_ioctl(fd, &flags));
+	EXPECT_EQ(FS_NODUMP_FL, flags & FS_NODUMP_FL);
+	EXPECT_EQ(0, test_setflags(fd, 0));
+
+	/* Allowed file: file_getattr(2), with a path and with AT_EMPTY_PATH */
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(0, test_file_getattr(AT_FDCWD, file1_s1d1, &fattr, 0));
+	EXPECT_EQ(0, fattr.fa_xflags & FS_XFLAG_NODUMP);
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(0, test_file_getattr(fd, NULL, &fattr, AT_EMPTY_PATH));
+
+	/* Allowed file: file_setattr(2), with a path and with AT_EMPTY_PATH */
+	memset(&fattr, 0, sizeof(fattr));
+	fattr.fa_xflags = FS_XFLAG_NODUMP;
+	EXPECT_EQ(0, test_file_setattr(AT_FDCWD, file1_s1d1, &fattr, 0));
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(0, test_file_getattr(AT_FDCWD, file1_s1d1, &fattr, 0));
+	EXPECT_EQ(FS_XFLAG_NODUMP, fattr.fa_xflags & FS_XFLAG_NODUMP);
+	memset(&fattr, 0, sizeof(fattr));
+	fattr.fa_xflags = 0;
+	EXPECT_EQ(0, test_file_setattr(fd, NULL, &fattr, AT_EMPTY_PATH));
+
+	/* Non-allowed file: FS_IOC_GETFLAGS and FS_IOC_SETFLAGS */
+	fd2 = open(file2_s1d1, O_RDONLY | O_CLOEXEC);
+	ASSERT_LE(0, fd2);
+	EXPECT_EQ(EACCES, test_fs_ioc_getflags_ioctl(fd2, &flags));
+	EXPECT_EQ(EACCES, test_setflags(fd2, FS_NODUMP_FL));
+
+	/* Non-allowed file: file_getattr(2) and file_setattr(2) */
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(EACCES, test_file_getattr(AT_FDCWD, file2_s1d1, &fattr, 0));
+	fattr.fa_xflags = FS_XFLAG_NODUMP;
+	EXPECT_EQ(EACCES, test_file_setattr(AT_FDCWD, file2_s1d1, &fattr, 0));
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(EACCES, test_file_getattr(fd2, NULL, &fattr, AT_EMPTY_PATH));
+	fattr.fa_xflags = FS_XFLAG_NODUMP;
+	EXPECT_EQ(EACCES, test_file_setattr(fd2, NULL, &fattr, AT_EMPTY_PATH));
+
+	ASSERT_EQ(0, close(fd));
+	ASSERT_EQ(0, close(fd2));
+}
+
+TEST_F(layout1, fileattr_write_only)
+{
+	const struct rule rules[] = {
+		{
+			.path = file1_s1d1,
+			.access = LANDLOCK_ACCESS_FS_WRITE_METADATA,
+		},
+		{},
+	};
+	struct file_attr fattr;
+	unsigned int flags;
+	int fd, fd2, ruleset_fd;
+
+	ruleset_fd = create_ruleset(_metadata,
+				    LANDLOCK_ACCESS_FS_WRITE_METADATA, rules);
+	ASSERT_LE(0, ruleset_fd);
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/*
+	 * The file descriptor is opened while WRITE_METADATA is handled but
+	 * READ_METADATA is not, so it carries WRITE_METADATA and the
+	 * unrestricted READ_METADATA of that time.
+	 */
+	fd = open(file1_s1d1, O_RDONLY | O_CLOEXEC);
+	ASSERT_LE(0, fd);
+
+	/*
+	 * WRITE_METADATA alone must be enough to set flags: the kernel-side
+	 * read of the old flags must not require READ_METADATA.
+	 */
+	EXPECT_EQ(0, test_setflags(fd, FS_NODUMP_FL));
+	flags = 0;
+	/* READ_METADATA is not handled: reading is allowed. */
+	EXPECT_EQ(0, test_fs_ioc_getflags_ioctl(fd, &flags));
+	EXPECT_EQ(FS_NODUMP_FL, flags & FS_NODUMP_FL);
+
+	/*
+	 * Handle READ_METADATA as well, without granting it.  Reading is
+	 * now denied for file descriptors opened from now on, but writing
+	 * must still work because the kernel-side read of the old flags
+	 * does not go through the READ_METADATA check.
+	 */
+	ruleset_fd = create_ruleset(
+		_metadata,
+		LANDLOCK_ACCESS_FS_READ_METADATA |
+			LANDLOCK_ACCESS_FS_WRITE_METADATA,
+		rules);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	fd2 = open(file1_s1d1, O_RDONLY | O_CLOEXEC);
+	ASSERT_LE(0, fd2);
+	EXPECT_EQ(EACCES, test_fs_ioc_getflags_ioctl(fd2, &flags));
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(EACCES,
+		  test_file_getattr(fd2, NULL, &fattr, AT_EMPTY_PATH));
+
+	EXPECT_EQ(0, test_setflags(fd2, 0));
+	memset(&fattr, 0, sizeof(fattr));
+	fattr.fa_xflags = FS_XFLAG_NODUMP;
+	EXPECT_EQ(0, test_file_setattr(fd2, NULL, &fattr, AT_EMPTY_PATH));
+	memset(&fattr, 0, sizeof(fattr));
+	fattr.fa_xflags = 0;
+	EXPECT_EQ(0, test_file_setattr(fd2, NULL, &fattr, AT_EMPTY_PATH));
+
+	/*
+	 * Reading through the file descriptor opened before READ_METADATA
+	 * was handled is still allowed: it carries the rights of the time
+	 * it was opened with.
+	 */
+	EXPECT_EQ(0, test_fs_ioc_getflags_ioctl(fd, &flags));
+
+	ASSERT_EQ(0, close(fd));
+	ASSERT_EQ(0, close(fd2));
+}
+
+TEST_F(layout1, metadata_open_time)
+{
+	int file_fd, opath_fd, ruleset_fd;
+	struct stat statbuf;
+	unsigned int flags;
+	struct file_attr fattr;
+	const char *const file1 = file1_s1d1;
+	const struct rule rules[] = {
+		{
+			.path = file1,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE |
+				  LANDLOCK_ACCESS_FS_WRITE_FILE,
+		},
+		{},
+	};
+
+	ruleset_fd = create_ruleset(_metadata, ACCESS_RW |
+				    LANDLOCK_ACCESS_FS_READ_METADATA |
+				    LANDLOCK_ACCESS_FS_WRITE_METADATA,
+				    rules);
+	ASSERT_LE(0, ruleset_fd);
+
+	/*
+	 * A file descriptor opened before the ruleset is enforced carries
+	 * all access rights: metadata accesses through it remain allowed
+	 * even though the current thread cannot access the file's metadata
+	 * anymore.
+	 */
+	file_fd = open(file1, O_RDWR | O_CLOEXEC);
+	ASSERT_LE(0, file_fd);
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	EXPECT_EQ(0, test_fchmod(file_fd, 0600));
+	EXPECT_EQ(0, test_fchown(file_fd, -1, getegid()));
+	EXPECT_EQ(0, test_futimens(file_fd));
+	EXPECT_EQ(0, test_fstat(file_fd, &statbuf));
+	EXPECT_EQ(0, test_fs_ioc_getflags_ioctl(file_fd, &flags));
+	EXPECT_EQ(0, test_fsetxattr(file_fd, "user.test", "a", 1));
+	EXPECT_EQ(0, test_fgetxattr(file_fd, "user.test", NULL, 0));
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(0,
+		  test_file_getattr(file_fd, NULL, &fattr, AT_EMPTY_PATH));
+	memset(&fattr, 0, sizeof(fattr));
+	fattr.fa_xflags = FS_XFLAG_NODUMP;
+	EXPECT_EQ(0,
+		  test_file_setattr(file_fd, NULL, &fattr, AT_EMPTY_PATH));
+	memset(&fattr, 0, sizeof(fattr));
+	fattr.fa_xflags = 0;
+	EXPECT_EQ(0,
+		  test_file_setattr(file_fd, NULL, &fattr, AT_EMPTY_PATH));
+
+	/* Path-based accesses use the rights of the current thread. */
+	EXPECT_EQ(EACCES, test_chmod(file1, 0644));
+	EXPECT_EQ(EACCES, test_chown(file1, -1, getegid()));
+	EXPECT_EQ(EACCES, test_utimensat(file1));
+	EXPECT_EQ(EACCES, test_stat(file1, &statbuf));
+	EXPECT_EQ(EACCES, test_setxattr(file1, "user.test", "a", 1));
+	EXPECT_EQ(EACCES, test_getxattr(file1, "user.test", NULL, 0));
+
+	ASSERT_EQ(0, close(file_fd));
+
+	/*
+	 * A file descriptor opened while the ruleset is enforced only
+	 * carries the rights granted to the file: metadata accesses
+	 * through it are denied, but data accesses still work.
+	 */
+	file_fd = open(file1, O_RDWR | O_CLOEXEC);
+	ASSERT_LE(0, file_fd);
+
+	EXPECT_EQ(EACCES, test_fchmod(file_fd, 0600));
+	EXPECT_EQ(EACCES, test_fchown(file_fd, -1, getegid()));
+	EXPECT_EQ(EACCES, test_futimens(file_fd));
+	EXPECT_EQ(EACCES, test_fstat(file_fd, &statbuf));
+	EXPECT_EQ(EACCES, test_fs_ioc_getflags_ioctl(file_fd, &flags));
+	EXPECT_EQ(EACCES, test_fsetxattr(file_fd, "user.test", "a", 1));
+	EXPECT_EQ(EACCES, test_fgetxattr(file_fd, "user.test", NULL, 0));
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(EACCES,
+		  test_file_getattr(file_fd, NULL, &fattr, AT_EMPTY_PATH));
+	memset(&fattr, 0, sizeof(fattr));
+	fattr.fa_xflags = FS_XFLAG_NODUMP;
+	EXPECT_EQ(EACCES,
+		  test_file_setattr(file_fd, NULL, &fattr, AT_EMPTY_PATH));
+
+	EXPECT_EQ(0, lseek(file_fd, 0, SEEK_SET));
+	EXPECT_EQ(1, write(file_fd, "a", 1));
+
+	/*
+	 * An O_PATH file descriptor does not carry open-time rights: it is
+	 * checked against the current domain, like path-based accesses.
+	 */
+	opath_fd = open(file1, O_PATH | O_CLOEXEC);
+	ASSERT_LE(0, opath_fd);
+	EXPECT_EQ(EACCES, test_fstat(opath_fd, &statbuf));
+
+	ASSERT_EQ(0, close(file_fd));
+	ASSERT_EQ(0, close(opath_fd));
+}
+
+TEST_F(layout1, metadata_transfer)
+{
+	int child, fd, status;
+	int socket_fds[2];
+	struct stat statbuf;
+	unsigned int flags;
+	const char *const file1 = file1_s1d1;
+	const struct rule rules[] = {
+		{
+			.path = file1,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE |
+				  LANDLOCK_ACCESS_FS_WRITE_FILE,
+		},
+		{},
+	};
+
+	ASSERT_EQ(0, socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0,
+				socket_fds));
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		/*
+		 * Enables Landlock in the child process, opens a file
+		 * descriptor without the metadata access rights and sends it
+		 * to the non-landlocked parent process.
+		 */
+		int fd;
+
+		enforce_fs(_metadata, ACCESS_RW |
+					  LANDLOCK_ACCESS_FS_READ_METADATA |
+					  LANDLOCK_ACCESS_FS_WRITE_METADATA,
+			   rules);
+
+		fd = open(file1, O_RDWR | O_CLOEXEC);
+		ASSERT_LE(0, fd);
+		ASSERT_EQ(0, send_fd(socket_fds[0], fd));
+		ASSERT_EQ(0, close(fd));
+		ASSERT_EQ(0, close(socket_fds[0]));
+
+		_exit(_metadata->exit_code);
+		return;
+	}
+
+	/*
+	 * The non-landlocked parent process can use the received file
+	 * descriptor for data accesses, but its metadata accesses are
+	 * still denied with the rights stashed at open time.
+	 */
+	fd = recv_fd(socket_fds[1]);
+	ASSERT_LE(0, fd);
+	EXPECT_EQ(1, write(fd, "a", 1));
+	EXPECT_EQ(EACCES, test_fchmod(fd, 0600));
+	EXPECT_EQ(EACCES, test_fchown(fd, -1, getegid()));
+	EXPECT_EQ(EACCES, test_futimens(fd));
+	EXPECT_EQ(EACCES, test_fstat(fd, &statbuf));
+	EXPECT_EQ(EACCES, test_fs_ioc_getflags_ioctl(fd, &flags));
+	ASSERT_EQ(0, close(fd));
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	ASSERT_EQ(1, WIFEXITED(status));
+	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+
+	ASSERT_EQ(0, close(socket_fds[0]));
+	ASSERT_EQ(0, close(socket_fds[1]));
+}
+
+TEST_F(layout2_overlay, fileattr)
+{
+	const struct rule rules[] = {
+		{
+			.path = MERGE_DATA,
+			.access = LANDLOCK_ACCESS_FS_READ_METADATA |
+				  LANDLOCK_ACCESS_FS_WRITE_METADATA,
+		},
+		{},
+	};
+	struct file_attr fattr;
+	unsigned int flags;
+	int fd, fd2, ruleset_fd;
+
+	if (self->skip_test)
+		SKIP(return, "overlayfs is not supported (test)");
+
+	ruleset_fd = create_ruleset(
+		_metadata,
+		LANDLOCK_ACCESS_FS_READ_METADATA |
+			LANDLOCK_ACCESS_FS_WRITE_METADATA,
+		rules);
+	ASSERT_LE(0, ruleset_fd);
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	ASSERT_EQ(0, close(ruleset_fd));
+
+	/*
+	 * The overlay mount was created before the ruleset was enforced
+	 * (i.e. as an administrator): the internal forwards to the real
+	 * paths must not interfere with the allowed accesses below.
+	 */
+	fd = open(merge_fl1, O_RDONLY | O_CLOEXEC);
+	ASSERT_LE(0, fd);
+
+	flags = 0;
+	EXPECT_EQ(0, test_fs_ioc_getflags_ioctl(fd, &flags));
+	EXPECT_EQ(0, flags & FS_NODUMP_FL);
+	/* Copies the file up and sets the flag on the upper real file. */
+	EXPECT_EQ(0, test_setflags(fd, FS_NODUMP_FL));
+	flags = 0;
+	EXPECT_EQ(0, test_fs_ioc_getflags_ioctl(fd, &flags));
+	EXPECT_EQ(FS_NODUMP_FL, flags & FS_NODUMP_FL);
+	EXPECT_EQ(0, test_setflags(fd, 0));
+
+	/* Allowed file: file_getattr(2) and file_setattr(2) */
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(0, test_file_getattr(AT_FDCWD, merge_fl1, &fattr, 0));
+	memset(&fattr, 0, sizeof(fattr));
+	fattr.fa_xflags = FS_XFLAG_NODUMP;
+	EXPECT_EQ(0, test_file_setattr(AT_FDCWD, merge_fl1, &fattr, 0));
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(0, test_file_getattr(AT_FDCWD, merge_fl1, &fattr, 0));
+	EXPECT_EQ(FS_XFLAG_NODUMP, fattr.fa_xflags & FS_XFLAG_NODUMP);
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(0, test_file_getattr(fd, NULL, &fattr, AT_EMPTY_PATH));
+	memset(&fattr, 0, sizeof(fattr));
+	fattr.fa_xflags = 0;
+	EXPECT_EQ(0, test_file_setattr(fd, NULL, &fattr, AT_EMPTY_PATH));
+
+	ASSERT_EQ(0, close(fd));
+
+	/* Non-allowed path: raw lower tmpfs path, outside of MERGE_DATA. */
+	fd2 = open(lower_fl1, O_RDONLY | O_CLOEXEC);
+	ASSERT_LE(0, fd2);
+	EXPECT_EQ(EACCES, test_fs_ioc_getflags_ioctl(fd2, &flags));
+	EXPECT_EQ(EACCES, test_setflags(fd2, FS_NODUMP_FL));
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(EACCES, test_file_getattr(AT_FDCWD, lower_fl1, &fattr, 0));
+	memset(&fattr, 0, sizeof(fattr));
+	EXPECT_EQ(EACCES,
+		  test_file_getattr(fd2, NULL, &fattr, AT_EMPTY_PATH));
+	memset(&fattr, 0, sizeof(fattr));
+	fattr.fa_xflags = FS_XFLAG_NODUMP;
+	EXPECT_EQ(EACCES, test_file_setattr(AT_FDCWD, lower_fl1, &fattr, 0));
+	ASSERT_EQ(0, close(fd2));
+}
+
 TEST_HARNESS_MAIN
-- 
2.18.0.huawei.25

