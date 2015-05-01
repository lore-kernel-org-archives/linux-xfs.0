Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 11C387F47
	for <xfs@oss.sgi.com>; Fri,  1 May 2015 03:10:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0E12AC002
	for <xfs@oss.sgi.com>; Fri,  1 May 2015 01:10:33 -0700 (PDT)
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56]) by
	cuda.sgi.com with ESMTP id HbbSloVlNcW9yE5o (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 May 2015 01:10:30 -0700 (PDT)
From: Wang Sheng-Hui <shhuiw@foxmail.com>
Subject: [PATCH] common/renameat2: pass the renameat2 flags from _rename_tests
	to _rename_tests_source_dest
Date: Fri,  1 May 2015 16:10:07 +0800
Message-Id: <1430467807-5511-1-git-send-email-shhuiw@foxmail.com>
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
To: mszeredi@suse.cz, david@fromorbit.com, xfs@oss.sgi.com

_rename_tests() records the 'flags' arg but doesn't pass it to
_rename_tests_source_dest() in old code, thus any 'flags' to
renameat2 is missed. Fix the missing.

Signed-off-by: Wang Sheng-Hui <shhuiw@foxmail.com>
---
 common/renameat2 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/common/renameat2 b/common/renameat2
index a335169..df2df2e 100644
--- a/common/renameat2
+++ b/common/renameat2
@@ -78,6 +78,7 @@ _rename_tests_source_dest()
 	local source=$1
 	local dest=$2
 	local options=$3
+	local flags=$4
 
 	for stype in none regu symb dire tree; do
 		for dtype in none regu symb dire tree; do
@@ -107,11 +108,11 @@ _rename_tests()
 	local flags=$2
 
 	#same directory renames
-	_rename_tests_source_dest $testdir/src $testdir/dst     "samedir "
+	_rename_tests_source_dest $testdir/src $testdir/dst     "samedir " $flags
 
 	#cross directory renames
 	mkdir $testdir/x $testdir/y
-	_rename_tests_source_dest $testdir/x/src $testdir/y/dst "crossdir"
+	_rename_tests_source_dest $testdir/x/src $testdir/y/dst "crossdir" $flags
 	rmdir $testdir/x $testdir/y
 }
 
-- 
2.1.2



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
