Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 02A167F37
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 17:22:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 91082AC001
	for <xfs@oss.sgi.com>; Wed, 13 Mar 2013 15:22:26 -0700 (PDT)
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 13 Mar 2013 15:21:11 -0700
Message-ID: <87boan3prc.fsf@xmission.com>
MIME-Version: 1.0
Subject: [PATCH 00/14] xfs: Support for interacting with multiple user
	namespaces
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org
Cc: Alex Elder <elder@kernel.org>, Linux Containers <containers@lists.linux-foundation.org>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, "Serge E. Hallyn" <serge@hallyn.com>


Or replace uids, gids, and projids with kuids, kgids, and kprojids

In support of user namespaces I have introduced into the kernel kuids,
kgids, and kprojids.  The most important characteristic of these ids is
that they are not assignment compatible with uids, gids, and projids
coming from userspace nor are they assignment compatible with uids, gids
or projids stored on disk.  This assignment incompatibility makes it
easy to ensure that conversions are introduced at the edge of userspace
and at the interface between on-disk and in-memory data structures.

Getting all of the conversions in all of the right places is important
because if one is missed it can easily become a permission check that
compares the wrong values.

While doing these conversions I have learned time and time again that if
I do not push kuids and kgids down into every in memory data structure I
can find there will be important conversions that are missed.

Converting xfs is an interesting challenge because of the way xfs
handles it's inode data is very atypical.  XFS does two things no other
filesystem in linux does.  XFS dumps it's in-memory inode structure
directly into the on-disk journal without any conversion.  After an
inode has been evicted from vfs inode cache XFS continues to cache the
inode for a time, so that if the inode is needed before all of the
state for the inode has been written to disk an uptodate copy can be
obtained from the in-memory cached inode.

Interacting with users in different user namespaces for filesystems for
the most part is easy.  The vfs data structures hand off kuids and kgids
to the filesystem.  The filesystem then places those kuids and kgids in
it's in memory data structures (if it has any beyond struct inode).
When data is read from disk the uid and gid values are converted from
values in the initial user namespace to kuid and kgid values.  When data
is written to disk the kuids and kgids are converted into uid and gid
values in the initial user namespace.

The initial user namespace is chosen for data on disk, because that is
the user namespace that the data on disk uses for unconverted
filesystems.

When interacting with userspace processes the values are stored
in the current user namespace, which is different for each process.

For example in this chunk of code that has caused some questions what is
happening is:
+       if (mask & FSX_PROJID) {
+               projid = make_kprojid(current_user_ns(), fa->fsx_projid);
+               if (!projid_valid(projid))
+                       return XFS_ERROR(EINVAL);

fsx_projid is coming from userspace so we convert it from whatever the
userspace value is in the current user namespace to a kprojid. 

+               /*
+                * Disallow 32bit project ids when projid32bit feature is not enabled.
+                */
+               if ((from_kprojid(&init_user_ns, projid) > (__uint16_t)-1) &&

The disk might only support 16bit project ids.  So the kprojid is
converted into a projid in the initial user namespace to see what the
value we will eventually try to store on-disk is.  If the on-disk value
is larger than (2^16-1) an error is flagged.

+                   !xfs_sb_version_hasprojid32bit(&ip->i_mount->m_sb))
+                       return XFS_ERROR(EINVAL);
+       }
 

In earlier versions of this patchset I have run afoul of the fact that the
in-memory inode is dumped to disk making a change to that data structure an
ABI change, and then I ran afoul of the fact that despite the fact that
struct xfs_inode survives the embedded struct inode may be evicted from the
vfs and become invalid and all of it's contents stomped with
inode_init_always.

Given the number of ioctls that xfs supports it would be irresponsible to
do anything except insist that kuids, kgids, and kprojids are used in all of
in memory data structures of xfs, as otherwise it becomes trivially easy to
miss a needed conversion with the advent of a new ioctl.

It has been suggested that kuids, and kgids are a vfs construct and should
stop at the vfs and should not be used in xfs data structures.  They are
not a vfs construct they are a kernel construct and are used everywhere in
the kernel.  xfs does not get to be an exception.

To put kuids, kgids, and kprojids in all of the xfs data structures without
breaking the on-disk ABI, this patchset moves struct xfs_icdinode from
struct xfs_inode to xfs_log_item, and introduces a set of conversion
functions.  Introducing the separation between on-disk and in-memory format
that is needed to properly perform this conversion.

I have a few additional patches not included in this posting sitting in my
development tree that removes the extra copie that this change introduces
into xfs_inode_item_format.

xfstests in this instance are boring the same 17 tests keep failing both
before and after my changes.

I don't care through which tree these changes are merged.  If you would
like to take these in through xfs tree that would be great.  Otherwise I
will be happy to take these changes through my user namespace tree.

Eric

Eric W. Biederman (14):
      xfs: Convert uids and gids in xfs acls to/from kuids and kgids
      xfs: Separate the in core and the logged inode.
      xfs: Store projectid as a single variable.
      xfs: Update inode uids, gids, and projids to be kuids, kgids, and kprojids
      xfs: Update xfs_ioctl_setattr to handle projids in any user namespace
      xfs: Use kuids and kgids in xfs_setattr_nonsize
      xfs: Update ioctl(XFS_IOC_FREE_EOFBLOCKS) to handle callers in any userspace
      xfs: Use kprojids when allocating inodes.
      xfs: Modify xfs_qm_vop_dqalloc to take kuids, kgids, and kprojids.
      xfs: Push struct kqid into xfs_qm_scall_qmlim and xfs_qm_scall_getquota
      xfs: Modify xfs_qm_dqget to take a struct kqid.
      xfs: Remember the kqid for a quota
      xfs: Use q_id instead of q_core.d_id.
      xfs: Enable building with user namespaces enabled.

 fs/xfs/xfs_acl.c         |   23 ++++++-
 fs/xfs/xfs_dquot.c       |   39 ++++++++----
 fs/xfs/xfs_dquot.h       |   13 +++-
 fs/xfs/xfs_icache.c      |   14 ++--
 fs/xfs/xfs_icache.h      |   11 +++-
 fs/xfs/xfs_inode.c       |  160 +++++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_inode.h       |   51 +++++++++------
 fs/xfs/xfs_inode_item.c  |    3 +-
 fs/xfs/xfs_inode_item.h  |    1 +
 fs/xfs/xfs_ioctl.c       |   52 ++++++++++++---
 fs/xfs/xfs_iops.c        |   14 ++--
 fs/xfs/xfs_itable.c      |   47 +++++++-------
 fs/xfs/xfs_qm.c          |   83 ++++++++++++------------
 fs/xfs/xfs_qm.h          |    4 +-
 fs/xfs/xfs_qm_bhv.c      |    2 +-
 fs/xfs/xfs_qm_syscalls.c |   24 ++++---
 fs/xfs/xfs_quota.h       |    4 +-
 fs/xfs/xfs_quotaops.c    |   20 +-----
 fs/xfs/xfs_rename.c      |    2 +-
 fs/xfs/xfs_trace.h       |    2 +-
 fs/xfs/xfs_trans_dquot.c |    8 +--
 fs/xfs/xfs_utils.c       |    2 +-
 fs/xfs/xfs_utils.h       |    2 +-
 fs/xfs/xfs_vnodeops.c    |   14 ++--
 init/Kconfig             |    1 -
 25 files changed, 366 insertions(+), 230 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
