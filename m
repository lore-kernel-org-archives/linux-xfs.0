Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 537037F53
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 22:17:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4EEEAC002
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 20:17:19 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id RNBLVu7TL1fYlHkS (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 20:17:15 -0700 (PDT)
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zwu.kernel@gmail.com>;
	Mon, 12 Aug 2013 04:17:14 +0100
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id B60EF38C8027
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 23:17:10 -0400 (EDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r7C3HBKl179824 for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 23:17:12 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id r7C3HBMh013293
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 21:17:11 -0600
From: zwu.kernel@gmail.com
Subject: [PATCH 00/12] xfs: another chunk of comment fixes
Date: Mon, 12 Aug 2013 11:14:51 +0800
Message-Id: <1376277303-29455-1-git-send-email-zwu.kernel@gmail.com>
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
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Submit another chunk of xfs comment fixes.

Zhi Yong Wu (12):
  xfs: fix the comment of xfs_bmap_count_tree()
  xfs: fix the comment of xfs_bmap_validate_ret()
  xfs: fix the comment of xfs_bmap_last_before()
  xfs: fix the comment of xfs_bmap_punch_delalloc_range()
  xfs: fix the comment of xfs_setsize_buftarg_early()
  xfs: fix the comment of xfs_extent_busy_update_extent()
  xfs: fix the comment of xfs_ialloc_ag_select()
  xfs: fix the comment of xfs_ifree_cluster()
  xfs: fix the comment of xfs_log_unmount_write()
  xfs: fix the comment of xlog_recover_do_dquot_buffer()
  xfs: fix the comment of xfs_sb_quiet_read_verify()
  xfs: fix the comment of xfs_mountfs()

 fs/xfs/xfs_bmap.c        | 10 +++++-----
 fs/xfs/xfs_buf.c         |  2 +-
 fs/xfs/xfs_extent_busy.c |  2 +-
 fs/xfs/xfs_ialloc.c      |  2 +-
 fs/xfs/xfs_inode.c       |  2 +-
 fs/xfs/xfs_log.c         |  2 +-
 fs/xfs/xfs_log_recover.c |  2 +-
 fs/xfs/xfs_mount.c       |  4 ++--
 8 files changed, 13 insertions(+), 13 deletions(-)

-- 
1.7.11.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
