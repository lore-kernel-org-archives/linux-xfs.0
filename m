Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9FEBE7F60
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 22:15:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 822A18F8039
	for <xfs@oss.sgi.com>; Sun, 29 Sep 2013 20:15:51 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	IJzWCSCRRR2a6mGZ for <xfs@oss.sgi.com>;
	Sun, 29 Sep 2013 20:15:50 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VQTxZ-0006Oj-SP
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:45 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VQTxZ-0002FF-Rq
	for xfs@oss.sgi.com; Mon, 30 Sep 2013 13:15:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 03/32] xfs: fix some minor sparse warnings
Date: Mon, 30 Sep 2013 13:15:15 +1000
Message-Id: <1380510944-8571-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1380510944-8571-1-git-send-email-david@fromorbit.com>
References: <1380510944-8571-1-git-send-email-david@fromorbit.com>
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

A couple of simple locking annotations and 0 vs NULL warnings.
Nothing that changes any code behaviour, just removes build noise.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 2d480cc..7336abf 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4415,7 +4415,7 @@ xfs_bmapi_write(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp;
-	struct xfs_bmalloca	bma = { 0 };	/* args for xfs_bmap_alloc */
+	struct xfs_bmalloca	bma = { NULL };	/* args for xfs_bmap_alloc */
 	xfs_fileoff_t		end;		/* end of mapped file region */
 	int			eof;		/* after the end of extents */
 	int			error;		/* error return */
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
