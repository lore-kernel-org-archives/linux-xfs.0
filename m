Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, for-next,
	updated. xfs-for-linus-v3.12-rc3-44-g10e6e65
Message-Id: <20131031155716.E43BA7FCA@oss.sgi.com>
Date: Thu, 31 Oct 2013 10:57:16 -0500 (CDT)
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
  10e6e65 xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields
  643f7c4 xfs: fix possible NULL dereference in xlog_verify_iclog
  5bf1f43 xfs:xfs_dir2_node.c: pointer use before check for null
  ad22c7a xfs: prevent stack overflows from page cache allocation
      from  632b89e82bf1c04c251924b49adc689f7b346321 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit 10e6e65dfcedff63275c3d649d329c044caa8e26
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Mon Sep 9 15:33:29 2013 -0500

    xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields
    
    Today, if xfs_sb_read_verify encounters a v4 superblock
    with junk past v4 fields which includes data in sb_crc,
    it will be treated as a failing checksum and a significant
    corruption.
    
    There are known prior bugs which leave junk at the end
    of the V4 superblock; we don't need to actually fail the
    verification in this case if other checks pan out ok.
    
    So if this is a secondary superblock, and the primary
    superblock doesn't indicate that this is a V5 filesystem,
    don't treat this as an actual checksum failure.
    
    We should probably check the garbage condition as
    we do in xfs_repair, and possibly warn about it
    or self-heal, but that's a different scope of work.
    
    Stable folks: This can go back to v3.10, which is what
    introduced the sb CRC checking that is tripped up by old,
    stale, incorrect V4 superblocks w/ unzeroed bits.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Acked-by: Dave Chinner <david@fromorbit.com>
    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 643f7c4e5656bd18c769211f933190f7bb738245
Author: Geyslan G. Bem <geyslan@gmail.com>
Date:   Wed Oct 30 16:01:00 2013 -0500

    xfs: fix possible NULL dereference in xlog_verify_iclog
    
    In xlog_verify_iclog a debug check of the incore log buffers prints an
    error if icptr is null and then goes on to dereference the pointer
    regardless.  Convert this to an assert so that the intention is clear.
    This was reported by Coverty.
    
    Signed-off-by: Ben Myers <bpm@sgi.com>
    Reviewed-by: Eric Sandeen <sandeen@redhat.com>

commit 5bf1f439c89d4653f8cc8f8aa303e0d6991aba4b
Author: Denis Efremov <yefremov.denis@gmail.com>
Date:   Fri Oct 25 15:53:25 2013 +0400

    xfs:xfs_dir2_node.c: pointer use before check for null
    
    ASSERT on args takes place after args dereference.
    This assertion is redundant since we are going to panic anyway.
    
    Found by Linux Driver Verification project (linuxtesting.org) -
    PVS-Studio analyzer.
    
    Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit ad22c7a043c2cc6792820e6c5da699935933e87d
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 29 22:11:57 2013 +1100

    xfs: prevent stack overflows from page cache allocation
    
    Page cache allocation doesn't always go through ->begin_write and
    hence we don't always get the opportunity to set the allocation
    context to GFP_NOFS. Failing to do this means we open up the direct
    relcaim stack to recurse into the filesystem and consume a
    significant amount of stack.
    
    On RHEL6.4 kernels we are seeing ra_submit() and
    generic_file_splice_read() from an nfsd context recursing into the
    filesystem via the inode cache shrinker and evicting inodes. This is
    causing truncation to be run (e.g EOF block freeing) and causing
    bmap btree block merges and free space btree block splits to occur.
    These btree manipulations are occurring with the call chain already
    30 functions deep and hence there is not enough stack space to
    complete such operations.
    
    To avoid these specific overruns, we need to prevent the page cache
    allocation from recursing via direct reclaim. We can do that because
    the allocation functions take the allocation context from that which
    is stored in the mapping for the inode. We don't set that right now,
    so the default is GFP_HIGHUSER_MOVABLE, which is effectively a
    GFP_KERNEL context. We need it to be the equivalent of GFP_NOFS, so
    when we initialise an inode, set the mapping gfp mask appropriately.
    
    This makes the use of AOP_FLAG_NOFS redundant from other parts of
    the XFS IO path, so get rid of it.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/xfs_aops.c      |  3 +--
 fs/xfs/xfs_dir2_node.c |  1 -
 fs/xfs/xfs_iops.c      |  9 +++++++++
 fs/xfs/xfs_log.c       |  8 +++-----
 fs/xfs/xfs_sb.c        | 13 +++++++++++--
 5 files changed, 24 insertions(+), 10 deletions(-)


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
