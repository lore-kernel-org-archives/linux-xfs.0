Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9D17D7F6D
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 16:10:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7610F8F8035
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2014 14:10:37 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id uxI7zly4M5UmX5it for <xfs@oss.sgi.com>;
	Fri, 13 Jun 2014 14:10:36 -0700 (PDT)
Message-ID: <539B68D2.2000300@sandeen.net>
Date: Fri, 13 Jun 2014 16:10:42 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs/279: use MKFS_XFS_PROG, not hardcoded path
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
To: xfs-oss <xfs@oss.sgi.com>, fstests@vger.kernel.org

I'm really not sure why this wasn't this way from the start.
On some systems it's in /usr/sbin, and the test fails.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/xfs/279 b/tests/xfs/279
index 872f8be..cde7d21 100755
--- a/tests/xfs/279
+++ b/tests/xfs/279
@@ -62,7 +62,7 @@ _check_mkfs()
 {
 	echo "===================" 
 	echo "mkfs with opts: $@" | sed -e "s,/dev/sd.,DEVICE,"
-	/sbin/mkfs.xfs $@ 2>/dev/null > $tmp.mkfs.full
+	$MKFS_XFS_PROG $@ 2>/dev/null > $tmp.mkfs.full
 	if [ $? -ne 0 ]; then
 		echo "Failed."
 		return

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
