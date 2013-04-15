Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A0C567F52
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 06:10:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C023AC002
	for <xfs@oss.sgi.com>; Mon, 15 Apr 2013 04:10:05 -0700 (PDT)
Received: from relay.sw.ru (mailhub.sw.ru [195.214.232.25]) by cuda.sgi.com
	with ESMTP id 9zDuqWd9eojNOaID (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 15 Apr 2013 04:10:00 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] xfstests: fix fio's arguments
Date: Mon, 15 Apr 2013 15:09:48 +0400
Message-Id: <1366024188-21756-2-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1366024188-21756-1-git-send-email-dmonakhov@openvz.org>
References: <1366024188-21756-1-git-send-email-dmonakhov@openvz.org>
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

Option 'group_reporting' semantics was changes for recent fio versions
In fact we do not need it here, let's just drop it.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 tests/ext4/301 |    1 -
 tests/ext4/302 |    1 -
 tests/ext4/303 |    1 -
 tests/ext4/304 |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/tests/ext4/301 b/tests/ext4/301
index b6c2f11..e1583d4 100755
--- a/tests/ext4/301
+++ b/tests/ext4/301
@@ -59,7 +59,6 @@ filesize=${FILE_SIZE}
 size=999G
 buffered=0
 fadvise_hint=0
-group_reporting
 
 #################################
 # Test1
diff --git a/tests/ext4/302 b/tests/ext4/302
index 9307ab4..abca805 100644
--- a/tests/ext4/302
+++ b/tests/ext4/302
@@ -59,7 +59,6 @@ filesize=${FILE_SIZE}
 size=999G
 buffered=0
 fadvise_hint=0
-group_reporting
 
 ##########################################
 # Test2
diff --git a/tests/ext4/303 b/tests/ext4/303
index 84d8f7b..7051576 100644
--- a/tests/ext4/303
+++ b/tests/ext4/303
@@ -59,7 +59,6 @@ filesize=${FILE_SIZE}
 size=999G
 buffered=0
 fadvise_hint=0
-group_reporting
 
 #################################
 # Test3
diff --git a/tests/ext4/304 b/tests/ext4/304
index 7b90f1d..5d15ecb 100644
--- a/tests/ext4/304
+++ b/tests/ext4/304
@@ -60,7 +60,6 @@ filesize=${FILE_SIZE}
 size=999G
 buffered=0
 fadvise_hint=0
-group_reporting
 
 #################################
 # Test4
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
