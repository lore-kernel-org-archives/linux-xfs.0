Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A97C07F3F
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 06:13:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 93B6C8F8035
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 04:13:14 -0800 (PST)
Received: from mail-pa0-f49.google.com (mail-pa0-f49.google.com
	[209.85.220.49]) by cuda.sgi.com with ESMTP id YJgljdPW0qAzIfuy
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 10 Feb 2014 04:13:13 -0800 (PST)
Received: by mail-pa0-f49.google.com with SMTP id hz1so6099416pad.36
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 04:13:12 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] xfstests: btrfs/004: fix to make test really work
Date: Mon, 10 Feb 2014 20:10:56 +0800
Message-Id: <1392034256-2412-1-git-send-email-wangshilong1991@gmail.com>
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
Cc: linux-btrfs@vger.kernel.org, Wang Shilong <wangsl.fnst@cn.fujitsu.com>

From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>

So i was wandering why test 004 could pass my previous wrong
kernel patch while it defenitely should not.

By some debugging, i found here perl script is wrong, we did not
filter out anything and this unit test did not work acutally.so
it came out we will never fail this test.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 tests/btrfs/004 | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)
 mode change 100755 => 100644 tests/btrfs/004

diff --git a/tests/btrfs/004 b/tests/btrfs/004
old mode 100755
new mode 100644
index 14da9f1..17a6e34
--- a/tests/btrfs/004
+++ b/tests/btrfs/004
@@ -57,10 +57,9 @@ _require_command "/usr/sbin/filefrag"
 
 rm -f $seqres.full
 
-FILEFRAG_FILTER='if (/, blocksize (\d+)/) {$blocksize = $1; next} ($ext, '\
-'$logical, $physical, $expected, $length, $flags) = (/^\s*(\d+)\s+(\d+)'\
-'\s+(\d+)\s+(?:(\d+)\s+)?(\d+)\s+(.*)/) or next; $flags =~ '\
-'/(?:^|,)inline(?:,|$)/ and next; print $physical * $blocksize, "#", '\
+FILEFRAG_FILTER='if (/blocks of (\d+) bytes/) {$blocksize = $1; next} ($ext, '\
+'$logical, $physical, $length) = (/^\s*(\d+):\s+(\d+)..\s+\d+:'\
+'\s+(\d+)..\s+\d+:\s+(\d+):/) or next; print $physical * $blocksize, "#", '\
 '$length * $blocksize, "#", $logical * $blocksize, " "'
 
 # this makes filefrag output script readable by using a perl helper.
-- 
1.8.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
