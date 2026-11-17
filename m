Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926060;
	b=KvzPaXKHzy6LZ3N9wY/PwF4ZtnfUjBYCKSUTe2sIl8iZtWdo2QKGliw/lz3hGkWgA+2l
	 Pn4M6pzzL2w+zmdSn8BcJruvW2aDocFudL9UM5tlbOq6Rn/ys7ttuzH3CfpdV6A/UPNLs
	 FCLU8lAZoy2MXJW2QdAUY7M2x+TDgXqGj2zyrOg3nX/K/Svcohano/5MaQS++oFpQvW8R
	 HaeVzK/JverocCD/oySsWPlBiWbBC9JJjM2O27YQRK8gyEpe5PWHdgpeRmPPSfy2nOTPE
	 V8ivCL/gScFE4f+rY+N0QrX12IgC+nrWMIKmGsQqhr7YyMfB5bA990JPS/7/Ul5dNhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926060;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:X-Originating-IP:X-ClientProxiedBy;
	bh=yp9C+GxjlpKb314SrFvwyNilz2vyZ0+Fp14pVZtlXoQ=;
	b=vksEAoGvX/XB5RAIwp/3mluV7YRmQ/F6xpnhvPVivme5goubT4ByPfGN0PyPRE5GSOUC
	 G2DO/La5X2QxvaLuNzmZRdPorQH8I87zLw75XOF1fQTNff5J2oWooOfnyrjA9z2zehwUQ
	 8FoA6vrIx+/NdlAClUfafVhLTAWU3mGLbHrzu2kVmyIczHLia1dgBIu9u5dLuCqxgPQLW
	 f3+KjG8fTtVZFIOfEqGmflibHcksPZxM/PZE85pIMLIZNAyIehGjZ/XHqgIp902nq01lg
	 iq7LkqLnpcvD55b/s7hEsb58rPMlpVz6H4ODURevpqa09vVPlCCl5o48WaRco02fPJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=3lBl+gXS;
	arc=none smtp.remote-ip=113.46.200.222
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53929606ABAF;
	Tue, 17 Nov 2026 14:34:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53929606ABAF
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=3lBl+gXS
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yp9C+GxjlpKb314SrFvwyNilz2vyZ0+Fp14pVZtlXoQ=;
	b=3lBl+gXS0CupZqXqMwtxYccV2LAZIDKxjdPoedNXkH2yR52sYhgd5yBQ2M550XFYAcrYL2ZiW
	GasIRCTTf9+USUXxxGgVuwhQWxxzcxp4va+r/cdp3n7lxZzW2Zlh99vyqrIsZqxLNYTUqWRg+s/
	/eqWkUXvJQeGPMXNqB26AhY=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jTS0L5VVXzLlTR;
	Tue, 17 Nov 2026 22:33:54 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id BE27C40586;
	Tue, 17 Nov 2026 22:34:13 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:34:07 +0800
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
Subject: [PATCH -next -v4 09/17] LSM: rename inode_getattr to path_getattr and pass struct file
Date: Tue, 17 Nov 2026 23:05:34 +0800
Message-ID: <20261117150542.1169451-10-caixinchen1@huawei.com>
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

The inode_getattr hook already receives a struct path, so rename it to
path_getattr to follow the path_* convention, and rename
security_inode_getattr() and its SELinux, Smack, AppArmor and TOMOYO
implementations accordingly.

Also pass the struct file through which the attributes are requested,
when there is one, for the same reason as the other metadata hooks.
vfs_getattr() keeps its signature and delegates to the new exported
vfs_getattr_file(), which takes the file and passes it to the hook;
callers that already hold the file use it directly, the others pass NULL.

Update the BPF selftests, the d_path BTF allowlist and the BPF_PROG()
argument lists to the new names and signature.

Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
---
 drivers/block/loop.c                          | 12 +++-
 drivers/block/zloop.c                         | 14 +++-
 fs/bpf_fs_kfuncs.c                            |  4 +-
 fs/stat.c                                     | 68 ++++++++++++++-----
 fs/xfs/xfs_ioctl.c                            |  2 +-
 include/linux/fs.h                            |  3 +
 include/linux/lsm_hook_defs.h                 |  3 +-
 include/linux/security.h                      |  5 +-
 kernel/bpf/bpf_lsm.c                          |  2 +-
 kernel/bpf/bpf_lsm_proto.c                    | 11 +++
 kernel/trace/bpf_trace.c                      |  2 +-
 security/apparmor/lsm.c                       |  5 +-
 security/security.c                           |  9 +--
 security/selinux/hooks.c                      |  5 +-
 security/smack/smack_lsm.c                    |  8 ++-
 security/tomoyo/tomoyo.c                      |  8 ++-
 .../testing/selftests/bpf/prog_tests/d_path.c |  2 +-
 .../testing/selftests/bpf/progs/test_d_path.c |  5 +-
 .../bpf/progs/test_d_path_check_rdonly_mem.c  |  5 +-
 .../bpf/progs/test_d_path_check_types.c       |  5 +-
 .../selftests/bpf/progs/verifier_vfs_accept.c |  2 +-
 21 files changed, 125 insertions(+), 55 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a3325ceab484..d4d4d1fce05c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -462,7 +462,7 @@ static void loop_update_dio_alignment(struct loop_device *lo)
 	 * file can't be used for direct-io at all, so fall back to the block
 	 * device limits in that case.
 	 */
-	if (!vfs_getattr(&file->f_path, &st, STATX_DIOALIGN, 0) &&
+	if (!vfs_getattr_file(&file->f_path, &st, STATX_DIOALIGN, 0, file) &&
 	    (st.result_mask & STATX_DIOALIGN) && st.dio_mem_align) {
 		lo->lo_min_dio_size = st.dio_offset_align;
 		lo->lo_dio_mem_align = min(st.dio_mem_align - 1, PAGE_SIZE - 1);
@@ -1220,7 +1220,15 @@ loop_get_status(struct loop_device *lo, struct loop_info64 *info)
 	path = lo->lo_backing_file->f_path;
 	path_get(&path);
 	mutex_unlock(&lo->lo_mutex);
-	ret = vfs_getattr(&path, &stat, STATX_INO, AT_STATX_SYNC_AS_STAT);
+	/*
+	 * The backing file was opened by the task that configured the
+	 * device, not by the one querying it, and the attributes are
+	 * returned to the requester: do not hand the file over to the LSM
+	 * hook, the metadata read is checked against the requester's
+	 * domain instead.
+	 */
+	ret = vfs_getattr_file(&path, &stat, STATX_INO,
+			       AT_STATX_SYNC_AS_STAT, NULL);
 	if (!ret) {
 		info->lo_device = huge_encode_dev(stat.dev);
 		info->lo_inode = stat.ino;
diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 9d82850d3f44..3b0feb1379ff 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -316,7 +316,13 @@ static int zloop_update_seq_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	lockdep_assert_held(&zone->lock);
 
-	ret = vfs_getattr(&zone->file->f_path, &stat, STATX_SIZE, 0);
+	/*
+	 * The zone file belongs to the task that set up the zone, not to
+	 * the one using the block device, so check the metadata read
+	 * against the current domain.
+	 */
+	ret = vfs_getattr_file(&zone->file->f_path, &stat, STATX_SIZE, 0,
+			       NULL);
 	if (ret < 0) {
 		pr_err("%pg: Failed to get zone %u file stat (err=%d)\n",
 		       zlo->disk->part0, zone_no, ret);
@@ -1074,7 +1080,8 @@ static int zloop_get_block_size(struct zloop_device *zlo,
 	 * file can't be used for direct-io at all, so fall back to the block
 	 * device limits in that case.
 	 */
-	if (!vfs_getattr(&zone->file->f_path, &st, STATX_DIOALIGN, 0) &&
+	if (!vfs_getattr_file(&zone->file->f_path, &st, STATX_DIOALIGN, 0,
+			      zone->file) &&
 	    (st.result_mask & STATX_DIOALIGN) && st.dio_mem_align) {
 		zlo->block_size = st.dio_offset_align;
 		zlo->dio_mem_align = min(st.dio_mem_align - 1, PAGE_SIZE - 1);
@@ -1153,7 +1160,8 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 		zone->cond = BLK_ZONE_COND_NOT_WP;
 		zone->wp = U64_MAX;
 
-		ret = vfs_getattr(&zone->file->f_path, &stat, STATX_SIZE, 0);
+		ret = vfs_getattr_file(&zone->file->f_path, &stat,
+				       STATX_SIZE, 0, zone->file);
 		if (ret < 0) {
 			pr_err("Failed to get zone %u file stat\n", zone_no);
 			goto out_fput;
diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
index a28a6eaaa145..079fe44ccd9b 100644
--- a/fs/bpf_fs_kfuncs.c
+++ b/fs/bpf_fs_kfuncs.c
@@ -538,7 +538,7 @@ BTF_SET_END(bpf_inode_init_xattr_hooks)
  * would update the victim without i_rwsem, and the non-locking one would
  * deadlock on the parent.  Reject both kfuncs for these hooks.
  *
- * inode_getattr() is also reached both with and without i_rwsem: path-based
+ * path_getattr() is also reached both with and without i_rwsem: path-based
  * callers such as stat(2) hold no lock, while nfsd fills the pre-operation
  * attributes from nfsd_setattr() with the inode already write-locked.
  */
@@ -546,7 +546,7 @@ BTF_ID_LIST_SINGLE(bpf_set_dentry_xattr_ids, func, bpf_set_dentry_xattr)
 BTF_ID_LIST_SINGLE(bpf_remove_dentry_xattr_ids, func, bpf_remove_dentry_xattr)
 
 BTF_SET_START(d_inode_ambiguous_hooks)
-BTF_ID(func, bpf_lsm_inode_getattr)
+BTF_ID(func, bpf_lsm_path_getattr)
 #ifdef CONFIG_SECURITY_PATH
 BTF_ID(func, bpf_lsm_path_link)
 BTF_ID(func, bpf_lsm_path_rename)
diff --git a/fs/stat.c b/fs/stat.c
index b032821efb79..e68dc17f23c4 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -172,11 +172,12 @@ EXPORT_SYMBOL_GPL(generic_fill_statx_atomic_writes);
  * @request_mask: STATX_xxx flags indicating what the caller wants
  * @query_flags: Query mode (AT_STATX_SYNC_TYPE)
  *
- * Get attributes without calling security_inode_getattr.
+ * Get attributes without calling security_path_getattr.
  *
- * Currently the only caller other than vfs_getattr is internal to the
- * filehandle lookup code, which uses only the inode number and returns no
- * attributes to any user.  Any other code probably wants vfs_getattr.
+ * Callers must call security_path_getattr() beforehand, unless they only
+ * use the attributes internally: the filehandle lookup code, for
+ * instance, uses only the inode number and returns no attributes to any
+ * user.  Code that merely holds a path probably wants vfs_getattr().
  */
 int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 		      u32 request_mask, unsigned int query_flags)
@@ -261,32 +262,62 @@ EXPORT_SYMBOL(vfs_getattr_nosec);
  */
 int vfs_getattr(const struct path *path, struct kstat *stat,
 		u32 request_mask, unsigned int query_flags)
+{
+	return vfs_getattr_file(path, stat, request_mask, query_flags, NULL);
+}
+EXPORT_SYMBOL(vfs_getattr);
+
+/**
+ * vfs_getattr_file - Get the enhanced basic attributes of an open file
+ * @path: The file of interest
+ * @stat: Where to return the statistics
+ * @request_mask: STATX_xxx flags indicating what the caller wants
+ * @query_flags: Query mode (AT_STATX_SYNC_TYPE)
+ * @file: The file through which the attributes are requested, if any
+ *
+ * Like vfs_getattr(), for callers that hold the struct file the operation
+ * is requested through: security_path_getattr() receives that file, so
+ * that LSMs can authorize the operation with the rights available at
+ * open(2) time.  When @file is set it must refer to the same object as
+ * @path.  Callers that do not hold a file should use vfs_getattr()
+ * instead.
+ *
+ * 0 will be returned on success, and a -ve error code if unsuccessful.
+ */
+int vfs_getattr_file(const struct path *path, struct kstat *stat,
+		     u32 request_mask, unsigned int query_flags,
+		     struct file *file)
 {
 	int retval;
 
-	retval = security_inode_getattr(path);
+	retval = security_path_getattr(path, file);
 	if (unlikely(retval))
 		return retval;
 	return vfs_getattr_nosec(path, stat, request_mask, query_flags);
 }
-EXPORT_SYMBOL(vfs_getattr);
+EXPORT_SYMBOL(vfs_getattr_file);
 
 /**
  * vfs_fstat - Get the basic attributes by file descriptor
  * @fd: The file descriptor referring to the file of interest
  * @stat: The result structure to fill in.
  *
- * This function is a wrapper around vfs_getattr().  The main difference is
- * that it uses a file descriptor to determine the file location.
+ * This function is a wrapper around vfs_getattr_file().  The main
+ * difference is that it uses a file descriptor to determine the file
+ * location, and passes that file to security_path_getattr(), so that
+ * LSMs can later authorize the operation with the rights available at
+ * open(2) time.
  *
  * 0 will be returned on success, and a -ve error code if unsuccessful.
  */
 int vfs_fstat(int fd, struct kstat *stat)
 {
 	CLASS(fd_raw, f)(fd);
+
 	if (fd_empty(f))
 		return -EBADF;
-	return vfs_getattr(&fd_file(f)->f_path, stat, STATX_BASIC_STATS, 0);
+	return vfs_getattr_file(&fd_file(f)->f_path, stat, STATX_BASIC_STATS,
+				0, fd_file(f));
 }
 
 static int statx_lookup_flags(int flags)
@@ -302,9 +333,11 @@ static int statx_lookup_flags(int flags)
 }
 
 static int vfs_statx_path(const struct path *path, int flags, struct kstat *stat,
-			  u32 request_mask)
+			  u32 request_mask, struct file *file)
 {
-	int error = vfs_getattr(path, stat, request_mask, flags);
+	int error;
+
+	error = vfs_getattr_file(path, stat, request_mask, flags, file);
 	if (error)
 		return error;
 
@@ -328,7 +361,8 @@ static int vfs_statx_fd(int fd, int flags, struct kstat *stat,
 	CLASS(fd_raw, f)(fd);
 	if (fd_empty(f))
 		return -EBADF;
-	return vfs_statx_path(&fd_file(f)->f_path, flags, stat, request_mask);
+	return vfs_statx_path(&fd_file(f)->f_path, flags, stat, request_mask,
+			      fd_file(f));
 }
 
 /**
@@ -339,10 +373,10 @@ static int vfs_statx_fd(int fd, int flags, struct kstat *stat,
  * @stat: The result structure to fill in.
  * @request_mask: STATX_xxx flags indicating what the caller wants
  *
- * This function is a wrapper around vfs_getattr().  The main difference is
- * that it uses a filename and base directory to determine the file location.
- * Additionally, the use of AT_SYMLINK_NOFOLLOW in flags will prevent a symlink
- * at the given name from being referenced.
+ * This function is a wrapper around vfs_statx_path().  The main difference
+ * with vfs_getattr() is that it uses a filename and base directory to
+ * determine the file location.  Additionally, the use of AT_SYMLINK_NOFOLLOW
+ * in flags will prevent a symlink at the given name from being referenced.
  *
  * 0 will be returned on success, and a -ve error code if unsuccessful.
  */
@@ -361,7 +395,7 @@ static int vfs_statx(int dfd, struct filename *filename, int flags,
 	error = filename_lookup(dfd, filename, lookup_flags, &path, NULL);
 	if (error)
 		return error;
-	error = vfs_statx_path(&path, flags, stat, request_mask);
+	error = vfs_statx_path(&path, flags, stat, request_mask, NULL);
 	path_put(&path);
 	if (retry_estale(error, lookup_flags)) {
 		lookup_flags |= LOOKUP_REVAL;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f81b6e52ac40..c418e38a78c2 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1249,7 +1249,7 @@ xfs_ioc_dioinfo(
 	struct dioattr		da;
 	int			error;
 
-	error = vfs_getattr(&file->f_path, &st, STATX_DIOALIGN, 0);
+	error = vfs_getattr_file(&file->f_path, &st, STATX_DIOALIGN, 0, file);
 	if (error)
 		return error;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d501d3d9ef0d..0e65e53cad84 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3241,6 +3241,9 @@ void generic_fill_statx_atomic_writes(struct kstat *stat,
 				      unsigned int unit_max_opt);
 extern int vfs_getattr_nosec(const struct path *, struct kstat *, u32, unsigned int);
 extern int vfs_getattr(const struct path *, struct kstat *, u32, unsigned int);
+int vfs_getattr_file(const struct path *path, struct kstat *stat,
+		     u32 request_mask, unsigned int query_flags,
+		     struct file *file);
 void __inode_add_bytes(struct inode *inode, loff_t bytes);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
 void __inode_sub_bytes(struct inode *inode, loff_t bytes);
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 180d2427e5f9..504db4be1cf9 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -164,7 +164,8 @@ LSM_HOOK(int, 0, path_setattr, const struct mnt_idmap *idmap,
 	 struct iattr *attr, struct file *file)
 LSM_HOOK(void, LSM_RET_VOID, inode_post_setattr, const struct mnt_idmap *idmap,
 	 struct dentry *dentry, int ia_valid)
-LSM_HOOK(int, 0, inode_getattr, const struct path *path)
+LSM_HOOK(int, 0, path_getattr, const struct path *path,
+	 struct file *file)
 LSM_HOOK(int, 0, inode_xattr_skipcap, const char *name)
 LSM_HOOK(int, 0, inode_setxattr, const struct mnt_idmap *idmap,
 	 const struct path *path, const char *name, const void *value,
diff --git a/include/linux/security.h b/include/linux/security.h
index e929ef320888..a2f2c97473dd 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -435,7 +435,7 @@ int security_path_setattr(const struct mnt_idmap *idmap,
 			  struct iattr *attr, struct file *file);
 void security_inode_post_setattr(const struct mnt_idmap *idmap, struct dentry *dentry,
 				 int ia_valid);
-int security_inode_getattr(const struct path *path);
+int security_path_getattr(const struct path *path, struct file *file);
 int security_inode_setxattr(const struct mnt_idmap *idmap,
 			    const struct path *path, const char *name,
 			    const void *value, size_t size, int flags,
@@ -1017,7 +1017,8 @@ security_inode_post_setattr(const struct mnt_idmap *idmap, struct dentry *dentry
 			    int ia_valid)
 { }
 
-static inline int security_inode_getattr(const struct path *path)
+static inline int security_path_getattr(const struct path *path,
+					struct file *file)
 {
 	return 0;
 }
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index c8d25b7ba2ea..6ac14e4020a4 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -342,7 +342,7 @@ BTF_ID(func, bpf_lsm_file_receive)
 
 BTF_ID(func, bpf_lsm_inode_create)
 BTF_ID(func, bpf_lsm_inode_free_security)
-BTF_ID(func, bpf_lsm_inode_getattr)
+BTF_ID(func, bpf_lsm_path_getattr)
 BTF_ID(func, bpf_lsm_inode_getxattr)
 BTF_ID(func, bpf_lsm_inode_mknod)
 BTF_ID(func, bpf_lsm_inode_need_killpriv)
diff --git a/kernel/bpf/bpf_lsm_proto.c b/kernel/bpf/bpf_lsm_proto.c
index 5d4e9ccd0078..510e18542e49 100644
--- a/kernel/bpf/bpf_lsm_proto.c
+++ b/kernel/bpf/bpf_lsm_proto.c
@@ -49,6 +49,17 @@ noinline int bpf_lsm_path_setattr(const struct mnt_idmap *idmap,
 	return 0;
 }
 
+/*
+ * Strong definition of the path_getattr() BPF LSM hook.  The file argument is
+ * only set by callers that hold the struct file the operation is requested
+ * through, and is NULL for path-based callers, so mark it as PTR_MAYBE_NULL.
+ */
+noinline int bpf_lsm_path_getattr(const struct path *path,
+				  struct file *file__nullable)
+{
+	return 0;
+}
+
 /*
  * Strong definitions of the inode xattr BPF LSM hooks.  The file argument is
  * only set for file descriptor-based operations and is NULL for path-based
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 310740045498..7006e1830269 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -962,7 +962,7 @@ BPF_CALL_3(bpf_d_path, const struct path *, path, char *, buf, u32, sz)
 BTF_SET_START(btf_allowlist_d_path)
 #ifdef CONFIG_SECURITY
 BTF_ID(func, security_file_permission)
-BTF_ID(func, security_inode_getattr)
+BTF_ID(func, security_path_getattr)
 BTF_ID(func, security_file_open)
 #endif
 #ifdef CONFIG_SECURITY_PATH
diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index eaebc3c60c5a..2329d73f1d6b 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -457,7 +457,8 @@ static int apparmor_path_chown(const struct path *path, kuid_t uid, kgid_t gid)
 	return common_perm_cond(OP_CHOWN, path, AA_MAY_CHOWN);
 }
 
-static int apparmor_inode_getattr(const struct path *path)
+static int apparmor_path_getattr(const struct path *path,
+				 struct file *file)
 {
 	return common_perm_cond(OP_GETATTR, path, AA_MAY_GETATTR);
 }
@@ -1803,7 +1804,7 @@ static struct security_hook_list apparmor_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(path_chmod, apparmor_path_chmod),
 	LSM_HOOK_INIT(path_chown, apparmor_path_chown),
 	LSM_HOOK_INIT(path_truncate, apparmor_path_truncate),
-	LSM_HOOK_INIT(inode_getattr, apparmor_inode_getattr),
+	LSM_HOOK_INIT(path_getattr, apparmor_path_getattr),
 
 	LSM_HOOK_INIT(file_open, apparmor_file_open),
 	LSM_HOOK_INIT(file_receive, apparmor_file_receive),
diff --git a/security/security.c b/security/security.c
index e27add36b0a6..c7cc9c51becd 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1908,18 +1908,19 @@ void security_inode_post_setattr(const struct mnt_idmap *idmap, struct dentry *d
 }
 
 /**
- * security_inode_getattr() - Check if getting file attributes is allowed
- * @path: file
+ * security_path_getattr() - Check if getting file attributes is allowed
+ * @path: file (the VFS makes no guarantees with regard to @path->mnt)
+ * @file: file through which the attributes are retrieved, if any
  *
  * Check permission before obtaining file attributes.
  *
  * Return: Returns 0 if permission is granted.
  */
-int security_inode_getattr(const struct path *path)
+int security_path_getattr(const struct path *path, struct file *file)
 {
 	if (unlikely(IS_PRIVATE(d_backing_inode(path->dentry))))
 		return 0;
-	return call_int_hook(inode_getattr, path);
+	return call_int_hook(path_getattr, path, file);
 }
 
 /**
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 0d55906f62e5..0323b38fa777 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3348,7 +3348,8 @@ static int selinux_path_setattr(const struct mnt_idmap *idmap,
 	return dentry_has_perm(cred, dentry, av);
 }
 
-static int selinux_inode_getattr(const struct path *path)
+static int selinux_path_getattr(const struct path *path,
+				struct file *file)
 {
 	struct task_security_struct *tsec;
 
@@ -7740,7 +7741,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(inode_follow_link, selinux_inode_follow_link),
 	LSM_HOOK_INIT(inode_permission, selinux_inode_permission),
 	LSM_HOOK_INIT(path_setattr, selinux_path_setattr),
-	LSM_HOOK_INIT(inode_getattr, selinux_inode_getattr),
+	LSM_HOOK_INIT(path_getattr, selinux_path_getattr),
 	LSM_HOOK_INIT(inode_xattr_skipcap, selinux_inode_xattr_skipcap),
 	LSM_HOOK_INIT(inode_setxattr, selinux_inode_setxattr),
 	LSM_HOOK_INIT(inode_post_setxattr, selinux_inode_post_setxattr),
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index c66cdb8a45d7..ec1e29f26700 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1296,12 +1296,14 @@ static int smack_path_setattr(const struct mnt_idmap *idmap,
 }
 
 /**
- * smack_inode_getattr - Smack check for getting attributes
+ * smack_path_getattr - Smack check for getting attributes
  * @path: path to extract the info from
+ * @file: file through which the attributes are retrieved, if any
  *
  * Returns 0 if access is permitted, an error code otherwise
  */
-static int smack_inode_getattr(const struct path *path)
+static int smack_path_getattr(const struct path *path,
+			      struct file *file)
 {
 	struct smk_audit_info ad;
 	struct inode *inode = d_backing_inode(path->dentry);
@@ -5205,7 +5207,7 @@ static struct security_hook_list smack_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(inode_rename, smack_inode_rename),
 	LSM_HOOK_INIT(inode_permission, smack_inode_permission),
 	LSM_HOOK_INIT(path_setattr, smack_path_setattr),
-	LSM_HOOK_INIT(inode_getattr, smack_inode_getattr),
+	LSM_HOOK_INIT(path_getattr, smack_path_getattr),
 	LSM_HOOK_INIT(inode_xattr_skipcap, smack_inode_xattr_skipcap),
 	LSM_HOOK_INIT(inode_setxattr, smack_inode_setxattr),
 	LSM_HOOK_INIT(inode_post_setxattr, smack_inode_post_setxattr),
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index c66e02ed8ee3..cf0090df7eab 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -112,13 +112,15 @@ static int tomoyo_bprm_check_security(struct linux_binprm *bprm)
 }
 
 /**
- * tomoyo_inode_getattr - Target for security_inode_getattr().
+ * tomoyo_path_getattr - Target for security_path_getattr().
  *
  * @path: Pointer to "struct path".
+ * @file: Pointer to "struct file", or NULL.
  *
  * Returns 0 on success, negative value otherwise.
  */
-static int tomoyo_inode_getattr(const struct path *path)
+static int tomoyo_path_getattr(const struct path *path,
+			       struct file *file)
 {
 	return tomoyo_path_perm(TOMOYO_TYPE_GETATTR, path, NULL);
 }
@@ -570,7 +572,7 @@ static struct security_hook_list tomoyo_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(path_mknod, tomoyo_path_mknod),
 	LSM_HOOK_INIT(path_link, tomoyo_path_link),
 	LSM_HOOK_INIT(path_rename, tomoyo_path_rename),
-	LSM_HOOK_INIT(inode_getattr, tomoyo_inode_getattr),
+	LSM_HOOK_INIT(path_getattr, tomoyo_path_getattr),
 	LSM_HOOK_INIT(file_ioctl, tomoyo_file_ioctl),
 	LSM_HOOK_INIT(file_ioctl_compat, tomoyo_file_ioctl),
 	LSM_HOOK_INIT(path_chmod, tomoyo_path_chmod),
diff --git a/tools/testing/selftests/bpf/prog_tests/d_path.c b/tools/testing/selftests/bpf/prog_tests/d_path.c
index ec73291ef060..3b5a20939ea9 100644
--- a/tools/testing/selftests/bpf/prog_tests/d_path.c
+++ b/tools/testing/selftests/bpf/prog_tests/d_path.c
@@ -98,7 +98,7 @@ static int trigger_fstat_events(pid_t pid)
 	if (!ASSERT_GE(ret, 0, "set_pathname for dir"))
 		goto out_close;
 
-	/* triggers vfs_getattr */
+	/* triggers vfs_fstat() */
 	fstat(pipefd[0], &fileStat);
 	fstat(pipefd[1], &fileStat);
 	fstat(sockfd, &fileStat);
diff --git a/tools/testing/selftests/bpf/progs/test_d_path.c b/tools/testing/selftests/bpf/progs/test_d_path.c
index edb5494a47f7..908ade86f262 100644
--- a/tools/testing/selftests/bpf/progs/test_d_path.c
+++ b/tools/testing/selftests/bpf/progs/test_d_path.c
@@ -19,9 +19,8 @@ int called_stat = 0;
 int called_close = 0;
 int path_match_fallocate = 0;
 
-SEC("fentry/security_inode_getattr")
-int BPF_PROG(prog_stat, struct path *path, struct kstat *stat,
-	     __u32 request_mask, unsigned int query_flags)
+SEC("fentry/security_path_getattr")
+int BPF_PROG(prog_stat, struct path *path, struct file *file)
 {
 	pid_t pid = bpf_get_current_pid_tgid() >> 32;
 	__u32 cnt = cnt_stat;
diff --git a/tools/testing/selftests/bpf/progs/test_d_path_check_rdonly_mem.c b/tools/testing/selftests/bpf/progs/test_d_path_check_rdonly_mem.c
index 27c27cff6a3a..668ce78cff31 100644
--- a/tools/testing/selftests/bpf/progs/test_d_path_check_rdonly_mem.c
+++ b/tools/testing/selftests/bpf/progs/test_d_path_check_rdonly_mem.c
@@ -7,9 +7,8 @@
 
 extern const int bpf_prog_active __ksym;
 
-SEC("fentry/security_inode_getattr")
-int BPF_PROG(d_path_check_rdonly_mem, struct path *path, struct kstat *stat,
-	     __u32 request_mask, unsigned int query_flags)
+SEC("fentry/security_path_getattr")
+int BPF_PROG(d_path_check_rdonly_mem, struct path *path, struct file *file)
 {
 	void *active;
 	__u32 cpu;
diff --git a/tools/testing/selftests/bpf/progs/test_d_path_check_types.c b/tools/testing/selftests/bpf/progs/test_d_path_check_types.c
index 7e02b7361307..18b411f2abad 100644
--- a/tools/testing/selftests/bpf/progs/test_d_path_check_types.c
+++ b/tools/testing/selftests/bpf/progs/test_d_path_check_types.c
@@ -11,9 +11,8 @@ struct {
 	__uint(max_entries, 1 << 12);
 } ringbuf SEC(".maps");
 
-SEC("fentry/security_inode_getattr")
-int BPF_PROG(d_path_check_rdonly_mem, struct path *path, struct kstat *stat,
-	     __u32 request_mask, unsigned int query_flags)
+SEC("fentry/security_path_getattr")
+int BPF_PROG(d_path_check_rdonly_mem, struct path *path, struct file *file)
 {
 	void *active;
 	u32 cpu;
diff --git a/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c b/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
index 25f37a3dd7cf..81142d217655 100644
--- a/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
+++ b/tools/testing/selftests/bpf/progs/verifier_vfs_accept.c
@@ -71,7 +71,7 @@ int BPF_PROG(get_task_exe_file_and_put_kfunc_from_argument,
 	return 0;
 }
 
-SEC("lsm.s/inode_getattr")
+SEC("lsm.s/path_getattr")
 __success
 int BPF_PROG(path_d_path_from_path_argument, struct path *path)
 {
-- 
2.18.0.huawei.25

