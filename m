Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49340 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932482AbeAKUYZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jan 2018 15:24:25 -0500
Date: Thu, 11 Jan 2018 12:23:31 -0800
From: Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH v5 00/19] fs: rework and optimize i_version handling in
 filesystems
Message-ID: <20180111202331.GB12421@dhcp-10-159-141-29.vpn.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <20180109141059.25929-1-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180109141059.25929-1-jlayton@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jeff Layton <jlayton@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-nfs@vger.kernel.org, bfields@fieldses.org, neilb@suse.de, jack@suse.de, linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, linux-xfs@vger.kernel.org, darrick.wong@oracle.com, david@fromorbit.com, linux-btrfs@vger.kernel.org, clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-integrity@vger.kernel.org, zohar@linux.vnet.ibm.com, dmitry.kasatkin@gmail.com, linux-afs@lists.infradead.org, dhowells@redhat.com, jaltman@auristor.com, krzk@kernel.org

On Tue, Jan 09, 2018 at 09:10:40AM -0500, Jeff Layton wrote:
> From: Jeff Layton <jlayton@redhat.com>
> 
> v5:
> - don't corrupt refcounts stashed in i_version of ext4 xattr inodes
> - add raw variants of inc and cmp functions, and have nfs use them
> 
> v4:
> - fix SB_LAZYTIME handling in generic_update_time
> - add memory barriers to patch to convert i_version field to atomic64_t
> 
> v3:
> - move i_version handling functions to new header file
> - document that the kernel-managed i_version implementation will appear to
>   increase over time
> - fix inode_cmp_iversion to handle wraparound correctly
> 
> v2:
> - xfs should use inode_peek_iversion instead of inode_peek_iversion_raw
> - rework file_update_time patch
> - don't dirty inode when only S_ATIME is set and SB_LAZYTIME is enabled
> - better comments and documentation
> 
> I think this is now approaching merge readiness.
> 
> Special thanks to Jan Kara and Dave Chinner who helped me tighten up the
> memory barriers in the final patch, and Krzysztof Kozlowski for help in
> tracking down a set of bugs in the NFS client patch.
> 
> tl;dr: I think we can greatly reduce the cost of the inode->i_version
> counter, by exploiting the fact that we don't need to increment it if no
> one is looking at it. We can also clean up the code to prepare to
> eventually expose this value via statx().
> 
> Note that this set relies on a few patches that are in other trees. The
> full stack that I've been testing with is here:
> 
>     https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/log/?h=iversion
> 
> The inode->i_version field is supposed to be a value that changes
> whenever there is any data or metadata change to the inode. Some
> filesystems use it internally to detect directory changes during
> readdir. knfsd will use it if the filesystem has MS_I_VERSION set. IMA
> will also use it to optimize away some remeasurement if it's available.
> NFS and AFS just use it to store an opaque change attribute from the
> server.
> 
> Only btrfs, ext4, and xfs increment it for data changes. Because of
> this, these filesystems must log the inode to disk whenever the
> i_version counter changes. That has a non-zero performance impact,
> especially on write-heavy workloads, because we end up dirtying the
> inode metadata on every write, not just when the times change.
> 
> It turns out though that none of these users of i_version require that
> it change on every change to the file. The only real requirement is that
> it be different if something changed since the last time we queried for
> it.
> 
> If we keep track of when something queries the value, we can avoid
> bumping the counter and an on-disk update when nothing else has changed
> if no one has queried it since it was last incremented.
> 
> This patchset changes the code to only bump the i_version counter when
> it's strictly necessary, or when we're updating the inode metadata
> anyway (e.g. when times change).
> 
> It takes the approach of converting the existing accessors of i_version
> to use a new API, while leaving the underlying implementation mostly the
> same.  The last patch then converts the existing implementation to keep
> track of whether the value has been queried since it was last
> incremented. It then uses that to avoid incrementing the counter when
> it can.
> 
> With this, we reduce inode metadata updates across all 3 filesystems
> down to roughly the frequency of the timestamp granularity, particularly
> when it's not being queried (the vastly common case).
> 
> I can see measurable performance gains on xfs and ext4 with iversion
> enabled, when streaming small (4k) I/Os.
> 
> btrfs shows some slight gain in testing, but not quite the magnitude
> that xfs and ext4 show. I'm not sure why yet and would appreciate some
> input from btrfs folks.
>

Thanks for the patchset.

Not sure about how you tested the performance, but in terms of
write+fsync or synchronous write, btrfs's fsync doesn't check if no
timestamp/iversion has been changed, instead only checks if inode has
been logged by some btrfs internal flags and counters, probably
because by default every write is cow and every write incurs a new
block allocation and some update is required.

Long time ago I made an attempt to fix fsync of nocow case where we
can skip the heavy flushing log part iff there is no
timestamp/iversion update and no isize change[1], but it ended no
where.  It was not a complete fix, but is good to explain the problem
we have.

[1]: https://www.spinics.net/lists/linux-btrfs/msg44762.html

Thanks,

-liubo
> My goal is to get this into linux-next fairly soon. If it shows no
> problems then we can look at merging it for 4.16, or 4.17 if all of the
> prequisite patches are not yet merged.
> 
> Jeff Layton (19):
>   fs: new API for handling inode->i_version
>   fs: don't take the i_lock in inode_inc_iversion
>   fat: convert to new i_version API
>   affs: convert to new i_version API
>   afs: convert to new i_version API
>   btrfs: convert to new i_version API
>   exofs: switch to new i_version API
>   ext2: convert to new i_version API
>   ext4: convert to new i_version API
>   nfs: convert to new i_version API
>   nfsd: convert to new i_version API
>   ocfs2: convert to new i_version API
>   ufs: use new i_version API
>   xfs: convert to new i_version API
>   IMA: switch IMA over to new i_version API
>   fs: only set S_VERSION when updating times if necessary
>   xfs: avoid setting XFS_ILOG_CORE if i_version doesn't need
>     incrementing
>   btrfs: only dirty the inode in btrfs_update_time if something was
>     changed
>   fs: handle inode->i_version more efficiently
> 
>  fs/affs/amigaffs.c                |   5 +-
>  fs/affs/dir.c                     |   5 +-
>  fs/affs/super.c                   |   3 +-
>  fs/afs/fsclient.c                 |   3 +-
>  fs/afs/inode.c                    |   5 +-
>  fs/btrfs/delayed-inode.c          |   7 +-
>  fs/btrfs/file.c                   |   1 +
>  fs/btrfs/inode.c                  |  12 +-
>  fs/btrfs/ioctl.c                  |   1 +
>  fs/btrfs/tree-log.c               |   4 +-
>  fs/btrfs/xattr.c                  |   1 +
>  fs/exofs/dir.c                    |   9 +-
>  fs/exofs/super.c                  |   3 +-
>  fs/ext2/dir.c                     |   9 +-
>  fs/ext2/super.c                   |   5 +-
>  fs/ext4/dir.c                     |   9 +-
>  fs/ext4/inline.c                  |   7 +-
>  fs/ext4/inode.c                   |  13 +-
>  fs/ext4/ioctl.c                   |   3 +-
>  fs/ext4/namei.c                   |   5 +-
>  fs/ext4/super.c                   |   3 +-
>  fs/ext4/xattr.c                   |   5 +-
>  fs/fat/dir.c                      |   3 +-
>  fs/fat/inode.c                    |   9 +-
>  fs/fat/namei_msdos.c              |   7 +-
>  fs/fat/namei_vfat.c               |  22 +--
>  fs/inode.c                        |  11 +-
>  fs/nfs/delegation.c               |   3 +-
>  fs/nfs/fscache-index.c            |   5 +-
>  fs/nfs/inode.c                    |  18 +-
>  fs/nfs/nfs4proc.c                 |  10 +-
>  fs/nfs/nfstrace.h                 |   5 +-
>  fs/nfs/write.c                    |   8 +-
>  fs/nfsd/nfsfh.h                   |   3 +-
>  fs/ocfs2/dir.c                    |  15 +-
>  fs/ocfs2/inode.c                  |   3 +-
>  fs/ocfs2/namei.c                  |   3 +-
>  fs/ocfs2/quota_global.c           |   3 +-
>  fs/ufs/dir.c                      |   9 +-
>  fs/ufs/inode.c                    |   3 +-
>  fs/ufs/super.c                    |   3 +-
>  fs/xfs/libxfs/xfs_inode_buf.c     |   7 +-
>  fs/xfs/xfs_icache.c               |   5 +-
>  fs/xfs/xfs_inode.c                |   3 +-
>  fs/xfs/xfs_inode_item.c           |   3 +-
>  fs/xfs/xfs_trans_inode.c          |  16 +-
>  include/linux/fs.h                |  17 +-
>  include/linux/iversion.h          | 335 ++++++++++++++++++++++++++++++++++++++
>  security/integrity/ima/ima_api.c  |   3 +-
>  security/integrity/ima/ima_main.c |   3 +-
>  50 files changed, 518 insertions(+), 135 deletions(-)
>  create mode 100644 include/linux/iversion.h
> 
> -- 
> 2.14.3
> 
