Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F1E187F52
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 15:54:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E7F06304051
	for <xfs@oss.sgi.com>; Wed,  7 May 2014 13:54:51 -0700 (PDT)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com
	[67.231.145.42]) by cuda.sgi.com with ESMTP id vlYpdN9BM5hgIUbq
	for <xfs@oss.sgi.com>; Wed, 07 May 2014 13:54:50 -0700 (PDT)
From: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] xfstests: fix flink test
Date: Wed, 7 May 2014 16:54:47 -0400
Message-ID: <1399496087-20431-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

I don't have flink support in my xfsprogs, but it doesn't fail with "command not
found" or whatever, it fails because I don't have the -T option.  So fix
_require_xfs_io_command to check for an invalid option and not run.  This way I
get notrun instead of a failure.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 common/rc | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/rc b/common/rc
index 5c13db5..4fa7e63 100644
--- a/common/rc
+++ b/common/rc
@@ -1258,6 +1258,8 @@ _require_xfs_io_command()
 		_notrun "xfs_io $command support is missing"
 	echo $testio | grep -q "Operation not supported" && \
 		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
+	echo $testio | grep -q "invalid option" && \
+		_notrun "xfs_io $command support is missing"
 }
 
 # Check that a fs has enough free space (in 1024b blocks)
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
