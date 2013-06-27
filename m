Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A17BB7F3F
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 17:25:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 81C488F804C
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 15:25:21 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id y7Oqy45LdI0nJAFy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 15:25:20 -0700 (PDT)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 27 Jun 2013 16:25:19 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 1B3773E40030
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:24:57 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5RMPGAc310928 for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:16 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r5RMPFWf017870
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:15 -0600
Received: from chandra-dt.austin.ibm.com (chandra-dt.austin.ibm.com
	[9.41.106.170])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r5RMPEGI017808 for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 16:25:15 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v10 00/11] Allow pquota and gquota to be used together
Date: Thu, 27 Jun 2013 17:25:03 -0500
Message-Id: <1372371914-11370-1-git-send-email-sekharan@us.ibm.com>
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

Hello All,

This is the version 10 of the changes to allow pquota and gquota to be used
together.

Patchset applies cleanly on top of 80a4049813a2ae0977d8e5db78e711c7f21c420b
in xfs git tree.

Ran xfstests against it with DEBUG and do not see any regressions.
---

Chandra Seetharaman (11):
  xfs: Define a new function xfs_is_quota_inode()
  xfs: Replace macro XFS_DQUOT_TREE with a function
  xfs: Replace macro XFS_DQ_TO_QIP with a function
  xfs: Code cleanup and removal of some typedef usage
  xfs: Do some whitespace cleanup in the data structure xfs_quotainfo
  xfs: Change xfs_dquot_acct to be a 2-dimensional array
  xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
  xfs: Add pquota fields where gquota is used.
  xfs: Start using pquotaino from the superblock.
  xfs: Add proper versioning support to fs_quota_stat
  xfs: Use new qs_pquota field in fs_quota_stat for Q_XGETQSTAT

 fs/gfs2/quota.c                |    3 -
 fs/quota/quota.c               |   49 +++++-
 fs/xfs/xfs_dquot.c             |   31 ++-
 fs/xfs/xfs_dquot.h             |   11 +-
 fs/xfs/xfs_fsops.c             |    3 +-
 fs/xfs/xfs_icache.c            |    4 +-
 fs/xfs/xfs_inode.h             |    1 +
 fs/xfs/xfs_ioctl.c             |   14 +-
 fs/xfs/xfs_iops.c              |    4 +-
 fs/xfs/xfs_itable.c            |    2 +-
 fs/xfs/xfs_mount.c             |   83 ++++++++
 fs/xfs/xfs_qm.c                |  409 ++++++++++++++++++++++++++--------------
 fs/xfs/xfs_qm.h                |  143 +++++++++-----
 fs/xfs/xfs_qm_bhv.c            |    2 +-
 fs/xfs/xfs_qm_syscalls.c       |  126 ++++++++----
 fs/xfs/xfs_quota.h             |   79 +++++----
 fs/xfs/xfs_quotaops.c          |    6 +-
 fs/xfs/xfs_sb.h                |   20 ++
 fs/xfs/xfs_super.c             |   35 ++--
 fs/xfs/xfs_symlink.c           |   13 +-
 fs/xfs/xfs_trans_dquot.c       |  113 ++++++------
 fs/xfs/xfs_vnodeops.c          |   13 +-
 include/uapi/linux/dqblk_xfs.h |   54 +++++-
 23 files changed, 821 insertions(+), 397 deletions(-)

---

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
