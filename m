Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A0727F3F
	for <xfs@oss.sgi.com>; Fri,  4 Jul 2014 00:57:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 872A8AC003
	for <xfs@oss.sgi.com>; Thu,  3 Jul 2014 22:57:32 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	lNGty9RIn2hDWMKE for <xfs@oss.sgi.com>;
	Thu, 03 Jul 2014 22:57:30 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] xfs_db: write command broken on 64 bit values
Date: Fri,  4 Jul 2014 15:57:11 +1000
Message-Id: <1404453435-1915-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1404453435-1915-1-git-send-email-david@fromorbit.com>
References: <1404453435-1915-1-git-send-email-david@fromorbit.com>
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

convert_args() has problesm with 64 bit fields because it tries to
shift them by 64 bits. The result of doing so is undefined by the C
standard, and so results in the unexpected behaviour of the result
being being the original value unchanged rather than 0. Hence you
can't write 64 bit fields because the code thinks that all values
other than 0 are out of range.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/write.c b/db/write.c
index ca8bd0f..0157a44 100644
--- a/db/write.c
+++ b/db/write.c
@@ -565,7 +565,7 @@ convert_arg(
 		return NULL;
 
 	/* Does the value fit into the range of the destination bitfield? */
-	if ((val >> bit_length) > 0)
+	if (bit_length < 64 && (val >> bit_length) > 0)
 		return NULL;
 	/*
 	 * If the length of the field is not a multiple of a byte, push
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
