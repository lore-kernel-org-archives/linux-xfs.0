Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q53BCwGv098329 for <xfs@oss.sgi.com>; Sun, 3 Jun 2012 06:12:58 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id xgIn2QVi49tjWQvC
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 03 Jun 2012 04:12:57 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so6066284pbb.26
	for <xfs@oss.sgi.com>; Sun, 03 Jun 2012 04:12:57 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH 0/3] Print when ENOSPC due to lack of inodes.
Date: Sun,  3 Jun 2012 16:42:46 +0530
Message-Id: <cover.1338721614.git.rprabhu@wnohang.net>
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
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, raghu.prabhu13@gmail.com

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

Currently, when there are no free inodes left / free space to allocate them (usually
without inode64), there is no indication anywhere of this case, making it harder
to diagnose this case. 

Hence, this three-part patch series to print errors to kernel log with reasons,
when such a situation arises.

Raghavendra D Prabhu (3):
  XFS: Print error when xfs_ialloc_ag_select fails to find continuous
    free space.
  XFS: Print error when unable to allocate inodes.
  XFS: Print error when there are no free AGs.

 fs/xfs/xfs_ialloc.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

-- 
1.7.10.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
