Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 404217F61
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 15:50:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 068B6304043
	for <xfs@oss.sgi.com>; Sun,  6 Mar 2016 13:50:11 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	WHP1peVsJ3owUEdb for <xfs@oss.sgi.com>;
	Sun, 06 Mar 2016 13:50:08 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1acgYt-0000Y6-LH
	for xfs@oss.sgi.com; Mon, 07 Mar 2016 08:50:03 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1acgYh-0004o4-Te
	for xfs@oss.sgi.com; Mon, 07 Mar 2016 08:49:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs: ioends require logically contiguous file offsets
Date: Mon,  7 Mar 2016 08:49:46 +1100
Message-Id: <1457300990-18300-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1457300990-18300-1-git-send-email-david@fromorbit.com>
References: <1457300990-18300-1-git-send-email-david@fromorbit.com>
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

From: "Darrick J. Wong" <darrick.wong@oracle.com>

We need to create a new ioend if the current writepage call isn't
logically contiguous with the range contained in the previous ioend.
Hopefully writepage gets called in order of increasing file offset.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_aops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 7a467b3..75a39a8 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -526,7 +526,8 @@ xfs_add_to_ioend(
 	struct list_head	*iolist)
 {
 	if (!wpc->ioend || wpc->io_type != wpc->ioend->io_type ||
-	    bh->b_blocknr != wpc->last_block + 1) {
+	    bh->b_blocknr != wpc->last_block + 1 ||
+	    offset != wpc->ioend->io_offset + wpc->ioend->io_size) {
 		struct xfs_ioend	*new;
 
 		if (wpc->ioend)
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
