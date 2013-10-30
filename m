Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2C3C77F3F
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 22:59:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B4A0BAC0A3
	for <xfs@oss.sgi.com>; Tue, 29 Oct 2013 20:59:05 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	gKyff9p6mQAVwIbY for <xfs@oss.sgi.com>;
	Tue, 29 Oct 2013 20:59:04 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1VbMvn-0002u8-SX
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 14:58:55 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1VbMvn-0007TI-Rh
	for xfs@oss.sgi.com; Wed, 30 Oct 2013 14:58:55 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfstests: fix mkfs filter on xfs/096
Date: Wed, 30 Oct 2013 14:58:55 +1100
Message-Id: <1383105535-28686-1-git-send-email-david@fromorbit.com>
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

Needs to filter out the new ftype field.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 tests/xfs/096 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/xfs/096 b/tests/xfs/096
index 44b19b0..b2719bc 100755
--- a/tests/xfs/096
+++ b/tests/xfs/096
@@ -87,6 +87,7 @@ _mkfs_filter()
 	-e 's/\(realtime[ 	]*=\).*extsz/\1REALTIME               extsz/' \
 	-e '/.*crc=/d' \
 	-e 's/ *$//' \
+	-e 's/ ftype=[01]//' \
    | grep -v parent
 }
 
-- 
1.8.4.rc3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
