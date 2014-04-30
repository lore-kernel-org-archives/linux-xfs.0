Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B590D7F37
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 05:11:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9B12B8F8033
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2014 03:11:36 -0700 (PDT)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25]) by
	cuda.sgi.com with ESMTP id A2aFXN3T2FMEpQtD (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 30 Apr 2014 03:11:35 -0700 (PDT)
Received: from epcpsbgr5.samsung.com
	(u145.gpu120.samsung.co.kr [203.254.230.145])
	by mailout2.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N4U0004C9N8GG20@mailout2.samsung.com> for
	xfs@oss.sgi.com; Wed, 30 Apr 2014 19:11:32 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] xfstests: fsstress: fix incorrect if condition check for
	collapse range mode
Date: Wed, 30 Apr 2014 19:11:32 +0900
Message-id: <004401cf645c$8f874710$ae95d530$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, Ashish Sangwan <a.sangwan@samsung.com>, xfs@oss.sgi.com

There is if condition to be block aligned for off and len of Collapse range.
But off and len for all fallocate opearion can be aligned by incorrect
if condition check.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 ltp/fsstress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 29fc250..ff9ed12 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2230,7 +2230,7 @@ do_fallocate(int opno, long r, int mode)
 	 * Collapse range requires off and len to be block aligned, make it
 	 * more likely to be the case.
 	 */
-	if (FALLOC_FL_COLLAPSE_RANGE && (opno % 2)) {
+	if (mode & FALLOC_FL_COLLAPSE_RANGE && (opno % 2)) {
 		off = ((off + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
 		len = ((len + stb.st_blksize - 1) & ~(stb.st_blksize - 1));
 	}
-- 
1.7.11-rc0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
