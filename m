Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8KDWItr088882 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 08:32:18 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8BH3K5FyYnIRY43R for
	<xfs@oss.sgi.com>; Thu, 20 Sep 2012 06:33:30 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8KDXUt4020074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 09:33:30 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-73.phx2.redhat.com
	[10.3.113.73])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8KDXRt2019074
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 09:33:29 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/6 V4] inode32/inode64 allocation changes 
Date: Thu, 20 Sep 2012 10:32:35 -0300
Message-Id: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
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

This patch set adds inode64 as the default allocation mode, but also includes 2
patches to remove duplicated code and another one to make inode32 able to be
remounted.

NOTE: This patch has as dependency "Make inode64 a remountable option" patch.

V4 properly set pagf_metadata in patch 5

V3 has a better factoring of each patch goal, including other dchinner's
suggestions in V2. 
Also it contains a fix in how m_agirotor reset is made (patch 01) that I've
found while doing tests with these patches.

Carlos Maiolino (6):
  xfs: Fix m_agirotor reset during AG selection
  xfs: make inode64 as the default allocation mode
  xfs: reduce code duplication handling inode32/64 options
  xfs: Fix mp->m_maxagi update during inode64 remount
  xfs: add inode64->inode32 transition into xfs_set_inode32()
  xfs: Make inode32 a remountable option

 fs/xfs/xfs_ialloc.c |   2 +-
 fs/xfs/xfs_mount.c  |  43 +++----------------
 fs/xfs/xfs_super.c  | 117 ++++++++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_super.h  |   2 +
 4 files changed, 99 insertions(+), 65 deletions(-)

-- 
1.7.11.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
