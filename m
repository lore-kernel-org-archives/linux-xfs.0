Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 158A77F9D
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 02:56:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EA8448F8059
	for <xfs@oss.sgi.com>; Fri, 21 Feb 2014 00:55:58 -0800 (PST)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id gNB4JtXFO1NFusS8 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 21 Feb 2014 00:55:56 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] xfstest generic/280: use waidpid instead of ugly sleep
Date: Fri, 21 Feb 2014 12:55:48 +0400
Message-Id: <1392972948-2463-1-git-send-email-dmonakhov@openvz.org>
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
Cc: Dmitry Monakhov <dmonakhov@openvz.org>


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 tests/generic/280 |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tests/generic/280 b/tests/generic/280
index 815a2c5..7a2d1d0 100755
--- a/tests/generic/280
+++ b/tests/generic/280
@@ -61,9 +61,10 @@ quotacheck -u -g $SCRATCH_MNT 2>/dev/null
 quotaon $SCRATCH_MNT 2>/dev/null
 xfs_freeze -f $SCRATCH_MNT
 setquota -u root 1 2 3 4 $SCRATCH_MNT &
+pid=$!
 sleep 1
 xfs_freeze -u $SCRATCH_MNT
-sleep 1
+wait $pid
 umount $SCRATCH_DEV
 
 # Failure comes in the form of a deadlock.
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
