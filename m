Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8BMCoA2162592 for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 17:12:50 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id iA6iJFaCfVmp90b7
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 11 Sep 2012 15:13:54 -0700 (PDT)
Received: by pbbro2 with SMTP id ro2so1775487pbb.26
	for <xfs@oss.sgi.com>; Tue, 11 Sep 2012 15:13:53 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH V2 0/3] Print when ENOSPC due to lack of inodes in non-inode64
	mount.
Date: Wed, 12 Sep 2012 03:43:21 +0530
Message-Id: <cover.1347396641.git.rprabhu@wnohang.net>
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
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

Currently, when there are no free inodes left / free space to allocate them (usually
without inode64), there is no indication anywhere of this case, making it harder
to diagnose this case. 

Hence, this series prints the causes/reasons to kernel log in a ratelimited
manner, when such a situation arises.

----- 
Version 1: Initially sent with pr_err_once to print the error only once.

Version 2: Added ratelimited functions to xfs_message.h instead of printing once
with pr_err_once on suggestion of Dave Chinner.

Raghavendra D Prabhu (3):
  Add ratelimited printk for different alert levels
  XFS: Print error when xfs_ialloc_ag_select fails to find continuous
    free space.
  XFS: Print error when unable to allocate inodes or out of free
    inodes.


 fs/xfs/xfs_ialloc.c  | 24 +++++++++++++++++++-----
 fs/xfs/xfs_message.h | 28 ++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 5 deletions(-)

-- 
1.7.12

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
