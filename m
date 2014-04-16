Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 25EF87F58
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 17:35:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F0A28F8039
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 15:35:39 -0700 (PDT)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25]) by
	cuda.sgi.com with ESMTP id hAFDjl2Y9RHVhBSS (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 16 Apr 2014 15:35:38 -0700 (PDT)
Received: from epcpsbgr2.samsung.com
	(u142.gpu120.samsung.co.kr [203.254.230.142])
	by mailout2.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0N4500FJGARC3J40@mailout2.samsung.com> for
	xfs@oss.sgi.com; Thu, 17 Apr 2014 07:35:36 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH] xfstests: fsstress: remove duplicate COLLAPSE_RANGE flags
Date: Thu, 17 Apr 2014 07:35:35 +0900
Message-id: <002c01cf59c4$2f4273e0$8dc75ba0$@samsung.com>
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
To: 'Dave Chinner' <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

From: Namjae Jeon <namjae.jeon@samsung.com>

Remove duplicate COLLAPSE_RANGE flags

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 ltp/fsstress.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 1eec11a..29fc250 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -2176,7 +2176,6 @@ struct print_flags falloc_flags [] = {
 	{ FALLOC_FL_NO_HIDE_STALE, "NO_HIDE_STALE"},
 	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
 	{ FALLOC_FL_ZERO_RANGE, "ZERO_RANGE"},
-	{ FALLOC_FL_COLLAPSE_RANGE, "COLLAPSE_RANGE"},
 	{ -1, NULL}
 };

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
