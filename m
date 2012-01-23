Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0NHWlxc122948 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 11:32:47 -0600
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153]) by
	cuda.sgi.com with ESMTP id gWf1hOD9J0cZz6G7 for
	<xfs@oss.sgi.com>; Mon, 23 Jan 2012 09:32:46 -0800 (PST)
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 23 Jan 2012 10:32:44 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id B84FA1FF0077
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:32:07 -0700 (MST)
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q0NHW0rN103082 for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:32:00 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id q0NHVxCf011820
	for <xfs@oss.sgi.com>; Mon, 23 Jan 2012 10:31:59 -0700
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Mon, 23 Jan 2012 11:31:59 -0600
Message-Id: <20120123173158.31640.30333.sendpatchset@chandra-lucid.austin.ibm.com>
Subject: [RFC v3 PATCH 0/4] xfs: Allow pquota and gquota to be used together
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Chandra Seetharaman <sekharan@us.ibm.com>

Hello All,

This is the version 2 of the changes to allow pquota and gquota to be used
together.

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

Thanks & Regards,

chandra

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
