Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8Q6ti9U168140 for <xfs@oss.sgi.com>; Wed, 26 Sep 2012 01:55:44 -0500
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
	[209.85.220.53]) by cuda.sgi.com with ESMTP id y1oPoSwA5hY0GeDn
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 25 Sep 2012 23:57:01 -0700 (PDT)
Received: by padbj3 with SMTP id bj3so305745pad.26
	for <xfs@oss.sgi.com>; Tue, 25 Sep 2012 23:57:01 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH v3 0/3] Print when ENOSPC due to lack of inodes.
Date: Wed, 26 Sep 2012 12:26:46 +0530
Message-Id: <cover.1348639531.git.rprabhu@wnohang.net>
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
Cc: bpm@sgi.com, elder@kernel.org, Raghavendra D Prabhu <rprabhu@wnohang.net>

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

Currently, when there are no free inodes left / free space to allocate them (usually
without inode64), there is no indication anywhere of this case, making it harder
to diagnose this case.

Hence, this series prints the causes/reasons to kernel log in a ratelimited
manner, when such a situation arises.

Regarding why it is printed at callee location instead at caller, it gives
greater granularity in expressing the precise reason and give more details, and
also some along the path are not ENOSPC (such in xfs_ialloc where ialloc_context is not NULL but
ino is) along with the fact that it (xfs_ialloc) is called at multiple sites, so to avoid duplication.

Version 1: Initial series.
Version 2: Added ratelimited printing to xfs_message and used that.
Version 3: Kept the logic intact in few places, fixed the column requirement. 

Raghavendra D Prabhu (3):
  xfs: Add ratelimited printk for different alert levels
  xfs: Print error when xfs_ialloc_ag_select fails to find continuous
    free space.
  xfs: Print error when unable to allocate inodes or out of free
    inodes.

 fs/xfs/xfs_ialloc.c  | 31 ++++++++++++++++++++++++++++---
 fs/xfs/xfs_linux.h   |  1 +
 fs/xfs/xfs_message.h | 26 ++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 3 deletions(-)

-- 
1.7.12.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
