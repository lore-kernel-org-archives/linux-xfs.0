Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.13-rc1-2-13376-gdf8052e
Message-Id: <20131210154021.CFC297FA7@oss.sgi.com>
Date: Tue, 10 Dec 2013 09:40:21 -0600 (CST)
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
  df8052e xfs: fix infinite loop by detaching the group/project hints from user dquot
  5a01dd5 xfs: fix assertion failure at xfs_setattr_nonsize
      from  c91c46c12768daac8486dff0f74bc52c2ec974cd (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit df8052e7dae00bde6f21b40b6e3e1099770f3afc
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Tue Nov 26 21:38:49 2013 +0800

    xfs: fix infinite loop by detaching the group/project hints from user dquot
    
    xfs_quota(8) will hang up if trying to turn group/project quota off
    before the user quota is off, this could be 100% reproduced by:
      # mount -ouquota,gquota /dev/sda7 /xfs
      # mkdir /xfs/test
      # xfs_quota -xc 'off -g' /xfs <-- hangs up
      # echo w > /proc/sysrq-trigger
      # dmesg
    
      SysRq : Show Blocked State
      task                        PC stack   pid father
      xfs_quota       D 0000000000000000     0 27574   2551 0x00000000
      [snip]
      Call Trace:
      [<ffffffff81aaa21d>] schedule+0xad/0xc0
      [<ffffffff81aa327e>] schedule_timeout+0x35e/0x3c0
      [<ffffffff8114b506>] ? mark_held_locks+0x176/0x1c0
      [<ffffffff810ad6c0>] ? call_timer_fn+0x2c0/0x2c0
      [<ffffffffa0c25380>] ? xfs_qm_shrink_count+0x30/0x30 [xfs]
      [<ffffffff81aa3306>] schedule_timeout_uninterruptible+0x26/0x30
      [<ffffffffa0c26155>] xfs_qm_dquot_walk+0x235/0x260 [xfs]
      [<ffffffffa0c059d8>] ? xfs_perag_get+0x1d8/0x2d0 [xfs]
      [<ffffffffa0c05805>] ? xfs_perag_get+0x5/0x2d0 [xfs]
      [<ffffffffa0b7707e>] ? xfs_inode_ag_iterator+0xae/0xf0 [xfs]
      [<ffffffffa0c22280>] ? xfs_trans_free_dqinfo+0x50/0x50 [xfs]
      [<ffffffffa0b7709f>] ? xfs_inode_ag_iterator+0xcf/0xf0 [xfs]
      [<ffffffffa0c261e6>] xfs_qm_dqpurge_all+0x66/0xb0 [xfs]
      [<ffffffffa0c2497a>] xfs_qm_scall_quotaoff+0x20a/0x5f0 [xfs]
      [<ffffffffa0c2b8f6>] xfs_fs_set_xstate+0x136/0x180 [xfs]
      [<ffffffff8136cf7a>] do_quotactl+0x53a/0x6b0
      [<ffffffff812fba4b>] ? iput+0x5b/0x90
      [<ffffffff8136d257>] SyS_quotactl+0x167/0x1d0
      [<ffffffff814cf2ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
      [<ffffffff81abcd19>] system_call_fastpath+0x16/0x1b
    
    It's fine if we turn user quota off at first, then turn off other
    kind of quotas if they are enabled since the group/project dquot
    refcount is decreased to zero once the user quota if off. Otherwise,
    those dquots refcount is non-zero due to the user dquot might refer
    to them as hint(s).  Hence, above operation cause an infinite loop
    at xfs_qm_dquot_walk() while trying to purge dquot cache.
    
    This problem has been around since Linux 3.4, it was introduced by:
      [ b84a3a9675 xfs: remove the per-filesystem list of dquots ]
    
    Originally we will release the group dquot pointers because the user
    dquots maybe carrying around as a hint via xfs_qm_detach_gdquots().
    However, with above change, there is no such work to be done before
    purging group/project dquot cache.
    
    In order to solve this problem, this patch introduces a special routine
    xfs_qm_dqpurge_hints(), and it would release the group/project dquot
    pointers the user dquots maybe carrying around as a hint, and then it
    will proceed to purge the user dquot cache if requested.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 5a01dd54f4a7fb513062070c5acef20d13cad980
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Tue Nov 26 21:38:34 2013 +0800

    xfs: fix assertion failure at xfs_setattr_nonsize
    
    For CRC enabled v5 super block, change a file's ownership can simply
    trigger an ASSERT failure at xfs_setattr_nonsize() if both group and
    project quota are enabled, i.e,
    
    [  305.337609] XFS: Assertion failed: !XFS_IS_PQUOTA_ON(mp), file: fs/xfs/xfs_iops.c, line: 621
    [  305.339250] Kernel BUG at ffffffffa0a7fa32 [verbose debug info unavailable]
    [  305.383939] Call Trace:
    [  305.385536]  [<ffffffffa0a7d95a>] xfs_setattr_nonsize+0x69a/0x720 [xfs]
    [  305.387142]  [<ffffffffa0a7dea9>] xfs_vn_setattr+0x29/0x70 [xfs]
    [  305.388727]  [<ffffffff811ca388>] notify_change+0x1a8/0x350
    [  305.390298]  [<ffffffff811ac39d>] chown_common+0xfd/0x110
    [  305.391868]  [<ffffffff811ad6bf>] SyS_fchownat+0xaf/0x110
    [  305.393440]  [<ffffffff811ad760>] SyS_lchown+0x20/0x30
    [  305.394995]  [<ffffffff8170f7dd>] system_call_fastpath+0x1a/0x1f
    [  305.399870] RIP  [<ffffffffa0a7fa32>] assfail+0x22/0x30 [xfs]
    
    This fix adjust the assertion to check if the super block support both
    quota inodes or not.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_iops.c |  3 ++-
 fs/xfs/xfs_qm.c   | 71 +++++++++++++++++++++++++++++++++++++++----------------
 2 files changed, 52 insertions(+), 22 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
