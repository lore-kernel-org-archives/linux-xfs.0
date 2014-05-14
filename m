Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-3.15-rc5-1332-g2d6dcc6
Message-Id: <20140514235605.C85387F47@oss.sgi.com>
Date: Wed, 14 May 2014 18:56:05 -0500 (CDT)
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
To: xfs@oss.sgi.com

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, for-next has been updated
  discards  a3f929877fab0bd5f759a62c9a1b5cf5673525d2 (commit)
  discards  d4f8a227bda5d95a2280bd2a96ad0a0b545349da (commit)
  discards  b8b39d39f94c0d3ea5771d1df3151c569599c20a (commit)
  discards  7043507bfa1af648512e36d95cca484757df0b64 (commit)
  discards  c24c775c5e3657d329ede70f744ba075095bb53d (commit)
  2d6dcc6 Merge branch 'xfs-attr-cleanup' into for-next
  ff14ee4 Merge branch 'xfs-misc-fixes-1-for-3.16' into for-next
  b767692 Merge branch 'xfs-free-inode-btree' into for-next
  232c2f5 Merge branch 'xfs-filestreams-lookup' into for-next
  fdd3a2a Merge branch 'xfs-unused-args-cleanup' into for-next
  ee4eec4 xfs: list_lru_init returns a negative error
  bc14782 xfs: negate xfs_icsb_init_counters error value 
  4568764 xfs: negate mount workqueue init error value
  6670232 xfs: fix wrong err sign on xfs_set_acl()
  a5a14de xfs: fix wrong errno from xfs_initxattrs
  65149e3 xfs: correct error sign on COLLAPSE_RANGE errors
  b38a134 xfs: xfs_commit_metadata returns wrong errno
  8ff1e67 xfs: fix incorrect error sign in xfs_file_aio_read
  43ec146 xfs: xfs_dir_fsync() returns positive errno
  6c888af xfs: pass struct da_args to xfs_attr_calc_size
  67fd718 xfs: simplify attr name setup
  1bc426a xfs: fold xfs_attr_remove_int into xfs_attr_remove
  b87d022 xfs: fold xfs_attr_get_int into xfs_attr_get
  c5b4ac3 xfs: fold xfs_attr_set_int into xfs_attr_set
  afcf0a2 Merge tag 'xfs-for-linus-3.15-rc5' of git://oss.sgi.com/xfs/xfs
  9ac0367 Merge tag 'ext4_for_linus_stable' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
  23fffa9 fs: move falloc collapse range check into the filesystem methods
      from  a3f929877fab0bd5f759a62c9a1b5cf5673525d2 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 2d6dcc6d7e95cc83046b2f97e179e6bbb7921245
Merge: ff14ee4 6c888af
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu May 15 09:39:28 2014 +1000

    Merge branch 'xfs-attr-cleanup' into for-next
    
    Conflicts:
    	fs/xfs/xfs_attr.c

commit ff14ee42a038cf48263ac8d2eca5d30196554b82
Merge: b767692 8cfcc3e
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu May 15 09:38:15 2014 +1000

    Merge branch 'xfs-misc-fixes-1-for-3.16' into for-next

commit b76769294ba400415fc44038c21cc2df86f9a28b
Merge: 232c2f5 53801fd
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu May 15 09:37:44 2014 +1000

    Merge branch 'xfs-free-inode-btree' into for-next

commit 232c2f5c65dd80055e7163a5c82e3816119330e6
Merge: fdd3a2a b94acd4
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu May 15 09:36:59 2014 +1000

    Merge branch 'xfs-filestreams-lookup' into for-next

commit fdd3a2ae2e48310491e605c46201c95629dd450b
Merge: ee4eec4 5e06d14
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu May 15 09:36:35 2014 +1000

    Merge branch 'xfs-unused-args-cleanup' into for-next

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_attr.c   | 328 +++++++++++++++++++---------------------------------
 fs/xfs/xfs_export.c |   2 +-
 fs/xfs/xfs_file.c   |  16 ++-
 fs/xfs/xfs_iops.c   |  12 +-
 fs/xfs/xfs_qm.c     |  26 +++--
 fs/xfs/xfs_super.c  |   4 +-
 6 files changed, 152 insertions(+), 236 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
