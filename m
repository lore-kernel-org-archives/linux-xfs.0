Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296C13AAF6E;
	Tue,  1 Sep 2026 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788264887; cv=none; b=ZBgvJTj6MDoY3nDhYuq5re/+jpVnEfQeWcaaS32d6ug80roBqrxwMKODpU3EbZb5N1YB/zvCNxp2wKGLo6hGPTfmjfrzpKejcq8GducGuWxghRFmcESS2clQ1zue9INbrj/SJe8RxniJPWFItWkbSMCtSwIYNh4a6SlsJtwLqOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788264887; c=relaxed/simple;
	bh=qEPD7TqTrsX4F9tRI6QayPtuz8wbQeuZ+h+xBDW2b9M=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=hfslb+LaThJz3AKbFbRYHQpetdsHxo35jnTu/QqklcIDT19WOz6wVOOJcJgDPSPgCT8Pq8+TXJ2q7bMho6QKiPSYBqOYoCOzQhDfIGeVXjTDgE58fPD54vdUQ+F9dyjBZtu/rBUwSIqegbxh5Vy47A/vTa+XAF4fEKxmQJwMXYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qsvihrq0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qsvihrq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9C61F000E9;
	Tue,  1 Sep 2026 12:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788264885;
	bh=HSS0AdBvpnxdShiiljl/JK78q8YL3ndZU+6Be46HYQ8=;
	h=From:Subject:Date:To:Cc;
	b=Qsvihrq0XRSaimrPFxYzPpwnLzFBpVowAtY1YS5Lpx7V5XcfdmHV/YM/uG3U5smmZ
	 +Jcx/hVqFmgG0Ed4uM4esfpwhIxRj62LY+KxDekKvf613PV0zDOrLctfJgZRIZzfd9
	 Svp/C821cWpXN86eiefS/FrurMl52pjA6A0TNd2NG/MULJU/krOKNZY8n0DGf56BRt
	 U43EEebRB0gwfDEis0WP//UCem9rXAASYINq6Ia5hPTaz/ZOpCRgFnvqRYPhnimvu2
	 ZRPd+Uz5qzRKJ1dJjETol0ed4RcnzKrY6dwMIwmoJsuxeBUUJzdQo2boWC2/8UdQdb
	 tnPyYCqTI04dA==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 00/27] fs: port to const struct mnt_idmap
Date: Tue, 01 Sep 2026 14:14:25 +0200
Message-Id: <20260901-work-idmap-const-v1-0-54ccd48e100b@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMyw7CIBBFf6WZtRBg4etXjIsBB4tGaGZaNWn67
 wIuz32cFYQ4kcB5WIHpnSSVXMHuBggj5jupdKsMzri9ORmrPoWfNXvhpELJMiuP0R/JOjxEhHq
 bmGL6duXl+mdZ/IPC3Dxt4VFIecYcxhY1o+5G3Y269bBtP5UF9kCcAAAA
X-Change-ID: 20260901-work-idmap-const-bafb8e12a7fa
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Seth Forshee <sforshee@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, linux-security-module@vger.kernel.org, 
 Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, 
 Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org, 
 Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org, 
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 linux-unionfs@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, 
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=18235; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qEPD7TqTrsX4F9tRI6QayPtuz8wbQeuZ+h+xBDW2b9M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNO7jm5dwfhSfmH3g8Q2bir+PHn+7+3LlpoY2q9cFlC
 y1jf9d4rO4oYWEQ42KQFVNkcWg3CZdbzlOx2ShTA2YOKxPIEAYuTgGYyAsFhi+cSydMEa5YeH5W
 TP2RzaqHxcUPm23Xfz591Yv7oQ3ZayIY/ofVXYzZePRA5rWSLddfiEQu1VC7U10TxC+5S+PRlKM
 qhrwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

A mount's idmapping is immutable. The only thing that is allowed to be
modified afterwards is the reference count and that is hidden behind
mnt_idmap_get() and mnt_idmap_put(). Everything else only ever reads
from the idmapping. This is the same model that struct cred uses and the
idmapping is also rather sensitive.

So make the idmap argument const wherever we can. The conversion is done
from the bottom up so callers can continue to pass a non-const pointer
to a const parameter until the conversion is finished.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (27):
      userns: pass const uid_gid_map in lookup helpers
      fs: port mnt_idmap_{get,put}() to const mnt_idmap
      fs: port vfs{g,u}id helpers to const mnt_idmap
      fs: port fs{g,u}id helpers to const mnt_idmap
      fs: port i_{g,u}id_into_vfs{g,u}id() to const mnt_idmap
      fs: port i_{g,u}id_{needs_}update() to const mnt_idmap
      quota: port to const mnt_idmap
      fs: port privilege checking helpers to const mnt_idmap
      fs: port inode_owner_or_capable() to const mnt_idmap
      fs: port inode_init_owner() to const mnt_idmap
      fs: port acl to const mnt_idmap
      fs: port ->permission() to pass const mnt_idmap
      fs: port xattr to const mnt_idmap
      fs: port ->fileattr_set() to pass const mnt_idmap
      fs: port ->set_acl() to pass const mnt_idmap
      fs: port ->get_acl() to pass const mnt_idmap
      fs: port ->tmpfile() to pass const mnt_idmap
      fs: port ->mknod() to pass const mnt_idmap
      fs: port ->rename() to pass const mnt_idmap
      fs: port ->mkdir() to pass const mnt_idmap
      fs: port ->symlink() to pass const mnt_idmap
      fs: port ->create() to pass const mnt_idmap
      fs: port ->getattr() to pass const mnt_idmap
      fs: port ->setattr() to pass const mnt_idmap
      fs: port vfs_*() helpers to const mnt_idmap
      fs: port mnt_idmap() and file_mnt_idmap() to const mnt_idmap
      fs: make nop_mnt_idmap and invalid_mnt_idmap const

 Documentation/filesystems/locking.rst     |  24 +++----
 Documentation/filesystems/porting.rst     |  13 ++++
 Documentation/filesystems/vfs.rst         |  24 +++----
 arch/powerpc/platforms/cell/spufs/inode.c |   2 +-
 drivers/android/binder/rust_binderfs.c    |   2 +-
 drivers/android/binderfs.c                |   2 +-
 fs/9p/acl.c                               |   4 +-
 fs/9p/acl.h                               |   4 +-
 fs/9p/v9fs.h                              |   2 +-
 fs/9p/v9fs_vfs.h                          |   2 +-
 fs/9p/vfs_inode.c                         |  14 ++--
 fs/9p/vfs_inode_dotl.c                    |  14 ++--
 fs/9p/xattr.c                             |   2 +-
 fs/adfs/adfs.h                            |   2 +-
 fs/adfs/inode.c                           |   2 +-
 fs/affs/affs.h                            |  10 +--
 fs/affs/inode.c                           |   2 +-
 fs/affs/namei.c                           |   8 +--
 fs/afs/dir.c                              |  16 ++---
 fs/afs/inode.c                            |   4 +-
 fs/afs/internal.h                         |   6 +-
 fs/afs/security.c                         |   2 +-
 fs/afs/xattr.c                            |   4 +-
 fs/anon_inodes.c                          |   4 +-
 fs/attr.c                                 |  16 ++---
 fs/autofs/root.c                          |  12 ++--
 fs/backing-file.c                         |   2 +-
 fs/bad_inode.c                            |  20 +++---
 fs/bfs/dir.c                              |   4 +-
 fs/btrfs/acl.c                            |   2 +-
 fs/btrfs/acl.h                            |   2 +-
 fs/btrfs/btrfs_inode.h                    |   2 +-
 fs/btrfs/inode.c                          |  24 +++----
 fs/btrfs/ioctl.c                          |  16 ++---
 fs/btrfs/ioctl.h                          |   2 +-
 fs/btrfs/xattr.c                          |   6 +-
 fs/ceph/acl.c                             |   2 +-
 fs/ceph/dir.c                             |  10 +--
 fs/ceph/file.c                            |   2 +-
 fs/ceph/inode.c                           |  10 +--
 fs/ceph/mds_client.h                      |   2 +-
 fs/ceph/super.h                           |  10 +--
 fs/ceph/xattr.c                           |   2 +-
 fs/coda/coda_linux.h                      |   6 +-
 fs/coda/dir.c                             |  10 +--
 fs/coda/inode.c                           |   4 +-
 fs/coda/pioctl.c                          |   4 +-
 fs/configfs/configfs_internal.h           |   4 +-
 fs/configfs/dir.c                         |   2 +-
 fs/configfs/inode.c                       |   2 +-
 fs/configfs/symlink.c                     |   2 +-
 fs/coredump.c                             |   2 +-
 fs/debugfs/inode.c                        |   2 +-
 fs/ecryptfs/inode.c                       |  26 +++----
 fs/efivarfs/inode.c                       |   6 +-
 fs/erofs/inode.c                          |   2 +-
 fs/erofs/internal.h                       |   2 +-
 fs/exec.c                                 |   4 +-
 fs/exfat/exfat_fs.h                       |   4 +-
 fs/exfat/file.c                           |   6 +-
 fs/exfat/namei.c                          |   6 +-
 fs/ext2/acl.c                             |   2 +-
 fs/ext2/acl.h                             |   2 +-
 fs/ext2/ext2.h                            |   6 +-
 fs/ext2/inode.c                           |   4 +-
 fs/ext2/ioctl.c                           |   2 +-
 fs/ext2/namei.c                           |  12 ++--
 fs/ext2/xattr_security.c                  |   2 +-
 fs/ext2/xattr_trusted.c                   |   2 +-
 fs/ext2/xattr_user.c                      |   2 +-
 fs/ext4/acl.c                             |   2 +-
 fs/ext4/acl.h                             |   2 +-
 fs/ext4/ext4.h                            |  10 +--
 fs/ext4/ialloc.c                          |   2 +-
 fs/ext4/inode.c                           |   6 +-
 fs/ext4/ioctl.c                           |   6 +-
 fs/ext4/namei.c                           |  16 ++---
 fs/ext4/symlink.c                         |   2 +-
 fs/ext4/xattr_hurd.c                      |   2 +-
 fs/ext4/xattr_security.c                  |   2 +-
 fs/ext4/xattr_trusted.c                   |   2 +-
 fs/ext4/xattr_user.c                      |   2 +-
 fs/f2fs/acl.c                             |   6 +-
 fs/f2fs/acl.h                             |   2 +-
 fs/f2fs/f2fs.h                            |   8 +--
 fs/f2fs/file.c                            |  14 ++--
 fs/f2fs/namei.c                           |  24 +++----
 fs/f2fs/xattr.c                           |   4 +-
 fs/failfs.c                               |   4 +-
 fs/fat/fat.h                              |   4 +-
 fs/fat/file.c                             |   6 +-
 fs/fat/namei_msdos.c                      |   6 +-
 fs/fat/namei_vfat.c                       |   6 +-
 fs/fhandle.c                              |   2 +-
 fs/file_attr.c                            |   6 +-
 fs/fuse/acl.c                             |   4 +-
 fs/fuse/dir.c                             |  51 +++++++-------
 fs/fuse/file.c                            |   2 +-
 fs/fuse/fuse_i.h                          |  12 ++--
 fs/fuse/ioctl.c                           |   2 +-
 fs/fuse/req.c                             |   8 ++-
 fs/fuse/xattr.c                           |   2 +-
 fs/gfs2/acl.c                             |   2 +-
 fs/gfs2/acl.h                             |   2 +-
 fs/gfs2/file.c                            |   2 +-
 fs/gfs2/inode.c                           |  16 ++---
 fs/gfs2/inode.h                           |   4 +-
 fs/gfs2/xattr.c                           |   2 +-
 fs/hfs/attr.c                             |   2 +-
 fs/hfs/dir.c                              |   6 +-
 fs/hfs/hfs_fs.h                           |   2 +-
 fs/hfs/inode.c                            |   2 +-
 fs/hfsplus/dir.c                          |  10 +--
 fs/hfsplus/hfsplus_fs.h                   |   4 +-
 fs/hfsplus/inode.c                        |   6 +-
 fs/hfsplus/xattr.c                        |   2 +-
 fs/hfsplus/xattr_security.c               |   2 +-
 fs/hfsplus/xattr_trusted.c                |   2 +-
 fs/hfsplus/xattr_user.c                   |   2 +-
 fs/hostfs/hostfs_kern.c                   |  14 ++--
 fs/hpfs/hpfs_fn.h                         |   2 +-
 fs/hpfs/inode.c                           |   2 +-
 fs/hpfs/namei.c                           |  10 +--
 fs/hugetlbfs/inode.c                      |  14 ++--
 fs/inode.c                                |  12 ++--
 fs/internal.h                             |  28 ++++----
 fs/jffs2/acl.c                            |   2 +-
 fs/jffs2/acl.h                            |   2 +-
 fs/jffs2/dir.c                            |  20 +++---
 fs/jffs2/fs.c                             |   2 +-
 fs/jffs2/os-linux.h                       |   2 +-
 fs/jffs2/security.c                       |   2 +-
 fs/jffs2/xattr_trusted.c                  |   2 +-
 fs/jffs2/xattr_user.c                     |   2 +-
 fs/jfs/acl.c                              |   2 +-
 fs/jfs/file.c                             |   2 +-
 fs/jfs/ioctl.c                            |   2 +-
 fs/jfs/jfs_acl.h                          |   2 +-
 fs/jfs/jfs_inode.h                        |   4 +-
 fs/jfs/namei.c                            |  10 +--
 fs/jfs/xattr.c                            |   4 +-
 fs/kernfs/dir.c                           |   4 +-
 fs/kernfs/inode.c                         |  10 +--
 fs/kernfs/kernfs-internal.h               |   6 +-
 fs/libfs.c                                |   8 +--
 fs/minix/file.c                           |   2 +-
 fs/minix/inode.c                          |   2 +-
 fs/minix/minix.h                          |   2 +-
 fs/minix/namei.c                          |  12 ++--
 fs/mnt_idmapping.c                        |  33 +++++----
 fs/namei.c                                |  84 +++++++++++------------
 fs/namespace.c                            |   8 +--
 fs/nfs/dir.c                              |  12 ++--
 fs/nfs/inode.c                            |   4 +-
 fs/nfs/internal.h                         |  10 +--
 fs/nfs/namespace.c                        |   4 +-
 fs/nfs/nfs3_fs.h                          |   2 +-
 fs/nfs/nfs3acl.c                          |   2 +-
 fs/nfs/nfs4proc.c                         |  10 +--
 fs/nilfs2/inode.c                         |   4 +-
 fs/nilfs2/ioctl.c                         |   2 +-
 fs/nilfs2/namei.c                         |  10 +--
 fs/nilfs2/nilfs.h                         |   6 +-
 fs/ntfs/ea.c                              |  10 +--
 fs/ntfs/ea.h                              |   6 +-
 fs/ntfs/file.c                            |   4 +-
 fs/ntfs/inode.h                           |   4 +-
 fs/ntfs/namei.c                           |  12 ++--
 fs/ntfs3/file.c                           |   6 +-
 fs/ntfs3/inode.c                          |   2 +-
 fs/ntfs3/namei.c                          |  10 +--
 fs/ntfs3/ntfs_fs.h                        |  16 ++---
 fs/ntfs3/xattr.c                          |  12 ++--
 fs/ocfs2/acl.c                            |   2 +-
 fs/ocfs2/acl.h                            |   2 +-
 fs/ocfs2/dlmfs/dlmfs.c                    |   6 +-
 fs/ocfs2/file.c                           |   6 +-
 fs/ocfs2/file.h                           |   6 +-
 fs/ocfs2/ioctl.c                          |   2 +-
 fs/ocfs2/ioctl.h                          |   2 +-
 fs/ocfs2/namei.c                          |  10 +--
 fs/ocfs2/xattr.c                          |   6 +-
 fs/omfs/dir.c                             |   6 +-
 fs/omfs/file.c                            |   2 +-
 fs/open.c                                 |   6 +-
 fs/orangefs/acl.c                         |   2 +-
 fs/orangefs/inode.c                       |   8 +--
 fs/orangefs/namei.c                       |   8 +--
 fs/orangefs/orangefs-kernel.h             |   8 +--
 fs/orangefs/xattr.c                       |   2 +-
 fs/overlayfs/dir.c                        |  14 ++--
 fs/overlayfs/file.c                       |   2 +-
 fs/overlayfs/inode.c                      |  16 ++---
 fs/overlayfs/overlayfs.h                  |  14 ++--
 fs/overlayfs/ovl_entry.h                  |   2 +-
 fs/overlayfs/util.c                       |   4 +-
 fs/overlayfs/xattrs.c                     |   4 +-
 fs/pidfs.c                                |   6 +-
 fs/posix_acl.c                            |  26 +++----
 fs/proc/base.c                            |  10 +--
 fs/proc/fd.c                              |   6 +-
 fs/proc/fd.h                              |   2 +-
 fs/proc/generic.c                         |   4 +-
 fs/proc/internal.h                        |   4 +-
 fs/proc/proc_net.c                        |   2 +-
 fs/proc/proc_sysctl.c                     |   6 +-
 fs/proc/root.c                            |   2 +-
 fs/quota/dquot.c                          |   2 +-
 fs/ramfs/file-nommu.c                     |   4 +-
 fs/ramfs/inode.c                          |  10 +--
 fs/remap_range.c                          |   2 +-
 fs/smb/client/cifsacl.c                   |   4 +-
 fs/smb/client/cifsfs.c                    |   2 +-
 fs/smb/client/cifsfs.h                    |  16 ++---
 fs/smb/client/cifsproto.h                 |   4 +-
 fs/smb/client/dir.c                       |   6 +-
 fs/smb/client/inode.c                     |   8 +--
 fs/smb/client/link.c                      |   2 +-
 fs/smb/client/xattr.c                     |   2 +-
 fs/smb/server/ndr.c                       |   2 +-
 fs/smb/server/ndr.h                       |   2 +-
 fs/smb/server/oplock.c                    |   2 +-
 fs/smb/server/smb2pdu.c                   |  22 +++---
 fs/smb/server/smb_common.c                |   2 +-
 fs/smb/server/smbacl.c                    |  20 +++---
 fs/smb/server/smbacl.h                    |   8 +--
 fs/smb/server/vfs.c                       |  44 ++++++------
 fs/smb/server/vfs.h                       |  28 ++++----
 fs/stat.c                                 |   4 +-
 fs/tracefs/event_inode.c                  |   2 +-
 fs/tracefs/inode.c                        |   8 +--
 fs/ubifs/dir.c                            |  14 ++--
 fs/ubifs/file.c                           |   4 +-
 fs/ubifs/ioctl.c                          |   2 +-
 fs/ubifs/ubifs.h                          |   6 +-
 fs/ubifs/xattr.c                          |   2 +-
 fs/udf/file.c                             |   2 +-
 fs/udf/namei.c                            |  12 ++--
 fs/udf/symlink.c                          |   2 +-
 fs/ufs/inode.c                            |   2 +-
 fs/ufs/namei.c                            |  10 +--
 fs/ufs/ufs.h                              |   2 +-
 fs/vboxsf/dir.c                           |   8 +--
 fs/vboxsf/utils.c                         |   4 +-
 fs/vboxsf/vfsmod.h                        |   4 +-
 fs/xattr.c                                |  30 ++++-----
 fs/xfs/libxfs/xfs_inode_util.h            |   2 +-
 fs/xfs/xfs_acl.c                          |   2 +-
 fs/xfs/xfs_acl.h                          |   2 +-
 fs/xfs/xfs_inode.c                        |   4 +-
 fs/xfs/xfs_inode.h                        |   2 +-
 fs/xfs/xfs_ioctl.c                        |   2 +-
 fs/xfs/xfs_ioctl.h                        |   2 +-
 fs/xfs/xfs_iops.c                         |  24 +++----
 fs/xfs/xfs_iops.h                         |   2 +-
 fs/xfs/xfs_itable.c                       |   2 +-
 fs/xfs/xfs_itable.h                       |   2 +-
 fs/xfs/xfs_symlink.c                      |   2 +-
 fs/xfs/xfs_symlink.h                      |   2 +-
 fs/xfs/xfs_xattr.c                        |   2 +-
 fs/zonefs/super.c                         |   2 +-
 include/linux/capability.h                |   8 +--
 include/linux/fileattr.h                  |   2 +-
 include/linux/fs.h                        | 108 +++++++++++++++---------------
 include/linux/lsm_hook_defs.h             |  24 +++----
 include/linux/mnt_idmapping.h             |  24 +++----
 include/linux/mount.h                     |   4 +-
 include/linux/namei.h                     |  16 ++---
 include/linux/nfs_fs.h                    |   6 +-
 include/linux/posix_acl.h                 |  24 +++----
 include/linux/quotaops.h                  |   6 +-
 include/linux/security.h                  |  54 +++++++--------
 include/linux/uidgid.h                    |  12 ++--
 include/linux/xattr.h                     |  20 +++---
 ipc/mqueue.c                              |   2 +-
 kernel/bpf/inode.c                        |   6 +-
 kernel/capability.c                       |   4 +-
 kernel/user_namespace.c                   |  28 ++++----
 mm/secretmem.c                            |   2 +-
 mm/shmem.c                                |  30 ++++-----
 net/socket.c                              |   6 +-
 net/unix/af_unix.c                        |   2 +-
 security/apparmor/apparmorfs.c            |   2 +-
 security/apparmor/lsm.c                   |   4 +-
 security/commoncap.c                      |  10 +--
 security/integrity/evm/evm_main.c         |  26 +++----
 security/integrity/ima/ima.h              |  10 +--
 security/integrity/ima/ima_api.c          |   2 +-
 security/integrity/ima/ima_appraise.c     |  12 ++--
 security/integrity/ima/ima_main.c         |   6 +-
 security/integrity/ima/ima_policy.c       |   4 +-
 security/security.c                       |  24 +++----
 security/selinux/hooks.c                  |  14 ++--
 security/selinux/selinuxfs.c              |   2 +-
 security/smack/smack_lsm.c                |  14 ++--
 virt/kvm/guest_memfd.c                    |   2 +-
 296 files changed, 1156 insertions(+), 1135 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260901-work-idmap-const-bafb8e12a7fa

