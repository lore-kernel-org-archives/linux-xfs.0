Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CE5CA7F37
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 16:53:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BC5508F8052
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 14:53:00 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id JJqcttPi1KhR9FhA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Mar 2013 14:52:59 -0700 (PDT)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Thu, 21 Mar 2013 15:52:59 -0600
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com
	[9.17.195.226])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 8182419D8045
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 15:52:52 -0600 (MDT)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r2LLqt2F100960 for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 15:52:55 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r2LLqtOn023079
	for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 15:52:55 -0600
Received: from chandra-dt.ibm.com.austin.ibm.com
	(chandra-dt.ibm.com.austin.ibm.com [9.41.106.170])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	r2LLqte4023035 for <xfs@oss.sgi.com>; Thu, 21 Mar 2013 15:52:55 -0600
From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH v7 0/5] xfs: Allow pquota and gquota to be used together
Date: Thu, 21 Mar 2013 16:52:49 -0500
Message-Id: <1363902774-19292-1-git-send-email-sekharan@us.ibm.com>
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

This is the version 7 of the changes to allow pquota and gquota to be used
together.

Patchset applies cleanly on top of 56cea2d088811b8cf7d2893e29bcf369a912de69
in xfs git tree.

Ran latest xfstests against it.

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
---
Chandra Seetharaman (5):
  xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD
  xfs: Add pquota fields and use them at appropriate places
  xfs: Add pquotaino to on-disk super block
  xfs: Add proper versioning support to fs_quota_stat
  xfs: Use the new qs_pquota field in fs_quota_stat for Q_XGETQSTAT

 fs/gfs2/quota.c                |    3 -
 fs/quota/quota.c               |   40 ++++-
 fs/xfs/xfs_dquot.c             |   33 +++-
 fs/xfs/xfs_dquot.h             |   13 +-
 fs/xfs/xfs_icache.c            |    4 +-
 fs/xfs/xfs_inode.h             |    1 +
 fs/xfs/xfs_ioctl.c             |   14 +-
 fs/xfs/xfs_iops.c              |    4 +-
 fs/xfs/xfs_itable.c            |    3 +-
 fs/xfs/xfs_mount.c             |  103 +++++++++++
 fs/xfs/xfs_qm.c                |  379 ++++++++++++++++++++++++++--------------
 fs/xfs/xfs_qm.h                |   54 ++++--
 fs/xfs/xfs_qm_bhv.c            |    2 +-
 fs/xfs/xfs_qm_syscalls.c       |  125 +++++++++-----
 fs/xfs/xfs_quota.h             |   78 +++++----
 fs/xfs/xfs_quotaops.c          |    6 +-
 fs/xfs/xfs_sb.h                |   19 ++-
 fs/xfs/xfs_super.c             |   35 ++--
 fs/xfs/xfs_trans_dquot.c       |  102 ++++++-----
 fs/xfs/xfs_vnodeops.c          |   25 ++-
 include/uapi/linux/dqblk_xfs.h |   37 ++++-
 21 files changed, 744 insertions(+), 336 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
