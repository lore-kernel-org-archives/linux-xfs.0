Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4C7E929DF7
	for <xfs@oss.sgi.com>; Sat, 22 Nov 2014 10:54:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E1B88F8040
	for <xfs@oss.sgi.com>; Sat, 22 Nov 2014 08:54:38 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id TPqDexFSikDbCZRJ (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 22 Nov 2014 08:54:37 -0800 (PST)
From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v2 0/5] add support for a lazytime mount option
Date: Sat, 22 Nov 2014 11:54:22 -0500
Message-Id: <1416675267-2191-1-git-send-email-tytso@mit.edu>
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
To: linux-fsdevel@vger.kernel.org
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

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

Changes since -v1:
   - Added explanatory comments in update_time() regarding i_ts_dirty_days
   - Fix type used for days_since_boot
   - Improve SMP scalability in update_time and ext4_update_other_inodes_time
   - Added tracepoints to help test and characterize how often and under
         what circumstances inodes have their timestamps lazily updated

Theodore Ts'o (5):
  fs: split update_time() into update_time() and write_time()
  vfs: add support for a lazytime mount option
  vfs: don't let the dirty time inodes get more than a day stale
  vfs: add lazytime tracepoints for better debugging
  ext4: add support for a lazytime mount option

 fs/btrfs/inode.c            |  10 +++++
 fs/ext4/inode.c             |  48 ++++++++++++++++++--
 fs/ext4/super.c             |   9 ++++
 fs/fs-writeback.c           |  42 +++++++++++++++++-
 fs/inode.c                  | 104 +++++++++++++++++++++++++++++++++++++++-----
 fs/proc_namespace.c         |   1 +
 fs/sync.c                   |   7 +++
 fs/xfs/xfs_iops.c           |  39 +++++++----------
 include/linux/fs.h          |   5 +++
 include/trace/events/ext4.h |  29 ++++++++++++
 include/trace/events/fs.h   |  56 ++++++++++++++++++++++++
 include/uapi/linux/fs.h     |   1 +
 12 files changed, 313 insertions(+), 38 deletions(-)
 create mode 100644 include/trace/events/fs.h

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
