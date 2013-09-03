Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 799CE7F4E
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 06:47:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 68EF48F804B
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 04:47:51 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9oIqu4ziiF8Inl7W for <xfs@oss.sgi.com>;
	Tue, 03 Sep 2013 04:47:49 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VGp5B-0003Va-27
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 21:47:41 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VGp5B-0005MV-1R
	for xfs@oss.sgi.com; Tue, 03 Sep 2013 21:47:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: don't assert fail on bad inode numbers
Date: Tue,  3 Sep 2013 21:47:38 +1000
Message-Id: <1378208858-20557-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1378208858-20557-1-git-send-email-david@fromorbit.com>
References: <1378208858-20557-1-git-send-email-david@fromorbit.com>
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

Let the inode verifier do it's work by returning an error when we
fail to find correct magic numbers in an inode buffer.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode_buf.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_inode_buf.c b/fs/xfs/xfs_inode_buf.c
index 3d25c9a..63382d3 100644
--- a/fs/xfs/xfs_inode_buf.c
+++ b/fs/xfs/xfs_inode_buf.c
@@ -53,9 +53,8 @@ xfs_inobp_check(
 					i * mp->m_sb.sb_inodesize);
 		if (!dip->di_next_unlinked)  {
 			xfs_alert(mp,
-	"Detected bogus zero next_unlinked field in incore inode buffer 0x%p.",
-				bp);
-			ASSERT(dip->di_next_unlinked);
+	"Detected bogus zero next_unlinked field in inode %d buffer 0x%llx.",
+				i, (long long)bp->b_bn);
 		}
 	}
 }
@@ -106,11 +105,10 @@ xfs_inode_buf_verify(
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_HIGH,
 					     mp, dip);
 #ifdef DEBUG
-			xfs_emerg(mp,
+			xfs_alert(mp,
 				"bad inode magic/vsn daddr %lld #%d (magic=%x)",
 				(unsigned long long)bp->b_bn, i,
 				be16_to_cpu(dip->di_magic));
-			ASSERT(0);
 #endif
 		}
 	}
-- 
1.8.3.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
