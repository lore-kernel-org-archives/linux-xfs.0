Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 62E0E7F56
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 15:08:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 412F730404E
	for <xfs@oss.sgi.com>; Fri, 30 May 2014 13:08:03 -0700 (PDT)
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24]) by
	cuda.sgi.com with ESMTP id frJFvFDoXvBiBo9F (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 May 2014 13:08:00 -0700 (PDT)
From: Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 00/32] making inode time stamps y2038 ready
Date: Fri, 30 May 2014 22:01:24 +0200
Message-Id: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, linux-mtd@lists.infradead.org, hpa@zytor.com, logfs@logfs.org, linux-afs@lists.infradead.org, joseph@codesourcery.com, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-f2fs-devel@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, lftan@altera.com, linux-btrfs@vger.kernel.org

Based on the recent discussion about 64-bit time_t for new
architectures, and for solving the year 2038 problem in general,
I decided to try out what it would take to solve part of the
kernel side of things.

This is a proof-of-concept work to get us to the point where
two system calls (utimes and stat) provide a working interface
to user space to pass 64-bit inode time stamps in and out of
the kernel all the way to the file systems.

I picked this because it is a fairly isolated problem, as the
inode time stamps are rarely assigned to any other time values.
As a byproduct of this work, I documented for each of the file
systems we support how long the on-disk format can work[1].

Obviously we also need to convert all the other syscalls and
have a proper libc implementation using those for this to
be really useful, but it's a start and it can be tested
independently (I didn't so far, want to wait for initial
feedback).

All the interesting stuff is in the first five patches here,
the rest is the straightforward conversion of all file systems
that use 'timespec' values internally.

There are of course a number of open questions:

a) is this the right approach in general? The previous discussion
   pointed this way, but there may be other opinions.
b) what type should we use internally to represent inode time
   stamps? The code contains three different versions that would
   all work, we just have to pick a good tradeoff between
   efficiency and the range of times we want to cover.
c) Should we continue this way for all 32-bit platforms for
   consistency, including future ones, or should we go to
   different 64-bit types right away? My feeling is that the
   second approach would complicate this work.

	Arnd

[1] http://kernelnewbies.org/y2038

Arnd Bergmann (32):
  fs: introduce new 'struct inode_time'
  uapi: add struct __kernel_timespec{32,64}
  fs: introduce sys_utimens64at
  fs: introduce sys_newfstat64/sys_newfstatat64
  arch: hook up new stat and utimes syscalls
  isofs: fix timestamps beyond 2027
  fs/nfs: convert to struct inode_time
  fs/ceph: convert to 'struct inode_time'
  fs/pstore: convert to struct inode_time
  fs/coda: convert to struct inode_time
  xfs: convert to struct inode_time
  btrfs: convert to struct inode_time
  ext3: convert to struct inode_time
  ext4: convert to struct inode_time
  cifs: convert to struct inode_time
  ntfs: convert to struct inode_time
  ubifs: convert to struct inode_time
  ocfs2: convert to struct inode_time
  fs/fat: convert to struct inode_time
  afs: convert to struct inode_time
  udf: convert to struct inode_time
  fs: convert simple fs to inode_time
  logfs: convert to struct inode_time
  hfs, hfsplus: convert to struct inode_time
  gfs2: convert to struct inode_time
  reiserfs: convert to struct inode_time
  jffs2: convert to struct inode_time
  adfs: convert to struct inode_time
  f2fs: convert to struct inode_time
  fuse: convert to struct inode_time
  scsi: fnic: use current_kernel_time() for timestamp
  fs: use new inode_time definition unconditionally

 arch/alpha/kernel/osf_sys.c        |  2 +-
 arch/arm/include/asm/unistd.h      |  2 +-
 arch/arm/include/uapi/asm/stat.h   | 25 +++++++++++++++++
 arch/arm/include/uapi/asm/unistd.h |  3 +++
 arch/arm/kernel/calls.S            |  3 +++
 arch/arm64/include/asm/unistd32.h  |  5 +++-
 arch/x86/include/uapi/asm/stat.h   | 28 +++++++++++++++++++
 arch/x86/syscalls/syscall_32.tbl   |  3 +++
 drivers/block/rbd.c                |  2 +-
 drivers/firmware/efi/efi-pstore.c  | 28 +++++++++----------
 drivers/scsi/fnic/fnic_trace.c     |  2 +-
 drivers/tty/tty_io.c               |  2 +-
 drivers/usb/gadget/f_fs.c          |  2 +-
 fs/adfs/inode.c                    |  4 +--
 fs/afs/afs.h                       |  6 ++---
 fs/afs/fsclient.c                  |  2 +-
 fs/attr.c                          |  8 +++---
 fs/btrfs/file.c                    |  6 ++---
 fs/btrfs/inode.c                   |  4 +--
 fs/btrfs/ioctl.c                   |  4 +--
 fs/btrfs/root-tree.c               |  2 +-
 fs/btrfs/transaction.c             |  2 +-
 fs/ceph/cache.c                    |  2 +-
 fs/ceph/caps.c                     |  6 ++---
 fs/ceph/file.c                     |  4 +--
 fs/ceph/inode.c                    | 20 +++++++-------
 fs/ceph/super.h                    |  8 +++---
 fs/cifs/cache.c                    |  6 ++---
 fs/cifs/cifsglob.h                 |  6 ++---
 fs/cifs/cifsproto.h                |  6 ++---
 fs/cifs/cifssmb.c                  |  5 ++--
 fs/cifs/inode.c                    |  2 +-
 fs/cifs/netmisc.c                  | 15 ++++++-----
 fs/coda/coda_linux.c               | 18 ++++++++-----
 fs/compat.c                        | 19 ++-----------
 fs/configfs/inode.c                |  6 ++---
 fs/cramfs/inode.c                  |  2 +-
 fs/ext3/inode.c                    |  4 +--
 fs/ext4/ext4.h                     | 10 +++----
 fs/ext4/extents.c                  |  2 +-
 fs/f2fs/file.c                     |  6 ++---
 fs/fat/dir.c                       |  2 +-
 fs/fat/fat.h                       |  6 ++---
 fs/fat/misc.c                      |  4 +--
 fs/fat/namei_msdos.c               |  8 +++---
 fs/fat/namei_vfat.c                | 10 +++----
 fs/fuse/inode.c                    |  6 ++---
 fs/gfs2/dir.c                      |  6 ++---
 fs/gfs2/glops.c                    |  4 +--
 fs/hfs/hfs_fs.h                    |  2 +-
 fs/hfsplus/hfsplus_fs.h            |  2 +-
 fs/inode.c                         | 18 ++++++-------
 fs/isofs/util.c                    |  2 +-
 fs/jffs2/os-linux.h                |  2 +-
 fs/locks.c                         |  4 +--
 fs/logfs/readwrite.c               | 18 ++++++-------
 fs/nfs/callback.h                  |  4 +--
 fs/nfs/callback_xdr.c              |  6 ++---
 fs/nfs/file.c                      |  2 +-
 fs/nfs/fscache-index.c             |  8 +++---
 fs/nfs/inode.c                     | 10 +++----
 fs/nfs/internal.h                  |  4 +--
 fs/nfs/netns.h                     |  2 +-
 fs/nfs/nfs2xdr.c                   |  8 +++---
 fs/nfs/nfs3xdr.c                   | 10 +++----
 fs/nfs/nfs4xdr.c                   | 20 +++++++-------
 fs/nfsd/nfs3xdr.c                  |  6 ++---
 fs/nfsd/nfsfh.h                    |  4 +--
 fs/nfsd/nfsxdr.c                   |  2 +-
 fs/ntfs/inode.c                    | 12 ++++-----
 fs/ntfs/time.h                     |  8 +++---
 fs/ocfs2/dlmglue.c                 | 16 +++++------
 fs/ocfs2/file.c                    |  6 ++---
 fs/ocfs2/ocfs2.h                   |  2 +-
 fs/pstore/inode.c                  |  2 +-
 fs/pstore/internal.h               |  2 +-
 fs/pstore/platform.c               |  2 +-
 fs/pstore/ram.c                    | 18 +++++++------
 fs/reiserfs/namei.c                |  2 +-
 fs/reiserfs/xattr.c                |  4 +--
 fs/stat.c                          | 55 ++++++++++++++++++++++++++++++++++++++
 fs/ubifs/dir.c                     |  2 +-
 fs/ubifs/file.c                    | 16 +++++------
 fs/ubifs/misc.h                    |  2 +-
 fs/udf/udf_i.h                     |  2 +-
 fs/udf/udf_sb.h                    |  2 +-
 fs/udf/udfdecl.h                   |  7 ++---
 fs/udf/udftime.c                   |  7 ++---
 fs/utimes.c                        | 47 +++++++++++++++++++++++++++-----
 fs/xfs/time.h                      |  4 +--
 fs/xfs/xfs_inode.c                 |  2 +-
 fs/xfs/xfs_iops.c                  |  2 +-
 fs/xfs/xfs_trans_inode.c           |  6 ++---
 include/linux/ceph/decode.h        |  8 +++---
 include/linux/ceph/osd_client.h    |  4 +--
 include/linux/compat.h             |  2 +-
 include/linux/fs.h                 | 32 +++++++++++-----------
 include/linux/nfs_fs_sb.h          |  2 +-
 include/linux/nfs_xdr.h            | 14 +++++-----
 include/linux/pstore.h             |  4 +--
 include/linux/stat.h               |  6 ++---
 include/linux/syscalls.h           |  9 ++++++-
 include/linux/time.h               | 44 +++++++++++++++++++++++++++---
 include/uapi/asm-generic/stat.h    | 29 ++++++++++++++++++--
 include/uapi/asm-generic/unistd.h  |  8 +++++-
 include/uapi/linux/coda.h          |  1 +
 include/uapi/linux/time.h          | 40 ++++++++++++++++++++++++++-
 init/initramfs.c                   |  2 +-
 kernel/audit.c                     |  2 +-
 kernel/auditsc.c                   |  2 +-
 kernel/time.c                      | 44 +++++++++++++++++++++++++-----
 kernel/time/timekeeping.c          | 16 +++++++++++
 net/ceph/auth_x.c                  |  2 +-
 net/ceph/osd_client.c              |  4 +--
 114 files changed, 642 insertions(+), 333 deletions(-)

-- 
1.8.3.2

Bcc: "J. Bruce Fields" <bfields@fieldses.org>
Bcc: "Theodore Ts'o" <tytso@mit.edu>
Bcc: Adrian Hunter <adrian.hunter@intel.com>
Bcc: Andreas Dilger <adilger.kernel@dilger.ca>
Bcc: Andrew Morton <akpm@linux-foundation.org>
Bcc: Anton Altaparmakov <anton@tuxera.com>
Bcc: Anton Vorontsov <anton@enomsg.org>
Bcc: Artem Bityutskiy <dedekind1@gmail.com>
Bcc: Brian Uchino <buchino@cisco.com>
Bcc: Chris Mason <clm@fb.com>
Bcc: Colin Cross <ccross@android.com>
Bcc: Dave Chinner <david@fromorbit.com>
Bcc: David Howells <dhowells@redhat.com>
Bcc: David Woodhouse <dwmw2@infradead.org>
Bcc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Bcc: Hiral Patel <hiralpat@cisco.com>
Bcc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Bcc: Jan Harkes <jaharkes@cs.cmu.edu>
Bcc: Jan Kara <jack@suse.cz>
Bcc: Joel Becker <jlbec@evilplan.org>
Bcc: Joern Engel <joern@logfs.org>
Bcc: Josef Bacik <jbacik@fb.com>
Bcc: Kees Cook <keescook@chromium.org>
Bcc: Mark Fasheh <mfasheh@suse.com>
Bcc: Miklos Szeredi <miklos@szeredi.hu>
Bcc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Bcc: Prasad Joshi <prasadjoshi.linux@gmail.com>
Bcc: Sage Weil <sage@inktank.com>
Bcc: Steve French <sfrench@samba.org>
Bcc: Steven Whitehouse <swhiteho@redhat.com>
Bcc: Suma Ramars <sramars@cisco.com>
Bcc: Tony Luck <tony.luck@intel.com>
Cc: ceph-devel@vger.kernel.org
Cc: cluster-devel@redhat.com
Cc: coda@cs.cmu.edu
Cc: codalist@coda.cs.cmu.edu
Cc: fuse-devel@lists.sourceforge.net
Cc: linux-afs@lists.infradead.org
Cc: linux-btrfs@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Cc: linux-ext4@vger.kernel.org
Cc: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-mtd@lists.infradead.org
Cc: linux-nfs@vger.kernel.org
Cc: linux-ntfs-dev@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org
Cc: logfs@logfs.org
Cc: ocfs2-devel@oss.oracle.com
Cc: reiserfs-devel@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: xfs@oss.sgi.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
