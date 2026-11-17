Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.220
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926101;
	b=woxU/xcs1Fk2HxDDHpNnj90SHVDcpaG7AAD8XgEHzO9y1g2RlRzlXh0Hd8e+8Imtquku
	 28pJ/xooZ5/OeXSOq4pBLqWcNLZyvT41/6SD5NDoIAvX8CrkvqW0LNQMmcMFbZWxMAzr7
	 QsTAk/cVgYng9B0+enqYiRW3hY3TVFk6U8VfHPlEkQsqw71c2WfPyM9RaKy43oPFkcy7v
	 6EqTVmxhTpZ+jP/P93jYm8Bj+kLKII49GYHah42BHYFvuRq1hMDFN63Z24Kd7KsQ1ceda
	 SDgzs4GZngTaABCSlhyCVnOZC77Y25NZYMk3HPsaICT+GTsnZXgDXTyPfzAJr+J9RkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926101;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=oUeL2OYGRrmUqOr+vX/qVkuVNBKWD8szUYft8PgT9+8=;
	b=XdnVu4Sd0DCggXKvgvNbhzq0SqFF/ZnMnRI3OTVih8Jtl4ylIGuQEfC/9XbLMqk7C+4u
	 QGVVXn+XhLkUZQOLBzuKUgWcxcTzODYQOTeOtkCVeuX7BkeLHE8oSadHg5S0S4sOtpSeQ
	 UZlfIW6zR0JlaB+ojk5KE8ZnjLpmvQ9DgQIRsXSwA08Vp3qCgpRulGmr6FWf5QuJFjciC
	 OVrVZxcL9EG+Ha8E9LXtpF1vMCCtBEky7FhbDOArI4AH42Sod1qz8pEVK4k/zNEDoaySh
	 L8fXohhjVuyhuYTFdfRJCwhruJO4grN5VrxcMw24B3HAZZL37vi+tCtXMFo3WlQCLHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=eohoCTlB;
	arc=none smtp.remote-ip=113.46.200.220
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2896074917;
	Tue, 17 Nov 2026 14:35:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A2896074917
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=eohoCTlB
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=oUeL2OYGRrmUqOr+vX/qVkuVNBKWD8szUYft8PgT9+8=;
	b=eohoCTlB2EIhXi+ewW+XKEqOdvBDn6Rrsrmr9Kn5t5St9JqqpV913wAAnhmwJh4+HvB/PecZv
	/e0ZLkqaqYq5tn9tmIPG9zIT+wg/d6Rlli36jENtRgsXSMICASpSKXjz4vHglw5HcmWtRUyR/gp
	IPaRLndTI9S6R9Vn5xnWqNQ=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4jTS0Y3MVqz12LFR;
	Tue, 17 Nov 2026 22:34:05 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 1A0AF40685;
	Tue, 17 Nov 2026 22:34:58 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:34:52 +0800
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
Subject: [PATCH -next -v4 17/17] Documentation: Update landlock doc for metadata rights
Date: Tue, 17 Nov 2026 23:05:42 +0800
Message-ID: <20261117150542.1169451-18-caixinchen1@huawei.com>
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

Document the two new access rights: add them to the example ruleset and
to the ABI fallback switch, and describe their semantics in a new "File
metadata" section, including the open-time semantic, the exclusion of
implicit changes and the chown(2) special case, and the warning that
READ_METADATA usually needs to be granted together with READ_FILE and
READ_DIR.

Also rename the "Bind mounts and OverlayFS" section to "Bind mounts and
stacking filesystems" and describe how eCryptfs forwards attribute
changes under the caller's credentials, which causes the lower path to be
checked as well, and extend the blockers list in
Documentation/admin-guide/LSM/landlock.rst.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 Documentation/admin-guide/LSM/landlock.rst |   2 +
 Documentation/userspace-api/landlock.rst   | 148 ++++++++++++++++++---
 2 files changed, 135 insertions(+), 15 deletions(-)

diff --git a/Documentation/admin-guide/LSM/landlock.rst b/Documentation/admin-guide/LSM/landlock.rst
index 946f3bf89650..86f8c7cbdacb 100644
--- a/Documentation/admin-guide/LSM/landlock.rst
+++ b/Documentation/admin-guide/LSM/landlock.rst
@@ -56,6 +56,8 @@ AUDIT_LANDLOCK_ACCESS
         - fs.truncate (ABI 3+)
         - fs.ioctl_dev (ABI 5+)
         - fs.resolve_unix (ABI 9+)
+        - fs.read_metadata (ABI 13+)
+        - fs.write_metadata (ABI 13+)
 
     **net.*** - Network access rights (ABI 4+):
         - net.bind_tcp - TCP port binding was denied
diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
index 24cfc2c23cb2..3aab4197319b 100644
--- a/Documentation/userspace-api/landlock.rst
+++ b/Documentation/userspace-api/landlock.rst
@@ -87,7 +87,9 @@ to be explicit about the denied-by-default access rights.
             LANDLOCK_ACCESS_FS_REFER |
             LANDLOCK_ACCESS_FS_TRUNCATE |
             LANDLOCK_ACCESS_FS_IOCTL_DEV |
-            LANDLOCK_ACCESS_FS_RESOLVE_UNIX,
+            LANDLOCK_ACCESS_FS_RESOLVE_UNIX |
+            LANDLOCK_ACCESS_FS_READ_METADATA |
+            LANDLOCK_ACCESS_FS_WRITE_METADATA,
         .handled_access_net =
             LANDLOCK_ACCESS_NET_BIND_TCP |
             LANDLOCK_ACCESS_NET_CONNECT_TCP |
@@ -159,6 +161,12 @@ version, and only use the available subset of access rights:
         ruleset_attr.handled_permissions &=
             ~(LANDLOCK_PERMISSION_NAMESPACE_USE |
               LANDLOCK_PERMISSION_CAPABILITY_USE);
+        __attribute__((fallthrough));
+    case 12:
+        /* Removes metadata rights for ABI < 13 */
+        ruleset_attr.handled_access_fs &=
+            ~(LANDLOCK_ACCESS_FS_READ_METADATA |
+              LANDLOCK_ACCESS_FS_WRITE_METADATA);
     }
 
 This enables the creation of an inclusive ruleset that will contain our rules.
@@ -175,10 +183,12 @@ This enables the creation of an inclusive ruleset that will contain our rules.
 
 We can now add a new rule to this ruleset thanks to the returned file
 descriptor referring to this ruleset.  The rule will allow reading and
-executing the file hierarchy ``/usr``.  Without another rule, write actions
-would then be denied by the ruleset.  To add ``/usr`` to the ruleset, we open
-it with the ``O_PATH`` flag and fill the &struct landlock_path_beneath_attr with
-this file descriptor.
+executing the file hierarchy ``/usr``, as well as reading its metadata (e.g.
+with :manpage:`stat(2)`): most programs do not expect metadata reads to fail
+and read metadata alongside file contents and directory listings.  Without
+another rule, write actions would then be denied by the ruleset.  To add
+``/usr`` to the ruleset, we open it with the ``O_PATH`` flag and fill the
+&struct landlock_path_beneath_attr with this file descriptor.
 
 .. code-block:: c
 
@@ -187,7 +197,8 @@ this file descriptor.
         .allowed_access =
             LANDLOCK_ACCESS_FS_EXECUTE |
             LANDLOCK_ACCESS_FS_READ_FILE |
-            LANDLOCK_ACCESS_FS_READ_DIR,
+            LANDLOCK_ACCESS_FS_READ_DIR |
+            LANDLOCK_ACCESS_FS_READ_METADATA,
     };
 
     path_beneath.allowed_access &= ruleset_attr.handled_access_fs;
@@ -359,8 +370,8 @@ no_new_privs should only be left unset if such a privilege transition is
 expected.
 
 We now have a ruleset with the first rule allowing read and execute access to
-``/usr`` while denying all other handled accesses for the filesystem, and two
-more rules allowing DNS queries.
+``/usr``, including reading its metadata, while denying all other handled
+accesses for the filesystem, and two more rules allowing DNS queries.
 
 .. code-block:: c
 
@@ -432,8 +443,8 @@ a file path if all its enforced policy layers grant the access as well as all
 the other system access controls (e.g. filesystem DAC, other LSM policies,
 etc.).
 
-Bind mounts and OverlayFS
--------------------------
+Bind mounts and stacking filesystems
+------------------------------------
 
 Landlock enables restricting access to file hierarchies, which means that these
 access rights can be propagated with bind mounts (cf.
@@ -458,6 +469,23 @@ OverlayFS layer will not restrict the resulted merged hierarchy, and vice versa.
 Landlock users should then only think about file hierarchies they want to allow
 access to, regardless of the underlying filesystem.
 
+eCryptfs is another stacking filesystem, but unlike OverlayFS it forwards some
+metadata changes to the lower filesystem under the credentials of the calling
+thread.  Forwarded attribute changes (:manpage:`chmod(2)`, :manpage:`chown(2)`,
+:manpage:`utimensat(2)`) are checked a second time, against the current
+Landlock domain, on the lower path, in addition to the check performed on the
+eCryptfs path.  The first check follows the usual semantics, including the
+open-time rights of file descriptor-based operations, but the forwarded one
+always uses the rights of the calling thread.  A sandboxed process changing
+attributes through an eCryptfs mount may therefore also need the corresponding
+metadata access rights on the lower path, even when the file descriptor was
+opened before the ruleset was enforced.  Extended attribute reads and removals
+are forwarded with the unchecked ``__vfs_getxattr()``, ``i_op->listxattr`` and
+``__vfs_removexattr()`` helpers and are only checked once, on the eCryptfs
+path, whereas setting an extended attribute, and reading or changing POSIX
+ACLs and file attributes, are forwarded with the checking helpers and are
+therefore checked on the lower path as well.
+
 Inheritance
 -----------
 
@@ -669,14 +697,91 @@ for writing, sidestepping the ``LANDLOCK_ACCESS_FS_TRUNCATE`` right.
 
 The truncate right is associated with the opened file (see below).
 
+File metadata
+-------------
+
+The ``LANDLOCK_ACCESS_FS_READ_METADATA`` right governs reading file and
+directory metadata: :manpage:`stat(2)` and friends, :manpage:`getxattr(2)`,
+:manpage:`listxattr(2)` and friends, the ``FS_IOC_GETFLAGS`` and
+``FS_IOC_FSGETXATTR`` ioctls, :manpage:`file_getattr(2)`, and POSIX ACL reads.
+Path-based checks also cover the metadata lookups that the kernel performs on
+behalf of the caller, for example when the ``LOOP_GET_STATUS`` ioctl reads
+the attributes of a loop device's backing file: a sandbox may therefore need
+to grant access to such paths as well.
+
+The ``LANDLOCK_ACCESS_FS_WRITE_METADATA`` right governs explicit changes to
+file and directory metadata: :manpage:`chmod(2)` and friends,
+:manpage:`chown(2)` and friends, :manpage:`utimensat(2)`,
+:manpage:`setxattr(2)`, :manpage:`removexattr(2)` and friends, the
+``FS_IOC_SETFLAGS`` and ``FS_IOC_FSSETXATTR`` ioctls,
+:manpage:`file_setattr(2)`, and POSIX ACL changes.  Both rights apply to files
+and directories alike.
+
+Metadata changes that the kernel performs implicitly on behalf of another
+operation are not restricted by ``LANDLOCK_ACCESS_FS_WRITE_METADATA``:
+reading a file may update its access time, writing a file updates its
+modification and change times and may change the file size, and writing to
+or truncating a file with a set-user-ID or set-group-ID bit clears these
+bits unless the caller holds ``CAP_FSETID`` (the set-group-ID bit is only
+cleared on a group-executable file whose group the caller is not a member
+of).  File size changes through
+:manpage:`truncate(2)` and friends are governed by
+``LANDLOCK_ACCESS_FS_TRUNCATE`` instead.
+
+``LANDLOCK_ACCESS_FS_WRITE_METADATA`` also governs the clearing of
+set-user-ID bits, set-group-ID bits and file capabilities requested by an
+explicit :manpage:`chown(2)`, whereas the same clearing performed implicitly
+after a write is not restricted.  A :manpage:`chown(2)` with owner and group
+``-1`` on a file without a set-user-ID bit, without file capabilities, and
+without a set-group-ID bit that the call would clear (as described above)
+changes nothing that ``LANDLOCK_ACCESS_FS_WRITE_METADATA`` governs, and is
+not restricted.
+
+.. warning::
+
+   Many programs read metadata as part of reading file contents or listing
+   directories (e.g. calling :manpage:`stat(2)` before or after
+   :manpage:`open(2)`), and do not expect such calls to fail with
+   ``EACCES``.  Most of the time, ``LANDLOCK_ACCESS_FS_READ_METADATA``
+   should therefore be granted together with
+   ``LANDLOCK_ACCESS_FS_READ_FILE`` and ``LANDLOCK_ACCESS_FS_READ_DIR``.
+   Conversely, denying only ``LANDLOCK_ACCESS_FS_READ_FILE`` or
+   ``LANDLOCK_ACCESS_FS_READ_DIR`` does not hide metadata: it remains
+   readable through :manpage:`stat(2)` and friends unless
+   ``LANDLOCK_ACCESS_FS_READ_METADATA`` is denied as well.  Tailored
+   programs that do not read metadata at all can still deny this right to
+   further restrict their sandbox.
+
+Both metadata rights are associated with opened files, like
+``LANDLOCK_ACCESS_FS_TRUNCATE`` (see below): metadata accesses and changes
+requested through an already opened file descriptor, e.g. with
+:manpage:`fchmod(2)`, :manpage:`fchown(2)`, :manpage:`utimensat(2)` on an
+empty path, :manpage:`fstat(2)`, :manpage:`fgetxattr(2)`,
+:manpage:`fsetxattr(2)`, :manpage:`ioctl(2)` with ``FS_IOC_GETFLAGS`` or
+``FS_IOC_SETFLAGS``, or ``file_getattr(2)`` and ``file_setattr(2)`` with
+``AT_EMPTY_PATH``, are granted according to the rights available at
+:manpage:`open(2)` time, not according to the rights of the calling thread.
+Metadata accesses requested through a path (e.g. :manpage:`chmod(2)`,
+:manpage:`stat(2)`) are always checked against the rights of the calling
+thread.  ``O_PATH`` file descriptors are not opened through the open
+permission checks: the metadata system calls that accept such descriptors
+(e.g. :manpage:`fstat(2)`, and :manpage:`statx(2)`, :manpage:`fchmodat(2)`,
+:manpage:`fchownat(2)` or :manpage:`utimensat(2)` with an empty path) are
+checked against the rights of the calling thread as well, while the other file
+descriptor based metadata system calls and the
+``FS_IOC_GETFLAGS``/``FS_IOC_SETFLAGS`` ioctls reject ``O_PATH`` descriptors
+with ``EBADF``.
+
 Rights associated with file descriptors
 ---------------------------------------
 
-When opening a file, the availability of the ``LANDLOCK_ACCESS_FS_TRUNCATE`` and
-``LANDLOCK_ACCESS_FS_IOCTL_DEV`` rights is associated with the newly created
-file descriptor and will be used for subsequent truncation and ioctl attempts
-using :manpage:`ftruncate(2)` and :manpage:`ioctl(2)`.  The behavior is similar
-to opening a file for reading or writing, where permissions are checked during
+When opening a file, the availability of the ``LANDLOCK_ACCESS_FS_TRUNCATE``,
+``LANDLOCK_ACCESS_FS_IOCTL_DEV``, ``LANDLOCK_ACCESS_FS_READ_METADATA`` and
+``LANDLOCK_ACCESS_FS_WRITE_METADATA`` rights is associated with the newly
+created file descriptor and will be used for subsequent truncation, ioctl
+and metadata attempts using :manpage:`ftruncate(2)`, :manpage:`ioctl(2)` and
+the file descriptor-based metadata system calls.  The behavior is similar to
+opening a file for reading or writing, where permissions are checked during
 :manpage:`open(2)`, but not during the subsequent :manpage:`read(2)` and
 :manpage:`write(2)` calls.
 
@@ -1054,6 +1159,19 @@ fd-reference acquisition (:manpage:`open_tree(2)`, :manpage:`fsmount(2)`) with
 the new ``LANDLOCK_PERMISSION_NAMESPACE_USE`` permission flag and
 ``LANDLOCK_RULE_NAMESPACE`` rule type.
 
+File metadata (ABI < 13)
+------------------------
+
+Starting with the Landlock ABI version 13, it is possible to restrict
+file metadata access with the new ``LANDLOCK_ACCESS_FS_READ_METADATA``
+and ``LANDLOCK_ACCESS_FS_WRITE_METADATA`` access rights, which control
+reading file and directory metadata (e.g. with :manpage:`stat(2)` and
+:manpage:`getxattr(2)`) and changing it (e.g. with :manpage:`chmod(2)`
+and :manpage:`setxattr(2)`).  As with ``LANDLOCK_ACCESS_FS_TRUNCATE``,
+these rights are tied to opened files: metadata accesses through an
+already opened file descriptor are granted according to the rights
+available at :manpage:`open(2)` time.
+
 .. _kernel_support:
 
 Kernel support
-- 
2.18.0.huawei.25

