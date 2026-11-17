Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794926019;
	b=pFmSiYRBrYCv/w8WTxBg36P9TQfr/d6kcdgAhNYiZsZ+irgjou0ImbCaXoKWDZuGjakU
	 RcU7h22z9LTNSW0C403ipBUZLvf6cFQd16oXZ2FJVxPzMKBCiWSZNKl217vNx5+Kszo5R
	 UwozkVQ5DS+mJ2PbFgcQGgEqZ/mHwOkDjvPNz8mXOUFUSsO0nkWC3Jl8MfzDGMzAcZ1Fh
	 8d6pIksm7IGse2uOWyR+VZkk/SIwRuQ/CMaH74ntNytt/4+Sp0qXHm/wI1eNfR8sFj60P
	 jFAyOWSBaIUYMtRmgeL4zNU5VppQrnJ9AAU1IUdujRSrzm6MKjipz23yNYFB8cOGyqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794926019;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
	bh=By2TgM9Xeiq5fwyI6d3OB7CNRr7DwQCDNevlT/7vutY=;
	b=1lmiG/sUBHJEkcbeRUXDRODjtrzpGl8f76dPrZX0JxcWGSOEq4PwxFRY1kmfRYqVlGNR
	 ACGZ/LCRNVqdlVgdSKs7zh3n/sDp29Ejtl3oY5OJsOcRQKund5rQYzxq1jo1AOucltwSI
	 sXRrpegTF215zSi1NCINQQT4edAp4RBfdki2aKjaXjLeEuvXFw4zMLqDJwuiZxau6yHZP
	 i17byLJYbmEXi1FEVoXtL3N9RbLYtS8O7vt45K2ZbXZcBMo9sz8zfKT/8qxZb8KTuNZ1C
	 NqzyEcaW+4Pr+MkVmqRehDYV3GYaC8JtstBZXoaMayapg0LQa0V22fMxclabC8tGOSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=fmE8M1h5;
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CB7606A882;
	Tue, 17 Nov 2026 14:33:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23CB7606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=fmE8M1h5
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=By2TgM9Xeiq5fwyI6d3OB7CNRr7DwQCDNevlT/7vutY=;
	b=fmE8M1h5jCOHDWXgeJCJFeb0hX7leMPaHPbVAUYxGt8hzFBowo9Z2rEnwEM2Ez5r8Ka6rpuE6
	fQfdQkYAzFq3InspAmYMT/Q1LWAGscF3EBrD7IpGRyf97gtdnnwp61LHAuyS/9PH/5bg4Hjc0Wp
	6DdiHT2efGkXmfXx1MI9Whg=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jTRym4C4Gzcb3H;
	Tue, 17 Nov 2026 22:32:32 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id A5EA34057F;
	Tue, 17 Nov 2026 22:33:23 +0800 (CST)
Received: from octopus.huawei.com (10.67.174.191) by
 whupemk100010.china.huawei.com (7.152.184.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 17 Nov 2026 22:33:17 +0800
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
Subject: [PATCH -next -v4 00/17] landlock: Add READ_METADATA and WRITE_METADATA access rights
Date: Tue, 17 Nov 2026 23:05:25 +0800
Message-ID: <20261117150542.1169451-1-caixinchen1@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 whupemk100010.china.huawei.com (7.152.184.41)

This series adds two new Landlock filesystem access rights,
LANDLOCK_ACCESS_FS_READ_METADATA and LANDLOCK_ACCESS_FS_WRITE_METADATA,
which control access to file and directory metadata such as inode
attributes (mode, ownership, timestamps), extended attributes, POSIX
ACLs and chattr(1)-style flags.  It picks up the work from the
"landlock: add chmod and chown support" series [1] and follows the
coarse-grained grouping discussed in that thread [2]: instead of
separate chmod/chown rights, metadata operations are grouped into one
read and one write right.

Landlock evaluates access rights on a per-path basis, but the
metadata related LSM hooks (inode_setattr, inode_setsecctx, the inode
xattr, POSIX ACL and fileattr hooks) only receive the dentry of the
accessed object.  Patches 1-8 therefore first pass struct path
instead of dentry through the metadata-related VFS helpers and LSM
hooks.  The hooks also receive a struct file argument, set by the
VFS to the file through which the operation is requested when there
is one (i.e. for the file descriptor-based system calls such as
fchmod(2), fchown(2), fgetxattr(2), utimensat(2) on an empty path,
and for the FS_IOC_* ioctls and file_[gs]etattr(2) with
AT_EMPTY_PATH), and NULL otherwise (i.e. for the path-based system
calls and for kernel-internal accesses).  This is a pure refactoring
with no behavior change for the other LSMs, which only have their
hook implementations' signatures updated; the file argument is only
consumed by Landlock (patch 14).  The series is split so that every
patch builds on its own:

  1: notify_change() and its callers
  2: inode_setsecctx hook (must come before 3: the SELinux and Smack
     implementations call __vfs_setxattr_locked internally)
  3: xattr helpers, which also drops a redundant EVM xattr size sanity
     check whose vfs_getxattr() call only has a dentry and therefore
     cannot be migrated to the new path-based signature
  4: POSIX ACL helpers
  5: inode xattr hooks, threaded through the xattr helpers so that
     the f[gs]etxattr(2) and io_uring flows pass their file
  6: inode POSIX ACL hooks, threaded through do_set_acl()/do_get_acl()
  7: inode fileattr hooks (FS_IOC_[GS]ETFLAGS, FS_IOC_FS[SG]ETXATTR,
     file_[gs]etattr(2)), which also adds a __vfs_fileattr_get()
     counterpart without security checks for the kernel-internal
     readers (nfsd), and removes the ovl_security_fileattr() hack by
     forwarding the real upper/lower path to the checked
     vfs_fileattr_get()/_set() from ecryptfs and overlayfs
  8: inode_setattr hook, which now receives the struct file held by
     the fd-based callers (fchmod(2), fchown(2), fchmodat2(2) and
     fchownat(2) with AT_EMPTY_PATH, utimensat(2) on an empty path);
     do_truncate() passes NULL because size changes are governed by
     the truncate hooks.  The hook is renamed to path_setattr in the
     same patch, so that a stale BPF LSM program attaching to
     lsm/inode_setattr fails to load instead of reading dentry->d_flags
     where it expects iattr->ia_valid (see below)

Three deliberate scoping decisions for this refactor:

- The hooks consistently take struct path rather than struct file as
  their primary object.  The VFS call sites involved (chmod(2),
  chown(2), utimensat(2), xattr(2) and ACL syscalls) operate on
  paths, and several of them (lstat(2), lchown(2), llistxattr(2),
  ...) have no struct file to begin with.  The optional struct file
  argument carries the open-time semantic described below.

- struct inode_operations->setattr still receives (idmap, dentry, attr).
  Only the VFS boundary (notify_change()) and the LSM hook layer see the
  path, which keeps the refactor contained to fs/attr.c and the LSM
  infrastructure instead of touching every filesystem.

- The path argument of the hooks is only meant to be handed to VFS
  helpers taking a struct path (e.g., notify_change(), the xattr
  helpers): the VFS makes no guarantees with regard to path->mnt,
  whose layout and implementation details are subject to change, and
  implementations must not rely on its properties.  The idmap, in
  contrast, is passed separately so that the VFS and the filesystem
  are guaranteed to see the same idmap.

Unlike what was done for LANDLOCK_ACCESS_FS_TRUNCATE, no new file_*
hooks are introduced for the file descriptor flows: the metadata
hooks are already consumed by other LSMs (SELinux, Smack, EVM, IMA,
AppArmor, TOMOYO) on these flows, and routing them to new hooks
would either silently remove the other LSMs' checks, or keep the
path_* hooks as well and check twice with Landlock.  Passing the
struct file to the existing path_* hooks instead keeps the pipeline
and the other LSMs' behavior unchanged, while giving Landlock the
information it needs to apply the open-time semantic below.

Since these hooks now operate on paths rather than inodes, patches
8-13 rename them to the path_* naming convention used by the other
hooks that take a struct path (path_chmod, path_chown, path_link,
...).  The inode_setattr hook is renamed in patch 8, in the same patch
that changes its ctx layout: BPF LSM program arguments are retyped
from the hook prototype at verification time and are not checked
against a versioned ABI, so leaving the old name in place for a few
patches would let a stale program read dentry->d_flags where it
expects iattr->ia_valid, silently inverting a deny rule.  The
inode_getattr hook, which already received a struct path, is renamed
to path_getattr as well; patch 9 also threads the struct file held by
the fd-based vfs_fstat() and vfs_statx_fd() callers through it, while
the many kernel-internal vfs_getattr() callers keep a wrapper which
passes NULL.  Apart from patch 8 and the file threading in patch 9,
these renames are purely mechanical and can be reviewed independently.

Patch 14 then adds the access rights and implements their
enforcement, and patches 15-17 add the selftests, the sandboxer
sample update and the documentation.

Patch 14 applies the LANDLOCK_ACCESS_FS_TRUNCATE mechanic to the
new rights, following Mickaël's confirmation [4]: for operations on
already opened files, it is the access rights at the time of open(2)
which decide whether a metadata operation is permitted, not the
rights of the current thread.  READ_METADATA and WRITE_METADATA are
looked up at open time, recorded in the opened file, and consumed by
the metadata hooks when they are called with a file.  As a
consequence:

- A file descriptor opened before sandboxing keeps allowing metadata
  operations whatever the current domain is, which resolves the
  "catch-22" raised by Justin [5]: an already opened file descriptor
  keeps working, it is not an escape hatch because its rights were
  fixed when it was legitimate to open the file.
- Conversely, a restricted file descriptor passed to another
  (possibly non-landlocked) process keeps denying metadata
  operations: the file descriptor carries the rights of the process
  which opened it.
- ioctl(FS_IOC_GETFLAGS) and friends on a file descriptor opened
  without READ_METADATA are now denied, which closes the metadata
  leak Justin was concerned about.
- O_PATH file descriptors are an exception: they are not opened
  through the open permission checks (cf. do_dentry_open()) and
  carry no recorded rights; metadata accesses through them are
  checked against the current domain, like path-based accesses.
- File descriptors obtained without going through the file_open
  hook (e.g. memfd_create(2), pipes, sockets) keep the full access
  rights granted at file allocation time, consistent with the
  truncate behavior.
- deny_masks_t is widened from u8 to u16 to keep tracking one
  nibble per optional access right for the audit logs.

The Landlock ABI version is incremented from 12 to 13; ABI 12 was
taken by the capability and namespace use restrictions that are
already in linux-next.

The series is based on linux-next commit 749a4de37040 ("Add linux-next
specific files for 20261116").

Changes since v3 [6]:

- The empty-path branch of do_fchmodat(), do_fchownat() and
  do_utimes_path() used fdget(), which rejects O_PATH file
  descriptors.  It now uses fd_raw, the same lookup path_init() uses
  for an empty path, so AT_EMPTY_PATH metadata operations work again
  on O_PATH descriptors; futimens(2) keeps rejecting O_PATH, and a
  NULL pathname returns -EFAULT instead of being turned into an empty
  path (patch 8).
- Every hook that gained a struct file argument is declared with a
  strong file__nullable definition in kernel/bpf/bpf_lsm_proto.c, so
  the verifier requires a NULL check before dereferencing it
  (patches 5-12).
- The ntfs named stream setattr no longer bypasses the hooks: it goes
  through notify_change_target(), which performs the path-based LSM
  checks on the caller-supplied path while the attributes land on the
  base inode, and the borrowed path is dropped from the caller-owned
  struct iattr before notify_change() returns (patch 1).
- ecryptfs and overlayfs run the fileattr hooks on the real
  upper/lower path instead of calling unchecked helpers, and the
  ksmbd xattr helper passes the file it was given instead of NULL
  (patches 5 and 7).
- Since a trusted struct path lets BPF LSM programs reach path->dentry
  and call the dentry xattr kfuncs, the sleepable path hooks that
  always run under i_rwsem use the _locked kfunc variants, while the
  hooks that can run either way (path_link, path_rename, path_rmdir,
  path_unlink and path_getattr, which nfsd reaches with the inode
  already locked) reject both variants (patch 8).
- fchmod(2) and fchown(2) are not O_PATH-capable metadata interfaces
  and are no longer listed as such in the UAPI header and in the
  userspace documentation (patches 14 and 17).
- The setattr hook rename is folded into the patch that changes its
  ctx layout, so that a stale BPF LSM program cannot be silently
  reinterpreted, and that patch now comes right before the getattr
  rename (patch 8).
- ksmbd reports the share root for the ".." entry when follow_up()
  cannot leave a mount that was detached, instead of using a parent
  which that mount does not cover (patch 3).
- The Landlock changelog states that kernel-internal getattr calls
  made under the caller's credentials, such as NFS localio's
  post-write attribute refresh, are subject to READ_METADATA too, and
  that localio discards the resulting error (patch 14).

[1]
https://lore.kernel.org/all/20220827111215.131442-1-xiujianfeng@huawei.com/
[2]
https://lore.kernel.org/all/abc960a1-e66e-792e-6869-cfd201c29dbe@digikod.net/
[3]
https://lore.kernel.org/all/20261015125425.3246251-1-caixinchen1@huawei.com/
[4] https://lore.kernel.org/all/20260929.Ahgoo4yeetai@digikod.net/
[5] https://lore.kernel.org/all/arvjb0HJYh1KyEBB@suesslenovo/
[6]
https://lore.kernel.org/all/20261027121151.1887650-1-caixinchen1@huawei.com/

Cai Xinchen (17):
  fs: pass struct path to notify_change()
  LSM: pass struct path to the inode_setsecctx hook
  fs: pass struct path to xattr helpers
  fs: pass struct path to POSIX ACL helpers
  LSM: pass struct path and struct file to the inode xattr hooks
  LSM: pass struct path and struct file to the inode posix acl hooks
  LSM: pass struct path and struct file to the inode fileattr hooks
  LSM: rename inode_setattr to path_setattr and pass struct path and
    file
  LSM: rename inode_getattr to path_getattr and pass struct file
  LSM: rename the inode xattr hooks to path_xattr hooks
  LSM: rename the inode posix acl hooks to path_*_acl hooks
  LSM: rename the inode fileattr hooks to path_file_* hooks
  LSM: rename inode_setsecctx to path_setsecctx
  landlock: Add READ_METADATA and WRITE_METADATA access rights
  selftests/landlock: Add tests for metadata access rights
  samples/landlock: Add metadata rights to sandboxer
  Documentation: Update landlock doc for metadata rights

 Documentation/admin-guide/LSM/landlock.rst    |   2 +
 Documentation/bpf/fs_kfuncs.rst               |   2 +-
 Documentation/filesystems/porting.rst         |  63 ++
 Documentation/trace/events-landlock.rst       |  18 +-
 Documentation/userspace-api/landlock.rst      | 148 ++-
 drivers/base/devtmpfs.c                       |   6 +-
 drivers/block/loop.c                          |  12 +-
 drivers/block/zloop.c                         |  23 +-
 fs/attr.c                                     | 119 ++-
 fs/bpf_fs_kfuncs.c                            |  58 +-
 fs/btrfs/volumes.c                            |   2 +-
 fs/cachefiles/xattr.c                         |  45 +-
 fs/coredump.c                                 |   2 +-
 fs/ecryptfs/inode.c                           |  48 +-
 fs/exfat/file.c                               |   5 +-
 fs/fat/file.c                                 |   5 +-
 fs/file_attr.c                                | 136 ++-
 fs/init.c                                     |   6 +-
 fs/inode.c                                    |   7 +-
 fs/internal.h                                 |  26 +-
 fs/namei.c                                    |   5 +-
 fs/nfsd/nfs4ctl.h                             |   5 +-
 fs/nfsd/nfs4state.c                           |  16 +-
 fs/nfsd/nfs4xdr.c                             |   2 +-
 fs/nfsd/state.h                               |   2 +-
 fs/nfsd/vfs.c                                 |  87 +-
 fs/ntfs/named_stream.c                        |  14 +-
 fs/open.c                                     |  77 +-
 fs/overlayfs/copy_up.c                        |   4 +-
 fs/overlayfs/inode.c                          |  27 +-
 fs/overlayfs/overlayfs.h                      |  44 +-
 fs/overlayfs/xattrs.c                         |  12 +-
 fs/posix_acl.c                                |  61 +-
 fs/smb/server/smb2pdu.c                       |  59 +-
 fs/smb/server/smb_common.c                    |  59 +-
 fs/smb/server/smbacl.c                        |  12 +-
 fs/smb/server/vfs.c                           | 101 +-
 fs/smb/server/vfs.h                           |  19 +-
 fs/stat.c                                     |  82 +-
 fs/utimes.c                                   |  38 +-
 fs/xattr.c                                    | 114 ++-
 fs/xfs/xfs_ioctl.c                            |   2 +-
 include/linux/fileattr.h                      |  10 +-
 include/linux/fs.h                            |  30 +-
 include/linux/landlock.h                      |   4 +-
 include/linux/lsm_hook_defs.h                 |  66 +-
 include/linux/posix_acl.h                     |  25 +-
 include/linux/security.h                      | 131 +--
 include/linux/xattr.h                         |  32 +-
 include/uapi/linux/landlock.h                 |  47 +-
 init/initramfs.c                              |   2 +-
 kernel/bpf/bpf_lsm.c                          |  10 +-
 kernel/bpf/bpf_lsm_proto.c                    | 108 ++
 kernel/bpf/verifier.c                         |  13 +
 kernel/trace/bpf_trace.c                      |   2 +-
 samples/landlock/sandboxer.c                  |  16 +-
 security/apparmor/lsm.c                       |   5 +-
 security/commoncap.c                          |  17 +-
 security/integrity/evm/evm_crypto.c           |   8 +-
 security/integrity/evm/evm_main.c             |  77 +-
 security/integrity/ima/ima_appraise.c         |  41 +-
 security/landlock/access.h                    |  13 +-
 security/landlock/fs.c                        | 235 ++++-
 security/landlock/limits.h                    |   2 +-
 security/landlock/syscalls.c                  |   2 +-
 security/security.c                           | 179 ++--
 security/selinux/hooks.c                      | 105 +-
 security/smack/smack_lsm.c                    | 128 ++-
 security/tomoyo/tomoyo.c                      |   8 +-
 .../testing/selftests/bpf/prog_tests/d_path.c |   2 +-
 .../selftests/bpf/prog_tests/fs_kfuncs.c      |  10 +-
 .../testing/selftests/bpf/progs/test_d_path.c |   5 +-
 .../bpf/progs/test_d_path_check_rdonly_mem.c  |   5 +-
 .../bpf/progs/test_d_path_check_types.c       |   5 +-
 .../selftests/bpf/progs/test_get_xattr.c      |   7 +-
 .../bpf/progs/test_set_remove_xattr.c         |  34 +-
 .../bpf/progs/verifier_lsm_init_xattr.c       |   8 +-
 .../selftests/bpf/progs/verifier_vfs_accept.c |   2 +-
 .../selftests/bpf/progs/verifier_vfs_reject.c |   2 +-
 tools/testing/selftests/landlock/base_test.c  |   2 +-
 tools/testing/selftests/landlock/fs_test.c    | 932 +++++++++++++++++-
 .../selftests/landlock/trace_fs_test.c        |   3 +-
 82 files changed, 3003 insertions(+), 905 deletions(-)

-- 
2.18.0.huawei.25

