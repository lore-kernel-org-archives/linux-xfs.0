Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E93A67F51
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 23:34:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C973B304032
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 21:34:50 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id JQIFr0ZSuAfejd1s (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 21:34:49 -0800 (PST)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v3 0/6] add support for a lazytime mount option
Date: Tue, 25 Nov 2014 00:34:28 -0500
Message-Id: <1416893674-419-1-git-send-email-tytso@mit.edu>
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
To: Linux Filesystem Development List <linux-fsdevel@vger.kernel.org>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, Linux btrfs Developers List <linux-btrfs@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>

This is an updated version of what had originally been an
ext4-specific patch which significantly improves performance by lazily
writing timestamp updates (and in particular, mtime updates) to disk.
The in-memory timestamps are always correct, but they are only written
to disk when required for correctness.

This provides a huge performance boost for ext4 due to how it handles
journalling, but it's valuable for all file systems running on flash
storage or drive-managed SMR disks by reducing the metadata write
load.  So upon request, I've moved the functionality to the VFS layer.
Once the /sbin/mount program adds support for MS_LAZYTIME, all file
systems should be able to benefit from this optimization.

There is still an ext4-specific optimization, which may be applicable
for other file systems which store more than one inode in a block, but
it will require file system specific code.  It is purely optional,
however.

Please note the changes to update_time() and the new write_time() inode
operations functions, which impact btrfs and xfs.  The changes are
fairly simple, but I would appreciate confirmation from the btrfs and
xfs teams that I got things right.   Thanks!!

Any objections to my carrying these patches in the ext4 git tree?

Changes since -v2:
   - If update_time() updates i_version, it will not use lazytime (i..e,
       the inode will be marked dirty so the change will be persisted on to
       disk sooner rather than later).  Yes, this eliminates the
       benefits of lazytime if the user is experting the file system via
       NFSv4.  Sad, but NFS's requirements seem to mandate this.
   - Fix time wrapping bug 49 days after the system boots (on a system
        with a 32-bit jiffies).   Use get_monotonic_boottime() instead.
   - Clean up type warning in include/tracing/ext4.h
   - Added explicit parenthesis for stylistic reasons    
   - Added an is_readonly() inode operations method so btrfs doesn't
       have to duplicate code in update_time().

Changes since -v1:
   - Added explanatory comments in update_time() regarding i_ts_dirty_days
   - Fix type used for days_since_boot
   - Improve SMP scalability in update_time and ext4_update_other_inodes_time
   - Added tracepoints to help test and characterize how often and under
         what circumstances inodes have their timestamps lazily updated

Theodore Ts'o (6):
  fs: split update_time() into update_time() and write_time()
  vfs: add support for a lazytime mount option
  vfs: don't let the dirty time inodes get more than a day stale
  vfs: add lazytime tracepoints for better debugging
  ext4: add support for a lazytime mount option
  btrfs: add an is_readonly() so btrfs can use common code for
    update_time()

 Documentation/filesystems/Locking |  2 +
 fs/btrfs/inode.c                  | 34 +++++++--------
 fs/ext4/inode.c                   | 48 +++++++++++++++++++--
 fs/ext4/super.c                   |  9 ++++
 fs/fs-writeback.c                 | 42 +++++++++++++++++-
 fs/inode.c                        | 91 ++++++++++++++++++++++++++++++++++++++-
 fs/proc_namespace.c               |  1 +
 fs/sync.c                         |  7 +++
 fs/xfs/xfs_iops.c                 | 39 +++++++----------
 include/linux/fs.h                |  7 ++-
 include/trace/events/ext4.h       | 30 +++++++++++++
 include/uapi/linux/fs.h           |  1 +
 12 files changed, 262 insertions(+), 49 deletions(-)

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
