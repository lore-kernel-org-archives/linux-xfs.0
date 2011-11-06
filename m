Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA64kpd2206385 for <xfs@oss.sgi.com>; Sat, 5 Nov 2011 23:46:52 -0500
Received: from smtp.gentoo.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BC17C12627DD
	for <xfs@oss.sgi.com>; Sat,  5 Nov 2011 21:46:49 -0700 (PDT)
Received: from smtp.gentoo.org (smtp.gentoo.org [140.211.166.183]) by
	cuda.sgi.com with ESMTP id mIaGRnAN80XzSZwu for
	<xfs@oss.sgi.com>; Sat, 05 Nov 2011 21:46:49 -0700 (PDT)
From: Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH] path: fix 1 byte overflow with empty lists
Date: Sun,  6 Nov 2011 00:46:57 -0400
Message-Id: <1320554817-2594-1-git-send-email-vapier@gentoo.org>
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
Cc: aelder@sgi.com

If pap->pa_cnt is 0, then the local buffer is allocated as 1 byte,
but the code then writes two bytes to it '/' and '\0'.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 common/path.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/common/path.c b/common/path.c
index 66320de..ca24f6a 100644
--- a/common/path.c
+++ b/common/path.c
@@ -285,6 +285,8 @@ pa_gen( pa_t *pap )
 	for ( i = 0 ; i < pap->pa_cnt ; i++ ) {
 		sz += strlen( pap->pa_array[ i ] ) + 1;
 	}
+	if ( i == 0 )
+		sz++;
 	sz++;
 
 	retp = ( char * )malloc( sz );
-- 
1.7.6.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
