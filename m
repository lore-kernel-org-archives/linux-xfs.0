Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3699D7F83
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 07:31:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1F863304048
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 05:31:06 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	57vIReQsPJyQXRAe for <xfs@oss.sgi.com>;
	Tue, 12 Mar 2013 05:31:04 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UFOMB-0001Ra-2p
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:31:03 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UFOM5-0002Lk-Ut
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 23:30:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/21] xfs: increase hexdump output in xfs_corruption_error
Date: Tue, 12 Mar 2013 23:30:35 +1100
Message-Id: <1363091454-8852-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1363091454-8852-1-git-send-email-david@fromorbit.com>
References: <1363091454-8852-1-git-send-email-david@fromorbit.com>
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

Currently xfs_corruption_error() dumps the first 16 bytes of the
buffer that is passed to it when a corruption occurs. This is not
large enough to see the entire state of the header of the block that
was determined to be corrupt.  increase the output to 64 bytes to
capture the majority of all headers in all types of metadata blocks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_error.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 07bf3b9..35d3f5b 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -178,7 +178,7 @@ xfs_corruption_error(
 	inst_t			*ra)
 {
 	if (level <= xfs_error_level)
-		xfs_hex_dump(p, 16);
+		xfs_hex_dump(p, 64);
 	xfs_error_report(tag, level, mp, filename, linenum, ra);
 	xfs_alert(mp, "Corruption detected. Unmount and run xfs_repair");
 }
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
