Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AE4BD7FCC
	for <xfs@oss.sgi.com>; Thu,  7 Mar 2013 07:59:49 -0600 (CST)
Message-Id: <20130307124125.435047948@sgi.com>
Date: Thu, 07 Mar 2013 06:41:03 -0600
From: rjohnston@sgi.com
Subject: [PATCH] Fix typo from commit 0c5e67e4 "xfstests 273: fix a typo"
References: <20130307124102.821208303@sgi.com>
Content-Disposition: inline; filename=fix-typo-273.patch
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
Cc: shhuiw@gmail.com

When updating the patch, the redirect was incorrect.

Reported-by: Wang Sheng-Hui <shhuiw@gmail.com>
Signed-off-by: Rich Johnston <rjohnston@sgi.com>

---

 273 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/273
===================================================================
--- a/273
+++ b/273
@@ -92,7 +92,7 @@ _porter()
 		exit
 	fi
 
-	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>>&1
+	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >>$seq.full 2>&1
 	if [ $? -ne 0 ]
 	then
 		echo "_porter $_suffix not complete"


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
