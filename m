Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CF6657CAE
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2016 00:19:01 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B19EB304043
	for <xfs@oss.sgi.com>; Sun, 14 Feb 2016 22:19:01 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	JTwFVvpDYyAYuE1T for <xfs@oss.sgi.com>;
	Sun, 14 Feb 2016 22:19:00 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVCUN-0000MK-LW
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVCUN-0005H3-Kk
	for xfs@oss.sgi.com; Mon, 15 Feb 2016 17:18:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/14] libxfs: fix two comment typos
Date: Mon, 15 Feb 2016 17:18:23 +1100
Message-Id: <1455517105-20033-13-git-send-email-david@fromorbit.com>
In-Reply-To: <1455517105-20033-1-git-send-email-david@fromorbit.com>
References: <1455517105-20033-1-git-send-email-david@fromorbit.com>
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

From: Geliang Tang <geliangtang@163.com>

Source kernel commit fef4ded8cb2e53a47093b334e7730d55a3badc59

Just fix two typos in code comments.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_btree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 658f27e..efcad26 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -219,7 +219,7 @@ xfs_btree_check_ptr(
  * long-form btree header.
  *
  * Prior to calculting the CRC, pull the LSN out of the buffer log item and put
- * it into the buffer so recovery knows what the last modifcation was that made
+ * it into the buffer so recovery knows what the last modification was that made
  * it to disk.
  */
 void
@@ -257,7 +257,7 @@ xfs_btree_lblock_verify_crc(
  * short-form btree header.
  *
  * Prior to calculting the CRC, pull the LSN out of the buffer log item and put
- * it into the buffer so recovery knows what the last modifcation was that made
+ * it into the buffer so recovery knows what the last modification was that made
  * it to disk.
  */
 void
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
