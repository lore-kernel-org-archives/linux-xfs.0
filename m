Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8J6A4Vo158664 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 01:10:04 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EiWQ26mrCXAxGalt for
	<xfs@oss.sgi.com>; Tue, 18 Sep 2012 23:11:15 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8J6BEBi031124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 02:11:15 -0400
Received: from andromeda.usersys.redhat.com (vpn1-7-14.gru2.redhat.com
	[10.97.7.14])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8J6BDjV014802
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 02:11:14 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/6 V3] inode32/inode64 allocation changes 
Date: Wed, 19 Sep 2012 03:10:59 -0300
Message-Id: <1348035065-6934-1-git-send-email-cmaiolino@redhat.com>
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
