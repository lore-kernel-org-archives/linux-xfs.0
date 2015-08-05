Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 57D507FB7
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 18:10:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 22964304059
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 16:10:00 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bqBrwMa1USM6DO64 for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 15:50:05 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZN7VQ-0007wl-21
	for xfs@oss.sgi.com; Thu, 06 Aug 2015 08:49:52 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZN7VQ-0008E7-15
	for xfs@oss.sgi.com; Thu, 06 Aug 2015 08:49:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] db: fix uninitialised variable warnings
Date: Thu,  6 Aug 2015 08:49:52 +1000
Message-Id: <1438814992-31588-1-git-send-email-david@fromorbit.com>
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

New versions of gcc barf on the conversion table code in
db/convert.c. Shut it up by initialising the conversion array.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 db/convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/db/convert.c b/db/convert.c
index 09f9225..a337abe 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -157,7 +157,7 @@ convert_f(int argc, char **argv)
 {
 	ctype_t		c;
 	int		conmask;
-	cval_t		cvals[NCTS];
+	cval_t		cvals[NCTS] = {};
 	int		i;
 	int		mask;
 	__uint64_t	v;
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
