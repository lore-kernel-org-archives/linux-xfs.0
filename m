Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926096;
	b=Y8P51PZZodn+TE5jknAlKtZfbTmRzL6twDgwDNtYiDlDtb17NAgQEBEtM/SqzVpc7alg
	 GC4Rm+/97SmBeugH7p5JODZIhoIfOp4xO2K8FUPgRJ9Dk1bwfZ0nmI26u4FFmYCyc5/bc
	 HOvNHbm4Q59nfAyo0RV5t/94KcnE63b/+sWtfYiW8k11pY6IjXK0CjPgNXgAnWq8vp3+B
	 0ZjNdzFhpa2VFZd7e6Wr7jsRTE0tvaDB9Bb7vtBPlfHOq4AVvlZCIYQorNRy7VO9fItAL
	 hC6qi5ODNhcDyatCwhJdgW5Ao9BVCqIZvkTc7L/aWKtwNfTjmrtU+3+9C6f3FVhycEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926096;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=msllHZEApp54KuI+5jaT9flmvof2Z7mHw32VX8stWY0=;
	b=n3Lh2GePrqMRt7LkBUE/Tu8vbkL/wY2uazwCY3zRX7ygoPmTaHBz2qALR1Qh1mrxFMUR
	 Q72WX2t9jg11xHsc33Pu/+4PNz/u3L+UVIn1d2YejffWZlexK8/c70dUAjRmvCE1oQjbn
	 AD8ARgpR+gecMnYSZ2omzQQmvGtVbhlu4dDXRaJo5BoDEMcz4kiRu+fzl4Zs7VnQCjqr5
	 cBH3TxSqIrmjg4S1ueoqyuWFcRSfYbRCgWcsFYc2i8MR0GOr6WQDnPMqIeEGHuXQjxHJx
	 XP6FLfZdhENDyarcEw1/QpXhmGIAqhHeFJoS6zn4Cz9d6C8cCi7HXkOdg3a4nFyLNOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=V6bOwBUa;
	arc=none smtp.remote-ip=113.46.200.222
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82588606A32A;
	Tue, 17 Nov 2026 14:34:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82588606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=V6bOwBUa
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=msllHZEApp54KuI+5jaT9flmvof2Z7mHw32VX8stWY0=;
	b=V6bOwBUaRpYicAoW86gz1i+ASQtPeNBlM8OZ7NHbPrX6MWN9ICi9GmKraEtAAGwopdaQRAICJ
	hDY+a6I4ZJYCIRe/RM2NyY6q3CBXeiUM9oQL1xXTv7XWisfIrbhg4r3N6TyqQHKrNKcToM49+ed
	SWm0X1qYsJ1N+G1fbxM+0Es=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jTS153XkTzLlXD;
	Tue, 17 Nov 2026 22:34:33 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 855474055B;
	Tue, 17 Nov 2026 22:34:52 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:34:46 +0800
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
Subject: [PATCH -next -v4 16/17] samples/landlock: Add metadata rights to sandboxer
Date: Tue, 17 Nov 2026 23:05:41 +0800
Message-ID: <20261117150542.1169451-17-caixinchen1@huawei.com>
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

Handle the two new access rights in the sandboxer: READ_METADATA joins
the read-only set, WRITE_METADATA the read-write set, and both join
ACCESS_FILE.  Bump LANDLOCK_ABI_LAST to 13 and remove the rights for
ABI < 13 in the fallback switch.

Update the trace example in events-landlock.rst accordingly.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 Documentation/trace/events-landlock.rst | 18 ++++++++++--------
 samples/landlock/sandboxer.c            | 16 +++++++++++++---
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/Documentation/trace/events-landlock.rst b/Documentation/trace/events-landlock.rst
index dc5f05a17c2c..f415eaa0eabf 100644
--- a/Documentation/trace/events-landlock.rst
+++ b/Documentation/trace/events-landlock.rst
@@ -88,7 +88,7 @@ Landlock, not from regular file permissions::
   $ LC_ALL=C LL_FS_RO=/usr:/lib:/lib64:/bin:/etc/ld.so.cache LL_FS_RW=/tmp \
       ./sandboxer cat /etc/passwd
   $ cat /sys/kernel/tracing/trace_pipe
-  cat-127 [...] landlock_create_ruleset: ruleset=195cc6b76.0 handled_fs=execute|write_file|read_file|read_dir|remove_dir|remove_file|make_char|make_dir|make_reg|make_sock|make_fifo|make_block|make_sym|refer|truncate|ioctl_dev|resolve_unix handled_net= scoped= handled_permissions=
+  cat-127 [...] landlock_create_ruleset: ruleset=195cc6b76.0 handled_fs=execute|write_file|read_file|read_dir|remove_dir|remove_file|make_char|make_dir|make_reg|make_sock|make_fifo|make_block|make_sym|refer|truncate|ioctl_dev|resolve_unix|read_metadata|write_metadata handled_net= scoped= handled_permissions=
   cat-127 [...] landlock_create_domain: domain=195cc6b7c parent=0 ruleset=195cc6b76.6
   cat-127 [...] landlock_enforce_domain: domain=195cc6b7c complete=1 process_wide=1 no_new_privs=1
   cat-127 [...] landlock_deny_access_fs: domain=195cc6b7c same_exec=0 logged=0 blockers=read_file dev=0:17 ino=5901179 path=/etc/passwd
@@ -279,20 +279,22 @@ For example, a program sandboxed with read and execute access to the
 whole filesystem reads ``/etc/passwd``; both the ``execve()`` and the
 read match the rule covering ``/`` (inode 2), so ``check_rule_inode`` fires
 with the requested rights intersected against what that rule grants.
-The ``access_request=`` mask includes ``truncate`` because the file-open hook
-evaluates that optional right alongside the required access, but the
-rule does not grant it, so ``truncate`` never appears in ``grants=``::
+The ``access_request=`` mask includes ``truncate``, ``read_metadata`` and
+``write_metadata`` because the file-open hook evaluates those optional rights
+alongside the required access.  The read-only rule grants ``read_metadata``,
+so it appears in ``grants=``, while ``truncate`` and ``write_metadata`` are
+not granted and therefore do not::
 
-  cat-127 [...] landlock_check_rule_inode: domain=1e40cb56f access_request=execute|read_file|truncate dev=0:17 ino=2 grants={execute|read_file}
-  cat-127 [...] landlock_check_rule_inode: domain=1e40cb56f access_request=read_file|truncate dev=0:17 ino=2 grants={read_file}
+  cat-127 [...] landlock_check_rule_inode: domain=1e40cb56f access_request=execute|read_file|truncate|read_metadata|write_metadata dev=0:17 ino=2 grants={execute|read_file|read_metadata}
+  cat-127 [...] landlock_check_rule_inode: domain=1e40cb56f access_request=read_file|truncate|read_metadata|write_metadata dev=0:17 ino=2 grants={read_file|read_metadata}
 
 The ``[...]`` replaces the ftrace CPU, flags, and timestamp columns.  A
 single ``grants=`` group means the enforcing domain has one layer.  With
 two nested sandboxes that each grant the same rights, the rule spans both
 layers, so ``grants=`` has one group per layer::
 
-  cat-128 [...] landlock_check_rule_inode: domain=184788b52 access_request=execute|read_file|truncate dev=0:17 ino=2 grants={execute|read_file,execute|read_file}
-  cat-128 [...] landlock_check_rule_inode: domain=184788b52 access_request=read_file|truncate dev=0:17 ino=2 grants={read_file,read_file}
+  cat-128 [...] landlock_check_rule_inode: domain=184788b52 access_request=execute|read_file|truncate|read_metadata|write_metadata dev=0:17 ino=2 grants={execute|read_file|read_metadata,execute|read_file|read_metadata}
+  cat-128 [...] landlock_check_rule_inode: domain=184788b52 access_request=read_file|truncate|read_metadata|write_metadata dev=0:17 ino=2 grants={read_file|read_metadata,read_file|read_metadata}
 
 eBPF access
 ===========
diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
index 1362f08ff14b..29965ef90bed 100644
--- a/samples/landlock/sandboxer.c
+++ b/samples/landlock/sandboxer.c
@@ -137,6 +137,8 @@ static int parse_path(char *env_path, const char ***const path_list)
 	LANDLOCK_ACCESS_FS_EXECUTE | \
 	LANDLOCK_ACCESS_FS_WRITE_FILE | \
 	LANDLOCK_ACCESS_FS_READ_FILE | \
+	LANDLOCK_ACCESS_FS_READ_METADATA | \
+	LANDLOCK_ACCESS_FS_WRITE_METADATA | \
 	LANDLOCK_ACCESS_FS_TRUNCATE | \
 	LANDLOCK_ACCESS_FS_IOCTL_DEV | \
 	LANDLOCK_ACCESS_FS_RESOLVE_UNIX)
@@ -487,7 +489,8 @@ static bool check_ruleset_scope(const char *const env_var,
 #define ACCESS_FS_ROUGHLY_READ ( \
 	LANDLOCK_ACCESS_FS_EXECUTE | \
 	LANDLOCK_ACCESS_FS_READ_FILE | \
-	LANDLOCK_ACCESS_FS_READ_DIR)
+	LANDLOCK_ACCESS_FS_READ_DIR | \
+	LANDLOCK_ACCESS_FS_READ_METADATA)
 
 #define ACCESS_FS_ROUGHLY_WRITE ( \
 	LANDLOCK_ACCESS_FS_WRITE_FILE | \
@@ -503,7 +506,8 @@ static bool check_ruleset_scope(const char *const env_var,
 	LANDLOCK_ACCESS_FS_REFER | \
 	LANDLOCK_ACCESS_FS_TRUNCATE | \
 	LANDLOCK_ACCESS_FS_IOCTL_DEV | \
-	LANDLOCK_ACCESS_FS_RESOLVE_UNIX)
+	LANDLOCK_ACCESS_FS_RESOLVE_UNIX | \
+	LANDLOCK_ACCESS_FS_WRITE_METADATA)
 
 /* clang-format on */
 
@@ -570,7 +574,7 @@ static int add_quiet_access(const char *const env_var,
 	return 0;
 }
 
-#define LANDLOCK_ABI_LAST 12
+#define LANDLOCK_ABI_LAST 13
 
 #define XSTR(s) #s
 #define STR(s) XSTR(s)
@@ -780,6 +784,12 @@ int main(const int argc, char *const argv[], char *const *const envp)
 		ruleset_attr.handled_permissions &=
 			~(LANDLOCK_PERMISSION_NAMESPACE_USE |
 			  LANDLOCK_PERMISSION_CAPABILITY_USE);
+		__attribute__((fallthrough));
+	case 12:
+		/* Removes metadata rights for ABI < 13 */
+		ruleset_attr.handled_access_fs &=
+			~(LANDLOCK_ACCESS_FS_READ_METADATA |
+			  LANDLOCK_ACCESS_FS_WRITE_METADATA);
 		/* Must be printed for any ABI < LANDLOCK_ABI_LAST. */
 		fprintf(stderr,
 			"Hint: You should update the running kernel "
-- 
2.18.0.huawei.25

