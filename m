Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 681FB7F56
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 06:35:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 48A458F8035
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:07 -0700 (PDT)
Received: from mail-pd0-f177.google.com (mail-pd0-f177.google.com
	[209.85.192.177]) by cuda.sgi.com with ESMTP id
	QKQKpQ2mVgsmOWUb (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2015 04:35:05 -0700 (PDT)
Received: by pdbcz9 with SMTP id cz9so56061054pdb.3
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 04:35:04 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH 0/5] Remove rw parameter from direct_IO()
Date: Mon, 16 Mar 2015 04:33:48 -0700
Message-Id: <cover.1426502566.git.osandov@osandov.com>
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
To: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, osd-dev@open-osd.org, linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net, HPDD-discuss@lists.01.org, linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net, xfs@oss.sgi.com
Cc: Latchesar Ionkov <lucho@ionkov.net>, Dave Kleikamp <shaggy@kernel.org>, Jan Kara <jack@suse.cz>, Trond Myklebust <trond.myklebust@primarydata.com>, David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>, Yan Zheng <zyan@redhat.com>, Sage Weil <sage@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, Changman Lee <cm224.lee@samsung.com>, Boaz Harrosh <ooo@electrozaur.com>, Eric Van Hensbergen <ericvh@gmail.com>, Mark Fasheh <mfasheh@suse.com>, Oleg Drokin <oleg.drokin@intel.com>, Joel Becker <jlbec@evilplan.org>, Jaegeuk Kim <jaegeuk@kernel.org>, Steven Whitehouse <swhiteho@redhat.com>, Theodore Ts'o <tytso@mit.edu>, Benny Halevy <bhalevy@primarydata.com>, Josef Bacik <jbacik@fb.com>, linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>, Ron Minnich <rminnich@sandia.gov>, Omar Sandoval <osandov@osandov.com>, Anna Schumaker <anna.schumaker@netapp.com>

Hi,

Al, here's some cleanup that you mentioned back in December that I got
around to (https://lkml.org/lkml/2014/12/15/28).

In summary, the rw parameter to a_ops->direct_IO() is redundant with
.type in struct iov_iter. Additionally, rw is inconsistently checked for
being a WRITE; some filesystems do rw == WRITE, others do rw & WRITE,
and others do both within the same function :) The distinction is that
swapout may OR in the ITER_BVEC flag in the rw passed to ->direct_IO(),
so the two are not equivalent (although this really only happens for
swap-over-NFS, but it's scary nonetheless). After looking through all of
these, it definitely looks like every check means for ANY write, not
just non-kernel writes.

So, the solution presented here is:

- Add a helper, iov_iter_rw(), which always returns either READ or
  WRITE, no ITER_.* or REQ_.* nonsense mixed in. For consistency, the
  return value is always checked for equality
- Get rid of all uses of rw in any implementations of direct_IO,
  starting with the generic code
- Nuke the actual parameter and update the documentation

I decided to squish all of the filesystems together in patch 4 to avoid
inundating the mailing lists with 20+ mostly two-line patches, but I can
split those out if that's any better. Additionally, patch 1 pulls fs.h
into uio.h, which seems undesirable.

These were mostly just compile tested, with a couple of direct I/O
xfstests run on btrfs as quick sanity check, so getting some more eyes
on is probably a good thing. They should apply on top of v4.0-rc4.
Please comment away.

Thank you,

Omar Sandoval (5):
  new helper: iov_iter_rw()
  Remove rw from {,__,do_}blockdev_direct_IO()
  Remove rw from dax_{do_,}io()
  direct_IO: use iov_iter_rw() instead of rw everywhere
  direct_IO: remove rw from a_ops->direct_IO()

 Documentation/filesystems/Locking          |  2 +-
 Documentation/filesystems/vfs.txt          |  2 +-
 drivers/staging/lustre/lustre/llite/rw26.c | 22 ++++++++---------
 fs/9p/vfs_addr.c                           |  2 +-
 fs/affs/file.c                             |  9 +++----
 fs/block_dev.c                             |  8 +++---
 fs/btrfs/inode.c                           | 24 +++++++++---------
 fs/ceph/addr.c                             |  3 +--
 fs/cifs/file.c                             |  3 +--
 fs/dax.c                                   | 27 ++++++++++-----------
 fs/direct-io.c                             | 39 ++++++++++++++----------------
 fs/exofs/inode.c                           |  4 +--
 fs/ext2/inode.c                            | 11 ++++-----
 fs/ext3/inode.c                            | 14 +++++------
 fs/ext4/ext4.h                             |  4 +--
 fs/ext4/indirect.c                         | 25 ++++++++++---------
 fs/ext4/inode.c                            | 28 ++++++++++-----------
 fs/f2fs/data.c                             | 22 ++++++++---------
 fs/fat/inode.c                             |  9 +++----
 fs/fuse/file.c                             | 16 ++++++------
 fs/gfs2/aops.c                             | 16 ++++++------
 fs/hfs/inode.c                             |  8 +++---
 fs/hfsplus/inode.c                         |  9 +++----
 fs/jfs/inode.c                             |  8 +++---
 fs/nfs/direct.c                            |  4 +--
 fs/nilfs2/inode.c                          | 10 +++-----
 fs/ocfs2/aops.c                            | 22 +++++++----------
 fs/reiserfs/inode.c                        |  8 +++---
 fs/udf/file.c                              |  3 +--
 fs/udf/inode.c                             |  7 +++---
 fs/xfs/xfs_aops.c                          | 12 ++++-----
 include/linux/fs.h                         | 24 +++++++++---------
 include/linux/nfs_fs.h                     |  2 +-
 include/linux/uio.h                        | 10 ++++++++
 mm/filemap.c                               |  4 +--
 mm/page_io.c                               |  4 +--
 36 files changed, 206 insertions(+), 219 deletions(-)

-- 
2.3.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
