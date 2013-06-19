Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1166429E13
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 23:51:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C33A304039
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:51:18 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VebsC1wu543zDh39 for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 21:51:17 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UpAMW-0002xx-4W
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:51:16 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UpAMQ-0008VC-WD
	for xfs@oss.sgi.com; Wed, 19 Jun 2013 14:51:11 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/60] xfs: patch queue for 3.11
Date: Wed, 19 Jun 2013 14:50:08 +1000
Message-Id: <1371617468-32559-1-git-send-email-david@fromorbit.com>
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

Hi Folks,

This is my patch queue for 3.11 as it stands right now.

The first 27 patches have been posted previously, and I've addressed
these comments directly:

	- non-debug static function prblems (Brian)
	- agblock_t in xfs-ialloc.c (Brian)
	- xfs-dir2_format.h changes reverted, now included before
	  xfs_dir2.h (Christoph)
	- rename xfs_aops_punch_delalloc_range() (Christoph)

The next set of patches then build on this and implement the first
part of where the discussions went - the removal of __KERNEL__ from
all the XFS code. This generally takes the form of:

	- split on-disk format definitions into a separate header
	- include the header in the original it came from
	- share the new header file with userspace
	- repeat until all definitions are split out and the only
	  thing is left in the orignal header is #includes and
	  ifdef __KERNEL__ sections.
	- remove the ifdef __KERNEL__, as this header file is no
	  longer shared with userspace.

The same process is done for the .c files, resulting in .c files
that contain only kernel code or only code shared with libxfs in
userspace.

This has resulted in some less than optimal code locality, mostly to
do with xfs_inode_ops.c. The code is kernel only, and it's in that
file because it all related to inode operatianos. However, some are
internal core operations, some are interfaces that the VFS inode
operations just wrap around, and some are related more closely to
inode allocation than anything else. Hence more thought and effort
needs to be put into factoring and merging this kernel code back
into the most appropriate places, and that is work for a future
release.

The final part of the patchset is a rebase of Jeff Liu's log size
validation patch set. This calculates the minimum size of the log
that we should have to guarantee that we don't end up with
transactions being too large for the log. This is an issue because
mkfs currently doesn't take into account the log stripe unit padding
that is necessary when calculating the log size, and this can drive
the size of transaction over the maximum size the log can safely
support.

This code will warn on existing filesystems at mount time if the log
is smaller than the minimum safe size, and for CRC enabled
filesystems it will abort immediately as it is expected that you are
using a mkfs binary that has this problem fixed.

Overall, there is a lot of code movement in the patch set. The tail
of the diffstat looks like:

 113 files changed, 14734 insertions(+), 13221 deletions(-)
 create mode 100644 fs/xfs/xfs_attr_inactive.c
 create mode 100644 fs/xfs/xfs_attr_list.c
 create mode 100644 fs/xfs/xfs_bmap_util.c
 create mode 100644 fs/xfs/xfs_bmap_util.h
 create mode 100644 fs/xfs/xfs_buf_item_format.h
 delete mode 100644 fs/xfs/xfs_dfrag.c
 delete mode 100644 fs/xfs/xfs_dfrag.h
 create mode 100644 fs/xfs/xfs_dir2_readdir.c
 create mode 100644 fs/xfs/xfs_dquot_format.h
 create mode 100644 fs/xfs/xfs_extent_ops.c
 rename fs/xfs/{xfs_utils.h => xfs_extent_ops.h} (55%)
 create mode 100644 fs/xfs/xfs_extfree_item_format.h
 create mode 100644 fs/xfs/xfs_icreate_item.c
 create mode 100644 fs/xfs/xfs_icreate_item.h
 create mode 100644 fs/xfs/xfs_icreate_item_format.h
 create mode 100644 fs/xfs/xfs_inode_buf.c
 create mode 100644 fs/xfs/xfs_inode_buf.h
 create mode 100644 fs/xfs/xfs_inode_fork.c
 create mode 100644 fs/xfs/xfs_inode_fork.h
 create mode 100644 fs/xfs/xfs_inode_item_format.h
 create mode 100644 fs/xfs/xfs_inode_ops.c
 create mode 100644 fs/xfs/xfs_inode_ops.h
 create mode 100644 fs/xfs/xfs_log_format.h
 create mode 100644 fs/xfs/xfs_log_rlimit.c
 create mode 100644 fs/xfs/xfs_quota_defs.h
 delete mode 100644 fs/xfs/xfs_rename.c
 create mode 100644 fs/xfs/xfs_rtalloc_defs.h
 create mode 100644 fs/xfs/xfs_sb.c
 create mode 100644 fs/xfs/xfs_symlink_remote.c
 create mode 100644 fs/xfs/xfs_symlink_remote.h
 create mode 100644 fs/xfs/xfs_trans_format.h
 create mode 100644 fs/xfs/xfs_trans_resv.c
 create mode 100644 fs/xfs/xfs_trans_resv.h
 delete mode 100644 fs/xfs/xfs_utils.c
 delete mode 100644 fs/xfs/xfs_vnodeops.c
 delete mode 100644 fs/xfs/xfs_vnodeops.h

Which should give you an idea of the number of new files that have
been added to split out shared userspace code, and hence an idea
of how much ofthe diffstat is just moving stuff around. FWIW, this
kills about 2000 lines of __KERNEL__ code in header files that is
currently exported to userspace. You can see why I'm thinking a
kernel fs/xfs/libxfs subdir might be a good idea. :)

Comments, flames, etc all welcome.

Cheers,

Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
