Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E0B347F3F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 04:08:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AFB588F806F
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 02:08:43 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id t16Cvgk4IYYOYAUb for
	<xfs@oss.sgi.com>; Tue, 11 Feb 2014 02:08:41 -0800 (PST)
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: [PATCH v2] xfstests: btrfs/004: fix to make test really work
Date: Tue, 11 Feb 2014 18:06:44 +0800
Message-Id: <1392113204-29237-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
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
Cc: linux-btrfs@vger.kernel.org

So i was wondering why test 004 could pass my previous wrong
kernel patch while it defenitely should not.

By some debugging, i found here perl script is wrong, we did not
filter out anything and this unit test did not work acutally.so
it came out we will never fail this test.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
Changelog v1->v2:
	format perl script to make it more readable(thanks to Dave Chinner)
---
 tests/btrfs/004 | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tests/btrfs/004 b/tests/btrfs/004
index 14da9f1..1d608db 100755
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -57,11 +57,17 @@ _require_command "/usr/sbin/filefrag"
 
 rm -f $seqres.full
 
-FILEFRAG_FILTER='if (/, blocksize (\d+)/) {$blocksize = $1; next} ($ext, '\
-'$logical, $physical, $expected, $length, $flags) = (/^\s*(\d+)\s+(\d+)'\
-'\s+(\d+)\s+(?:(\d+)\s+)?(\d+)\s+(.*)/) or next; $flags =~ '\
-'/(?:^|,)inline(?:,|$)/ and next; print $physical * $blocksize, "#", '\
-'$length * $blocksize, "#", $logical * $blocksize, " "'
+FILEFRAG_FILTER='
+	if (/blocks of (\d+) bytes/) {
+		$blocksize = $1;
+		next
+	}
+	($ext, $logical, $physical, $length) =
+		(/^\s*(\d+):\s+(\d+)..\s+\d+:\s+(\d+)..\s+\d+:\s+(\d+):/)
+	or next;
+	print $physical * $blocksize, "#",
+	      $length * $blocksize, "#",
+	      $logical * $blocksize, " "'
 
 # this makes filefrag output script readable by using a perl helper.
 # output is one extent per line, with three numbers separated by '#'
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
