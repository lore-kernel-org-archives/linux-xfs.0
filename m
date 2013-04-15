Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 885957F4C
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 06:10:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 166C8AC002
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 04:10:03 -0700 (PDT)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id UkyvQ9nBcJ8L4cBN (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Apr 2013 04:10:01 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] xfstests: dump _require_fio output to log
Date: Mon, 15 Apr 2013 15:09:47 +0400
Message-Id: <1366024188-21756-1-git-send-email-dmonakhov@openvz.org>
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
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org, dchinner@redhat.com

This should helps to find incompatibility issues.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 common/rc      |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
 mode change 100644 => 100755 tests/ext4/301

diff --git a/common/rc b/common/rc
index 09fb83f..ad3e378 100644
--- a/common/rc
+++ b/common/rc
@@ -1967,8 +1967,8 @@ _require_fio()
 		return 1;
 	fi
 
-	$FIO_PROG --warnings-fatal --showcmd $job >/dev/null 2>&1
-	[ $? -eq 0 ] || _notrun "$FIO_PROG too old"
+	$FIO_PROG --warnings-fatal --showcmd $job >> $seqres.full 2>&1
+	[ $? -eq 0 ] || _notrun "$FIO_PROG too old, see $seqres.full"
 }
 
 # Does freeze work on this fs?
diff --git a/tests/ext4/301 b/tests/ext4/301
old mode 100644
new mode 100755
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
