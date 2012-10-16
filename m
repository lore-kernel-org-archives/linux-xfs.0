Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9G9eCrk099640 for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 04:40:12 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id estC6rSzjmfNCW63 for
	<xfs@oss.sgi.com>; Tue, 16 Oct 2012 02:41:49 -0700 (PDT)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] 251: Do not allow step to be zero
Date: Tue, 16 Oct 2012 11:41:34 +0200
Message-Id: <1350380494-17482-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1350380494-17482-1-git-send-email-lczerner@redhat.com>
References: <1350380494-17482-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

Currently 'step' variable which is used as length of the range to
discard can be zero. However it would result in error returned by the
fstrim.

Fix this by forcing 'step' to be at least 4KB.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 251 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/251 b/251
index f46b6e2..373afd0 100755
--- a/251
+++ b/251
@@ -98,7 +98,7 @@ fstrim_loop()
 	mmlen=$(_guess_max_minlen)
 
 	while true ; do
-		step=$((RANDOM*$RANDOM))
+		step=$((RANDOM*$RANDOM+4))
 		minlen=$(((RANDOM*($RANDOM%2+1))%$mmlen))
 		start=$RANDOM
 		if [ $((RANDOM%10)) -gt 7 ]; then
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
