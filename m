Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBL08FFm199486 for <xfs@oss.sgi.com>; Tue, 20 Dec 2011 18:08:16 -0600
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	nkUTBUKyDy38resR for <xfs@oss.sgi.com>;
	Tue, 20 Dec 2011 16:08:10 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1Rd9ij-0000QR-U6
	for xfs@oss.sgi.com; Wed, 21 Dec 2011 11:07:45 +1100
Received: from dave by disappointment with local (Exim 4.76)
	(envelope-from <dave@disappointment.disaster>) id 1Rd9ij-0005bb-PX
	for xfs@oss.sgi.com; Wed, 21 Dec 2011 11:07:45 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: fix endian conversion issue in discard code
Date: Wed, 21 Dec 2011 11:07:42 +1100
Message-Id: <1324426062-21505-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1324426062-21505-1-git-send-email-david@fromorbit.com>
References: <1324426062-21505-1-git-send-email-david@fromorbit.com>
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

When finding the longest extent in an AG, we read the value directly
out of the AGF buffer without endian conversion. This will give an
incorrect length, resulting in FITRIM operations potentially not
trimming everything that it should.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_discard.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 8a24f0c..286a051 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -68,7 +68,7 @@ xfs_trim_extents(
 	 * Look up the longest btree in the AGF and start with it.
 	 */
 	error = xfs_alloc_lookup_le(cur, 0,
-				    XFS_BUF_TO_AGF(agbp)->agf_longest, &i);
+			    be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest), &i);
 	if (error)
 		goto out_del_cursor;
 
@@ -84,7 +84,7 @@ xfs_trim_extents(
 		if (error)
 			goto out_del_cursor;
 		XFS_WANT_CORRUPTED_GOTO(i == 1, out_del_cursor);
-		ASSERT(flen <= XFS_BUF_TO_AGF(agbp)->agf_longest);
+		ASSERT(flen <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_longest));
 
 		/*
 		 * Too small?  Give up.
-- 
1.7.5.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
