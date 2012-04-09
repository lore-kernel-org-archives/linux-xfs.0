Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q39Iadhp187767 for <xfs@oss.sgi.com>; Mon, 9 Apr 2012 13:36:40 -0500
Received: from mx2.netapp.com (mx2.netapp.com [216.240.18.37]) by cuda.sgi.com
	with ESMTP id 1oEEHGJZAgdXYFsx (version=TLSv1 cipher=RC4-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 09 Apr 2012 11:36:38 -0700 (PDT)
Message-ID: <4F832C25.3080408@netapp.com>
Date: Mon, 09 Apr 2012 14:36:21 -0400
From: Bryan Schumaker <bjschuma@netapp.com>
MIME-Version: 1.0
Subject: [PATCH] 273: don't delete everything if $SCRATCH_MNT isn't set
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

The cleanup function is trapped before _require_scratch() is called, and
then expands "rm -rf $SCRATCH_MNT/*" to "rm -rf /*"

Signed-off-by: Bryan Schumaker <bjschuma@netapp.com>
---
 273 |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/273 b/273
index 2965132..8889f5a 100755
--- a/273
+++ b/273
@@ -35,7 +35,11 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
-	rm -rf $SCRATCH_MNT/* $tmp.*
+	if [ ! -z $SCRATCH_DEV ] && [ ! -z $SCRATCH_MNT ];
+	then
+		rm -rf $SCRATCH_MNT
+	fi
+	rm -rf $tmp.*
 	_scratch_unmount
 }
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
