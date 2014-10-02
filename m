From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, xfs-misc-fixes-for-3.18-3,
	created. v3.16-11825-g5217793
Message-Id: <20141002232551.4B83C7F51@oss.sgi.com>
Date: Thu,  2 Oct 2014 18:25:50 -0500 (CDT)
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

The branch, xfs-misc-fixes-for-3.18-3 has been created
        at  52177937e9ac4573391143065b250403d3a6ae4b (commit)

- Log -----------------------------------------------------------------
commit 52177937e9ac4573391143065b250403d3a6ae4b
Author: Mark Tinguely <tinguely@sgi.com>
Date:   Fri Oct 3 09:09:50 2014 +1000

    xfs: xfs_iflush_done checks the wrong log item callback
    
    Commit 3013683 ("xfs: remove all the inodes on a buffer from the AIL
    in bulk") made the xfs inode flush callback more efficient by
    combining all the inode writes on the buffer and the deletions of
    the inode log item from AIL.
    
    The initial loop in this patch should be looping through all
    the log items on the buffer to see which items have
    xfs_iflush_done as their callback function. But currently,
    only the log item passed to the function has its callback
    compared to xfs_iflush_done. If the log item pointer passed to
    the function does have the xfs_iflush_done callback function,
    then all the log items on the buffer are removed from the
    li_bio_list on the buffer b_fspriv and could be removed from
    the AIL even though they may have not been written yet.
    
    This problem is masked by the fact that currently all inodes on a
    buffer will have the same calback function - either xfs_iflush_done
    or xfs_istale_done - and hence the bug cannot manifest in any way.
    Still, we need to remove the landmine so that if we add new
    callbacks in future this doesn't cause us problems.
    
    Signed-off-by: Mark Tinguely <tinguely@sgi.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit da5f10969d54006a24777a84ed3eaeeb2a21047f
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Oct 2 09:44:54 2014 +1000

    xfs: flush the range before zero range conversion
    
    XFS currently discards delalloc blocks within the target range of a
    zero range request. Unaligned start and end offsets are zeroed
    through the page cache and the internal, aligned blocks are
    converted to unwritten extents.
    
    If EOF is page aligned and covered by a delayed allocation extent.
    The inode size is not updated until I/O completion. If a zero range
    request discards a delalloc range that covers page aligned EOF as
    such, the inode size update never occurs. For example:
    
    $ rm -f /mnt/file
    $ xfs_io -fc "pwrite 0 64k" -c "zero 60k 4k" /mnt/file
    $ stat -c "%s" /mnt/file
    65536
    $ umount /mnt
    $ mount <dev> /mnt
    $ stat -c "%s" /mnt/file
    61440
    
    Update xfs_zero_file_space() to flush the range rather than discard
    delalloc blocks to ensure that inode size updates occur
    appropriately.
    
    [dchinner: Note that this is really a workaround to avoid the
    underlying problems. More work is needed (and ongoing) to fix those
    issues so this fix is being added as a temporary stop-gap measure. ]
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 07d08681d26e99d8ba3bc4e56380f2cc04d3ff3b
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Oct 2 09:42:06 2014 +1000

    xfs: restore buffer_head unwritten bit on ioend cancel
    
    xfs_vm_writepage() walks each buffer_head on the page, maps to the block
    on disk and attaches to a running ioend structure that represents the
    I/O submission. A new ioend is created when the type of I/O (unwritten,
    delayed allocation or overwrite) required for a particular buffer_head
    differs from the previous. If a buffer_head is a delalloc or unwritten
    buffer, the associated bits are cleared by xfs_map_at_offset() once the
    buffer_head is added to the ioend.
    
    The process of mapping each buffer_head occurs in xfs_map_blocks() and
    acquires the ilock in blocking or non-blocking mode, depending on the
    type of writeback in progress. If the lock cannot be acquired for
    non-blocking writeback, we cancel the ioend, redirty the page and
    return. Writeback will revisit the page at some later point.
    
    Note that we acquire the ilock for each buffer on the page. Therefore
    during non-blocking writeback, it is possible to add an unwritten buffer
    to the ioend, clear the unwritten state, fail to acquire the ilock when
    mapping a subsequent buffer and cancel the ioend. If this occurs, the
    unwritten status of the buffer sitting in the ioend has been lost. The
    page will eventually hit writeback again, but xfs_vm_writepage() submits
    overwrite I/O instead of unwritten I/O and does not perform unwritten
    extent conversion at I/O completion. This leads to data corruption
    because unwritten extents are treated as holes on reads and zeroes are
    returned instead of reading from disk.
    
    Modify xfs_cancel_ioend() to restore the buffer unwritten bit for ioends
    of type XFS_IO_UNWRITTEN. This ensures that unwritten extent conversion
    occurs once the page is eventually written back.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 5cca3f611d159e5a4a5ec60413bd09948ef40aea
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Thu Oct 2 09:27:09 2014 +1000

    xfs: check for null dquot in xfs_quota_calc_throttle()
    
    Coverity spotted this.
    
    Granted, we *just* checked xfs_inod_dquot() in the caller (by
    calling xfs_quota_need_throttle). However, this is the only place we
    don't check the return value but the check is cheap and future-proof
    so add it.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 04dd1a0d4b17a71220eae4fb313218f15a49bcdd
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Oct 2 09:24:11 2014 +1000

    xfs: fix crc field handling in xfs_sb_to/from_disk
    
    I discovered this in userspace, but the same change applies
    to the kernel.
    
    If we xfs_mdrestore an image from a non-crc filesystem, lo
    and behold the restored image has gained a CRC:
    
    # db/xfs_metadump.sh -o /dev/sdc1 - | xfs_mdrestore - test.img
    # xfs_db -c "sb 0" -c "p crc" /dev/sdc1
    crc = 0 (correct)
    # xfs_db -c "sb 0" -c "p crc" test.img
    crc = 0xb6f8d6a0 (correct)
    
    This is because xfs_sb_from_disk doesn't fill in sb_crc,
    but xfs_sb_to_disk(XFS_SB_ALL_BITS) does write the in-memory
    CRC to disk - so we get uninitialized memory on disk.
    
    Fix this by always initializing sb_crc to 0 when we read
    the superblock, and masking out the CRC bit from ALL_BITS
    when we write it.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 6ee49a20c13b4b4e79a3bba406df8106cff284a1
Author: Eric Sandeen <sandeen@sandeen.net>
Date:   Thu Oct 2 09:23:49 2014 +1000

    xfs: don't send null bp to xfs_trans_brelse()
    
    In this case, if bp is NULL, error is set, and we send a
    NULL bp to xfs_trans_brelse, which will try to dereference it.
    
    Test whether we actually have a buffer before we try to
    free it.
    
    Coverity spotted this.
    
    Signed-off-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit ce57bcf6b81caf1e9f780e98e8d23d3555746d74
Author: Brian Foster <bfoster@redhat.com>
Date:   Thu Oct 2 09:21:53 2014 +1000

    xfs: check for inode size overflow in xfs_new_eof()
    
    If we write to the maximum file offset (2^63-2), XFS fails to log the
    inode size update when the page is flushed. For example:
    
    $ xfs_io -fc "pwrite `echo "2^63-1-1" | bc` 1" /mnt/file
    wrote 1/1 bytes at offset 9223372036854775806
    1.000000 bytes, 1 ops; 0.0000 sec (22.711 KiB/sec and 23255.8140 ops/sec)
    $ stat -c %s /mnt/file
    9223372036854775807
    $ umount /mnt ; mount <dev> /mnt/
    $ stat -c %s /mnt/file
    0
    
    This occurs because XFS calculates the new file size as io_offset +
    io_size, I/O occurs in block sized requests, and the maximum supported
    file size is not block aligned. Therefore, a write to the max allowable
    offset on a 4k blocksize fs results in a write of size 4k to offset
    2^63-4096 (e.g., equivalent to round_down(2^63-1, 4096), or IOW the
    offset of the block that contains the max file size). The offset plus
    size calculation (2^63 - 4096 + 4096 == 2^63) overflows the signed
    64-bit variable which goes negative and causes the > comparison to the
    on-disk inode size to fail. This returns 0 from xfs_new_eof() and
    results in no change to the inode on-disk.
    
    Update xfs_new_eof() to explicitly detect overflow of the local
    calculation and use the VFS inode size in this scenario. The VFS inode
    size is capped to the maximum and thus XFS writes the correct inode size
    to disk.
    
    Signed-off-by: Brian Foster <bfoster@redhat.com>
    Reviewed-by: Dave Chinner <dchinner@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit a872703f34cd6033d0b174fa598f63f1a57145bb
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:20:30 2014 +1000

    xfs: only set extent size hint when asked
    
    Currently the extent size hint is set unconditionally in
    xfs_ioctl_setattr() when the FSX_EXTSIZE flag is set. Hence we can
    set hints when the inode flags indicating the hint should be used
    are not set.  Hence only set the extent size hint from userspace
    when the inode has the XFS_DIFLAG_EXTSIZE flag set to indicate that
    we should have an extent size hint set on the inode.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit 9336e3a765b68d4a7fdd8256f393ebce95ecb0a7
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:18:40 2014 +1000

    xfs: project id inheritance is a directory only flag
    
    xfs_set_diflags() allows it to be set on non-directory inodes, and
    this flags errors in xfs_repair. Further, inode allocation allows
    the same directory-only flag to be inherited to non-directories.
    Make sure directory inode flags don't appear on other types of
    inodes.
    
    This fixes several xfstests scratch fileystem corruption reports
    (e.g. xfs/050) now that xfstests checks scratch filesystems after
    test completion.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit e076b0f3a5c472e77c0a0e163188f2761e8b4fed
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:18:13 2014 +1000

    xfs: kill time.h
    
    The typedef for timespecs and nanotime() are completely unnecessary,
    and delay() can be moved to fs/xfs/linux.h, which means this file
    can go away.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

commit b1d6cc02f2f6a590c4d8dc2c3bcf7be3b9419945
Author: Dave Chinner <dchinner@redhat.com>
Date:   Thu Oct 2 09:17:58 2014 +1000

    xfs: compat_xfs_bstat does not have forkoff
    
    struct compat_xfs_bstat is missing the di_forkoff field and so does
    not fully translate the structure correctly. Fix it.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Dave Chinner <david@fromorbit.com>

-----------------------------------------------------------------------


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
