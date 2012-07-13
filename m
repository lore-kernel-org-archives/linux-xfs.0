Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6D8a712130582 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 03:36:07 -0500
Message-ID: <4FFFDDB0.8020200@oracle.com>
Date: Fri, 13 Jul 2012 16:34:56 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH  0/4] xfs: rebase patch set for allow pquota and gquota to
	be used together
Reply-To: jeff.liu@oracle.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Ben Myers <bpm@sgi.com>, Mark Tinguely <tinguely@sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>

Hello,

Chandra has worked on the feature for allowing pquota and gquota to be used together before, and the v5 from him
is closed to complete.  However, Chandra is not ping-able for a few months, I'd like to continue his job to re-base
his patch set to the updated 3.5-rcX after contacting Christoph and Dave off-line.

Hi Chandra,
If you turn back to deal with that, I would release it for you. :)

So here is the updated patch set(based on 3.5-rc4, will update it to 3.5-rc6), except a few comments fix, I mainly have the following changes.

Changes from v5 to v6:
- Using Radix-tree for project quota because we have already replaced the old hash table with radix-tree for dquots operations since 3.4.

- Attach pquota ptr to uquota->q_pdquot as a hint at xfs_qm_dqattach_one(),  the 2nd patch of v5 attaching the pquota ptr to udquot->q_gdquot.

- Add xfs_qm_dqrele(pdqp) at xfs_ioctl_setattr(), the 2nd patch for v5 does not do that.

- Revise xfs_qm_dqattach_grouphint() to attach gpdq to uddq->q_pdquot. The 2nd patch of v5 attaching it to udq->q_gquot.
  According to the naming of xfs_qm_dqattach_grouphint(), it implicit that we should call it to attach group hint only, however, consider
  project quota here, IMHO, we should attach the pquota ptr as well, maybe it's better to s/xfs_qm_dqattach_grouphint()/xfs_qm_dqattach_pghint()/ if
  my understood is correct.

- xfs_qm_scall_trunc_qfiles(), the 3rd patch for v5 using error2 as the return value for both gquota file and pquota file truncation.
  In this case, if both operation all performed failed, it will only return the first error. IMHO, that will confuse end user maybe.
  However, the original code logic is same to that, it does not stop immediately and return error when the first user quota file
  truncated(if needed) failed.
  I'm not sure the reason, so I changed the logic to stop and return instead of proceeding to truncate the next qfile, please correct me.

- Adjust XFS_PQUOTA_CHKD to 0x0800 for quota checking against the project quota.
  This flag is introduced by the 1st patch for v5, originally, 0x0400 was used for it.  However, it has already been reserved by XFS_GQUOTA_ACTIVE.
  So any function call XFS_IS_GQUOTA_ON(mp) will be true even if gquota does not enabled on mount, it will cause many cases failed with kernel crashes
  regarding quota tests in xfstests.
  This is the major issue I am facing for the old patch set rebasing, it spent me a few days to figure out a better way.
  Currently, chose skipping 0x0400 but still looks ugly I think. or else, we need to check XFS_PQUOTA_CHKD is not enabled combine with XFS_IS_GQUOTA_ON(),
  however, it need to spread that over other routines.
  So I'd like to post the current patch set for the review and ask advice in this point.

Note that, run checkpatch.pl against current patch set will show warning for "quoted string split across lines" for xfs_notice(), this will be solved
after other issues were settle down.


Old patch posts info were copied as following.

Version 5 from Chandra can be found at:
http://oss.sgi.com/archives/xfs/2012-03/msg00310.html

Version 4 can be found at:
http://oss.sgi.com/archives/xfs/2012-02/msg00528.html

Version 3 of the posting can be found at
http://oss.sgi.com/archives/xfs/2012-01/msg00309.html

Changes from version 3 to version 4:
- Remove save_flags with storing the value (in to superblock) 
  based on field type info
- fix checkpatch.pl warnings and errors

version 2 of the posting can be found at
http://marc.info/?l=linux-xfs&m=131966420607401&w=2

Changes from version 2 to version 3:
 - hash table for pquota is added.
 - changes to apply cleanly with the latest tree

version 1 of the posting can be found at
http://article.gmane.org/gmane.comp.file-systems.xfs.general/41284

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


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
