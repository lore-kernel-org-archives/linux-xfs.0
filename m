Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9HBrw1o258042 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 06:53:59 -0500
Received: from hades.usersys.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 32B4F1F22057
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 04:53:57 -0700 (PDT)
Received: from hades.usersys.redhat.com ([187.60.101.4]) by cuda.sgi.com with
	ESMTP id UdrgR7ANKiH2GnDZ for <xfs@oss.sgi.com>;
	Mon, 17 Oct 2011 04:53:57 -0700 (PDT)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfs: Fix possible memory corruption in xfs_readlink
Date: Mon, 17 Oct 2011 12:52:48 -0200
Message-Id: <1318863168-3187-1-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <20111016234121.GS3159@dastard>
References: <20111016234121.GS3159@dastard>
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
Cc: Carlos Maiolino <cmaiolino@redhat.com>

This patch fix a possible memory corruption when
the link is larger than MAXPATHLEN and XFS_DEBUG
is not enabled. This also uses S_IFLNK to check
link not only in DEBUG mode.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_vnodeops.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 51fc429..c9721d7 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -123,8 +123,13 @@ xfs_readlink(
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
-	ASSERT(S_ISLNK(ip->i_d.di_mode));
-	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
+	if (!(S_ISLNK(ip->i_d.di_mode)) || !(ip->i_d.di_size <= MAXPATHLEN )){
+
+		xfs_emerg(mp, "inode (%lld), link too long or not a link"
+			 (unsigned long long)ip->i_no);
+		ASSERT(0);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
 
 	pathlen = ip->i_d.di_size;
 	if (!pathlen)
-- 
1.7.6.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
