Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 322887F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 13:38:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A864CAC012
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 11:38:40 -0700 (PDT)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id NTMts31h5dVH0iz0
	for <xfs@oss.sgi.com>; Thu, 08 May 2014 11:38:39 -0700 (PDT)
From: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] xfstests: fix flink test V2
Date: Thu, 8 May 2014 14:38:30 -0400
Message-ID: <1399574310-13718-1-git-send-email-jbacik@fb.com>
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
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, sandeen@redhat.com

I don't have flink support in my xfsprogs, but it doesn't fail with "command not
found" or whatever, it fails because I don't have the -T option, whereas Eric
gets an error about $TEST_DIR being a directory because his xfs_io tries to open
the directory first before it parses the options.  So fix this by checking flink
with these two cases and don't run if we hit either of them.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
V1->V2: check for "Is a directory" errors that Eric mentioned, move test up into
the flink specific case.

 common/rc | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/rc b/common/rc
index 5c13db5..f37b310 100644
--- a/common/rc
+++ b/common/rc
@@ -1248,6 +1248,8 @@ _require_xfs_io_command()
 	"flink" )
 		testio=`$XFS_IO_PROG -T -F -c "flink $testfile" \
 			$TEST_DIR 2>&1`
+		echo $testio | egrep -q "invalid option|Is a directory" && \
+			_notrun "xfs_io $command support is missing"
 		;;
 	*)
 		testio=`$XFS_IO_PROG -c "$command help" 2>&1`
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
