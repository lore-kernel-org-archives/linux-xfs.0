Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F0A197F74
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 18:37:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DE75F8F8033
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2014 16:37:51 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	gQaPxXnmPyy7BE1n for <xfs@oss.sgi.com>;
	Wed, 24 Sep 2014 16:37:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XWw81-0004yH-Lp
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 09:37:45 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XWw81-00056y-Kl
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 09:37:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfs: annotate user variables passed as void
Date: Thu, 25 Sep 2014 09:37:43 +1000
Message-Id: <1411601863-19594-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1411601863-19594-1-git-send-email-david@fromorbit.com>
References: <1411601863-19594-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Some argument callbacks can contain user buffers, and sparse warns
about passing them as void pointers. Cast appropriately to remove
the sparse warnings.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_ioctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3799695..7a6b406 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1349,7 +1349,7 @@ xfs_ioc_setxflags(
 STATIC int
 xfs_getbmap_format(void **ap, struct getbmapx *bmv, int *full)
 {
-	struct getbmap __user	*base = *ap;
+	struct getbmap __user	*base = (struct getbmap __user *)*ap;
 
 	/* copy only getbmap portion (not getbmapx) */
 	if (copy_to_user(base, bmv, sizeof(struct getbmap)))
@@ -1380,7 +1380,7 @@ xfs_ioc_getbmap(
 		bmx.bmv_iflags |= BMV_IF_NO_DMAPI_READ;
 
 	error = xfs_getbmap(ip, &bmx, xfs_getbmap_format,
-			    (struct getbmap *)arg+1);
+			    (__force struct getbmap *)arg+1);
 	if (error)
 		return error;
 
@@ -1393,7 +1393,7 @@ xfs_ioc_getbmap(
 STATIC int
 xfs_getbmapx_format(void **ap, struct getbmapx *bmv, int *full)
 {
-	struct getbmapx __user	*base = *ap;
+	struct getbmapx __user	*base = (struct getbmapx __user *)*ap;
 
 	if (copy_to_user(base, bmv, sizeof(struct getbmapx)))
 		return -EFAULT;
@@ -1420,7 +1420,7 @@ xfs_ioc_getbmapx(
 		return -EINVAL;
 
 	error = xfs_getbmap(ip, &bmx, xfs_getbmapx_format,
-			    (struct getbmapx *)arg+1);
+			    (__force struct getbmapx *)arg+1);
 	if (error)
 		return error;
 
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
