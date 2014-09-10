Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-misc-fixes-for-3.18-1,
	created. v3.16-11807-gab6978c
Message-Id: <20140910000004.544657F66@oss.sgi.com>
Date: Tue,  9 Sep 2014 19:00:03 -0500 (CDT)
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

The branch, xfs-misc-fixes-for-3.18-1 has been created
        at  ab6978c295b074eb2ba4b06fdf206c7ab4f293e5 (commit)

- Log -----------------------------------------------------------------
commit ab6978c295b074eb2ba4b06fdf206c7ab4f293e5
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Sep 9 11:59:12 2014 +1000

    xfs: remove rbpp check from xfs_rtmodify_summary_int
    
    rbpp is always passed into xfs_rtmodify_summary
    and xfs_rtget_summary, so there is no need to
    test for it in xfs_rtmodify_summary_int.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit afabfd30d05264ff493c24bce310b6a5350f099b
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Sep 9 11:58:42 2014 +1000

    xfs: combine xfs_rtmodify_summary and xfs_rtget_summary
    
    xfs_rtmodify_summary and xfs_rtget_summary are almost identical;
    fold them into xfs_rtmodify_summary_int(), with wrappers for each of
    the original calls.
    
    The _int function modifies if a delta is passed, and returns a
    summary pointer if *sum is passed.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit b16ed7c114b8cca45fa87b675c431f43ff90c179
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Sep 9 11:58:07 2014 +1000

    xfs: combine xfs_dir_canenter into xfs_dir_createname
    
    xfs_dir_canenter and xfs_dir_createname are
    almost identical.
    
    Fold the former into the latter, with a helpful
    wrapper for the former.  If createname is called without
    an inode number, it now only checks for space, and does
    not actually add the entry.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 94f3cad555d66048906deade06a764f7ea2c6e4d
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Sep 9 11:57:52 2014 +1000

    xfs: check resblks before calling xfs_dir_canenter
    
    Move the resblks test out of the xfs_dir_canenter,
    and into the caller.
    
    This makes a little more sense on the face of it;
    xfs_dir_canenter immediately returns if resblks !=0;
    and given some of the comments preceding the calls:
    
     * Check for ability to enter directory entry, if no space reserved.
    
    even more so.
    
    It also facilitates the next patch.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 970fd3f04d5949a4b5f6d0a5fea8e4b6797a5992
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue Sep 9 11:57:29 2014 +1000

    xfs: deduplicate xlog_do_recovery_pass()
    
    In xlog_do_recovery_pass(), there are 2 distinct cases:
    non-wrapped and wrapped log recovery.
    
    If we find a wrapped log, we recover around the end
    of the log, and then handle the rest of recovery
    exactly as in the non-wrapped case - using exactly the same
    (duplicated) code.
    
    Rather than having the same code in both cases, we can
    get the wrapped portion out of the way first if needed,
    and then recover the non-wrapped portion of the log.
    
    There should be no functional change here, just code
    reorganization & deduplication.
    
    The patch looks a bit bigger than it really is; the last
    hunk is whitespace changes (un-indenting).
    
    Tested with xfstests "check -g log" on a stock configuration.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 59f9c004320704179913fa7c57645017ccf1b5c3
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Tue Sep 9 11:57:10 2014 +1000

    xfs: lseek: the "whence" argument is called "whence"
    
    For some reason, the older commit:
    
        965c8e5 lseek: the "whence" argument is called "whence"
    
        lseek: the "whence" argument is called "whence"
    
        But the kernel decided to call it "origin" instead.
        Fix most of the sites.
    
    left out xfs.  So fix xfs.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 49c69591c80648c14ff87525e97ee6ebe3a343cb
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Sep 9 11:56:48 2014 +1000

    xfs: combine xfs_seek_hole & xfs_seek_data
    
    xfs_seek_hole & xfs_seek_data are remarkably similar;
    so much so that they can be combined, saving a fair
    bit of semi-complex code duplication.
    
    The following patch passes generic/285 and generic/286,
    which specifically test seek behavior.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Jie Liu <jeff.liu@oracle.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 2e2271787419a12496bf5da5c3028a9c73c9697f
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Sep 9 11:56:13 2014 +1000

    xfs: export log_recovery_delay to delay mount time log recovery
    
    XFS log recovery has been discovered to have race conditions with
    buffers when I/O errors occur. External tools are available to simulate
    I/O errors to XFS, but this alone is not sufficient for testing log
    recovery. XFS unconditionally resets the inactive region of the log
    prior to log recovery to avoid confusion over processing any partially
    written log records that might have been written before an unclean
    shutdown. Therefore, unconditional write I/O failures at mount time are
    caught by the reset sequence rather than log recovery and hinder the
    ability to test the latter.
    
    The device-mapper dm-flakey module uses an up/down timer to define a
    cycle for when to fail I/Os. Create a pre log recovery delay tunable
    that can be used to coordinate XFS log recovery with I/O errors
    simulated by dm-flakey. This facilitates coordination in userspace that
    allows the reset of stale log blocks to succeed and writes due to log
    recovery to fail. For example, define a dm-flakey instance with an
    uptime long enough to allow log reset to succeed and a log recovery
    delay long enough to allow the dm-flakey uptime to expire.
    
    The 'log_recovery_delay' sysfs tunable is exported under
    /sys/fs/xfs/debug and is only enabled for kernels compiled in XFS debug
    mode. The value is exported in units of seconds and allows for a delay
    of up to 60 seconds. Note that this is for XFS debug and test
    instrumentation purposes only and should not be used by applications. No
    delay is enabled by default.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 65b65735fede29b516fed1d8c2391e8bc373b805
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Sep 9 11:52:42 2014 +1000

    xfs: add debug sysfs attribute set
    
    Create a top-level debug directory for global debug sysfs attributes.
    This directory is added and removed on XFS module initialization and
    removal respectively for DEBUG mode kernels only. It typically resides
    at /sys/fs/xfs/debug. It is located at the top level of the xfs sysfs
    hierarchy as attributes might define global behavior or behavior that
    must be configured before an xfs mount is available (e.g., log recovery
    behavior).
    
    Define the global debug kobject that represents the debug sysfs
    directory and add generic attribute show/store helpers to support future
    attributes. No debug attributes are exported as of yet.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e1b05723ed834090caab56866adc05bce31c9bdd
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Tue Sep 9 11:47:24 2014 +1000

    xfs: add a few more verifier tests
    
    These were exposed by fsfuzzer runs; without them we fail
    in various exciting and sometimes convoluted ways when we
    encounter disk corruption.
    
    Without the MAXLEVELS tests we tend to walk off the end of
    an array in a loop like this:
    
            for (i = 0; i < cur->bc_nlevels; i++) {
                    if (cur->bc_bufs[i])
    
    Without the dirblklog test we try to allocate more memory
    than we could possibly hope for and loop forever:
    
    xfs_dabuf_map()
    	nfsb = mp->m_dir_geo->fsbcount;
    	irecs = kmem_zalloc(sizeof(irec) * nfsb, KM_SLEEP...
    
    As for the logbsize check, that's the convoluted one.
    
    If logbsize is specified at mount time, it's sanitized
    in xfs_parseargs; in particular it makes sure that it's
    not > XLOG_MAX_RECORD_BSIZE.
    
    If not specified at mount time, it comes from the superblock
    via sb_logsunit; this is limited to 256k at mkfs time as well;
    it's copied into m_logbsize in xfs_finish_flags().
    
    However, if for some reason the on-disk value is corrupt and
    too large, nothing catches it.  It's a circuitous path, but
    that size eventually finds its way to places that make the kernel
    very unhappy, leading to oopses in xlog_pack_data() because we
    use the size as an index into iclog->ic_data, but the array
    is not necessarily that big.
    
    Anyway - bounds checking when we read from disk is a good thing!
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 8018ec083c72443cc74fd2d08eb7c5dddc13af53
Author: Brian Foster <bfoster@redhat.com>
Date:   Tue Sep 9 11:44:46 2014 +1000

    xfs: mark all internal workqueues as freezable
    
    Workqueues must be explicitly set as freezable to ensure they are frozen
    in the assocated part of the hibernation/suspend sequence. Freezing of
    workqueues and kernel threads is important to ensure that modifications
    are not made on-disk after the hibernation image has been created.
    Otherwise, the in-memory state can become inconsistent with what is on
    disk and eventually lead to filesystem corruption. We have reports of
    free space btree corruptions that occur immediately after restore from
    hibernate that suggest the xfs-eofblocks workqueue could be causing
    such problems if it races with hibernation.
    
    Mark all of the internal XFS workqueues as freezable to ensure nothing
    changes on-disk once the freezer infrastructure freezes kernel threads
    and creates the hibernation image.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reported-by: Carlos E. R. <carlos.e.r@opensuse.org>
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
