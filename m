Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47064 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933895AbcLURDs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Dec 2016 12:03:48 -0500
From: Jeff Layton <jlayton@redhat.com>
Subject: [RFC PATCH v1 00/30] fs: inode->i_version rework and optimization
Date: Wed, 21 Dec 2016 12:03:17 -0500
Message-Id: <1482339827-7882-1-git-send-email-jlayton@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org

tl;dr: I think we can greatly reduce the cost of the inode->i_version
counter, by exploiting the fact that we don't need to increment it
if no one is looking at it. We can also clean up the code to prepare
to eventually expose this value via statx().

The inode->i_version field is supposed to be a value that changes
whenever there is any data or metadata change to the inode. Some
filesystems use it internally to detect directory changes during
readdir. knfsd will use it if the filesystem has MS_I_VERSION
set. IMA will also use it (though it's not clear to me that that
works 100% -- no check for MS_I_VERSION there).

Only btrfs, ext4, and xfs implement it for data changes. Because of
this, these filesystems must log the inode to disk whenever the
i_version counter changes. That has a non-zero performance impact,
especially on write-heavy workloads, because we end up dirtying the
inode metadata on every write, not just when the times change. [1]

It turns out though that none of these users of i_version require that
i_version change on every change to the file. The only real requirement
is that it be different if _something_ changed since the last time we
queried for it. [2]

So, if we simply keep track of when something queries the value, we
can avoid bumping the counter and that metadata update.

This patchset implements this:

It starts with some small cleanup patches to just remove any mention of
the i_version counter in filesystems that don't actually use it.

Then, we add a new set of static inlines for managing the counter. The
initial version should work identically to what we have now. Then, all
of the remaining filesystems that use i_version are converted to the new
inlines.

Once that's in place, we switch to a new implementation that allows us
to track readers of i_version counter, and only bump it when it's
necessary or convenient (i.e. we're going to disk anyway).

The final patch switches from a scheme that uses the i_lock to serialize
the counter updates during write to an atomic64_t. That's a wash
performance-wise in my testing, but I like not having to take the i_lock
down where it could end up nested inside other locks.

With this, we reduce inode metadata updates across all 3 filesystems
down to roughly the frequency of the timestamp granularity, particularly
when it's not being queried (the vastly common case).

The pessimal workload here is 1 byte writes, and it helps that
significantly. Of course, that's not a real-world workload.

A tiobench-example.fio workload also shows some modest performance
gains, and I've gotten mails from the kernel test robot that show some
significant performance gains on some microbenchmarks (case-msync-mt in
the vm-scalability testsuite to be specific).

I'm happy to run other workloads if anyone can suggest them.

At this point, the patchset works and does what it's expected to do in
my own testing. It seems like it's at least a modest performance win
across all 3 major disk-based filesystems. It may also encourage others
to implement i_version as well since it reduces that cost.

Is this an avenue that's worthwhile to pursue?

Note that I think we may have other changes coming in the future that
will make this sort of cleanup necessary anyway. I'd like to plug in the
Ceph change attribute here eventually, and that will require something
like this anyway.

Thoughts, comments and suggestions are welcome...

---

[1]: On ext4 it must be turned on with the i_version mount option,
     mostly due to fears of incurring this impact, AFAICT.

[2]: NFS also recommends that it appear to increase in value over time, so
     that clients can discard metadata updates that are older than ones
     they've already seen.

Jeff Layton (30):
  lustre: don't set f_version in ll_readdir
  ecryptfs: remove unnecessary i_version bump
  ceph: remove the bump of i_version
  f2fs: don't bother setting i_version
  hpfs: don't bother with the i_version counter
  jfs: remove initialization of i_version counter
  nilfs2: remove inode->i_version initialization
  orangefs: remove initialization of i_version
  reiserfs: remove unneeded i_version bump
  ntfs: remove i_version handling
  fs: new API for handling i_version
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
  fs: add a "force" parameter to inode_inc_iversion
  fs: only set S_VERSION when updating times if it has been queried
  xfs: avoid setting XFS_ILOG_CORE if i_version doesn't need
    incrementing
  btrfs: only dirty the inode in btrfs_update_time if something was
    changed
  fs: track whether the i_version has been queried with an i_state flag
  fs: convert i_version counter over to an atomic64_t

 drivers/staging/lustre/lustre/llite/dir.c |   3 -
 fs/affs/amigaffs.c                        |   4 +-
 fs/affs/dir.c                             |   4 +-
 fs/affs/super.c                           |   2 +-
 fs/afs/fsclient.c                         |   2 +-
 fs/afs/inode.c                            |   4 +-
 fs/btrfs/delayed-inode.c                  |   4 +-
 fs/btrfs/file.c                           |   4 +-
 fs/btrfs/inode.c                          |  41 ++++----
 fs/btrfs/ioctl.c                          |   4 +-
 fs/btrfs/tree-log.c                       |   2 +-
 fs/btrfs/xattr.c                          |   2 +-
 fs/ceph/inode.c                           |   1 -
 fs/ecryptfs/inode.c                       |   1 -
 fs/exofs/dir.c                            |   8 +-
 fs/exofs/super.c                          |   2 +-
 fs/ext2/dir.c                             |   8 +-
 fs/ext2/super.c                           |   4 +-
 fs/ext4/dir.c                             |   8 +-
 fs/ext4/inline.c                          |   6 +-
 fs/ext4/inode.c                           |  16 ++--
 fs/ext4/ioctl.c                           |   2 +-
 fs/ext4/namei.c                           |   8 +-
 fs/ext4/super.c                           |   2 +-
 fs/f2fs/super.c                           |   1 -
 fs/fat/dir.c                              |   2 +-
 fs/fat/inode.c                            |   8 +-
 fs/fat/namei_msdos.c                      |   6 +-
 fs/fat/namei_vfat.c                       |  20 ++--
 fs/hpfs/dir.c                             |   1 -
 fs/hpfs/dnode.c                           |   2 -
 fs/hpfs/super.c                           |   1 -
 fs/inode.c                                |   9 +-
 fs/jfs/super.c                            |   1 -
 fs/nfs/delegation.c                       |   2 +-
 fs/nfs/fscache-index.c                    |   4 +-
 fs/nfs/inode.c                            |  16 ++--
 fs/nfs/nfs4proc.c                         |   4 +-
 fs/nfs/nfstrace.h                         |   4 +-
 fs/nfs/write.c                            |   2 +-
 fs/nfsd/nfs3xdr.c                         |   2 +-
 fs/nfsd/nfs4xdr.c                         |   2 +-
 fs/nfsd/nfsfh.h                           |   2 +-
 fs/nilfs2/super.c                         |   1 -
 fs/ntfs/inode.c                           |   9 --
 fs/ntfs/mft.c                             |   6 --
 fs/ocfs2/dir.c                            |  14 +--
 fs/ocfs2/inode.c                          |   2 +-
 fs/ocfs2/namei.c                          |   2 +-
 fs/ocfs2/quota_global.c                   |   2 +-
 fs/orangefs/super.c                       |   2 -
 fs/reiserfs/super.c                       |   1 -
 fs/ufs/dir.c                              |   8 +-
 fs/ufs/inode.c                            |   2 +-
 fs/ufs/super.c                            |   2 +-
 fs/xfs/libxfs/xfs_inode_buf.c             |   4 +-
 fs/xfs/xfs_icache.c                       |   4 +-
 fs/xfs/xfs_inode.c                        |   2 +-
 fs/xfs/xfs_inode_item.c                   |   2 +-
 fs/xfs/xfs_trans_inode.c                  |  12 +--
 include/linux/fs.h                        | 151 ++++++++++++++++++++++++++++--
 security/integrity/ima/ima_api.c          |   2 +-
 security/integrity/ima/ima_main.c         |   2 +-
 63 files changed, 288 insertions(+), 173 deletions(-)

-- 
2.7.4

