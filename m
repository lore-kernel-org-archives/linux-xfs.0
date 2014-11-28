Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-misc-fixes-for-3.19-1,
	created. v3.18-rc2-5-gdb52d09e
Message-Id: <20141128111604.0F3A67F47@oss.sgi.com>
Date: Fri, 28 Nov 2014 05:16:03 -0600 (CST)
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

The branch, xfs-misc-fixes-for-3.19-1 has been created
        at  db52d09ecbf85c54e263a9d1ebfb615a9b2b3ba6 (commit)

- Log -----------------------------------------------------------------
commit db52d09ecbf85c54e263a9d1ebfb615a9b2b3ba6
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Nov 28 14:03:55 2014 +1100

    xfs: catch invalid negative blknos in _xfs_buf_find()
    
    Here blkno is a daddr_t, which is a __s64; it's possible to hold
    a value which is negative, and thus pass the (blkno >= eofs)
    test.  Then we try to do a xfs_perag_get() for a ridiculous
    agno via xfs_daddr_to_agno(), and bad things happen when that
    fails, and returns a null pag which is dereferenced shortly
    thereafter.
    
    Found via a user-supplied fuzzed image...
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 91ee575f2b35d1307412f917787195c2f6a38dfb
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Nov 28 14:02:59 2014 +1100

    xfs: allow lazy sb counter sync during filesystem freeze sequence
    
    The expectation since the introduction the lazy superblock counters is
    that the counters are synced and superblock logged appropriately as part
    of the filesystem freeze sequence. This does not occur, however, due to
    the logic in xfs_fs_writable() that prevents progress when the fs is in
    any state other than SB_UNFROZEN.
    
    While this is a bug, it has not been exposed to date because the last
    thing XFS does during freeze is dirty the log. The log recovery process
    recalculates the counters from AGI/AGF metadata to ensure everything is
    correct. Therefore should a crash occur while an fs is frozen, the
    subsequent log recovery puts everything back in order. See the following
    commit for reference:
    
    	92821e2b [XFS] Lazy Superblock Counters
    
    We might not always want to rely on dirtying the log on a frozen fs.
    Modify xfs_log_sbcount() to proceed when the filesystem is freezing but
    not once the freeze process has completed. Modify xfs_fs_writable() to
    accept the minimum freeze level for which modifications should be
    blocked to support various codepaths.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 5d45ee1b41b02269ce04920a48cd2c6b2a458090
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Nov 28 14:00:53 2014 +1100

    xfs: fix error handling in xfs_qm_log_quotaoff()
    
    The error handling in xfs_qm_log_quotaoff() has a couple problems. If
    xfs_trans_commit() fails, we fall through to the error block and call
    xfs_trans_cancel(). This is incorrect on commit failure. If
    xfs_trans_reserve() fails, we jump to the error block, cancel the tp and
    restore the superblock qflags to oldsbqflag. However, oldsbqflag has
    been initialized to zero and not yet updated from the original flags so
    we set the flags to zero.
    
    Fix up the error handling in xfs_qm_log_quotaoff() to not restore flags
    if they haven't been modified and not cancel the tp on commit failure.
    Remove the flag restore code altogether because commit error is the only
    failure condition and we don't know whether the transaction made it to
    disk.
    
    Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 062647a8b41928f4fb97f967b24092be68f5f0f0
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Nov 28 14:00:16 2014 +1100

    xfs: replace on-stack xfs_trans_res with pointer in xfs_create()
    
    There's no need to store a full struct xfs_trans_res on the stack in
    xfs_create() and copy the fields. Use a pointer to the appropriate
    structures embedded in the xfs_mount.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 78c931b8be75456562b55ed4e27878f1519e1367
Author: Brian Foster <bfoster@redhat.com>
Date:   Fri Nov 28 13:59:58 2014 +1100

    xfs: replace global xfslogd wq with per-mount wq
    
    The xfslogd workqueue is a global, single-job workqueue for buffer ioend
    processing. This means we allow for a single work item at a time for all
    possible XFS mounts on a system. fsstress testing in loopback XFS over
    XFS configurations has reproduced xfslogd deadlocks due to the single
    threaded nature of the queue and dependencies introduced between the
    separate XFS instances by online discard (-o discard).
    
    Discard over a loopback device converts the discard request to a hole
    punch (fallocate) on the underlying file. Online discard requests are
    issued synchronously and from xfslogd context in XFS, hence the xfslogd
    workqueue is blocked in the upper fs waiting on a hole punch request to
    be servied in the lower fs. If the lower fs issues I/O that depends on
    xfslogd to complete, both filesystems end up hung indefinitely. This is
    reproduced reliabily by generic/013 on XFS->loop->XFS test devices with
    the '-o discard' mount option.
    
    Further, docker implementations appear to use this kind of configuration
    for container instance filesystems by default (container fs->dm->
    loop->base fs) and therefore are subject to this deadlock when running
    on XFS.
    
    Replace the global xfslogd workqueue with a per-mount variant. This
    guarantees each mount access to a single worker and prevents deadlocks
    due to inter-fs dependencies introduced by discard. Since the queue is
    only responsible for buffer iodone processing at this point in time,
    rename xfslogd to xfs-buf.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
