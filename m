Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754229AbdLPNrA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 16 Dec 2017 08:47:00 -0500
From: Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 00/19] fs: rework and optimize i_version handling in filesystems
Date: Sat, 16 Dec 2017 08:46:37 -0500
Message-Id: <20171216134656.15561-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com

From: Jeff Layton <jlayton@redhat.com>

v2:
- xfs should use inode_peek_iversion instead of inode_peek_iversion_raw
- rework file_update_time patch
- don't dirty inode when only S_ATIME is set and SB_LAZYTIME is enabled
- better comments and documentation

tl;dr: I think we can greatly reduce the cost of the inode->i_version
counter, by exploiting the fact that we don't need to increment it if no
one is looking at it. We can also clean up the code to prepare to
eventually expose this value via statx().

Note that this set relies on a few patches that are in other trees. The
full stack that I've been testing with is here:

    https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/log/?h=iversion

The inode->i_version field is supposed to be a value that changes
whenever there is any data or metadata change to the inode. Some
filesystems use it internally to detect directory changes during
readdir. knfsd will use it if the filesystem has MS_I_VERSION set. IMA
will also use it to optimize away some remeasurement if it's available.
NFS and AFS just use it to store an opaque change attribute from the
server.

Only btrfs, ext4, and xfs increment it for data changes. Because of
this, these filesystems must log the inode to disk whenever the
i_version counter changes. That has a non-zero performance impact,
especially on write-heavy workloads, because we end up dirtying the
inode metadata on every write, not just when the times change. [1]

It turns out though that none of these users of i_version require that
it change on every change to the file. The only real requirement is that
it be different if something changed since the last time we queried for
it.

If we keep track of when something queries the value, we can avoid
bumping the counter and an on-disk update when nothing else has changed
if no one has queried it since it was last incremented.

This patchset changes the code to only bump the i_version counter when
it's strictly necessary, or when we're updating the inode metadata
anyway (e.g. when times change).

It takes the approach of converting the existing accessors of i_version
to use a new API, while leaving the underlying implementation mostly the
same.  The last patch then converts the existing implementation to keep
track of whether the value has been queried since it was last
incremented. It then uses that to avoid incrementing the counter when
it can.

With this, we reduce inode metadata updates across all 3 filesystems
down to roughly the frequency of the timestamp granularity, particularly
when it's not being queried (the vastly common case).

I can see measurable performance gains on xfs and ext4 with iversion
enabled, when streaming small (4k) I/Os. 

btrfs shows some slight gain in testing, but not quite the magnitude
that xfs and ext4 show. I'm not sure why yet and would appreciate some
input from btrfs folks.

My goal is to get this into -next fairly soon. If it shows no problems
then we can look at merging it for 4.16, or 4.17 if all of the
prequisite patches are not yet merged.

Jeff Layton (19):
  fs: new API for handling inode->i_version
  fs: don't take the i_lock in inode_inc_iversion
  fat: convert to new i_version API
  affs: convert to new i_version API
  afs: convert to new i_version API
  btrfs: convert to new i_version API
  exofs: switch to new i_version API
  ext2: convert to new i_version API
  ext4: convert to new i_version API
  nfs: convert to new i_version API
  nfsd: convert to new i_version API
  ocfs2: convert to new i_version API
  ufs: use new i_version API
  xfs: convert to new i_version API
  IMA: switch IMA over to new i_version API
  fs: only set S_VERSION when updating times if necessary
  xfs: avoid setting XFS_ILOG_CORE if i_version doesn't need
    incrementing
  btrfs: only dirty the inode in btrfs_update_time if something was
    changed
  fs: handle inode->i_version more efficiently

 fs/affs/amigaffs.c                |   4 +-
 fs/affs/dir.c                     |   4 +-
 fs/affs/super.c                   |   2 +-
 fs/afs/fsclient.c                 |   2 +-
 fs/afs/inode.c                    |   4 +-
 fs/btrfs/delayed-inode.c          |   6 +-
 fs/btrfs/inode.c                  |  11 +-
 fs/btrfs/tree-log.c               |   3 +-
 fs/exofs/dir.c                    |   8 +-
 fs/exofs/super.c                  |   2 +-
 fs/ext2/dir.c                     |   8 +-
 fs/ext2/super.c                   |   4 +-
 fs/ext4/dir.c                     |   8 +-
 fs/ext4/inline.c                  |   6 +-
 fs/ext4/inode.c                   |  12 +-
 fs/ext4/ioctl.c                   |   2 +-
 fs/ext4/namei.c                   |   4 +-
 fs/ext4/super.c                   |   2 +-
 fs/ext4/xattr.c                   |   4 +-
 fs/fat/dir.c                      |   2 +-
 fs/fat/inode.c                    |   8 +-
 fs/fat/namei_msdos.c              |   6 +-
 fs/fat/namei_vfat.c               |  20 +--
 fs/inode.c                        |  19 ++-
 fs/nfs/delegation.c               |   2 +-
 fs/nfs/fscache-index.c            |   4 +-
 fs/nfs/inode.c                    |  16 +--
 fs/nfs/nfs4proc.c                 |   9 +-
 fs/nfs/nfstrace.h                 |   4 +-
 fs/nfs/write.c                    |   7 +-
 fs/nfsd/nfsfh.h                   |   2 +-
 fs/ocfs2/dir.c                    |  14 +-
 fs/ocfs2/inode.c                  |   2 +-
 fs/ocfs2/namei.c                  |   2 +-
 fs/ocfs2/quota_global.c           |   2 +-
 fs/ufs/dir.c                      |   8 +-
 fs/ufs/inode.c                    |   2 +-
 fs/ufs/super.c                    |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c     |   5 +-
 fs/xfs/xfs_icache.c               |   4 +-
 fs/xfs/xfs_inode.c                |   2 +-
 fs/xfs/xfs_inode_item.c           |   2 +-
 fs/xfs/xfs_trans_inode.c          |  14 +-
 include/linux/fs.h                | 275 ++++++++++++++++++++++++++++++++++++--
 security/integrity/ima/ima_api.c  |   2 +-
 security/integrity/ima/ima_main.c |   2 +-
 46 files changed, 404 insertions(+), 129 deletions(-)

-- 
2.14.3

