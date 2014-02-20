Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-fixes-for-3.14-rc4,
	created. xfs-for-linus-v3.14-rc1-2-12926-g5ef11eb
Message-Id: <20140220042331.1F25D7FEF@oss.sgi.com>
Date: Wed, 19 Feb 2014 22:23:28 -0600 (CST)
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

The branch, xfs-fixes-for-3.14-rc4 has been created
        at  5ef11eb0700f806c4671ba33e5befa784a2f70ef (commit)

- Log -----------------------------------------------------------------
commit 5ef11eb0700f806c4671ba33e5befa784a2f70ef
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Feb 19 15:39:35 2014 +1100

    xfs: limit superblock corruption errors to actual corruption
    
    Today, if
    
    xfs_sb_read_verify
      xfs_sb_verify
        xfs_mount_validate_sb
    
    detects superblock corruption, it'll be extremely noisy, dumping
    2 stacks, 2 hexdumps, etc.
    
    This is because we call XFS_CORRUPTION_ERROR in xfs_mount_validate_sb
    as well as in xfs_sb_read_verify.
    
    Also, *any* errors in xfs_mount_validate_sb which are not corruption
    per se; things like too-big-blocksize, bad version, bad magic, v1 dirs,
    rw-incompat etc - things which do not return EFSCORRUPTED - will
    still do the whole XFS_CORRUPTION_ERROR spew when xfs_sb_read_verify
    sees any error at all.  And it suggests to the user that they
    should run xfs_repair, even if the root cause of the mount failure
    is a simple incompatibility.
    
    I'll submit that the probably-not-corrupted errors don't warrant
    this much noise, so this patch removes the warning for anything
    other than EFSCORRUPTED returns, and replaces the lower-level
    XFS_CORRUPTION_ERROR with an xfs_notice().
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit daba5427dad6b260256053f914de2c0b79f7a79f
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Feb 19 15:39:16 2014 +1100

    xfs: skip verification on initial "guess" superblock read
    
    When xfs_readsb() does the very first read of the superblock,
    it makes a guess at the length of the buffer, based on the
    sector size of the underlying storage.  This may or may
    not match the filesystem sector size in sb_sectsize, so
    we can't i.e. do a CRC check on it; it might be too short.
    
    In fact, mounting a filesystem with sb_sectsize larger
    than the device sector size will cause a mount failure
    if CRCs are enabled, because we are checksumming a length
    which exceeds the buffer passed to it.
    
    So always read twice; the first time we read with NULL
    buffer ops to skip verification; then set the proper
    read length, hook up the proper verifier, and give it
    another go.
    
    Once we are sure that we've got the right buffer length,
    we can also use bp->b_length in the xfs_sb_read_verify,
    rather than the less-trusted on-disk sectorsize for
    secondary superblocks.  Before this we ran the risk of
    passing junk to the crc32c routines, which didn't always
    handle extreme values.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 82daa86a77e592b38b7fa3f533173d1a3c1299a1
Author: Ben Myers <bpm@sgi.com>
Date:   Wed Feb 19 15:38:22 2014 +1100

    MAINTAINERS: SGI no longer maintaining XFS
    
    SGI is stepping out of maintainer roles for xfs, xfsprogs, xfsdump, and
    xfstests.  This removes me from the MAINTAINERS entry.
    
    Signed-off-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 7a01e707a324a4585949ca3df6c7f7485d8783f2
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Wed Feb 19 15:33:05 2014 +1100

    xfs: xfs_sb_read_verify() doesn't flag bad crcs on primary sb
    
    My earlier commit 10e6e65 deserves a layer or two of brown paper
    bags.  The logic in that commit means that a CRC failure on the
    primary superblock will *never* result in an error return.
    
    Hopefully this fixes it, so that we always return the error
    if it's a primary superblock, otherwise only if the filesystem
    has CRCs enabled.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
