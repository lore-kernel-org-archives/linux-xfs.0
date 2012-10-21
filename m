Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9LBQQRe200959 for <xfs@oss.sgi.com>; Sun, 21 Oct 2012 06:26:26 -0500
Received: from mail-pa0-f53.google.com (mail-pa0-f53.google.com
	[209.85.220.53]) by cuda.sgi.com with ESMTP id hAUjlwmYJrvhUdOo
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 21 Oct 2012 04:28:07 -0700 (PDT)
Received: by mail-pa0-f53.google.com with SMTP id bj3so1553811pad.26
	for <xfs@oss.sgi.com>; Sun, 21 Oct 2012 04:28:06 -0700 (PDT)
From: "wenqing.lz" <gnehzuil.liu@gmail.com>
Subject: [PATCH] xfstests: get return value in seek_sanity_test
Date: Sun, 21 Oct 2012 19:39:08 +0800
Message-Id: <1350819548-29634-1-git-send-email-wenqing.lz@taobao.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

In seek_sanity_test getting return value is missing.  Thus we couldn't get the
result unless someone read the log file (e.g. # 285).

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 src/seek_sanity_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index 34f5508..e3ed64a 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -676,7 +676,7 @@ int main(int argc, char **argv)
 	for (i = 0; i < numtests; ++i) {
 		if (ret)
 			goto out;
-		run_test(&seek_tests[i]);
+		ret = run_test(&seek_tests[i]);
 	}
 
 out:
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
