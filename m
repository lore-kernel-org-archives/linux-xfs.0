Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA88g3Kr101459 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 02:42:03 -0600
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8E791DBA4B2
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 00:42:02 -0800 (PST)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id hi0T6s3XttaFDQ5R
	for <xfs@oss.sgi.com>; Tue, 08 Nov 2011 00:42:02 -0800 (PST)
Received: by mail-bw0-f53.google.com with SMTP id q10so218577bka.26
	for <xfs@oss.sgi.com>; Tue, 08 Nov 2011 00:42:02 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/3] xfstests: fix typo in 260'th test
Date: Tue,  8 Nov 2011 12:41:54 +0400
Message-Id: <1320741715-32692-2-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1320741715-32692-1-git-send-email-dmonakhov@openvz.org>
References: <1320741715-32692-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, hch@lst.de

dd should not have count argument because it suposed to work untill ENOSPC.
Also it is reasonable to log dd's output, do that for both 269'th and 270'th
tests

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 269 |    4 ++--
 270 |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/269 b/269
index 61e83ad..206492b 100755
--- a/269
+++ b/269
@@ -53,8 +53,8 @@ _workout()
 	for ((i=0; i < num_iterations; i++))
 	do
 		# File will be opened with O_TRUNC each time
-		dd if=/dev/zero of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M count=1 \
-			> /dev/null 2>&1
+		dd if=/dev/zero of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M \
+			>> $here/$seq.full 2>&1
 		sleep $enospc_time
 	done
 	kill $pid
diff --git a/270 b/270
index ed1e31e..e45029f 100755
--- a/270
+++ b/270
@@ -63,7 +63,7 @@ _workout()
 		# File will be opened with O_TRUNC each time
 		su $qa_user -c "dd if=/dev/zero \
 			of=$SCRATCH_MNT/SPACE_CONSUMER bs=1M " \
-			> /dev/null 2>&1
+			>> $here/$seq.full 2>&1
 		sleep $enospc_time
 	done
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
