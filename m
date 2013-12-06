Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.13-rc1-2-13374-gc91c46c
Message-Id: <20131206234421.A6E9E29E24@oss.sgi.com>
Date: Fri,  6 Dec 2013 17:44:20 -0600 (CST)
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
  c91c46c xfs: add xfs_setattr_time
  0c3d88d xfs: tiny xfs_setattr_mode cleanup
  37eb970 xfs: fix false assertion at xfs_qm_vop_create_dqattach
  afbd123 xfs: integrate xfs_quota_priv header file to xfs_qm
  c61a9e3 xfs: make quota metadata truncation behavior consistent to user space
      from  ef701600fd26cace9d513ee174688a2b83832126 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit c91c46c12768daac8486dff0f74bc52c2ec974cd
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Nov 18 05:10:52 2013 -0800

    xfs: add xfs_setattr_time
    
    Split out a xfs_setattr_time helper to share code between truncate and
    regular setattr similar to xfs_setattr_mode.  I might also have another
    caller growing for this in the near future.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 0c3d88dfcedf92b28d759182ecb33f2808dc3e59
Author: Christoph Hellwig <hch@infradead.org>
Date:   Mon Nov 18 05:10:40 2013 -0800

    xfs: tiny xfs_setattr_mode cleanup
    
    Remove the pointless tp argument, and properly align the local variable
    declarations.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 37eb9706ebf5b99d14c6086cdeef2c2f73f9c9fb
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Tue Nov 26 21:38:54 2013 +0800

    xfs: fix false assertion at xfs_qm_vop_create_dqattach
    
    After the previous fix, there still has another ASSERT failure if turning
    off any type of quota while fsstress is running at the same time.
    
    Backtrace in this case:
    
    [   50.867897] XFS: Assertion failed: XFS_IS_GQUOTA_ON(mp), file: fs/xfs/xfs_qm.c, line: 2118
    [   50.867924] ------------[ cut here ]------------
    ... <snip>
    [   50.867957] Kernel BUG at ffffffffa0b55a32 [verbose debug info unavailable]
    [   50.867999] invalid opcode: 0000 [#1] SMP
    [   50.869407] Call Trace:
    [   50.869446]  [<ffffffffa0bc408a>] xfs_qm_vop_create_dqattach+0x19a/0x2d0 [xfs]
    [   50.869512]  [<ffffffffa0b9cc45>] xfs_create+0x5c5/0x6a0 [xfs]
    [   50.869564]  [<ffffffffa0b5307c>] xfs_vn_mknod+0xac/0x1d0 [xfs]
    [   50.869615]  [<ffffffffa0b531d6>] xfs_vn_mkdir+0x16/0x20 [xfs]
    [   50.869655]  [<ffffffff811becd5>] vfs_mkdir+0x95/0x130
    [   50.869689]  [<ffffffff811bf63a>] SyS_mkdirat+0xaa/0xe0
    [   50.869723]  [<ffffffff811bf689>] SyS_mkdir+0x19/0x20
    [   50.869757]  [<ffffffff8170f7dd>] system_call_fastpath+0x1a/0x1f
    [   50.869793] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 <snip>
    [   50.870003] RIP  [<ffffffffa0b55a32>] assfail+0x22/0x30 [xfs]
    [   50.870050]  RSP <ffff88002941fd60>
    [   50.879251] ---[ end trace c93a2b342341c65b ]---
    
    We're hitting the ASSERT(XFS_IS_*QUOTA_ON(mp)) in xfs_qm_vop_create_dqattach(),
    however the assertion itself is not right IMHO.  While performing quota off, we
    firstly clear the XFS_*QUOTA_ACTIVE bit(s) from struct xfs_mount without taking
    any special locks, see xfs_qm_scall_quotaoff().  Hence there is no guarantee
    that the desired quota is still active.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit afbd123db4e72d5fe44db235976af64a22b32976
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Sat Nov 23 00:15:43 2013 +0800

    xfs: integrate xfs_quota_priv header file to xfs_qm
    
    The xfs_quota_priv header file is only included by xfs_qm header and
    there is no much users for its contents, hence we can move those stuff
    to xfs_qm header file and kill it.
    
    This patch also remove an unused macro DQFLAGTO_TYPESTR.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit c61a9e39f637373929a110ad2a5922a2e8b00f4c
Author: Jie Liu <jeff.liu@oracle.com>
Date:   Fri Nov 22 14:04:00 2013 +0800

    xfs: make quota metadata truncation behavior consistent to user space
    
    In xfs_qm_scall_trunc_qfiles(), we ignore the error if failed to remove
    the users quota metadata and proceed to remove groups and projects if
    they are being there.  However, in user space, the remove operation will
    break and return if failed to remove any kind of quota.
    Also for v5 super block, we can enabled both group and project quota at
    the same time, in this case the current error handling will cover the
    group error with projects but they might failed due to different reasons.
    
    It seems we'd better the error handling consistent to the user space and
    don't trying to remove another kind of quota metadata if the previous
    operation is failed.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_iops.c        | 76 ++++++++++++++++++++++--------------------------
 fs/xfs/xfs_qm.c          |  9 ++----
 fs/xfs/xfs_qm.h          | 18 +++++++++++-
 fs/xfs/xfs_qm_syscalls.c | 18 ++++++++----
 fs/xfs/xfs_quota_priv.h  | 42 --------------------------
 5 files changed, 66 insertions(+), 97 deletions(-)
 delete mode 100644 fs/xfs/xfs_quota_priv.h


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
