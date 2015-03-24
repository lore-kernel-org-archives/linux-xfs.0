Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3C8217F50
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 05:51:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2793E8F8071
	for <xfs@oss.sgi.com>; Tue, 24 Mar 2015 03:51:21 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	WOpIfcLR8HGPTa3h for <xfs@oss.sgi.com>;
	Tue, 24 Mar 2015 03:51:19 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/8 v2] xfs: DAX support
Date: Tue, 24 Mar 2015 21:50:58 +1100
Message-Id: <1427194266-2885-1-git-send-email-david@fromorbit.com>
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
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz

Hi folks,

This is an updated version of the XFS DAX support patchset. It was
first posted here:

http://oss.sgi.com/pipermail/xfs/2015-March/040804.html

This version of the patchset sits on top of the current for-next
branch of the XFS dev tree.

The series has grown slightly as a result of the first round of
reviews. The initial patch is a new patch that reworks the new XFS
mmap lock to nest correctly inside freeze notifications, as noticed
and requested by Jan Kara.

The second patch has been updated to move unwritten extent
conversion back into do_dax_fault so the completion function does
not need ot be passed around any further.

The third patch is also a new patch, derived from Willy's patch to
allow ext4 to correctly nest locking and freeze operations during
page faults. I gutted that patch down to the bare infrastructure
that was necessary for XFS, and havent included any of the ext4
changes because the unwritten extent conversion problems are dealt
with by the previous patch.

The rest of the patch set is updating the XFS support to use the new
infrastructure and changed mmap locking order via __dax_fault. Most
of the changes fall in the file operations patch (patch 5). 

The main changes to patch 5 are that it no longer has separate
operations structures. I validated that splice has paths that don't
require page cache manipulations and switched XFS to use them (as
pointed out by Boaz) and that solved one of the duplicate operations
structures. All of the .fault and .page_mkwrite code were also made
common and that got rid of all the other ifdef CONFIG_DAX hackery
left in the code.

Overall, it's a much cleaner set of changes than in V1. it passes
xfstests without any significant regressions (the only problems are
to do with extent layouts differing from expected patterns) so I'm
happy that it won't immediately go feral and start eating babies for
lunch.

Comments, thoughts and flames are welcome, especially for the DAX
infrastructure changes.

-Dave.

Diffstat:

 fs/dax.c               |  30 ++++++++---
 fs/ext2/file.c         |   4 +-
 fs/ext4/file.c         |  16 +++++-
 fs/ext4/inode.c        |  21 +++-----
 fs/xfs/xfs_aops.c      | 108 +++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_aops.h      |   7 ++-
 fs/xfs/xfs_bmap_util.c |  23 +++++++--
 fs/xfs/xfs_file.c      | 143 +++++++++++++++++++++++++++++++--------------------
 fs/xfs/xfs_iops.c      |  30 ++++++-----
 fs/xfs/xfs_mount.h     |   2 +
 fs/xfs/xfs_super.c     |  25 ++++++++-
 include/linux/fs.h     |   9 +++-
 12 files changed, 303 insertions(+), 115 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
