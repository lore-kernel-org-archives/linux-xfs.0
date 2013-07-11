Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4614D7F62
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 00:00:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D16E7AC002
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 22:00:54 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id HoHFAxD8R6KwliVZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 10 Jul 2013 22:00:53 -0700 (PDT)
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 10 Jul 2013 23:00:53 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 138671FF001B
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 22:55:31 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r6B50nqf367790 for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 23:00:49 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r6B50n2X004178
	for <xfs@oss.sgi.com>; Wed, 10 Jul 2013 23:00:49 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v11 0/4] Allow pquota and gquota to be used together
Date: Thu, 11 Jul 2013 00:00:39 -0500
Message-Id: <1373518843-1492-1-git-send-email-sekharan@us.ibm.com>
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Hello All,

This is the version 11 of the changes to allow pquota and gquota to be used
together.

Patchset applies cleanly on top of 42c49d7f249c2487f36d3314753d5d8ebcee8249
in xfs git tree.

---

Chandra Seetharaman (4):
  xfs: Add pquota fields where gquota is used.
  xfs: Start using pquotaino from the superblock.
  xfs: Add proper versioning support to fs_quota_stat
  xfs: Use new qs_pquota field in fs_quota_stat for Q_XGETQSTAT

 fs/gfs2/quota.c                |    3 -
 fs/quota/quota.c               |   67 ++++++++++-
 fs/xfs/xfs_dquot.c             |   15 ++-
 fs/xfs/xfs_dquot.h             |    7 +-
 fs/xfs/xfs_icache.c            |    1 +
 fs/xfs/xfs_inode.h             |    1 +
 fs/xfs/xfs_ioctl.c             |   14 +-
 fs/xfs/xfs_iops.c              |    4 +-
 fs/xfs/xfs_mount.c             |   62 +++++++++--
 fs/xfs/xfs_qm.c                |  259 ++++++++++++++++++++++++++++------------
 fs/xfs/xfs_qm.h                |   20 ++-
 fs/xfs/xfs_qm_bhv.c            |   10 +-
 fs/xfs/xfs_qm_syscalls.c       |   70 +++++++++---
 fs/xfs/xfs_quota.h             |   32 +++--
 fs/xfs/xfs_sb.h                |    9 ++-
 fs/xfs/xfs_super.c             |   19 ++--
 fs/xfs/xfs_symlink.c           |   10 +-
 fs/xfs/xfs_trans_dquot.c       |   26 ++++-
 fs/xfs/xfs_vnodeops.c          |   13 ++-
 include/uapi/linux/dqblk_xfs.h |   59 ++++++++-
 20 files changed, 528 insertions(+), 173 deletions(-)
----------

Changes from version 10 to verion 11:
 - Few of the patches have been merged.
 - Localized all the logic to handle simultaneous use
   of XFS_SB_GQUOTINO and XFS_SB_PQUOTINO to xfs_sb_quota_from_disk()
   and xfs_sb_from_disk as per Dave's suggestion.
 - moved setting sb_pquotino to xfs_sb_quota_frp,_disk() as per
   Dave's suggestion.
 - Added new Q_XGETQSTATV command to handle the new sematics of
   quota_stata as per Jan's comment.
 - Fixed few nits as per Ben's comment

Version 10 can be found at:
http://oss.sgi.com/archives/xfs/2013-06/msg00902.html

Changes from version 9 to version 10:
 - Split prep into 6 patches as per Ben and Dave's suggestion
 - Added xfs_sb_quota_from_disk() as per Dave's suggestion
 - Made u/g/p ordering consistent
 - Fixed fields in fs_quota_stat as per Dave's suggestion
 - Moved few ASSERTs to be inside error check as per Ben's suggestion
 - Few cosmetic changes

Version 9 can be found at:
http://oss.sgi.com/archives/xfs/2013-06/msg00770.html

Changes from verion 8 to version 9:
 - Made all the changes suggested by Dave
 - Rearranged code to make the functional changes to
   not be cluttered.

Version 8 can be found at:
http://oss.sgi.com/archives/xfs/2013-05/msg00296.html

Changes from version 7 to version 8:
 - Rebased to the current code.
 - Modified code to use the new pquotino field in version 5
   of the superblock.

Version 7 can be found at:
http://oss.sgi.com/archives/xfs/2013-03/msg00671.html

Changes from version 6 to version 7:
 - Made all the changes suggested by Dave Chinner
 - Added padding to fs_quota_stat, which made the new
   data structure field ordering different from the old data
   structure field ordering. So, copied the old version
   to be _v1 version and used that if old version of data
   structure was provided from user space.

Version 6 can be found at:
http://oss.sgi.com/archives/xfs/2012-07/msg00286.html

Changes from version 5 to version 6:
- Use radix tree instead of hash table

Version 5 can be found at:
http://oss.sgi.com/archives/xfs/2012-03/msg00310.html

Changes fron version 4 to version 5:
rebase with the current tree one simple change.

Version 4 can be found at
http://oss.sgi.com/archives/xfs/2012-02/msg00528.html

Changes from version 3 to version 4:
- Remove save_flags with storing the value (in to superblock) 
  based on field type info
- fix checkpatch.pl warnings and errors

Version 3 of the posting can be found at
http://oss.sgi.com/archives/xfs/2012-01/msg00309.html

Changes from version 2 to version 3:
 - hash table for pquota is added.
 - changes to apply cleanly with the latest tree

version 2 of the posting can be found at
http://oss.sgi.com/archives/xfs/2011-10/msg00470.html

Changes from version 1 to version 2:

 - Created a new prep patch to accomodate some generic changes that ease
   the later patches.
 - Created a new patch to add a new field qs_pquota to fs_quota_stat
   with appropriate versioning changes
 - Changed the logic to allow XFS_OQUOTA.* flags to be allowed only in
   the older versions.
 - Changed couple of places where PQUOTA checking was on the else if
   construct so as to allow both GQUOTA and PQUOTA in those places.
 - Fixed comments in xfs_quota.h to reflect the current changes.
 - Changed the name of the macro XFS_SB_VERSION2_SEPER_PQUOTA to 
   XFS_SB_VERSION2_NO_OQUOTA
 - got rid of the macros XFS_MOUNT_QUOTA_SET1 and XFS_MOUNT_QUOTA_SET2
 - added a new inline function xfs_inode_dquot(ip, type) to simplify
   the error path in xfs_qm_dqget()
 - got rid of the macro XFS_IS_THIS_QUOTA_OFF
 - added comment to explain why sb_qflags is saved and restored in 
   xfs_sb_to_disk()

version 1 of the posting can be found at
http://oss.sgi.com/archives/xfs/2011-10/msg00341.html

Thanks & Regards,

chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
