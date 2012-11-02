Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA20awQl064886 for <xfs@oss.sgi.com>; Thu, 1 Nov 2012 19:36:58 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	9cGaOg3hAFEMXqam for <xfs@oss.sgi.com>;
	Thu, 01 Nov 2012 17:38:50 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TU5Hb-0004WG-8n
	for xfs@oss.sgi.com; Fri, 02 Nov 2012 11:38:47 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TU5Hb-0000nE-4X
	for xfs@oss.sgi.com; Fri, 02 Nov 2012 11:38:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] xfs: silence uninitialised f.file warning.
Date: Fri,  2 Nov 2012 11:38:39 +1100
Message-Id: <1351816724-3000-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1351816724-3000-1-git-send-email-david@fromorbit.com>
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Uninitialised variable build warning introduced by 2903ff0 ("switch
simple cases of fget_light to fdget"), gcc is not smart enough to
work out that the variable is not used uninitialised, and the commit
removed the initialisation at declaration that the old variable had.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8305f2a..c1df3c6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -70,7 +70,7 @@ xfs_find_handle(
 	int			hsize;
 	xfs_handle_t		handle;
 	struct inode		*inode;
-	struct fd		f;
+	struct fd		f = {0};
 	struct path		path;
 	int			error;
 	struct xfs_inode	*ip;
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
