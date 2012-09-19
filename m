Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8J6AKoZ158729 for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 01:10:20 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VGcPML11SYrbrmDM for
	<xfs@oss.sgi.com>; Tue, 18 Sep 2012 23:11:31 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8J6BVKW009412
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 02:11:31 -0400
Received: from andromeda.usersys.redhat.com (vpn1-7-14.gru2.redhat.com
	[10.97.7.14])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8J6BDjZ014802
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2012 02:11:30 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 4/6] xfs: Fix mp->m_maxagi update during inode64 remount
Date: Wed, 19 Sep 2012 03:11:03 -0300
Message-Id: <1348035065-6934-5-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1348035065-6934-1-git-send-email-cmaiolino@redhat.com>
References: <1348035065-6934-1-git-send-email-cmaiolino@redhat.com>
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

With the changes made on xfs_set_inode64(), to make it behave as
xfs_set_inode32() (now leaving to the caller the responsibility to update
mp->m_maxagi), we use the return value of xfs_set_inode64() to update
mp->m_maxagi during remount.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0c2e06f..966f56c 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1129,7 +1129,7 @@ xfs_fs_remount(
 			mp->m_flags &= ~XFS_MOUNT_BARRIER;
 			break;
 		case Opt_inode64:
-			xfs_set_inode64(mp);
+			mp->m_maxagi = xfs_set_inode64(mp);
 			break;
 		default:
 			/*
-- 
1.7.11.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
