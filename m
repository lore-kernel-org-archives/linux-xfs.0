Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. for-linus-v3.11-rc1-2-12223-g914ed44
Message-Id: <20130902004011.8E4A929DFB@oss.sgi.com>
Date: Sun,  1 Sep 2013 19:40:10 -0500 (CDT)
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
  914ed44 Fix wrong flag ASSERT in xfs_attr_shortform_getvalue
  904c17e xfs: finish removing IOP_* macros.
  2395670 xfs: inode log reservations are too small
  b121099 xfs: check correct status variable for xfs_inobt_get_rec() call
  d891400 xfs: inode buffers may not be valid during recovery readahead
  50d5c8d xfs: check LSN ordering for v5 superblocks during recovery
  b58fa55 xfs: btree block LSN escaping to disk uninitialised
  3780437 XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
  0f0d334 xfs: fix bad dquot buffer size in log recovery readahead
  84a5b73 xfs: don't account buffer cancellation during log recovery readahead
      from  0d0ab120d1fe90fcc73a2bfff3945bea636b3025 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 914ed44b17dc30ce0d783e8e23fce58a1a92412c
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Fri Mar 30 11:24:11 2012 -0500

    Fix wrong flag ASSERT in xfs_attr_shortform_getvalue
    
    This ASSERT is testing an if_flags flag value against
    a di_aformat enum value.  di_aformat is never assigned
    XFS_IFINLINE.
    
    This happens to work for now, because XFS_IFINLINE has
    the same value as XFS_DINODE_FMT_LOCAL, and that's tested
    just before we call this function.
    
    However, I think the intention is to assert that we have
    read in the data, i.e. XFS_IFINLINE on if_flags, before
    we use if_data.  This is done in other places through the
    code as well.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 904c17e6832845cc651a4d5108a7d57eacdb61f7
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Aug 28 21:12:03 2013 +1000

    xfs: finish removing IOP_* macros.
    
    In optimising the CIL operations, some of the IOP_* macros for
    calling log item operations were removed. Remove the rest of them as
    Christoph requested.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Geoffrey Wehrman <gwehrman@sgi.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 239567033c38933c4d6f402f9f8a2126df73e4c6
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Aug 28 16:10:35 2013 +1000

    xfs: inode log reservations are too small
    
    We've been seeing occasional problems with log space leaks and
    transaction underruns such as this for some time:
    
     XFS (dm-0): xlog_write: reservation summary:
       trans type  = FSYNC_TS (36)
       unit res    = 2740 bytes
       current res = -4 bytes
       total reg   = 0 bytes (o/flow = 0 bytes)
       ophdrs      = 0 (ophdr space = 0 bytes)
       ophdr + reg = 0 bytes
       num regions = 0
    
    Turns out that xfstests generic/311 is reliably reproducing this
    problem with the test it runs at sequence 16 of it execution. It is
    a 100% reliable reproducer with the mkfs configuration of "-b
    size=1024 -m crc=1" on a 10GB scratch device.
    
    The problem? Inode forks in btree format are logged in memory
    format, not disk format (i.e. bmbt format, not bmdr format). That
    means there is a btree block header being logged, when such a
    structure is never written to the inode fork in bmdr format. The
    bmdr header in the inode is only 4 bytes, while the bmbt header is
    24 bytes for v4 filesystems and 72 bytes for v5 filesystems.
    
    We currently reserve the inode size plus the rounded up overhead of
    a logging a buffer, which is 128 bytes. That means the reservation
    for a 512 byte inode is 640 bytes. What we can actually log is:
    
    	inode core, data and attr fork = 512 bytes
    	inode log format + log op header = 56 + 12 = 68 bytes
    	data fork bmbt hdr = 24/72 bytes
    	attr fork bmbt hdr = 24/72 bytes
    
    So, for a v2 inodes we can log at least 628 bytes, but if we split that
    inode over the end of the log across log buffers, we need to also
    another log op header, which takes us to 640 bytes. If there's
    another reservation taken out of this that I haven't taken into
    account (perhaps multiple iclog splits?) or I haven't corectly
    calculated the bmbt format space used (entirely possible), then
    we will overun it.
    
    For v3 inodes the maximum is actually 724 bytes, and even a
    single maximally sized btree format fork can blow it (652 bytes).
    And that's exactly what is happening with the FSYNC_TS transaction
    in the above output - it's consumed 644 bytes of space after the CIL
    context took the space reserved for it (2100 bytes).
    
    This problem has always been present in the XFS code - the btree
    format inode forks have always been logged in this manner. Hence
    there has always been the possibility of an overrun with such a
    transaction. The CRC code has just exposed it frequently enough to
    be able to debug and understand the root cause....
    
    So, let's fix all the inode log space reservations.
    
    [ I'm so glad we spent the effort to clean up the transaction
      reservation code. This is an easy fix now. ]
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit b121099d84b0311a26ca04d33961febb33580fe4
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Aug 27 17:15:45 2013 -0400

    xfs: check correct status variable for xfs_inobt_get_rec() call
    
    The call to xfs_inobt_get_rec() in xfs_dialloc_ag() passes 'j' as
    the output status variable. The immediately following
    XFS_WANT_CORRUPTED_GOTO() checks the value of 'i,' which is from
    the previous lookup call and has already been checked. Fix the
    corruption check to use 'j.'
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit d8914002a0391331a88d9f5de4a235220735d4cc
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Aug 27 11:39:37 2013 +1000

    xfs: inode buffers may not be valid during recovery readahead
    
    CRC enabled filesystems fail log recovery with 100% reliability on
    xfstests xfs/085 with the following failure:
    
    XFS (vdb): Mounting Filesystem
    XFS (vdb): Starting recovery (logdev: internal)
    XFS (vdb): Corruption detected. Unmount and run xfs_repair
    XFS (vdb): bad inode magic/vsn daddr 144 #0 (magic=0)
    XFS: Assertion failed: 0, file: fs/xfs/xfs_inode_buf.c, line: 95
    
    The problem is that the inode buffer has not been recovered before
    the readahead on the inode buffer is issued. The checkpoint being
    recovered actually allocates the inode chunk we are doing readahead
    from, so what comes from disk during readahead is essentially
    random and the verifier barfs on it.
    
    This inode buffer readahead problem affects non-crc filesystems,
    too, but xfstests does not trigger it at all on such
    configurations....
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 50d5c8d8e938e3c4c0d21db9fc7d64282dc7be20
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Aug 28 21:22:47 2013 +1000

    xfs: check LSN ordering for v5 superblocks during recovery
    
    Log recovery has some strict ordering requirements which unordered
    or reordered metadata writeback can defeat. This can occur when an
    item is logged in a transaction, written back to disk, and then
    logged in a new transaction before the tail of the log is moved past
    the original modification.
    
    The result of this is that when we read an object off disk for
    recovery purposes, the buffer that we read may not contain the
    object type that recovery is expecting and hence at the end of the
    checkpoint being recovered we have an invalid object in memory.
    
    This isn't usually a problem, as recovery will then replay all the
    other checkpoints and that brings the object back to a valid and
    correct state, but the issue is that while the object is in the
    invalid state it can be flushed to disk. This results in the object
    verifier failing and triggering a corruption shutdown of log
    recover. This is correct behaviour for the verifiers - the problem
    is that we are not detecting that the object we've read off disk is
    newer than the transaction we are replaying.
    
    All metadata in v5 filesystems has the LSN of it's last modification
    stamped in it. This enabled log recover to read that field and
    determine the age of the object on disk correctly. If the LSN of the
    object on disk is older than the transaction being replayed, then we
    replay the modification. If the LSN of the object matches or is more
    recent than the transaction's LSN, then we should avoid overwriting
    the object as that is what leads to the transient corrupt state.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit b58fa554e9b940083a0691f7234c13240fc09377
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Aug 28 21:22:46 2013 +1000

    xfs: btree block LSN escaping to disk uninitialised
    
    When testing LSN ordering code for v5 superblocks, it was discovered
    that the the LSN embedded in the generic btree blocks was
    occasionally uninitialised. These values didn't get written to disk
    by metadata writeback - they got written by previous transactions in
    log recovery.
    
    The issue is here that the when the block is first allocated and
    initialised, the LSN field was not initialised - it gets overwritten
    before IO is issued on the buffer - but the value that is logged by
    transactions that modify the header before it is written to disk
    (and initialised) contain garbage. Hence the first recovery of the
    buffer will stamp garbage into the LSN field, and that can cause
    subsequent transactions to not replay correctly.
    
    The fix is simply to initialise the bb_lsn field to zero when we
    initialise the block for the first time.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 37804376121de1a25fb582bdd8970f139c4d9685
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Aug 26 14:13:30 2013 +1000

    XFS: Assertion failed: first <= last && last < BBTOB(bp->b_length), file: fs/xfs/xfs_trans_buf.c, line: 568
    
    The calculation doesn't take into account the size of the dir v3
    header, so overestimates the hash entries in a node. This causes
    directory buffer overruns when splitting and merging nodes.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Tested-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 0f0d334595105d982ea22ae1d5947723e462344f
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Aug 27 13:25:43 2013 +1000

    xfs: fix bad dquot buffer size in log recovery readahead
    
    xfstests xfs/087 fails 100% reliably with this assert:
    
    XFS (vdb): Mounting Filesystem
    XFS (vdb): Starting recovery (logdev: internal)
    XFS: Assertion failed: bp->b_flags & XBF_STALE, file: fs/xfs/xfs_buf.c, line: 548
    
    while trying to read a dquot buffer in xlog_recover_dquot_ra_pass2().
    
    The issue is that the buffer length to read that is passed to
    xfs_buf_readahead is in units of filesystem blocks, not disk blocks.
    (i.e. FSB, not daddr). Fix it but putting the correct conversion in
    place.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 84a5b7300c724f4000f689c410aeae3242b4f034
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Aug 27 08:10:53 2013 +1000

    xfs: don't account buffer cancellation during log recovery readahead
    
    When doing readhaead in log recovery, we check to see if buffers are
    cancelled before doing readahead. If we find a cancelled buffer,
    however, we always decrement the reference count we have on it, and
    that means that readahead is causing a double decrement of the
    cancelled buffer reference count.
    
    This results in log recovery *replaying cancelled buffers* as the
    actual recovery pass does not find the cancelled buffer entry in the
    commit phase of the second pass across a transaction. On debug
    kernels, this results in an ASSERT failure like so:
    
    XFS: Assertion failed: !(flags & XFS_BLF_CANCEL), file: fs/xfs/xfs_log_recover.c, line: 1815
    
    xfstests generic/311 reproduces this ASSERT failure with 100%
    reproducability.
    
    Fix it by making readahead only peek at the buffer cancelled state
    rather than the full accounting that xlog_check_buffer_cancelled()
    does.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_attr_leaf.c   |   2 +-
 fs/xfs/xfs_btree.c       |   2 +
 fs/xfs/xfs_da_btree.h    |  11 ++-
 fs/xfs/xfs_dir2.c        |  16 ++--
 fs/xfs/xfs_ialloc.c      |   2 +-
 fs/xfs/xfs_inode_buf.c   |  36 +++++++-
 fs/xfs/xfs_inode_buf.h   |   1 +
 fs/xfs/xfs_log_recover.c | 234 ++++++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_trans.c       |  23 +++--
 fs/xfs/xfs_trans.h       |   8 +-
 fs/xfs/xfs_trans_ail.c   |   4 +-
 fs/xfs/xfs_trans_buf.c   |   2 +-
 fs/xfs/xfs_trans_resv.c  |  72 +++++++++++----
 13 files changed, 320 insertions(+), 93 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
