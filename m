Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.226
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926093;
	b=jmsUiCbMEdOjoMMQGd4xFI9EDYmRvzTqXP88WKw4QX+AJrwUum1EaldkiVauGU3FXQzv
	 wCQ4gHFUmiJRAmC5P4X2LrjV6ohd/8jLRRwhda/TaBy7bmU1G24CWOFFxYYtKzxmATLzL
	 djas7/+d03iGGCJ3cd5fxGTqo+Yqh+oySP4Rj1GCU9AJL1duMQBiN8DnQq4GDW1HOx0hj
	 W3NMvdM1bkzyTjYaqh/Xc8gs7HF9cxeezglGJshWYbuPCfiJaDwmSTlmjYbBitkqqAJHo
	 qKLYWMh3nPtmWf9cXPAwqD8kQ1IQoctInG4W22qpPJhOmFuyTx6CJTeCMaVDov7qHIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926093;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=pJZ4NzOAvolg7d9pXS4YjOfsPEAMwi10SQnhEe1l3Co=;
	b=q+uwUlXVlb6alyiBneyT3o7XeSK1RMOjdzvEdXQDiJH3fis/j9oCrPOZHa/QxTd7Wv7a
	 Y1DZ0Vac9Q0P45HMSkZGAVWD5oh30Fnk2eBq+b0M9rhNYEr0WMcchJcnt+Tn3sniQ56M6
	 mzwSeiPQKQAMmpAHWwn4Zs+EF9PWhzhe32h7OY00jwRr1F6gYOnwld5wfHy/PXcvxZrMk
	 eGTPVWSwY4KKvglTA+5eL7iC+ue/pvZxjlukiTX1KJgQeYGyHyDvr8POqKmlM4TMxkyf5
	 ffF1q0Zfy69aW5olye0xaHgPWE0iKXKdq9B7qT0Vx7MjFh+squvR9Y1c+ZCg9HHqjoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=RYnbgzOa;
	arc=none smtp.remote-ip=113.46.200.226
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0A6606A897;
	Tue, 17 Nov 2026 14:34:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D0A6606A897
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=RYnbgzOa
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pJZ4NzOAvolg7d9pXS4YjOfsPEAMwi10SQnhEe1l3Co=;
	b=RYnbgzOaUYlJRHl0tyH761o1t8bfyI4441/5hkH25zYsOxtP6WW33AwlarsUyeeKWCQ3he8wu
	8TET6Hi/vmrjF4zwOYMCo0jJuQLezZ3GzN7MuELUqKOEHqZsCq5ANC6X5M/zNVHs600/I4hYHk0
	bkG0RPDXSVddPWmayxs9s24=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4jTS0z4pcDzKm8l;
	Tue, 17 Nov 2026 22:34:27 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 713C440586;
	Tue, 17 Nov 2026 22:34:41 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:34:35 +0800
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
Subject: [PATCH -next -v4 14/17] landlock: Add READ_METADATA and WRITE_METADATA access rights
Date: Tue, 17 Nov 2026 23:05:39 +0800
Message-ID: <20261117150542.1169451-15-caixinchen1@huawei.com>
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

Add LANDLOCK_ACCESS_FS_READ_METADATA and
LANDLOCK_ACCESS_FS_WRITE_METADATA, which group metadata operations by
security relevance instead of by syscall [1].  They cover the metadata
system calls, the FS_IOC_* flag ioctls and the file_getattr(2) and
file_setattr(2) interfaces, and are implemented by hooking path_getattr,
path_file_getattr, path_setattr, path_file_setattr, path_setxattr,
path_getxattr, path_listxattr, path_removexattr, path_set_acl,
path_get_acl and path_remove_acl.

Like for LANDLOCK_ACCESS_FS_TRUNCATE, the rights available at open(2)
time decide for operations on an already opened file, whereas path-based
accesses and O_PATH descriptors are checked against the current domain.
Both rights are added to _LANDLOCK_ACCESS_FS_OPTIONAL and their names to
_LANDLOCK_ACCESS_FS_NAMES, and deny_masks_t is widened to u16.

hook_path_setattr only restricts explicit changes.  The setuid/setgid bit
and capability clearing that the kernel performs implicitly arrives with
ATTR_FORCE set and is ignored, while the same clearing requested by
chown(2) is checked; a chown(2) that changes nothing is not restricted.
Kernel-internal accesses made under the current credentials are checked
because they cannot be told apart from a user request, but kernel threads
and override_creds() users are not.

Bump the ABI version to 13, and keep the in-tree selftests valid by
updating the shared masks, the expected ABI version and the expected
trace suffix.

[1]
https://lore.kernel.org/all/abc960a1-e66e-792e-6869-cfd201c29dbe@digikod.net/

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 fs/stat.c                                     |  14 ++
 include/linux/landlock.h                      |   4 +-
 include/uapi/linux/landlock.h                 |  47 +++-
 security/landlock/access.h                    |  13 +-
 security/landlock/fs.c                        | 235 ++++++++++++++++--
 security/landlock/limits.h                    |   2 +-
 security/landlock/syscalls.c                  |   2 +-
 tools/testing/selftests/landlock/base_test.c  |   2 +-
 tools/testing/selftests/landlock/fs_test.c    |   4 +-
 .../selftests/landlock/trace_fs_test.c        |   3 +-
 10 files changed, 285 insertions(+), 41 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index e68dc17f23c4..a1a5bd83b507 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -19,6 +19,7 @@
 #include <linux/pagemap.h>
 #include <linux/compat.h>
 #include <linux/iversion.h>
+#include <linux/audit.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -361,6 +362,7 @@ static int vfs_statx_fd(int fd, int flags, struct kstat *stat,
 	CLASS(fd_raw, f)(fd);
 	if (fd_empty(f))
 		return -EBADF;
+	audit_file(fd_file(f));
 	return vfs_statx_path(&fd_file(f)->f_path, flags, stat, request_mask,
 			      fd_file(f));
 }
@@ -391,6 +393,18 @@ static int vfs_statx(int dfd, struct filename *filename, int flags,
 		      AT_STATX_SYNC_TYPE))
 		return -EINVAL;
 
+	/*
+	 * An empty pathname with AT_EMPTY_PATH refers to the file descriptor
+	 * itself.  Resolve it as such so that the struct file is passed down
+	 * to the LSM hooks, like sys_statx() does for a NULL pathname and
+	 * unlike a plain path lookup from the file descriptor.  This branch
+	 * replaces a path lookup, so vfs_statx_fd() keeps auditing the file
+	 * descriptor as that lookup would have.
+	 */
+	if ((flags & AT_EMPTY_PATH) && dfd >= 0 && !IS_ERR_OR_NULL(filename) &&
+	    !filename->name[0])
+		return vfs_statx_fd(dfd, flags, stat, request_mask);
+
 retry:
 	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
diff --git a/include/linux/landlock.h b/include/linux/landlock.h
index 0ee4880988ba..ee1234fbc9f0 100644
--- a/include/linux/landlock.h
+++ b/include/linux/landlock.h
@@ -41,7 +41,9 @@
 	_LANDLOCK_NAME_ENTRY(LANDLOCK_ACCESS_FS_REFER, "refer"), \
 	_LANDLOCK_NAME_ENTRY(LANDLOCK_ACCESS_FS_TRUNCATE, "truncate"), \
 	_LANDLOCK_NAME_ENTRY(LANDLOCK_ACCESS_FS_IOCTL_DEV, "ioctl_dev"), \
-	_LANDLOCK_NAME_ENTRY(LANDLOCK_ACCESS_FS_RESOLVE_UNIX, "resolve_unix")
+	_LANDLOCK_NAME_ENTRY(LANDLOCK_ACCESS_FS_RESOLVE_UNIX, "resolve_unix"), \
+	_LANDLOCK_NAME_ENTRY(LANDLOCK_ACCESS_FS_READ_METADATA, "read_metadata"), \
+	_LANDLOCK_NAME_ENTRY(LANDLOCK_ACCESS_FS_WRITE_METADATA, "write_metadata")
 
 #define _LANDLOCK_ACCESS_NET_NAMES \
 	_LANDLOCK_NAME_ENTRY(LANDLOCK_ACCESS_NET_BIND_TCP, "bind_tcp"), \
diff --git a/include/uapi/linux/landlock.h b/include/uapi/linux/landlock.h
index 7e38b9d1bf12..59838325c2af 100644
--- a/include/uapi/linux/landlock.h
+++ b/include/uapi/linux/landlock.h
@@ -430,10 +430,49 @@ struct landlock_capability_attr {
  *   The rationale for this design is described in
  *   :ref:`Documentation/security/landlock.rst <scoped-flags-interaction>`.
  *
+ * The following access rights apply to both files and directories:
+ *
+ * - %LANDLOCK_ACCESS_FS_READ_METADATA: Read file or directory metadata (e.g.
+ *   inode attributes, extended attributes, and POSIX ACLs) through
+ *   :manpage:`stat(2)`, :manpage:`fstat(2)`, :manpage:`lstat(2)`,
+ *   :manpage:`newfstatat(2)`, :manpage:`statx(2)`, :manpage:`getxattr(2)`,
+ *   and :manpage:`listxattr(2)`.
+ *
+ *   This access right is available since the thirteenth version of the
+ *   Landlock ABI.
+ * - %LANDLOCK_ACCESS_FS_WRITE_METADATA: Change file or directory metadata
+ *   (e.g. inode attributes, extended attributes, and POSIX ACLs) through
+ *   :manpage:`chmod(2)`, :manpage:`chown(2)`, :manpage:`utimensat(2)`,
+ *   :manpage:`setxattr(2)`, and :manpage:`removexattr(2)`, as well as related
+ *   system calls.  Metadata changes that the kernel performs implicitly on
+ *   behalf of another operation (e.g. timestamp updates with
+ *   :manpage:`write(2)`, or set-user-ID and set-group-ID bit clearing with
+ *   :manpage:`write(2)` or :manpage:`truncate(2)`) are not restricted by
+ *   this access right.
+ *
+ *   This access right is available since the thirteenth version of the
+ *   Landlock ABI.
+ *
  * Whether an opened file can be truncated with :manpage:`ftruncate(2)` or used
  * with `ioctl(2)` is determined during :manpage:`open(2)`, in the same way as
  * read and write permissions are checked during :manpage:`open(2)` using
- * %LANDLOCK_ACCESS_FS_READ_FILE and %LANDLOCK_ACCESS_FS_WRITE_FILE.
+ * %LANDLOCK_ACCESS_FS_READ_FILE and %LANDLOCK_ACCESS_FS_WRITE_FILE.  The same
+ * applies to metadata operations performed on an already opened file through
+ * its file descriptor (e.g. :manpage:`fstat(2)`, :manpage:`fchmod(2)`,
+ * :manpage:`fchown(2)`, :manpage:`futimens(2)`, :manpage:`fgetxattr(2)`,
+ * :manpage:`fsetxattr(2)`, the ``FS_IOC_GETFLAGS`` and ``FS_IOC_SETFLAGS``
+ * ioctls, and :manpage:`file_getattr(2)` and :manpage:`file_setattr(2)` with
+ * ``AT_EMPTY_PATH``): these are authorized with
+ * %LANDLOCK_ACCESS_FS_READ_METADATA and %LANDLOCK_ACCESS_FS_WRITE_METADATA at
+ * :manpage:`open(2)` time.  O_PATH file descriptors are an exception: they do
+ * not record any access right at :manpage:`open(2)` time, so metadata
+ * operations performed through them are checked against the Landlock domain
+ * of the calling thread instead.  Only the metadata system calls that accept
+ * O_PATH file descriptors behave that way, e.g. fstat(2), and statx(2),
+ * fchmodat(2), fchownat(2) or utimensat(2) with an empty path; the other
+ * file descriptor based metadata system calls and the
+ * FS_IOC_GETFLAGS and FS_IOC_SETFLAGS ioctls reject O_PATH file descriptors
+ * with EBADF.
  *
  * A directory can receive access rights related to files or directories.  The
  * following access right is applied to the directory itself, and the
@@ -494,9 +533,7 @@ struct landlock_capability_attr {
  *
  *   It is currently not possible to restrict some file-related actions
  *   accessible through these syscall families: :manpage:`chdir(2)`,
- *   :manpage:`stat(2)`, :manpage:`flock(2)`, :manpage:`chmod(2)`,
- *   :manpage:`chown(2)`, :manpage:`setxattr(2)`, :manpage:`utime(2)`,
- *   :manpage:`fcntl(2)`, :manpage:`access(2)`.
+ *   :manpage:`flock(2)`, :manpage:`fcntl(2)`, :manpage:`access(2)`.
  *   Future Landlock evolutions will enable to restrict them.
  */
 /* clang-format off */
@@ -517,6 +554,8 @@ struct landlock_capability_attr {
 #define LANDLOCK_ACCESS_FS_TRUNCATE			(1ULL << 14)
 #define LANDLOCK_ACCESS_FS_IOCTL_DEV			(1ULL << 15)
 #define LANDLOCK_ACCESS_FS_RESOLVE_UNIX			(1ULL << 16)
+#define LANDLOCK_ACCESS_FS_READ_METADATA		(1ULL << 17)
+#define LANDLOCK_ACCESS_FS_WRITE_METADATA		(1ULL << 18)
 /* clang-format on */
 
 /**
diff --git a/security/landlock/access.h b/security/landlock/access.h
index 72afd236f883..10e7b6d35545 100644
--- a/security/landlock/access.h
+++ b/security/landlock/access.h
@@ -30,7 +30,9 @@
 /* clang-format off */
 #define _LANDLOCK_ACCESS_FS_OPTIONAL ( \
 	LANDLOCK_ACCESS_FS_TRUNCATE | \
-	LANDLOCK_ACCESS_FS_IOCTL_DEV)
+	LANDLOCK_ACCESS_FS_IOCTL_DEV | \
+	LANDLOCK_ACCESS_FS_READ_METADATA | \
+	LANDLOCK_ACCESS_FS_WRITE_METADATA)
 /* clang-format on */
 
 typedef u32 access_mask_t;
@@ -155,11 +157,12 @@ struct layer_masks {
  * required by update_request().
  *
  * Each nibble represents the layer index of the newest layer which denied a
- * certain access right.  For file system access rights, the upper four bits are
- * the index of the layer which denies LANDLOCK_ACCESS_FS_IOCTL_DEV and the
- * lower nibble represents LANDLOCK_ACCESS_FS_TRUNCATE.
+ * certain access right.  For file system access rights, the nibbles from the
+ * least to the most significant one represent the layers which deny
+ * LANDLOCK_ACCESS_FS_TRUNCATE, LANDLOCK_ACCESS_FS_IOCTL_DEV,
+ * LANDLOCK_ACCESS_FS_READ_METADATA and LANDLOCK_ACCESS_FS_WRITE_METADATA.
  */
-typedef u8 deny_masks_t;
+typedef u16 deny_masks_t;
 
 /*
  * Makes sure all optional access rights can be tied to a layer index (cf.
diff --git a/security/landlock/fs.c b/security/landlock/fs.c
index 2ab67bcad198..7d0e539b4cda 100644
--- a/security/landlock/fs.c
+++ b/security/landlock/fs.c
@@ -318,6 +318,8 @@ static struct landlock_object *get_inode_object(struct inode *const inode)
 	LANDLOCK_ACCESS_FS_EXECUTE | \
 	LANDLOCK_ACCESS_FS_WRITE_FILE | \
 	LANDLOCK_ACCESS_FS_READ_FILE | \
+	LANDLOCK_ACCESS_FS_READ_METADATA | \
+	LANDLOCK_ACCESS_FS_WRITE_METADATA | \
 	LANDLOCK_ACCESS_FS_TRUNCATE | \
 	LANDLOCK_ACCESS_FS_IOCTL_DEV | \
 	LANDLOCK_ACCESS_FS_RESOLVE_UNIX)
@@ -1676,6 +1678,195 @@ static int hook_path_truncate(const struct path *const path)
 	return current_check_access_path(path, LANDLOCK_ACCESS_FS_TRUNCATE);
 }
 
+static int check_access_file(const struct file *const file,
+			     const access_mask_t access)
+{
+	/*
+	 * O_PATH file descriptors do not go through the open permission
+	 * checks (cf. do_dentry_open()) and therefore do not carry the
+	 * access rights stashed at open time: they are checked against the
+	 * current domain, like path-based accesses.
+	 */
+	if (unlikely(file->f_mode & FMODE_PATH))
+		return current_check_access_path(&file->f_path, access);
+
+	/*
+	 * Allows accesses if the requested access right was available at the
+	 * time of opening the file, to get a consistent access check as for
+	 * read, write and execute operations.
+	 *
+	 * Note: For checks done based on the file's Landlock allowed access,
+	 * we enforce them independently of whether the current thread is in
+	 * a Landlock domain, so that open files passed between independent
+	 * processes retain their behaviour.
+	 */
+	if (landlock_file(file)->allowed_access & access)
+		return 0;
+
+	landlock_log_denial(landlock_cred(file->f_cred), &(struct landlock_request) {
+		.type = LANDLOCK_REQUEST_FS_ACCESS,
+		.audit = {
+			.type = LSM_AUDIT_DATA_FILE,
+			.u.file = file,
+		},
+		.all_existing_optional_access = _LANDLOCK_ACCESS_FS_OPTIONAL,
+		.access = access,
+#ifdef CONFIG_SECURITY_LANDLOCK_LOG
+		.deny_masks = landlock_file(file)->deny_masks,
+		.quiet_optional_accesses = landlock_file(file)->quiet_optional_accesses,
+#endif /* CONFIG_SECURITY_LANDLOCK_LOG */
+	});
+	return -EACCES;
+}
+
+static int check_access_path_or_file(const struct path *const path,
+				     const struct file *const file,
+				     const access_mask_t access)
+{
+	if (file)
+		return check_access_file(file, access);
+
+	return current_check_access_path(path, access);
+}
+
+static int hook_path_getattr(const struct path *const path,
+			     struct file *const file)
+{
+	return check_access_path_or_file(path, file,
+					 LANDLOCK_ACCESS_FS_READ_METADATA);
+}
+
+static int hook_path_file_getattr(const struct path *const path,
+				  struct file_kattr *const fa,
+				  struct file *const file)
+{
+	return check_access_path_or_file(path, file,
+					 LANDLOCK_ACCESS_FS_READ_METADATA);
+}
+
+static int hook_path_setattr(const struct mnt_idmap *const idmap,
+			     const struct path *const path,
+			     struct dentry *const dentry,
+			     struct iattr *const attr,
+			     struct file *const file)
+{
+	unsigned int ia_valid = attr->ia_valid;
+
+	/*
+	 * Only explicit metadata changes are checked: implicit
+	 * timestamp updates never go through notify_change(), and size
+	 * changes (ATTR_SIZE) are governed by the truncate hooks
+	 * instead.
+	 *
+	 * The setuid/setgid bit and file capability clearing that the
+	 * kernel performs after write(2) or truncate(2) is an implicit
+	 * change as well: it comes through __remove_privs() and
+	 * do_truncate() with ATTR_FORCE set, and do_notify_change() then
+	 * adds a synthesized ATTR_MODE (with these bits removed) before
+	 * calling this hook.  As do_notify_change() makes it a bug for
+	 * callers to pass ATTR_MODE together with a kill flag, an
+	 * ATTR_MODE seen along with ATTR_FORCE is always
+	 * kernel-synthesized and must not be checked.  An explicit
+	 * chown(2) does not set ATTR_FORCE, so the same clearing
+	 * requested through chown(2), including chown(2) with
+	 * (-1, -1) on a privileged file, is still checked through the
+	 * synthesized ATTR_MODE or the remaining ATTR_KILL_PRIV.  A
+	 * chown(2) that changes nothing (e.g. with (-1, -1) on a file
+	 * without privilege bits or file capabilities) sets neither a
+	 * changed attribute nor a kill flag, and is not checked.
+	 */
+	if (ia_valid & ATTR_FORCE)
+		ia_valid &= ~(ATTR_KILL_SUID | ATTR_KILL_SGID |
+			      ATTR_KILL_PRIV | ATTR_MODE);
+
+	if (!(ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID |
+			  ATTR_TIMES_SET | ATTR_TOUCH | ATTR_KILL_PRIV)))
+		return 0;
+
+	return check_access_path_or_file(path, file,
+					 LANDLOCK_ACCESS_FS_WRITE_METADATA);
+}
+
+static int hook_path_file_setattr(const struct path *const path,
+				  struct file_kattr *const fa,
+				  struct file *const file)
+{
+	/*
+	 * The chattr(2) style flags (e.g. FS_IMMUTABLE_FL) and fsxattr
+	 * fields are metadata: writing them requires WRITE_METADATA.  The
+	 * user-facing path is checked here.  Stacking filesystems that
+	 * forward the operation with their own credentials (e.g. overlayfs)
+	 * are not restricted again, unlike the ones that use the caller's
+	 * credentials (e.g. eCryptfs), which are checked on the lower path
+	 * as well.
+	 */
+	return check_access_path_or_file(path, file,
+					 LANDLOCK_ACCESS_FS_WRITE_METADATA);
+}
+
+static int hook_path_setxattr(const struct mnt_idmap *const idmap,
+			       const struct path *const path,
+			       const char *const name,
+			       const void *const value, const size_t size,
+			       const int flags,
+			       struct file *const file)
+{
+	return check_access_path_or_file(path, file,
+					 LANDLOCK_ACCESS_FS_WRITE_METADATA);
+}
+
+static int hook_path_getxattr(const struct path *const path,
+			      const char *const name,
+			      struct file *const file)
+{
+	return check_access_path_or_file(path, file,
+					 LANDLOCK_ACCESS_FS_READ_METADATA);
+}
+
+static int hook_path_listxattr(const struct path *const path,
+			       struct file *const file)
+{
+	return check_access_path_or_file(path, file,
+					 LANDLOCK_ACCESS_FS_READ_METADATA);
+}
+
+static int hook_path_removexattr(const struct mnt_idmap *const idmap,
+				  const struct path *const path,
+				  const char *const name,
+				  struct file *const file)
+{
+	return check_access_path_or_file(path, file,
+					 LANDLOCK_ACCESS_FS_WRITE_METADATA);
+}
+
+static int hook_path_set_acl(const struct mnt_idmap *const idmap,
+			      const struct path *const path,
+			      const char *const acl_name,
+			      struct posix_acl *const kacl,
+			      struct file *const file)
+{
+	return check_access_path_or_file(path, file,
+					 LANDLOCK_ACCESS_FS_WRITE_METADATA);
+}
+
+static int hook_path_get_acl(const struct mnt_idmap *const idmap,
+			      const struct path *const path,
+			      const char *const acl_name,
+			      struct file *const file)
+{
+	return check_access_path_or_file(path, file,
+					 LANDLOCK_ACCESS_FS_READ_METADATA);
+}
+
+static int hook_path_remove_acl(const struct mnt_idmap *const idmap,
+				const struct path *const path,
+				const char *const acl_name,
+				struct file *const file)
+{
+	return check_access_path_or_file(path, file,
+					 LANDLOCK_ACCESS_FS_WRITE_METADATA);
+}
+
 /**
  * unmask_scoped_access - Remove access right bits in @masks in all layers
  *                        where @client and @server have the same domain
@@ -1876,7 +2067,9 @@ static int hook_file_open(struct file *const file)
 	 * We look up more access than what we immediately need for open(), so
 	 * that we can later authorize operations on opened files.
 	 */
-	optional_access = LANDLOCK_ACCESS_FS_TRUNCATE;
+	optional_access = LANDLOCK_ACCESS_FS_TRUNCATE |
+			  LANDLOCK_ACCESS_FS_READ_METADATA |
+			  LANDLOCK_ACCESS_FS_WRITE_METADATA;
 	if (is_device(file))
 		optional_access |= LANDLOCK_ACCESS_FS_IOCTL_DEV;
 
@@ -1928,32 +2121,11 @@ static int hook_file_open(struct file *const file)
 static int hook_file_truncate(struct file *const file)
 {
 	/*
-	 * Allows truncation if the truncate right was available at the time of
-	 * opening the file, to get a consistent access check as for read, write
-	 * and execute operations.
-	 *
-	 * Note: For checks done based on the file's Landlock allowed access, we
-	 * enforce them independently of whether the current thread is in a
-	 * Landlock domain, so that open files passed between independent
-	 * processes retain their behaviour.
+	 * Allows truncation if the truncate right was available at the time
+	 * of opening the file, to get a consistent access check as for read,
+	 * write and execute operations.
 	 */
-	if (landlock_file(file)->allowed_access & LANDLOCK_ACCESS_FS_TRUNCATE)
-		return 0;
-
-	landlock_log_denial(landlock_cred(file->f_cred), &(struct landlock_request) {
-		.type = LANDLOCK_REQUEST_FS_ACCESS,
-		.audit = {
-			.type = LSM_AUDIT_DATA_FILE,
-			.u.file = file,
-		},
-		.all_existing_optional_access = _LANDLOCK_ACCESS_FS_OPTIONAL,
-		.access = LANDLOCK_ACCESS_FS_TRUNCATE,
-#ifdef CONFIG_SECURITY_LANDLOCK_LOG
-		.deny_masks = landlock_file(file)->deny_masks,
-		.quiet_optional_accesses = landlock_file(file)->quiet_optional_accesses,
-#endif /* CONFIG_SECURITY_LANDLOCK_LOG */
-	});
-	return -EACCES;
+	return check_access_file(file, LANDLOCK_ACCESS_FS_TRUNCATE);
 }
 
 static int hook_file_ioctl_common(const struct file *const file,
@@ -2100,6 +2272,17 @@ static struct security_hook_list landlock_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(path_unlink, hook_path_unlink),
 	LSM_HOOK_INIT(path_rmdir, hook_path_rmdir),
 	LSM_HOOK_INIT(path_truncate, hook_path_truncate),
+	LSM_HOOK_INIT(path_getattr, hook_path_getattr),
+	LSM_HOOK_INIT(path_file_getattr, hook_path_file_getattr),
+	LSM_HOOK_INIT(path_setattr, hook_path_setattr),
+	LSM_HOOK_INIT(path_file_setattr, hook_path_file_setattr),
+	LSM_HOOK_INIT(path_setxattr, hook_path_setxattr),
+	LSM_HOOK_INIT(path_getxattr, hook_path_getxattr),
+	LSM_HOOK_INIT(path_listxattr, hook_path_listxattr),
+	LSM_HOOK_INIT(path_removexattr, hook_path_removexattr),
+	LSM_HOOK_INIT(path_set_acl, hook_path_set_acl),
+	LSM_HOOK_INIT(path_get_acl, hook_path_get_acl),
+	LSM_HOOK_INIT(path_remove_acl, hook_path_remove_acl),
 	LSM_HOOK_INIT(unix_find, hook_unix_find),
 
 	LSM_HOOK_INIT(file_alloc_security, hook_file_alloc_security),
diff --git a/security/landlock/limits.h b/security/landlock/limits.h
index ddd300e10689..ed606ee3102f 100644
--- a/security/landlock/limits.h
+++ b/security/landlock/limits.h
@@ -21,7 +21,7 @@
 #define LANDLOCK_MAX_NUM_LAYERS		16
 #define LANDLOCK_MAX_NUM_RULES		U32_MAX
 
-#define LANDLOCK_LAST_ACCESS_FS		LANDLOCK_ACCESS_FS_RESOLVE_UNIX
+#define LANDLOCK_LAST_ACCESS_FS		LANDLOCK_ACCESS_FS_WRITE_METADATA
 #define LANDLOCK_MASK_ACCESS_FS		((LANDLOCK_LAST_ACCESS_FS << 1) - 1)
 #define LANDLOCK_NUM_ACCESS_FS		__const_hweight64(LANDLOCK_MASK_ACCESS_FS)
 
diff --git a/security/landlock/syscalls.c b/security/landlock/syscalls.c
index fb5af318b69b..11d3a2abcec1 100644
--- a/security/landlock/syscalls.c
+++ b/security/landlock/syscalls.c
@@ -191,7 +191,7 @@ static const struct file_operations ruleset_fops = {
  * If the change involves a fix that requires userspace awareness, also update
  * the errata documentation in Documentation/userspace-api/landlock.rst .
  */
-const int landlock_abi_version = 12;
+const int landlock_abi_version = 13;
 
 /**
  * sys_landlock_create_ruleset - Create a new ruleset
diff --git a/tools/testing/selftests/landlock/base_test.c b/tools/testing/selftests/landlock/base_test.c
index 89c0d96607de..14078ad203d8 100644
--- a/tools/testing/selftests/landlock/base_test.c
+++ b/tools/testing/selftests/landlock/base_test.c
@@ -76,7 +76,7 @@ TEST(abi_version)
 	const struct landlock_ruleset_attr ruleset_attr = {
 		.handled_access_fs = LANDLOCK_ACCESS_FS_READ_FILE,
 	};
-	ASSERT_EQ(12, landlock_create_ruleset(NULL, 0,
+	ASSERT_EQ(13, landlock_create_ruleset(NULL, 0,
 					      LANDLOCK_CREATE_RULESET_VERSION));
 
 	ASSERT_EQ(-1, landlock_create_ruleset(&ruleset_attr, 0,
diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 48c1f896dc9a..2593db7ef25c 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -571,11 +571,13 @@ TEST_F_FORK(layout1, inval)
 	LANDLOCK_ACCESS_FS_EXECUTE | \
 	LANDLOCK_ACCESS_FS_WRITE_FILE | \
 	LANDLOCK_ACCESS_FS_READ_FILE | \
+	LANDLOCK_ACCESS_FS_READ_METADATA | \
+	LANDLOCK_ACCESS_FS_WRITE_METADATA | \
 	LANDLOCK_ACCESS_FS_TRUNCATE | \
 	LANDLOCK_ACCESS_FS_IOCTL_DEV | \
 	LANDLOCK_ACCESS_FS_RESOLVE_UNIX)
 
-#define ACCESS_LAST LANDLOCK_ACCESS_FS_RESOLVE_UNIX
+#define ACCESS_LAST LANDLOCK_ACCESS_FS_WRITE_METADATA
 
 #define ACCESS_ALL ( \
 	ACCESS_FILE | \
diff --git a/tools/testing/selftests/landlock/trace_fs_test.c b/tools/testing/selftests/landlock/trace_fs_test.c
index 64014ade3a0e..97506d249c4f 100644
--- a/tools/testing/selftests/landlock/trace_fs_test.c
+++ b/tools/testing/selftests/landlock/trace_fs_test.c
@@ -252,7 +252,8 @@ TEST_F(trace_fs, add_rule_path_beneath)
 TEST_F(trace_fs, add_rule_path_beneath_escaped_path_overflow)
 {
 	static const char access_prefix[] = "execute|write_file|read_file|";
-	static const char access_suffix[] = "|ioctl_dev|resolve_unix";
+	static const char access_suffix[] =
+		"|ioctl_dev|resolve_unix|read_metadata|write_metadata";
 	struct landlock_ruleset_attr ruleset_attr = {
 		.handled_access_fs = LANDLOCK_ACCESS_FS_READ_FILE,
 	};
-- 
2.18.0.huawei.25

