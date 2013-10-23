Return-Path: <xfs-bounces@oss.sgi.com>
From: xfs@oss.sgi.com
Subject: [XFS updates] XFS development tree branch, master,
	updated. xfs-for-linus-v3.12-rc3-28-gc963c61
Message-Id: <20131023222201.F17087F4E@oss.sgi.com>
Date: Wed, 23 Oct 2013 17:22:01 -0500 (CDT)
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
  c963c61 xfs: split xfs_rtalloc.c for userspace sanity
  a4fbe6a xfs: decouple inode and bmap btree header files
  239880e xfs: decouple log and transaction headers
  d420e5c xfs: remove unused transaction callback variables
  9aede1d xfs: split dquot buffer operations out
  5706278 xfs: unify directory/attribute format definitions
  70a9883 xfs: create a shared header file for format-related information
      from  865e9446b4c17f78be0b1387426394b6bfc278f3 (commit)

Those revisions listed above that are new to this repository have
not appeared on any other notification email; so we list those
revisions in full, below.

- Log -----------------------------------------------------------------
commit c963c6193a5adaec58044e238ef23516d04e5a74
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 15 09:17:56 2013 +1100

    xfs: split xfs_rtalloc.c for userspace sanity
    
    xfs_rtalloc.c is partially shared with userspace. Split the file up
    into two parts - one that is kernel private and the other which is
    wholly shared with userspace.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit a4fbe6ab1e7abecf42b75e9c73701ed33b4ab03b
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Oct 23 10:51:50 2013 +1100

    xfs: decouple inode and bmap btree header files
    
    Currently the xfs_inode.h header has a dependency on the definition
    of the BMAP btree records as the inode fork includes an array of
    xfs_bmbt_rec_host_t objects in it's definition.
    
    Move all the btree format definitions from xfs_btree.h,
    xfs_bmap_btree.h, xfs_alloc_btree.h and xfs_ialloc_btree.h to
    xfs_format.h to continue the process of centralising the on-disk
    format definitions. With this done, the xfs inode definitions are no
    longer dependent on btree header files.
    
    The enables a massive culling of unnecessary includes, with close to
    200 #include directives removed from the XFS kernel code base.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 239880ef6454ccff2ba8d762c3f86e8278f0ce1c
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Oct 23 10:50:10 2013 +1100

    xfs: decouple log and transaction headers
    
    xfs_trans.h has a dependency on xfs_log.h for a couple of
    structures. Most code that does transactions doesn't need to know
    anything about the log, but this dependency means that they have to
    include xfs_log.h. Decouple the xfs_trans.h and xfs_log.h header
    files and clean up the includes to be in dependency order.
    
    In doing this, remove the direct include of xfs_trans_reserve.h from
    xfs_trans.h so that we remove the dependency between xfs_trans.h and
    xfs_mount.h. Hence the xfs_trans.h include can be moved to the
    indicate the actual dependencies other header files have on it.
    
    Note that these are kernel only header files, so this does not
    translate to any userspace changes at all.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit d420e5c810bce5debce0238021b410d0ef99cf08
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 15 09:17:53 2013 +1100

    xfs: remove unused transaction callback variables
    
    We don't do callbacks at transaction commit time, no do we have any
    infrastructure to set up or run such callbacks, so remove the
    variables and typedefs for these operations. If we ever need to add
    callbacks, we can reintroduce the variables at that time.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 9aede1d81b12a95771db0e2f9196dd37e10aaf20
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 15 09:17:52 2013 +1100

    xfs: split dquot buffer operations out
    
    Parts of userspace want to be able to read and modify dquot buffers
    (e.g. xfs_db) so we need to split out the reading and writing of
    these buffers so it is easy to shared code with libxfs in userspace.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 5706278758e334bf6a15f57c18dc16df19c83957
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Oct 15 09:17:51 2013 +1100

    xfs: unify directory/attribute format definitions
    
    The on-disk format definitions for the directory and attribute
    structures are spread across 3 header files right now, only one of
    which is dedicated to defining on-disk structures and their
    manipulation (xfs_dir2_format.h). Pull all the format definitions
    into a single header file - xfs_da_format.h - and switch all the
    code over to point at that.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Ben Myers <bpm@sgi.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

commit 70a9883c5f34b215b8a77665cefd0398edc5a9ef
Author: Dave Chinner <dchinner@redhat.com>
Date:   Wed Oct 23 10:36:05 2013 +1100

    xfs: create a shared header file for format-related information
    
    All of the buffer operations structures are needed to be exported
    for xfs_db, so move them all to a common location rather than
    spreading them all over the place. They are verifying the on-disk
    format, so while xfs_format.h might be a good place, it is not part
    of the on disk format.
    
    Hence we need to create a new header file that we centralise these
    related definitions. Start by moving the bffer operations
    structures, and then also move all the other definitions that have
    crept into xfs_log_format.h and xfs_format.h as there was no other
    shared header file to put them in.
    
    Signed-off-by: Dave Chinner <dchinner@redhat.com>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Ben Myers <bpm@sgi.com>

-----------------------------------------------------------------------

Summary of changes:
 fs/xfs/Makefile                               |    7 +-
 fs/xfs/xfs_acl.c                              |    8 +-
 fs/xfs/xfs_ag.h                               |    4 -
 fs/xfs/xfs_alloc.c                            |   14 +-
 fs/xfs/xfs_alloc.h                            |    3 -
 fs/xfs/xfs_alloc_btree.c                      |   13 +-
 fs/xfs/xfs_alloc_btree.h                      |   35 -
 fs/xfs/xfs_aops.c                             |   11 +-
 fs/xfs/xfs_attr.c                             |   12 +-
 fs/xfs/xfs_attr_inactive.c                    |   16 +-
 fs/xfs/xfs_attr_leaf.c                        |   21 +-
 fs/xfs/xfs_attr_leaf.h                        |  232 ----
 fs/xfs/xfs_attr_list.c                        |   19 +-
 fs/xfs/xfs_attr_remote.c                      |   13 +-
 fs/xfs/xfs_attr_remote.h                      |   29 -
 fs/xfs/xfs_bit.c                              |    5 +-
 fs/xfs/xfs_bmap.c                             |   20 +-
 fs/xfs/xfs_bmap_btree.c                       |   12 +-
 fs/xfs/xfs_bmap_btree.h                       |  105 --
 fs/xfs/xfs_bmap_util.c                        |   16 +-
 fs/xfs/xfs_btree.c                            |   12 +-
 fs/xfs/xfs_btree.h                            |   79 +-
 fs/xfs/xfs_buf.c                              |    5 +-
 fs/xfs/xfs_buf_item.c                         |    7 +-
 fs/xfs/xfs_buf_item.h                         |    4 -
 fs/xfs/xfs_da_btree.c                         |   12 +-
 fs/xfs/xfs_da_btree.h                         |  142 --
 fs/xfs/{xfs_dir2_format.h => xfs_da_format.h} |  404 +++++-
 fs/xfs/xfs_dir2.c                             |   13 +-
 fs/xfs/xfs_dir2_block.c                       |   12 +-
 fs/xfs/xfs_dir2_data.c                        |   11 +-
 fs/xfs/xfs_dir2_leaf.c                        |   12 +-
 fs/xfs/xfs_dir2_node.c                        |   11 +-
 fs/xfs/xfs_dir2_readdir.c                     |   12 +-
 fs/xfs/xfs_dir2_sf.c                          |   12 +-
 fs/xfs/xfs_discard.c                          |   11 +-
 fs/xfs/xfs_dquot.c                            |  133 +-
 fs/xfs/xfs_dquot.h                            |    2 -
 fs/xfs/xfs_dquot_buf.c                        |  287 ++++
 fs/xfs/xfs_dquot_item.c                       |   14 +-
 fs/xfs/xfs_error.c                            |    9 +-
 fs/xfs/xfs_export.c                           |   12 +-
 fs/xfs/xfs_extent_busy.c                      |   11 +-
 fs/xfs/xfs_extent_busy.h                      |    4 +
 fs/xfs/xfs_extfree_item.c                     |    8 +-
 fs/xfs/xfs_file.c                             |   16 +-
 fs/xfs/xfs_filestream.c                       |   12 +-
 fs/xfs/xfs_format.h                           |  263 +++-
 fs/xfs/xfs_fsops.c                            |   19 +-
 fs/xfs/xfs_ialloc.c                           |   14 +-
 fs/xfs/xfs_ialloc.h                           |    5 +-
 fs/xfs/xfs_ialloc_btree.c                     |   12 +-
 fs/xfs/xfs_ialloc_btree.h                     |   51 -
 fs/xfs/xfs_icache.c                           |   13 +-
 fs/xfs/xfs_icreate_item.c                     |    7 +-
 fs/xfs/xfs_inode.c                            |   23 +-
 fs/xfs/xfs_inode.h                            |    1 -
 fs/xfs/xfs_inode_buf.c                        |   10 +-
 fs/xfs/xfs_inode_buf.h                        |    3 -
 fs/xfs/xfs_inode_fork.c                       |   22 +-
 fs/xfs/xfs_inode_fork.h                       |    1 +
 fs/xfs/xfs_inode_item.c                       |   12 +-
 fs/xfs/xfs_ioctl.c                            |   13 +-
 fs/xfs/xfs_ioctl32.c                          |    7 +-
 fs/xfs/xfs_iomap.c                            |   20 +-
 fs/xfs/xfs_iops.c                             |   20 +-
 fs/xfs/xfs_itable.c                           |   15 +-
 fs/xfs/xfs_log.c                              |   16 +-
 fs/xfs/xfs_log.h                              |   10 +-
 fs/xfs/xfs_log_cil.c                          |   12 +-
 fs/xfs/xfs_log_format.h                       |  177 ---
 fs/xfs/xfs_log_priv.h                         |    7 +-
 fs/xfs/xfs_log_recover.c                      |  165 +--
 fs/xfs/xfs_log_rlimit.c                       |    9 +-
 fs/xfs/xfs_message.c                          |    5 +-
 fs/xfs/xfs_mount.c                            |   21 +-
 fs/xfs/xfs_qm.c                               |   39 +-
 fs/xfs/xfs_qm.h                               |    2 -
 fs/xfs/xfs_qm_bhv.c                           |   12 +-
 fs/xfs/xfs_qm_syscalls.c                      |   16 +-
 fs/xfs/xfs_quota.h                            |    4 -
 fs/xfs/xfs_quota_defs.h                       |    4 +
 fs/xfs/xfs_quotaops.c                         |    5 +-
 fs/xfs/xfs_rtalloc.c                          | 1848 ++++++-------------------
 fs/xfs/xfs_rtalloc.h                          |   24 +
 fs/xfs/xfs_rtbitmap.c                         |  973 +++++++++++++
 fs/xfs/xfs_sb.c                               |   23 +-
 fs/xfs/xfs_sb.h                               |    3 -
 fs/xfs/xfs_shared.h                           |  244 ++++
 fs/xfs/xfs_super.c                            |   25 +-
 fs/xfs/xfs_symlink.c                          |   16 +-
 fs/xfs/xfs_symlink_remote.c                   |    6 +-
 fs/xfs/xfs_trace.c                            |   16 +-
 fs/xfs/xfs_trans.c                            |   23 +-
 fs/xfs/xfs_trans.h                            |   20 +-
 fs/xfs/xfs_trans_ail.c                        |    7 +-
 fs/xfs/xfs_trans_buf.c                        |   12 +-
 fs/xfs/xfs_trans_dquot.c                      |   15 +-
 fs/xfs/xfs_trans_extfree.c                    |    7 +-
 fs/xfs/xfs_trans_inode.c                      |   13 +-
 fs/xfs/xfs_trans_priv.h                       |    1 -
 fs/xfs/xfs_trans_resv.c                       |   18 +-
 fs/xfs/xfs_xattr.c                            |    8 +-
 103 files changed, 3099 insertions(+), 3100 deletions(-)
 rename fs/xfs/{xfs_dir2_format.h => xfs_da_format.h} (65%)
 create mode 100644 fs/xfs/xfs_dquot_buf.c
 create mode 100644 fs/xfs/xfs_rtbitmap.c
 create mode 100644 fs/xfs/xfs_shared.h


hooks/post-receive
-- 
XFS development tree

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
