Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.12-rc1-2-11718-g272b98c
Message-Id: <20130919164635.27FCC7F37@oss.sgi.com>
Date: Thu, 19 Sep 2013 11:46:34 -0500 (CDT)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5368827967719854458=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5368827967719854458==
Content-Type: text/plain

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, for-next has been updated
  e0ea404 Merge tag 'xfs-for-linus-v3.12-rc1-2' of git://oss.sgi.com/xfs/xfs
  ac4de95 Merge branch 'akpm' (patches from Andrew Morton)
  7caef26 truncate: drop 'oldsize' truncate_pagecache() parameter
  f5e1dd3 super: fix for destroy lrus
  5ca302c list_lru: dynamically adjust node arrays
  3516341 xfs: fix dquot isolation hang
  2f5b56f xfs-convert-dquot-cache-lru-to-list_lru-fix
  cd56a39 xfs: convert dquot cache lru to list_lru
  a408235 xfs: rework buffer dispose list tracking
  addbda4 xfs-convert-buftarg-lru-to-generic-code-fix
  e80dfa1 xfs: convert buftarg LRU to generic code
  9b17c62 fs: convert inode and dentry shrinking to be node aware
  0a234c6 shrinker: convert superblock shrinkers to new API
  55f841c super: fix calculation of shrinkable objects for small numbers
  300893b Merge tag 'xfs-for-linus-v3.12-rc1' of git://oss.sgi.com/xfs/xfs
  7b7a866 direct-io: Implement generic deferred AIO completions
  e1b4271 xfs: di_flushiter considered harmful
      from  08474ed639e971e9d5a877cf7aba7ef91d847ae9 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit e0ea4045bce3cee84e35746fb98946ca36781248
Merge: 48efe45 08474ed
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Sep 12 16:13:41 2013 -0700

    Merge tag 'xfs-for-linus-v3.12-rc1-2' of git://oss.sgi.com/xfs/xfs
    
    Pull xfs update #2 from Ben Myers:
     "Here we have defrag support for v5 superblock, a number of bugfixes
      and a cleanup or two.
    
       - defrag support for CRC filesystems
       - fix endian worning in xlog_recover_get_buf_lsn
       - fixes for sparse warnings
       - fix for assert in xfs_dir3_leaf_hdr_from_disk
       - fix for log recovery of remote symlinks
       - fix for log recovery of btree root splits
       - fixes formemory allocation failures with ACLs
       - fix for assert in xfs_buf_item_relse
       - fix for assert in xfs_inode_buf_verify
       - fix an assignment in an assert that should be a test in
         xfs_bmbt_change_owner
       - remove dead code in xlog_recover_inode_pass2"
    
    * tag 'xfs-for-linus-v3.12-rc1-2' of git://oss.sgi.com/xfs/xfs:
      xfs: remove dead code from xlog_recover_inode_pass2
      xfs: = vs == typo in ASSERT()
      xfs: don't assert fail on bad inode numbers
      xfs: aborted buf items can be in the AIL.
      xfs: factor all the kmalloc-or-vmalloc fallback allocations
      xfs: fix memory allocation failures with ACLs
      xfs: ensure we copy buffer type in da btree root splits
      xfs: set remote symlink buffer type for recovery
      xfs: recovery of swap extents operations for CRC filesystems
      xfs: swap extents operations for CRC filesystems
      xfs: check magic numbers in dir3 leaf verifier first
      xfs: fix some minor sparse warnings
      xfs: fix endian warning in xlog_recover_get_buf_lsn()

commit ac4de9543aca59f2b763746647577302fbedd57e
Merge: 26935fb de32a81
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Sep 12 15:44:27 2013 -0700

    Merge branch 'akpm' (patches from Andrew Morton)
    
    Merge more patches from Andrew Morton:
     "The rest of MM.  Plus one misc cleanup"
    
    * emailed patches from Andrew Morton <akpm@linux-foundation.org>: (35 commits)
      mm/Kconfig: add MMU dependency for MIGRATION.
      kernel: replace strict_strto*() with kstrto*()
      mm, thp: count thp_fault_fallback anytime thp fault fails
      thp: consolidate code between handle_mm_fault() and do_huge_pmd_anonymous_page()
      thp: do_huge_pmd_anonymous_page() cleanup
      thp: move maybe_pmd_mkwrite() out of mk_huge_pmd()
      mm: cleanup add_to_page_cache_locked()
      thp: account anon transparent huge pages into NR_ANON_PAGES
      truncate: drop 'oldsize' truncate_pagecache() parameter
      mm: make lru_add_drain_all() selective
      memcg: document cgroup dirty/writeback memory statistics
      memcg: add per cgroup writeback pages accounting
      memcg: check for proper lock held in mem_cgroup_update_page_stat
      memcg: remove MEMCG_NR_FILE_MAPPED
      memcg: reduce function dereference
      memcg: avoid overflow caused by PAGE_ALIGN
      memcg: rename RESOURCE_MAX to RES_COUNTER_MAX
      memcg: correct RESOURCE_MAX to ULLONG_MAX
      mm: memcg: do not trap chargers with full callstack on OOM
      mm: memcg: rework and document OOM waiting and wakeup
      ...

commit 7caef26767c1727d7abfbbbfbe8b2bb473430d48
Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Date:   Thu Sep 12 15:13:56 2013 -0700

    truncate: drop 'oldsize' truncate_pagecache() parameter
    
    truncate_pagecache() doesn't care about old size since commit
    cedabed49b39 ("vfs: Fix vmtruncate() regression").  Let's drop it.
    
    Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

commit f5e1dd34561e0fb06400b378d595198918833021
Author: Glauber Costa <glommer@gmail.com>
Date:   Wed Aug 28 10:18:18 2013 +1000

    super: fix for destroy lrus
    
    This patch adds the missing call to list_lru_destroy (spotted by Li Zhong)
    and moves the deletion to after the shrinker is unregistered, as correctly
    spotted by Dave
    
    Signed-off-by: Glauber Costa <glommer@openvz.org>
    Cc: Michal Hocko <mhocko@suse.cz>
    Cc: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 5ca302c8e502ca53b7d75f12127ec0289904003a
Author: Glauber Costa <glommer@openvz.org>
Date:   Wed Aug 28 10:18:18 2013 +1000

    list_lru: dynamically adjust node arrays
    
    We currently use a compile-time constant to size the node array for the
    list_lru structure.  Due to this, we don't need to allocate any memory at
    initialization time.  But as a consequence, the structures that contain
    embedded list_lru lists can become way too big (the superblock for
    instance contains two of them).
    
    This patch aims at ameliorating this situation by dynamically allocating
    the node arrays with the firmware provided nr_node_ids.
    
    Signed-off-by: Glauber Costa <glommer@openvz.org>
    Cc: Dave Chinner <dchinner@redhat.com>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: "Theodore Ts'o" <tytso@mit.edu>
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    Cc: Arve Hjønnevåg <arve@android.com>
    Cc: Carlos Maiolino <cmaiolino@redhat.com>
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: Chuck Lever <chuck.lever@oracle.com>
    Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
    Cc: David Rientjes <rientjes@google.com>
    Cc: Gleb Natapov <gleb@redhat.com>
    Cc: Greg Thelen <gthelen@google.com>
    Cc: J. Bruce Fields <bfields@redhat.com>
    Cc: Jan Kara <jack@suse.cz>
    Cc: Jerome Glisse <jglisse@redhat.com>
    Cc: John Stultz <john.stultz@linaro.org>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: Kent Overstreet <koverstreet@google.com>
    Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Cc: Marcelo Tosatti <mtosatti@redhat.com>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: Steven Whitehouse <swhiteho@redhat.com>
    Cc: Thomas Hellstrom <thellstrom@vmware.com>
    Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 35163417fb7a55a24b6b0ebb102e9991adf309aa
Author: Dave Chinner <david@fromorbit.com>
Date:   Wed Aug 28 10:18:08 2013 +1000

    xfs: fix dquot isolation hang
    
    The new LRU list isolation code in xfs_qm_dquot_isolate() isn't
    completely up to date.  Firstly, it needs conversion to return enum
    lru_status values, not raw numbers. Secondly - most importantly - it
    fails to unlock the dquot and relock the LRU in the LRU_RETRY path.
    This leads to deadlocks in xfstests generic/232. Fix them.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Cc: Glauber Costa <glommer@gmail.com>
    Cc: Michal Hocko <mhocko@suse.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 2f5b56f85674d75f35a10e2e9a4310e7539280da
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Wed Aug 28 10:18:08 2013 +1000

    xfs-convert-dquot-cache-lru-to-list_lru-fix
    
    fix warnings
    
    Cc: Dave Chinner <dchinner@redhat.com>
    Cc: Glauber Costa <glommer@openvz.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit cd56a39a59868911bbf8832725630c1cf43a7b09
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Aug 28 10:18:07 2013 +1000

    xfs: convert dquot cache lru to list_lru
    
    Convert the XFS dquot lru to use the list_lru construct and convert the
    shrinker to being node aware.
    
    [glommer@openvz.org: edited for conflicts + warning fixes]
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Glauber Costa <glommer@openvz.org>
    Cc: "Theodore Ts'o" <tytso@mit.edu>
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    Cc: Arve Hjønnevåg <arve@android.com>
    Cc: Carlos Maiolino <cmaiolino@redhat.com>
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: Chuck Lever <chuck.lever@oracle.com>
    Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
    Cc: David Rientjes <rientjes@google.com>
    Cc: Gleb Natapov <gleb@redhat.com>
    Cc: Greg Thelen <gthelen@google.com>
    Cc: J. Bruce Fields <bfields@redhat.com>
    Cc: Jan Kara <jack@suse.cz>
    Cc: Jerome Glisse <jglisse@redhat.com>
    Cc: John Stultz <john.stultz@linaro.org>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: Kent Overstreet <koverstreet@google.com>
    Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Cc: Marcelo Tosatti <mtosatti@redhat.com>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: Steven Whitehouse <swhiteho@redhat.com>
    Cc: Thomas Hellstrom <thellstrom@vmware.com>
    Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit a408235726aa82c0358c9ec68124b6f4bc0a79df
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Aug 28 10:18:06 2013 +1000

    xfs: rework buffer dispose list tracking
    
    In converting the buffer lru lists to use the generic code, the locking
    for marking the buffers as on the dispose list was lost.  This results in
    confusion in LRU buffer tracking and acocunting, resulting in reference
    counts being mucked up and filesystem beig unmountable.
    
    To fix this, introduce an internal buffer spinlock to protect the state
    field that holds the dispose list information.  Because there is now
    locking needed around xfs_buf_lru_add/del, and they are used in exactly
    one place each two lines apart, get rid of the wrappers and code the logic
    directly in place.
    
    Further, the LRU emptying code used on unmount is less than optimal.
    Convert it to use a dispose list as per a normal shrinker walk, and repeat
    the walk that fills the dispose list until the LRU is empty.  Thi avoids
    needing to drop and regain the LRU lock for every item being freed, and
    allows the same logic as the shrinker isolate call to be used.  Simpler,
    easier to understand.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Glauber Costa <glommer@openvz.org>
    Cc: "Theodore Ts'o" <tytso@mit.edu>
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    Cc: Arve Hjønnevåg <arve@android.com>
    Cc: Carlos Maiolino <cmaiolino@redhat.com>
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: Chuck Lever <chuck.lever@oracle.com>
    Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
    Cc: David Rientjes <rientjes@google.com>
    Cc: Gleb Natapov <gleb@redhat.com>
    Cc: Greg Thelen <gthelen@google.com>
    Cc: J. Bruce Fields <bfields@redhat.com>
    Cc: Jan Kara <jack@suse.cz>
    Cc: Jerome Glisse <jglisse@redhat.com>
    Cc: John Stultz <john.stultz@linaro.org>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: Kent Overstreet <koverstreet@google.com>
    Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Cc: Marcelo Tosatti <mtosatti@redhat.com>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: Steven Whitehouse <swhiteho@redhat.com>
    Cc: Thomas Hellstrom <thellstrom@vmware.com>
    Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit addbda40bed47d8942658fca93e14b5f1cbf009a
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Wed Aug 28 10:18:06 2013 +1000

    xfs-convert-buftarg-lru-to-generic-code-fix
    
    fix warnings
    
    Cc: Dave Chinner <dchinner@redhat.com>
    Cc: Glauber Costa <glommer@openvz.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit e80dfa19976b884db1ac2bc5d7d6ca0a4027bd1c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Aug 28 10:18:05 2013 +1000

    xfs: convert buftarg LRU to generic code
    
    Convert the buftarg LRU to use the new generic LRU list and take advantage
    of the functionality it supplies to make the buffer cache shrinker node
    aware.
    
    Signed-off-by: Glauber Costa <glommer@openvz.org>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Cc: "Theodore Ts'o" <tytso@mit.edu>
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    Cc: Arve Hjønnevåg <arve@android.com>
    Cc: Carlos Maiolino <cmaiolino@redhat.com>
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: Chuck Lever <chuck.lever@oracle.com>
    Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
    Cc: David Rientjes <rientjes@google.com>
    Cc: Gleb Natapov <gleb@redhat.com>
    Cc: Greg Thelen <gthelen@google.com>
    Cc: J. Bruce Fields <bfields@redhat.com>
    Cc: Jan Kara <jack@suse.cz>
    Cc: Jerome Glisse <jglisse@redhat.com>
    Cc: John Stultz <john.stultz@linaro.org>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: Kent Overstreet <koverstreet@google.com>
    Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Cc: Marcelo Tosatti <mtosatti@redhat.com>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: Steven Whitehouse <swhiteho@redhat.com>
    Cc: Thomas Hellstrom <thellstrom@vmware.com>
    Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 9b17c62382dd2e7507984b9890bf44e070cdd8bb
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Aug 28 10:18:05 2013 +1000

    fs: convert inode and dentry shrinking to be node aware
    
    Now that the shrinker is passing a node in the scan control structure, we
    can pass this to the the generic LRU list code to isolate reclaim to the
    lists on matching nodes.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Glauber Costa <glommer@parallels.com>
    Acked-by: Mel Gorman <mgorman@suse.de>
    Cc: "Theodore Ts'o" <tytso@mit.edu>
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    Cc: Arve Hjønnevåg <arve@android.com>
    Cc: Carlos Maiolino <cmaiolino@redhat.com>
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: Chuck Lever <chuck.lever@oracle.com>
    Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
    Cc: David Rientjes <rientjes@google.com>
    Cc: Gleb Natapov <gleb@redhat.com>
    Cc: Greg Thelen <gthelen@google.com>
    Cc: J. Bruce Fields <bfields@redhat.com>
    Cc: Jan Kara <jack@suse.cz>
    Cc: Jerome Glisse <jglisse@redhat.com>
    Cc: John Stultz <john.stultz@linaro.org>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: Kent Overstreet <koverstreet@google.com>
    Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Cc: Marcelo Tosatti <mtosatti@redhat.com>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: Steven Whitehouse <swhiteho@redhat.com>
    Cc: Thomas Hellstrom <thellstrom@vmware.com>
    Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 0a234c6dcb79a270803f5c9773ed650b78730962
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Aug 28 10:17:57 2013 +1000

    shrinker: convert superblock shrinkers to new API
    
    Convert superblock shrinker to use the new count/scan API, and propagate
    the API changes through to the filesystem callouts.  The filesystem
    callouts already use a count/scan API, so it's just changing counters to
    longs to match the VM API.
    
    This requires the dentry and inode shrinker callouts to be converted to
    the count/scan API.  This is mainly a mechanical change.
    
    [glommer@openvz.org: use mult_frac for fractional proportions, build fixes]
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Glauber Costa <glommer@openvz.org>
    Acked-by: Mel Gorman <mgorman@suse.de>
    Cc: "Theodore Ts'o" <tytso@mit.edu>
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    Cc: Arve Hjønnevåg <arve@android.com>
    Cc: Carlos Maiolino <cmaiolino@redhat.com>
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: Chuck Lever <chuck.lever@oracle.com>
    Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
    Cc: David Rientjes <rientjes@google.com>
    Cc: Gleb Natapov <gleb@redhat.com>
    Cc: Greg Thelen <gthelen@google.com>
    Cc: J. Bruce Fields <bfields@redhat.com>
    Cc: Jan Kara <jack@suse.cz>
    Cc: Jerome Glisse <jglisse@redhat.com>
    Cc: John Stultz <john.stultz@linaro.org>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: Kent Overstreet <koverstreet@google.com>
    Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Cc: Marcelo Tosatti <mtosatti@redhat.com>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: Steven Whitehouse <swhiteho@redhat.com>
    Cc: Thomas Hellstrom <thellstrom@vmware.com>
    Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 55f841ce9395a72c6285fbcc4c403c0c786e1c74
Author: Glauber Costa <glommer@openvz.org>
Date:   Wed Aug 28 10:17:53 2013 +1000

    super: fix calculation of shrinkable objects for small numbers
    
    The sysctl knob sysctl_vfs_cache_pressure is used to determine which
    percentage of the shrinkable objects in our cache we should actively try
    to shrink.
    
    It works great in situations in which we have many objects (at least more
    than 100), because the aproximation errors will be negligible.  But if
    this is not the case, specially when total_objects < 100, we may end up
    concluding that we have no objects at all (total / 100 = 0, if total <
    100).
    
    This is certainly not the biggest killer in the world, but may matter in
    very low kernel memory situations.
    
    Signed-off-by: Glauber Costa <glommer@openvz.org>
    Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
    Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Acked-by: Mel Gorman <mgorman@suse.de>
    Cc: Dave Chinner <david@fromorbit.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: "Theodore Ts'o" <tytso@mit.edu>
    Cc: Adrian Hunter <adrian.hunter@intel.com>
    Cc: Al Viro <viro@zeniv.linux.org.uk>
    Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
    Cc: Arve Hjønnevåg <arve@android.com>
    Cc: Carlos Maiolino <cmaiolino@redhat.com>
    Cc: Christoph Hellwig <hch@lst.de>
    Cc: Chuck Lever <chuck.lever@oracle.com>
    Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
    Cc: David Rientjes <rientjes@google.com>
    Cc: Gleb Natapov <gleb@redhat.com>
    Cc: Greg Thelen <gthelen@google.com>
    Cc: J. Bruce Fields <bfields@redhat.com>
    Cc: Jan Kara <jack@suse.cz>
    Cc: Jerome Glisse <jglisse@redhat.com>
    Cc: John Stultz <john.stultz@linaro.org>
    Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
    Cc: Kent Overstreet <koverstreet@google.com>
    Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Cc: Marcelo Tosatti <mtosatti@redhat.com>
    Cc: Mel Gorman <mgorman@suse.de>
    Cc: Steven Whitehouse <swhiteho@redhat.com>
    Cc: Thomas Hellstrom <thellstrom@vmware.com>
    Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 300893b08f3bc7057a7a5f84074090ba66c8b5ca
Merge: 45150c4 1d03c6f
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 9 11:19:09 2013 -0700

    Merge tag 'xfs-for-linus-v3.12-rc1' of git://oss.sgi.com/xfs/xfs
    
    Pull xfs updates from Ben Myers:
     "For 3.12-rc1 there are a number of bugfixes in addition to work to
      ease usage of shared code between libxfs and the kernel, the rest of
      the work to enable project and group quotas to be used simultaneously,
      performance optimisations in the log and the CIL, directory entry file
      type support, fixes for log space reservations, some spelling/grammar
      cleanups, and the addition of user namespace support.
    
       - introduce readahead to log recovery
       - add directory entry file type support
       - fix a number of spelling errors in comments
       - introduce new Q_XGETQSTATV quotactl for project quotas
       - add USER_NS support
       - log space reservation rework
       - CIL optimisations
      - kernel/userspace libxfs rework"
    
    * tag 'xfs-for-linus-v3.12-rc1' of git://oss.sgi.com/xfs/xfs: (112 commits)
      xfs: XFS_MOUNT_QUOTA_ALL needed by userspace
      xfs: dtype changed xfs_dir2_sfe_put_ino to xfs_dir3_sfe_put_ino
      Fix wrong flag ASSERT in xfs_attr_shortform_getvalue
      xfs: finish removing IOP_* macros.
      xfs: inode log reservations are too small
      xfs: check correct status variable for xfs_inobt_get_rec() call
      xfs: inode buffers may not be valid during recovery readahead
      xfs: check LSN ordering for v5 superblocks during recovery
      xfs: btree block LSN escaping to disk uninitialised
      XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
      xfs: fix bad dquot buffer size in log recovery readahead
      xfs: don't account buffer cancellation during log recovery readahead
      xfs: check for underflow in xfs_iformat_fork()
      xfs: xfs_dir3_sfe_put_ino can be static
      xfs: introduce object readahead to log recovery
      xfs: Simplify xfs_ail_min() with list_first_entry_or_null()
      xfs: Register hotcpu notifier after initialization
      xfs: add xfs sb v4 support for dirent filetype field
      xfs: Add write support for dirent filetype field
      xfs: Add read-only support for dirent filetype field
      ...

commit 7b7a8665edd8db733980389b098530f9e4f630b2
Author: Christoph Hellwig <hch@infradead.org>
Date:   Wed Sep 4 15:04:39 2013 +0200

    direct-io: Implement generic deferred AIO completions
    
    Add support to the core direct-io code to defer AIO completions to user
    context using a workqueue.  This replaces opencoded and less efficient
    code in XFS and ext4 (we save a memory allocation for each direct IO)
    and will be needed to properly support O_(D)SYNC for AIO.
    
    The communication between the filesystem and the direct I/O code requires
    a new buffer head flag, which is a bit ugly but not avoidable until the
    direct I/O code stops abusing the buffer_head structure for communicating
    with the filesystems.
    
    Currently this creates a per-superblock unbound workqueue for these
    completions, which is taken from an earlier patch by Jan Kara.  I'm
    not really convinced about this use and would prefer a "normal" global
    workqueue with a high concurrency limit, but this needs further discussion.
    
    JK: Fixed ext4 part, dynamic allocation of the workqueue.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit e1b4271ac261b290fdab51446996fb13e68a57be
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Jul 24 15:47:30 2013 +1000

    xfs: di_flushiter considered harmful
    
    When we made all inode updates transactional, we no longer needed
    the log recovery detection for inodes being newer on disk than the
    transaction being replayed - it was redundant as replay of the log
    would always result in the latest version of the inode would be on
    disk. It was redundant, but left in place because it wasn't
    considered to be a problem.
    
    However, with the new "don't read inodes on create" optimisation,
    flushiter has come back to bite us. Essentially, the optimisation
    made always initialises flushiter to zero in the create transaction,
    and so if we then crash and run recovery and the inode already on
    disk has a non-zero flushiter it will skip recovery of that inode.
    As a result, log recovery does the wrong thing and we end up with a
    corrupt filesystem.
    
    Because we have to support old kernel to new kernel upgrades, we
    can't just get rid of the flushiter support in log recovery as we
    might be upgrading from a kernel that doesn't have fully transactional
    inode updates.  Unfortunately, for v4 superblocks there is no way to
    guarantee that log recovery knows about this fact.
    
    We cannot add a new inode format flag to say it's a "special inode
    create" because it won't be understood by older kernels and so
    recovery could do the wrong thing on downgrade. We cannot specially
    detect the combination of zero mode/non-zero flushiter on disk to
    non-zero mode, zero flushiter in the log item during recovery
    because wrapping of the flushiter can result in false detection.
    
    Hence that makes this "don't use flushiter" optimisation limited to
    a disk format that guarantees that we don't need it. And that means
    the only fix here is to limit the "no read IO on create"
    optimisation to version 5 superblocks....
    
    Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit e60896d8f2b81412421953e14d3feb14177edb56)

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_aops.c   |  32 ++----
 fs/xfs/xfs_aops.h   |   3 -
 fs/xfs/xfs_buf.c    | 253 +++++++++++++++++++++++----------------------
 fs/xfs/xfs_buf.h    |  17 ++--
 fs/xfs/xfs_dquot.c  |   7 +-
 fs/xfs/xfs_icache.c |   4 +-
 fs/xfs/xfs_icache.h |   2 +-
 fs/xfs/xfs_qm.c     | 287 +++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_qm.h     |   4 +-
 fs/xfs/xfs_super.c  |  12 ++-
 10 files changed, 312 insertions(+), 309 deletions(-)


hooks/post-receive
-- 
XFS development tree


--===============5368827967719854458==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5368827967719854458==--
