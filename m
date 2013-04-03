Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E7727FA4
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 00:11:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0C4D3304081
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 22:11:48 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	XjmEJDQ0FBdcuVUB for <xfs@oss.sgi.com>;
	Tue, 02 Apr 2013 22:11:47 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UNFyx-0000Ky-1l
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:11:35 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UNFyw-0005Am-U8
	for xfs@oss.sgi.com; Wed, 03 Apr 2013 16:11:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/22] xfs: increase hexdump output in xfs_corruption_error
Date: Wed,  3 Apr 2013 16:11:11 +1100
Message-Id: <1364965892-19623-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1364965892-19623-1-git-send-email-david@fromorbit.com>
References: <1364965892-19623-1-git-send-email-david@fromorbit.com>
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
