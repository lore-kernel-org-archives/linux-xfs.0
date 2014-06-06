Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 62A817F3F
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 03:18:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58025304053
	for <xfs@oss.sgi.com>; Fri,  6 Jun 2014 01:18:30 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	eQTVD4InFhSostyn for <xfs@oss.sgi.com>;
	Fri, 06 Jun 2014 01:18:28 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WspLx-00031P-I5
	for xfs@oss.sgi.com; Fri, 06 Jun 2014 18:18:21 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1WspLx-0006ol-G8
	for xfs@oss.sgi.com; Fri, 06 Jun 2014 18:18:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs; fix xfs_da_args sparse warning in xfs_readdir
Date: Fri,  6 Jun 2014 18:18:21 +1000
Message-Id: <1402042701-26173-1-git-send-email-david@fromorbit.com>
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

The kbuild test robot reported:

>> fs/xfs/xfs_dir2_readdir.c:672:41: sparse: Using plain integer as NULL pointer

Fix it.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_dir2_readdir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index ca1f43c..48e99af 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -669,7 +669,7 @@ xfs_readdir(
 	struct dir_context	*ctx,
 	size_t			bufsize)
 {
-	struct xfs_da_args	args = {0};
+	struct xfs_da_args	args = { NULL };
 	int			rval;
 	int			v;
 	uint			lock_mode;
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
