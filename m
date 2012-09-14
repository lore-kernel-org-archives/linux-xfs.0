Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8EGmfwc147395 for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 11:48:41 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SO7PWKaHDVdFGWv5 for
	<xfs@oss.sgi.com>; Fri, 14 Sep 2012 09:49:48 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8EGnlCa025680
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 12:49:47 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-109.phx2.redhat.com
	[10.3.113.109])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8EGnk0T019005
	for <xfs@oss.sgi.com>; Fri, 14 Sep 2012 12:49:47 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/4] inode32/inode64 allocation changes 
Date: Fri, 14 Sep 2012 13:49:37 -0300
Message-Id: <1347641381-30050-1-git-send-email-cmaiolino@redhat.com>
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


Carlos Maiolino (4):
  xfs: make inode64 as the default allocation mode
  xfs: add xfs_set_inode32()
  xfs: set xfs_initialize_perag() to use xfs_set_inode32/64()
  xfs: Make inode32 a remountable option

 fs/xfs/xfs_mount.c |  43 +++----------------
 fs/xfs/xfs_super.c | 124 +++++++++++++++++++++++++++++++++++++++++------------
 fs/xfs/xfs_super.h |   2 +
 3 files changed, 104 insertions(+), 65 deletions(-)

-- 
1.7.11.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
