Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. xfs-for-linus-3.15-rc1-14826-gc9eaa44
Message-Id: <20140414072728.B89D57F52@oss.sgi.com>
Date: Mon, 14 Apr 2014 02:27:25 -0500 (CDT)
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

The branch, master has been updated
  5166701 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
  f182036 mm: implement ->map_pages for page cache
  d15e031 Merge tag 'xfs-for-linus-3.15-rc1' of git://oss.sgi.com/xfs/xfs
  24e7ea3 Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
  91b0abe mm + fs: store shadow entries in page cache
  a6cf33b Merge branch 'xfs-bug-fixes-for-3.15-3' into for-next
  c88547a xfs: fix directory hash ordering bug
  805eeb8 xfs: extra semi-colon breaks a condition
  0a64bc2 xfs_file_buffered_aio_write(): switch to generic_perform_write()
  5cb6c6c generic_file_direct_write(): get rid of ppos argument
  fcacafd kill the 5th argument of generic_file_buffered_write()
  5d826c8 new helper: readlink_copy()
  02b9984 fs: push sync_filesystem() down to the file system's remount_fs()
  fe986f9 Merge branch 'xfs-O_TMPFILE-support' into for-next
  5f44e4c Merge branch 'xfs-bug-fixes-for-3.15-2' into for-next
  49ae4b9 Merge branch 'xfs-verifier-cleanup' into for-next
  730357a Merge branch 'xfs-stack-fixes' into for-next
  b6db055 Merge branch 'xfs-collapse-range' into for-next
  376ba31 xfs: Add support for FALLOC_FL_ZERO_RANGE
  fe4c224 xfs: inode log reservations are still too small
  a49935f xfs: xfs_check_page_type buffer checks need help
  e480a72 xfs: avoid AGI/AGF deadlock scenario for inode chunk allocation
  ae687e5 xfs: use NOIO contexts for vm_map_ram
  ac75a1f xfs: don't leak EFSBADCRC to userspace
  8d75318 Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
  93a8614 xfs: fix directory inode iolock lockdep false positive
  a1358aa xfs: allocate xfs_da_args to reduce stack footprint
  f876e44 xfs: always do log forces via the workqueue
  ce5028c xfs: modify verifiers to differentiate CRC from other errors
  db9355c xfs: print useful caller information in xfs_error_report
  ca23f8f xfs: add xfs_verifier_error()
  f1dbcd7 xfs: add helper for updating checksums on xfs_bufs
  5158217 xfs: add helper for verifying checksums on xfs_bufs
  533b81c xfs: Use defines for CRC offsets in all cases
  e0d2c23 xfs: skip pointless CRC updates after verifier failures
  e1d8fb8 xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
  645ceee Merge branch 'xfs-fixes-for-3.14-rc4' of git://oss.sgi.com/xfs/xfs
  0dc83bd Revert "writeback: do not sync data dirtied after sync start"
  027f185 Merge remote-tracking branch 'xfs-async-aio-extend' into for-next
  b678573 Merge branch 'xfs-fixes-for-3.15' into for-next
  5ef11eb xfs: limit superblock corruption errors to actual corruption
  daba542 xfs: skip verification on initial "guess" superblock read
  7a01e70 xfs: xfs_sb_read_verify() doesn't flag bad crcs on primary sb
  3895e51 xfs: ensure correct log item buffer alignment
  fe60a8a xfs: ensure correct timestamp updates from truncate
  9862f62 xfs: allow appending aio writes
  d531d91 xfs: always use unwritten extents for direct I/O writes
  d311d79 fix O_SYNC|O_APPEND syncing the wrong range on write()
  492185e xfs: remove XFS_TRANS_DEBUG dead code
  4ae69fe xfs: return -E2BIG if hit the maximum size limits of ACLs
  392c6de xfs: sanitize sb_inopblock in xfs_mount_validate_sb
  c6f9726 xfs: convert xfs_log_commit_cil() to void
  410b11a xfs: use tr_qm_dqalloc log reservation for dquot alloc
  c19ec23 xfs: remove unused tr_swrite
  70bbca07 xfs: use tr_growrtalloc for growing rt files
  ab29743 xfs: allow linkat() on O_TMPFILE files
  99b6436 xfs: add O_TMPFILE support
  163467d xfs: factor prid related codes into xfs_get_initial_prid()
      from  38dbfb59d1175ef458d006556061adeaa8751b72 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 5166701b368caea89d57b14bf41cf39e819dad51
Merge: 0a7418f a786c06
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Apr 12 14:49:50 2014 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
    
    Pull vfs updates from Al Viro:
     "The first vfs pile, with deep apologies for being very late in this
      window.
    
      Assorted cleanups and fixes, plus a large preparatory part of iov_iter
      work.  There's a lot more of that, but it'll probably go into the next
      merge window - it *does* shape up nicely, removes a lot of
      boilerplate, gets rid of locking inconsistencie between aio_write and
      splice_write and I hope to get Kent's direct-io rewrite merged into
      the same queue, but some of the stuff after this point is having
      (mostly trivial) conflicts with the things already merged into
      mainline and with some I want more testing.
    
      This one passes LTP and xfstests without regressions, in addition to
      usual beating.  BTW, readahead02 in ltp syscalls testsuite has started
      giving failures since "mm/readahead.c: fix readahead failure for
      memoryless NUMA nodes and limit readahead pages" - might be a false
      positive, might be a real regression..."
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs: (63 commits)
      missing bits of "splice: fix racy pipe->buffers uses"
      cifs: fix the race in cifs_writev()
      ceph_sync_{,direct_}write: fix an oops on ceph_osdc_new_request() failure
      kill generic_file_buffered_write()
      ocfs2_file_aio_write(): switch to generic_perform_write()
      ceph_aio_write(): switch to generic_perform_write()
      xfs_file_buffered_aio_write(): switch to generic_perform_write()
      export generic_perform_write(), start getting rid of generic_file_buffer_write()
      generic_file_direct_write(): get rid of ppos argument
      btrfs_file_aio_write(): get rid of ppos
      kill the 5th argument of generic_file_buffered_write()
      kill the 4th argument of __generic_file_aio_write()
      lustre: don't open-code kernel_recvmsg()
      ocfs2: don't open-code kernel_recvmsg()
      drbd: don't open-code kernel_recvmsg()
      constify blk_rq_map_user_iov() and friends
      lustre: switch to kernel_sendmsg()
      ocfs2: don't open-code kernel_sendmsg()
      take iov_iter stuff to mm/iov_iter.c
      process_vm_access: tidy up a bit
      ...

commit f1820361f83d556a7f0a9f629100f3825e594328
Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Date:   Mon Apr 7 15:37:19 2014 -0700

    mm: implement ->map_pages for page cache
    
    filemap_map_pages() is generic implementation of ->map_pages() for
    filesystems who uses page cache.
    
    It should be safe to use filemap_map_pages() for ->map_pages() if
    filesystem use filemap_fault() for ->fault().
    
    Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: Rik van Riel <riel@redhat.com>
    Cc: Andi Kleen <ak@linux.intel.com>
    Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
    Cc: Dave Hansen <dave.hansen@linux.intel.com>
    Cc: Alexander Viro <viro@zeniv.linux.org.uk>
    Cc: Dave Chinner <david@fromorbit.com>
    Cc: Ning Qu <quning@gmail.com>
    Cc: Hugh Dickins <hughd@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit d15e03104eb9a4f8e244ab6ed3ca5a107e46db13
Merge: 24e7ea3 a6cf33b
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Apr 4 15:50:08 2014 -0700

    Merge tag 'xfs-for-linus-3.15-rc1' of git://oss.sgi.com/xfs/xfs
    
    Pull xfs update from Dave Chinner:
     "There are a couple of new fallocate features in this request - it was
      decided that it was easiest to push them through the XFS tree using
      topic branches and have the ext4 support be based on those branches.
      Hence you may see some overlap with the ext4 tree merge depending on
      how they including those topic branches into their tree.  Other than
      that, there is O_TMPFILE support, some cleanups and bug fixes.
    
      The main changes in the XFS tree for 3.15-rc1 are:
    
       - O_TMPFILE support
       - allowing AIO+DIO writes beyond EOF
       - FALLOC_FL_COLLAPSE_RANGE support for fallocate syscall and XFS
         implementation
       - FALLOC_FL_ZERO_RANGE support for fallocate syscall and XFS
         implementation
       - IO verifier cleanup and rework
       - stack usage reduction changes
       - vm_map_ram NOIO context fixes to remove lockdep warings
       - various bug fixes and cleanups"
    
    * tag 'xfs-for-linus-3.15-rc1' of git://oss.sgi.com/xfs/xfs: (34 commits)
      xfs: fix directory hash ordering bug
      xfs: extra semi-colon breaks a condition
      xfs: Add support for FALLOC_FL_ZERO_RANGE
      fs: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
      xfs: inode log reservations are still too small
      xfs: xfs_check_page_type buffer checks need help
      xfs: avoid AGI/AGF deadlock scenario for inode chunk allocation
      xfs: use NOIO contexts for vm_map_ram
      xfs: don't leak EFSBADCRC to userspace
      xfs: fix directory inode iolock lockdep false positive
      xfs: allocate xfs_da_args to reduce stack footprint
      xfs: always do log forces via the workqueue
      xfs: modify verifiers to differentiate CRC from other errors
      xfs: print useful caller information in xfs_error_report
      xfs: add xfs_verifier_error()
      xfs: add helper for updating checksums on xfs_bufs
      xfs: add helper for verifying checksums on xfs_bufs
      xfs: Use defines for CRC offsets in all cases
      xfs: skip pointless CRC updates after verifier failures
      xfs: Add support FALLOC_FL_COLLAPSE_RANGE for fallocate
      ...

commit 24e7ea3bea94fe05eae5019f5f12bcdc98fc5157
Merge: 8e343c8 ad6599a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Apr 4 15:39:39 2014 -0700

    Merge tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4
    
    Pull ext4 updates from Ted Ts'o:
     "Major changes for 3.14 include support for the newly added ZERO_RANGE
      and COLLAPSE_RANGE fallocate operations, and scalability improvements
      in the jbd2 layer and in xattr handling when the extended attributes
      spill over into an external block.
    
      Other than that, the usual clean ups and minor bug fixes"
    
    * tag 'ext4_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4: (42 commits)
      ext4: fix premature freeing of partial clusters split across leaf blocks
      ext4: remove unneeded test of ret variable
      ext4: fix comment typo
      ext4: make ext4_block_zero_page_range static
      ext4: atomically set inode->i_flags in ext4_set_inode_flags()
      ext4: optimize Hurd tests when reading/writing inodes
      ext4: kill i_version support for Hurd-castrated file systems
      ext4: each filesystem creates and uses its own mb_cache
      fs/mbcache.c: doucple the locking of local from global data
      fs/mbcache.c: change block and index hash chain to hlist_bl_node
      ext4: Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
      ext4: refactor ext4_fallocate code
      ext4: Update inode i_size after the preallocation
      ext4: fix partial cluster handling for bigalloc file systems
      ext4: delete path dealloc code in ext4_ext_handle_uninitialized_extents
      ext4: only call sync_filesystm() when remounting read-only
      fs: push sync_filesystem() down to the file system's remount_fs()
      jbd2: improve error messages for inconsistent journal heads
      jbd2: minimize region locked by j_list_lock in jbd2_journal_forget()
      jbd2: minimize region locked by j_list_lock in journal_get_create_access()
      ...

commit 91b0abe36a7b2b3b02d7500925a5f8455334f0e5
Author: Johannes Weiner <hannes@cmpxchg.org>
Date:   Thu Apr 3 14:47:49 2014 -0700

    mm + fs: store shadow entries in page cache
    
    Reclaim will be leaving shadow entries in the page cache radix tree upon
    evicting the real page.  As those pages are found from the LRU, an
    iput() can lead to the inode being freed concurrently.  At this point,
    reclaim must no longer install shadow pages because the inode freeing
    code needs to ensure the page tree is really empty.
    
    Add an address_space flag, AS_EXITING, that the inode freeing code sets
    under the tree lock before doing the final truncate.  Reclaim will check
    for this flag before installing shadow pages.
    
    Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
    Reviewed-by: Rik van Riel <riel@redhat.com>
    Reviewed-by: Minchan Kim <minchan@kernel.org>
    Cc: Andrea Arcangeli <aarcange@redhat.com>
    Cc: Bob Liu <bob.liu@oracle.com>
    Cc: Christoph Hellwig <hch@infradead.org>
    Cc: Dave Chinner <david@fromorbit.com>
    Cc: Greg Thelen <gthelen@google.com>
    Cc: Hugh Dickins <hughd@google.com>
    Cc: Jan Kara <jack@suse.cz>
    Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Cc: Luigi Semenzato <semenzato@google.com>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: Metin Doslu <metin@citusdata.com>
    Cc: Michel Lespinasse <walken@google.com>
    Cc: Ozgun Erdogan <ozgun@citusdata.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Roman Gushchin <klamm@yandex-team.ru>
    Cc: Ryan Mallon <rmallon@gmail.com>
    Cc: Tejun Heo <tj@kernel.org>
    Cc: Vlastimil Babka <vbabka@suse.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit 0a64bc2c0474640a850febd5ac3abb8d45b32821
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Feb 11 22:25:22 2014 -0500

    xfs_file_buffered_aio_write(): switch to generic_perform_write()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 5cb6c6c7eb1ed24744b41fad47d9a25b72207098
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Feb 11 20:58:20 2014 -0500

    generic_file_direct_write(): get rid of ppos argument
    
    always equal to &iocb->ki_pos.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit fcacafd269adc88f41b68cb77a3f957a66563428
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Feb 9 13:37:49 2014 -0500

    kill the 5th argument of generic_file_buffered_write()
    
    same story - it's &iocb->ki_pos in all cases
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 5d826c847b34de6415b4f1becd88a57ff619af50
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri Mar 14 13:42:45 2014 -0400

    new helper: readlink_copy()
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 02b9984d640873b7b3809e63f81a0d7e13496886
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Mar 13 10:14:33 2014 -0400

    fs: push sync_filesystem() down to the file system's remount_fs()
    
    Previously, the no-op "mount -o mount /dev/xxx" operation when the
    file system is already mounted read-write causes an implied,
    unconditional syncfs().  This seems pretty stupid, and it's certainly
    documented or guaraunteed to do this, nor is it particularly useful,
    except in the case where the file system was mounted rw and is getting
    remounted read-only.
    
    However, it's possible that there might be some file systems that are
    actually depending on this behavior.  In most file systems, it's
    probably fine to only call sync_filesystem() when transitioning from
    read-write to read-only, and there are some file systems where this is
    not needed at all (for example, for a pseudo-filesystem or something
    like romfs).
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: linux-fsdevel@vger.kernel.org
    Cc: Christoph Hellwig <hch@infradead.org>
    Cc: Artem Bityutskiy <dedekind1@gmail.com>
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: Evgeniy Dushistov <dushistov@mail.ru>
    Cc: Jan Kara <jack@suse.cz>
    Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    Cc: Anders Larsen <al@alarsen.net>
    Cc: Phillip Lougher <phillip@squashfs.org.uk>
    Cc: Kees Cook <keescook@chromium.org>
    Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
    Cc: Petr Vandrovec <petr@vandrovec.name>
    Cc: xfs@oss.sgi.com
    Cc: linux-btrfs@vger.kernel.org
    Cc: linux-cifs@vger.kernel.org
    Cc: samba-technical@lists.samba.org
    Cc: codalist@coda.cs.cmu.edu
    Cc: linux-ext4@vger.kernel.org
    Cc: linux-f2fs-devel@lists.sourceforge.net
    Cc: fuse-devel@lists.sourceforge.net
    Cc: cluster-devel@redhat.com
    Cc: linux-mtd@lists.infradead.org
    Cc: jfs-discussion@lists.sourceforge.net
    Cc: linux-nfs@vger.kernel.org
    Cc: linux-nilfs@vger.kernel.org
    Cc: linux-ntfs-dev@lists.sourceforge.net
    Cc: ocfs2-devel@oss.oracle.com
    Cc: reiserfs-devel@vger.kernel.org

commit 8d7531825c0dc24f3f300c07fb1a2a3a00b9e89c
Merge: bb7d43b14 ff57cd5
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Feb 27 10:37:22 2014 -0800

    Merge branch 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
    
    Pull filesystem fixes from Jan Kara:
     "Notification, writeback, udf, quota fixes
    
      The notification patches are (with one exception) a fallout of my
      fsnotify rework which went into -rc1 (I've extented LTP to cover these
      cornercases to avoid similar breakage in future).
    
      The UDF patch is a nasty data corruption Al has recently reported,
      the revert of the writeback patch is due to possibility of violating
      sync(2) guarantees, and a quota bug can lead to corruption of quota
      files in ocfs2"
    
    * 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs:
      fsnotify: Allocate overflow events with proper type
      fanotify: Handle overflow in case of permission events
      fsnotify: Fix detection whether overflow event is queued
      Revert "writeback: do not sync data dirtied after sync start"
      quota: Fix race between dqput() and dquot_scan_active()
      udf: Fix data corruption on file type conversion
      inotify: Fix reporting of cookies for inotify events

commit 645ceee885facc6de60051be150ca1b06bdb9e51
Merge: 1052710 5ef11eb
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Feb 22 08:26:01 2014 -0800

    Merge branch 'xfs-fixes-for-3.14-rc4' of git://oss.sgi.com/xfs/xfs
    
    Pull xfs fixes from Dave Chinner:
     "This is the first pull request I've had to do for you, so I'm still
      sorting things out.  The reason I'm sending this and not Ben should be
      obvious from the first commit below - SGI has stepped down from the
      XFS maintainership role.  As such, I'd like to take another
      opportunity to thank them for their many years of effort maintaining
      XFS and supporting the XFS community that they developed from the
      ground up.
    
      So I haven't had time to work things like signed tags into my
      workflows yet, so this is just a repo branch I'm asking you to pull
      from.  And yes, I named the branch -rc4 because I wanted the fixes in
      rc4, not because the branch was for merging into -rc3.  Probably not
      right, either.
    
      Anyway, I should have everything sorted out by the time the next merge
      window comes around.  If there's anything that you don't like in the
      pull req, feel free to flame me unmercifully.
    
      The changes are fixes for recent regressions and important thinkos in
      verification code:
    
            - a log vector buffer alignment issue on ia32
            - timestamps on truncate got mangled
            - primary superblock CRC validation fixes and error message
              sanitisation"
    
    * 'xfs-fixes-for-3.14-rc4' of git://oss.sgi.com/xfs/xfs:
      xfs: limit superblock corruption errors to actual corruption
      xfs: skip verification on initial "guess" superblock read
      MAINTAINERS: SGI no longer maintaining XFS
      xfs: xfs_sb_read_verify() doesn't flag bad crcs on primary sb
      xfs: ensure correct log item buffer alignment
      xfs: ensure correct timestamp updates from truncate

commit 0dc83bd30b0bf5410c0933cfbbf8853248eff0a9
Author: Jan Kara <jack@suse.cz>
Date:   Fri Feb 21 11:19:04 2014 +0100

    Revert "writeback: do not sync data dirtied after sync start"
    
    This reverts commit c4a391b53a72d2df4ee97f96f78c1d5971b47489. Dave
    Chinner <david@fromorbit.com> has reported the commit may cause some
    inodes to be left out from sync(2). This is because we can call
    redirty_tail() for some inode (which sets i_dirtied_when to current time)
    after sync(2) has started or similarly requeue_inode() can set
    i_dirtied_when to current time if writeback had to skip some pages. The
    real problem is in the functions clobbering i_dirtied_when but fixing
    that isn't trivial so revert is a safer choice for now.
    
    CC: stable@vger.kernel.org # >= 3.13
    Signed-off-by: Jan Kara <jack@suse.cz>

commit d311d79de305f1ada47cadd672e6ed1b28a949eb
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sun Feb 9 15:18:09 2014 -0500

    fix O_SYNC|O_APPEND syncing the wrong range on write()
    
    It actually goes back to 2004 ([PATCH] Concurrent O_SYNC write support)
    when sync_page_range() had been introduced; generic_file_write{,v}() correctly
    synced
    	pos_after_write - written .. pos_after_write - 1
    but generic_file_aio_write() synced
    	pos_before_write .. pos_before_write + written - 1
    instead.  Which is not the same thing with O_APPEND, obviously.
    A couple of years later correct variant had been killed off when
    everything switched to use of generic_file_aio_write().
    
    All users of generic_file_aio_write() are affected, and the same bug
    has been copied into other instances of ->aio_write().
    
    The fix is trivial; the only subtle point is that generic_write_sync()
    ought to be inlined to avoid calculations useless for the majority of
    calls.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/kmem.c               |  21 ++-
 fs/xfs/xfs_acl.c            |   2 +-
 fs/xfs/xfs_ag.h             |   6 +
 fs/xfs/xfs_alloc.c          |  45 +++---
 fs/xfs/xfs_alloc_btree.c    |  16 ++-
 fs/xfs/xfs_aops.c           |  84 ++++++-----
 fs/xfs/xfs_attr_leaf.c      |  17 +--
 fs/xfs/xfs_attr_remote.c    |  15 +-
 fs/xfs/xfs_bmap.c           | 193 +++++++++++++++++++++++++
 fs/xfs/xfs_bmap.h           |  15 ++
 fs/xfs/xfs_bmap_btree.c     |  16 +--
 fs/xfs/xfs_bmap_util.c      |  97 ++++++++++++-
 fs/xfs/xfs_bmap_util.h      |   2 +
 fs/xfs/xfs_btree.c          |  14 +-
 fs/xfs/xfs_buf.c            |  11 ++
 fs/xfs/xfs_buf.h            |  14 ++
 fs/xfs/xfs_buf_item.c       |  19 ---
 fs/xfs/xfs_da_btree.c       |  19 +--
 fs/xfs/xfs_dinode.h         |   2 +
 fs/xfs/xfs_dir2.c           | 342 +++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_dir2_block.c     |  17 +--
 fs/xfs/xfs_dir2_data.c      |  20 +--
 fs/xfs/xfs_dir2_leaf.c      |  17 +--
 fs/xfs/xfs_dir2_node.c      |  17 +--
 fs/xfs/xfs_dquot.c          |   2 +-
 fs/xfs/xfs_dquot_buf.c      |  11 +-
 fs/xfs/xfs_error.c          |  27 +++-
 fs/xfs/xfs_error.h          |   1 +
 fs/xfs/xfs_file.c           |  42 ++++--
 fs/xfs/xfs_format.h         |   2 +
 fs/xfs/xfs_ialloc.c         |  36 +++--
 fs/xfs/xfs_ialloc_btree.c   |  16 ++-
 fs/xfs/xfs_inode.c          | 123 +++++++++++++++-
 fs/xfs/xfs_inode.h          |  12 ++
 fs/xfs/xfs_inode_buf.c      |   7 +-
 fs/xfs/xfs_ioctl.c          |  28 +---
 fs/xfs/xfs_iomap.c          |  10 +-
 fs/xfs/xfs_iops.c           |  46 ++++--
 fs/xfs/xfs_linux.h          |   2 +
 fs/xfs/xfs_log.h            |   2 +-
 fs/xfs/xfs_log_cil.c        |  74 +++++++---
 fs/xfs/xfs_mount.c          |  27 ++--
 fs/xfs/xfs_rtalloc.c        |   2 +-
 fs/xfs/xfs_sb.c             |  23 ++-
 fs/xfs/xfs_sb.h             |   2 +
 fs/xfs/xfs_shared.h         |   4 +-
 fs/xfs/xfs_super.c          |   5 +-
 fs/xfs/xfs_symlink.c        |   9 +-
 fs/xfs/xfs_symlink_remote.c |  16 +--
 fs/xfs/xfs_trace.h          |   1 +
 fs/xfs/xfs_trans.c          |  12 +-
 fs/xfs/xfs_trans_buf.c      |  11 ++
 fs/xfs/xfs_trans_resv.c     |  82 +++++++++--
 fs/xfs/xfs_trans_resv.h     |   3 +-
 54 files changed, 1193 insertions(+), 466 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
