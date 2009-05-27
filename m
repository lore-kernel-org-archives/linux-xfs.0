Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RIrMOA204142 for <xfs@oss.sgi.com>; Wed, 27 May 2009 13:53:22 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 482182B394B
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:35 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 91Q3H9Mcu9JPWpQD for
	<xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:35 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 4/9] 069: make scratch mkfs quiet
Date: Wed, 27 May 2009 13:53:28 -0500
Message-Id: <1243450413-12681-5-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
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
Cc: Eric Sandeen <sandeen@sandeen.net>

The _scratch_mkfs call in test 069 was not redirecting
stderr to /dev/null; other mkfs's may be more noisy
on stderr.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 069 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/069 b/069
index 4950901..78689ed 100755
--- a/069
+++ b/069
@@ -32,7 +32,7 @@ rm -f $seq.full
 umount $SCRATCH_DEV >/dev/null 2>&1
 
 echo "*** mkfs"
-_scratch_mkfs >/dev/null || _fail "mkfs failed"
+_scratch_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
 
 echo "*** mount FS"
 _scratch_mount >/dev/null || _fail "mount failed"
-- 
1.5.5.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
