Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8KDWO2B088957 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 08:32:24 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5tgQZ7rQgtZQPSxT for
	<xfs@oss.sgi.com>; Thu, 20 Sep 2012 06:33:36 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q8KDXat9016440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 09:33:36 -0400
Received: from andromeda.usersys.redhat.com (ovpn-113-73.phx2.redhat.com
	[10.3.113.73])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id q8KDXRt8019074
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 09:33:35 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 6/6] xfs: Make inode32 a remountable option
Date: Thu, 20 Sep 2012 10:32:41 -0300
Message-Id: <1348147961-7520-7-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
References: <1348147961-7520-1-git-send-email-cmaiolino@redhat.com>
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

As inode64 is the default option now, and was also made remountable previously,
inode32 can also be remounted on-the-fly when it is needed.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_super.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3329296..545ab6f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -122,13 +122,18 @@ mempool_t *xfs_ioend_pool;
  * in the future, too.
  */
 enum {
-	Opt_barrier, Opt_nobarrier, Opt_inode64, Opt_err
+	Opt_barrier,
+	Opt_nobarrier,
+	Opt_inode64,
+	Opt_inode32,
+	Opt_err
 };
 
 static const match_table_t tokens = {
 	{Opt_barrier, "barrier"},
 	{Opt_nobarrier, "nobarrier"},
 	{Opt_inode64, "inode64"},
+	{Opt_inode32, "inode32"},
 	{Opt_err, NULL}
 };
 
@@ -1140,6 +1145,9 @@ xfs_fs_remount(
 		case Opt_inode64:
 			mp->m_maxagi = xfs_set_inode64(mp);
 			break;
+		case Opt_inode32:
+			mp->m_maxagi = xfs_set_inode32(mp);
+			break;
 		default:
 			/*
 			 * Logically we would return an error here to prevent
-- 
1.7.11.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
