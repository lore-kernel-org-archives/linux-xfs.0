Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.14-rc1-2-12920-g38dbfb5
Message-Id: <20140207001158.5F0D97F53@oss.sgi.com>
Date: Thu,  6 Feb 2014 18:11:57 -0600 (CST)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5353808140204056726=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5353808140204056726==
Content-Type: text/plain

This is an automated email from the git hooks/post-receive script. It was
generated because a ref change was pushed to the repository containing
the project "XFS development tree".

The branch, for-next has been updated
  f568849 Merge branch 'for-3.14/core' of git://git.kernel.dk/linux-block
  f149938 Merge tag 'xfs-for-linus-v3.14-rc1-2' of git://oss.sgi.com/xfs/xfs
  bf3d846 Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
  2401dc2 xfs: use generic posix ACL infrastructure
  37bc153 fs: make posix_acl_create more useful
  5bf3258 fs: make posix_acl_chmod more useful
  96c8c44 xfs: switch to kfree_put_link()
  1f4a63b xfs: Calling destroy_work_on_stack() to pair with INIT_WORK_ONSTACK()
  bba719b xfs: fix off-by-one error in xfs_attr3_rmt_verify
  b28bc9b Merge tag 'v3.13-rc6' into for-3.14/core
  4f024f3 block: Abstract out bvec iterator
      from  7c71ee78031c248dca13fc94dea9a4cc217db6cf (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit f568849edac8611d603e00bd6cbbcfea09395ae6
Merge: d9894c2 675675a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jan 30 11:19:05 2014 -0800

    Merge branch 'for-3.14/core' of git://git.kernel.dk/linux-block
    
    Pull core block IO changes from Jens Axboe:
     "The major piece in here is the immutable bio_ve series from Kent, the
      rest is fairly minor.  It was supposed to go in last round, but
      various issues pushed it to this release instead.  The pull request
      contains:
    
       - Various smaller blk-mq fixes from different folks.  Nothing major
         here, just minor fixes and cleanups.
    
       - Fix for a memory leak in the error path in the block ioctl code
         from Christian Engelmayer.
    
       - Header export fix from CaiZhiyong.
    
       - Finally the immutable biovec changes from Kent Overstreet.  This
         enables some nice future work on making arbitrarily sized bios
         possible, and splitting more efficient.  Related fixes to immutable
         bio_vecs:
    
            - dm-cache immutable fixup from Mike Snitzer.
            - btrfs immutable fixup from Muthu Kumar.
    
      - bio-integrity fix from Nic Bellinger, which is also going to stable"
    
    * 'for-3.14/core' of git://git.kernel.dk/linux-block: (44 commits)
      xtensa: fixup simdisk driver to work with immutable bio_vecs
      block/blk-mq-cpu.c: use hotcpu_notifier()
      blk-mq: for_each_* macro correctness
      block: Fix memory leak in rw_copy_check_uvector() handling
      bio-integrity: Fix bio_integrity_verify segment start bug
      block: remove unrelated header files and export symbol
      blk-mq: uses page->list incorrectly
      blk-mq: use __smp_call_function_single directly
      btrfs: fix missing increment of bi_remaining
      Revert "block: Warn and free bio if bi_end_io is not set"
      block: Warn and free bio if bi_end_io is not set
      blk-mq: fix initializing request's start time
      block: blk-mq: don't export blk_mq_free_queue()
      block: blk-mq: make blk_sync_queue support mq
      block: blk-mq: support draining mq queue
      dm cache: increment bi_remaining when bi_end_io is restored
      block: fixup for generic bio chaining
      block: Really silence spurious compiler warnings
      block: Silence spurious compiler warnings
      block: Kill bio_pair_split()
      ...

commit f1499382f114231cbd1e3dee7e656b50ce9d8236
Merge: 4db658e 7c71ee7
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jan 28 18:21:22 2014 -0800

    Merge tag 'xfs-for-linus-v3.14-rc1-2' of git://oss.sgi.com/xfs/xfs
    
    Pull second xfs update from Ben Myers:
     "Allow logical sector sized direct io on 'advanced format' 4k/512 disk"
    
    * tag 'xfs-for-linus-v3.14-rc1-2' of git://oss.sgi.com/xfs/xfs:
      xfs: allow logical-sector sized O_DIRECT
      xfs: rename xfs_buftarg structure members
      xfs: clean up xfs_buftarg

commit bf3d846b783327359ddc4bd4f52627b36abb4d1d
Merge: 54c0a4b f650080
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Jan 28 08:38:04 2014 -0800

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
    
    Pull vfs updates from Al Viro:
     "Assorted stuff; the biggest pile here is Christoph's ACL series.  Plus
      assorted cleanups and fixes all over the place...
    
      There will be another pile later this week"
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs: (43 commits)
      __dentry_path() fixes
      vfs: Remove second variable named error in __dentry_path
      vfs: Is mounted should be testing mnt_ns for NULL or error.
      Fix race when checking i_size on direct i/o read
      hfsplus: remove can_set_xattr
      nfsd: use get_acl and ->set_acl
      fs: remove generic_acl
      nfs: use generic posix ACL infrastructure for v3 Posix ACLs
      gfs2: use generic posix ACL infrastructure
      jfs: use generic posix ACL infrastructure
      xfs: use generic posix ACL infrastructure
      reiserfs: use generic posix ACL infrastructure
      ocfs2: use generic posix ACL infrastructure
      jffs2: use generic posix ACL infrastructure
      hfsplus: use generic posix ACL infrastructure
      f2fs: use generic posix ACL infrastructure
      ext2/3/4: use generic posix ACL infrastructure
      btrfs: use generic posix ACL infrastructure
      fs: make posix_acl_create more useful
      fs: make posix_acl_chmod more useful
      ...

commit 2401dc2975fc5a33021dc8347ea82984c4707a08
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 20 05:16:50 2013 -0800

    xfs: use generic posix ACL infrastructure
    
    Also don't bother to set up a .get_acl method for symlinks as we do not
    support access control (ACLs or even mode bits) for symlinks in Linux,
    and create inodes with the proper mode instead of fixing it up later.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 37bc15392a2363ca822b2c2828e0ccafbea32f75
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 20 05:16:42 2013 -0800

    fs: make posix_acl_create more useful
    
    Rename the current posix_acl_created to __posix_acl_create and add
    a fully featured helper to set up the ACLs on file creation that
    uses get_acl().
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 5bf3258fd2acd8515450ab8efcd97c9d3b69f7f9
Author: Christoph Hellwig <hch@infradead.org>
Date:   Fri Dec 20 05:16:41 2013 -0800

    fs: make posix_acl_chmod more useful
    
    Rename the current posix_acl_chmod to __posix_acl_chmod and add
    a fully featured ACL chmod helper that uses the ->set_acl inode
    operation.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Jan Kara <jack@suse.cz>
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 96c8c442117859cd95b5b57836ff374ff43f0564
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Fri Nov 29 22:54:55 2013 -0500

    xfs: switch to kfree_put_link()
    
    don't bother open-coding it...
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

commit 1f4a63bf019524c96e79f088cd717b96ef00a249
Author: Chuansheng Liu <chuansheng.liu@intel.com>
Date:   Tue Jan 7 16:53:34 2014 +0800

    xfs: Calling destroy_work_on_stack() to pair with INIT_WORK_ONSTACK()
    
    In case CONFIG_DEBUG_OBJECTS_WORK is defined, it is needed to
    call destroy_work_on_stack() which frees the debug object to pair
    with INIT_WORK_ONSTACK().
    
    Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 6f96b3063cdd473c68664a190524ed966ac0cd92)

commit bba719b5004234e55737e7074b81b337210c511d
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Wed Jan 1 19:28:03 2014 +0800

    xfs: fix off-by-one error in xfs_attr3_rmt_verify
    
    With CRC check is enabled, if trying to set an attributes value just
    equal to the maximum size of XATTR_SIZE_MAX would cause the v3 remote
    attr write verification procedure failure, which would yield the back
    trace like below:
    
    <snip>
    XFS (sda7): Internal error xfs_attr3_rmt_write_verify at line 191 of file fs/xfs/xfs_attr_remote.c
    <snip>
    Call Trace:
    [<ffffffff816f0042>] dump_stack+0x45/0x56
    [<ffffffffa0d99c8b>] xfs_error_report+0x3b/0x40 [xfs]
    [<ffffffffa0d96edd>] ? _xfs_buf_ioapply+0x6d/0x390 [xfs]
    [<ffffffffa0d99ce5>] xfs_corruption_error+0x55/0x80 [xfs]
    [<ffffffffa0dbef6b>] xfs_attr3_rmt_write_verify+0x14b/0x1a0 [xfs]
    [<ffffffffa0d96edd>] ? _xfs_buf_ioapply+0x6d/0x390 [xfs]
    [<ffffffffa0d97315>] ? xfs_bdstrat_cb+0x55/0xb0 [xfs]
    [<ffffffffa0d96edd>] _xfs_buf_ioapply+0x6d/0x390 [xfs]
    [<ffffffff81184cda>] ? vm_map_ram+0x31a/0x460
    [<ffffffff81097230>] ? wake_up_state+0x20/0x20
    [<ffffffffa0d97315>] ? xfs_bdstrat_cb+0x55/0xb0 [xfs]
    [<ffffffffa0d9726b>] xfs_buf_iorequest+0x6b/0xc0 [xfs]
    [<ffffffffa0d97315>] xfs_bdstrat_cb+0x55/0xb0 [xfs]
    [<ffffffffa0d97906>] xfs_bwrite+0x46/0x80 [xfs]
    [<ffffffffa0dbfa94>] xfs_attr_rmtval_set+0x334/0x490 [xfs]
    [<ffffffffa0db84aa>] xfs_attr_leaf_addname+0x24a/0x410 [xfs]
    [<ffffffffa0db8893>] xfs_attr_set_int+0x223/0x470 [xfs]
    [<ffffffffa0db8b76>] xfs_attr_set+0x96/0xb0 [xfs]
    [<ffffffffa0db13b2>] xfs_xattr_set+0x42/0x70 [xfs]
    [<ffffffff811df9b2>] generic_setxattr+0x62/0x80
    [<ffffffff811e0213>] __vfs_setxattr_noperm+0x63/0x1b0
    [<ffffffff81307afe>] ? evm_inode_setxattr+0xe/0x10
    [<ffffffff811e0415>] vfs_setxattr+0xb5/0xc0
    [<ffffffff811e054e>] setxattr+0x12e/0x1c0
    [<ffffffff811c6e82>] ? final_putname+0x22/0x50
    [<ffffffff811c708b>] ? putname+0x2b/0x40
    [<ffffffff811cc4bf>] ? user_path_at_empty+0x5f/0x90
    [<ffffffff811bdfd9>] ? __sb_start_write+0x49/0xe0
    [<ffffffff81168589>] ? vm_mmap_pgoff+0x99/0xc0
    [<ffffffff811e07df>] SyS_setxattr+0x8f/0xe0
    [<ffffffff81700c2d>] system_call_fastpath+0x1a/0x1f
    
    Tests:
        setfattr -n user.longxattr -v `perl -e 'print "A"x65536'` testfile
    
    This patch fix it to check the remote EA size is greater than the
    XATTR_SIZE_MAX rather than more than or equal to it, because it's
    valid if the specified EA value size is equal to the limitation as
    per VFS setxattr interface.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>
    
    (cherry picked from commit 85dd0707f0cad26d60f2dc574d17a5ab948d10f7)

commit b28bc9b38c52f63f43e3fd875af982f2240a2859
Merge: 8d30726 802eee9
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Dec 31 09:51:02 2013 -0700

    Merge tag 'v3.13-rc6' into for-3.14/core
    
    Needed to bring blk-mq uptodate, since changes have been going in
    since for-3.14/core was established.
    
    Fixup merge issues related to the immutable biovec changes.
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
    
    Conflicts:
    	block/blk-flush.c
    	fs/btrfs/check-integrity.c
    	fs/btrfs/extent_io.c
    	fs/btrfs/scrub.c
    	fs/logfs/dev_bdev.c

commit 4f024f3797c43cb4b73cd2c50cec728842d0e49e
Author: Kent Overstreet <kmo@daterainc.com>
Date:   Fri Oct 11 15:44:27 2013 -0700

    block: Abstract out bvec iterator
    
    Immutable biovecs are going to require an explicit iterator. To
    implement immutable bvecs, a later patch is going to add a bi_bvec_done
    member to this struct; for now, this patch effectively just renames
    things.
    
    Signed-off-by: Kent Overstreet <kmo@daterainc.com>
    Cc: Jens Axboe <axboe@kernel.dk>
    Cc: Geert Uytterhoeven <geert@linux-m68k.org>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: "Ed L. Cashin" <ecashin@coraid.com>
    Cc: Nick Piggin <npiggin@kernel.dk>
    Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>
    Cc: Jiri Kosina <jkosina@suse.cz>
    Cc: Matthew Wilcox <willy@linux.intel.com>
    Cc: Geoff Levand <geoff@infradead.org>
    Cc: Yehuda Sadeh <yehuda@inktank.com>
    Cc: Sage Weil <sage@inktank.com>
    Cc: Alex Elder <elder@inktank.com>
    Cc: ceph-devel@vger.kernel.org
    Cc: Joshua Morris <josh.h.morris@us.ibm.com>
    Cc: Philip Kelleher <pjk1939@linux.vnet.ibm.com>
    Cc: Rusty Russell <rusty@rustcorp.com.au>
    Cc: "Michael S. Tsirkin" <mst@redhat.com>
    Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Cc: Jeremy Fitzhardinge <jeremy@goop.org>
    Cc: Neil Brown <neilb@suse.de>
    Cc: Alasdair Kergon <agk@redhat.com>
    Cc: Mike Snitzer <snitzer@redhat.com>
    Cc: dm-devel@redhat.com
    Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
    Cc: linux390@de.ibm.com
    Cc: Boaz Harrosh <bharrosh@panasas.com>
    Cc: Benny Halevy <bhalevy@tonian.com>
    Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
    Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
    Cc: Alexander Viro <viro@zeniv.linux.org.uk>
    Cc: Chris Mason <chris.mason@fusionio.com>
    Cc: "Theodore Ts'o" <tytso@mit.edu>
    Cc: Andreas Dilger <adilger.kernel@dilger.ca>
    Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
    Cc: Steven Whitehouse <swhiteho@redhat.com>
    Cc: Dave Kleikamp <shaggy@kernel.org>
    Cc: Joern Engel <joern@logfs.org>
    Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>
    Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
    Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
    Cc: Mark Fasheh <mfasheh@suse.com>
    Cc: Joel Becker <jlbec@evilplan.org>
    Cc: Ben Myers <bpm@sgi.com>
    Cc: xfs@oss.sgi.com
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Len Brown <len.brown@intel.com>
    Cc: Pavel Machek <pavel@ucw.cz>
    Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
    Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    Cc: Ben Hutchings <ben@decadent.org.uk>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Guo Chao <yan@linux.vnet.ibm.com>
    Cc: Tejun Heo <tj@kernel.org>
    Cc: Asai Thambi S P <asamymuthupa@micron.com>
    Cc: Selvan Mani <smani@micron.com>
    Cc: Sam Bradshaw <sbradshaw@micron.com>
    Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
    Cc: "Roger Pau Monné" <roger.pau@citrix.com>
    Cc: Jan Beulich <jbeulich@suse.com>
    Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
    Cc: Ian Campbell <Ian.Campbell@citrix.com>
    Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
    Cc: Christian Borntraeger <borntraeger@de.ibm.com>
    Cc: Minchan Kim <minchan@kernel.org>
    Cc: Jiang Liu <jiang.liu@huawei.com>
    Cc: Nitin Gupta <ngupta@vflare.org>
    Cc: Jerome Marchand <jmarchand@redhat.com>
    Cc: Joe Perches <joe@perches.com>
    Cc: Peng Tao <tao.peng@emc.com>
    Cc: Andy Adamson <andros@netapp.com>
    Cc: fanchaoting <fanchaoting@cn.fujitsu.com>
    Cc: Jie Liu <jeff.liu@oracle.com>
    Cc: Sunil Mushran <sunil.mushran@gmail.com>
    Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
    Cc: Namjae Jeon <namjae.jeon@samsung.com>
    Cc: Pankaj Kumar <pankaj.km@samsung.com>
    Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
    Cc: Mel Gorman <mgorman@suse.de>6

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_acl.c   | 151 +++--------------------------------------------------
 fs/xfs/xfs_acl.h   |   9 +---
 fs/xfs/xfs_aops.c  |   2 +-
 fs/xfs/xfs_buf.c   |   4 +-
 fs/xfs/xfs_iops.c  |  55 +++++++++----------
 fs/xfs/xfs_iops.h  |   2 +-
 fs/xfs/xfs_xattr.c |   4 +-
 7 files changed, 40 insertions(+), 187 deletions(-)


hooks/post-receive
-- 
XFS development tree


--===============5353808140204056726==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5353808140204056726==--
