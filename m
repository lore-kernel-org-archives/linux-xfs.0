Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2EEC67F72
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 23:46:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 157DD304053
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 21:46:29 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	SoPSgd4nRm74hx95 for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 21:46:28 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1WYTLz-0007ub-D5
	for xfs@oss.sgi.com; Fri, 11 Apr 2014 14:46:15 +1000
Received: from dave by disappointment with local (Exim 4.82)
	(envelope-from <dave@disappointment.disaster>) id 1WYTLz-0000ZD-Bz
	for xfs@oss.sgi.com; Fri, 11 Apr 2014 14:46:15 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: wrong error sign conversion during failed DIO writes
Date: Fri, 11 Apr 2014 14:46:15 +1000
Message-Id: <1397191575-2144-1-git-send-email-david@fromorbit.com>
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

We negate the error value being returned from a generic function
incorrectly. The code path that it is running in returned negative
errors, so there is no need to negate it to get the correct error
signs here.

This was uncovered by generic/019.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 003c005..067c3aa 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -679,7 +679,7 @@ xfs_file_dio_aio_write(
 		goto out;
 
 	if (mapping->nrpages) {
-		ret = -filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
+		ret = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
 						    pos, -1);
 		if (ret)
 			goto out;
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
