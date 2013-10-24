Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 217367F37
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 16:59:27 -0500 (CDT)
Received: from eagdhcp-232-150.americas.sgi.com
	(eagdhcp-232-150.americas.sgi.com [128.162.232.150])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A28CAAC002
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 14:59:26 -0700 (PDT)
Received: from eagdhcp-232-150.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-150.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r9OLxQDH003248
	for <xfs@oss.sgi.com>; Thu, 24 Oct 2013 16:59:26 -0500 (CDT)
	(envelope-from tinguely@eagdhcp-232-150.americas.sgi.com)
Message-Id: <20131024215652.413619467@sgi.com>
Date: Thu, 24 Oct 2013 16:56:42 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfstest: fix filtering in 206 for ftype and projid32bit
Content-Disposition: inline; filename=xfstests-fix-206-ftype.patch
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
To: XFS Community <xfs@oss.sgi.com>

xfs/206 displays the output for mkfs.xfs, xfs_growfs and xfs_info.
Change the filtering to hide the new output for the field type
feature.

While cleaning up the ftype output, also clean up the projid32bit
output in xfs_growfs and xfs_info.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 tests/xfs/206 |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/tests/xfs/206
===================================================================
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -77,6 +77,7 @@ mkfs.xfs -f -bsize=4096 -dagsize=7628871
 	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
 		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
 		-e "s/, projid32bit=[0-9]//" \
+		-e "s/ ftype=[0-9]//" \
 		-e "/.*crc=/d"
 
 mount -o loop $tmpfile $tmpdir || _fail "!!! failed to loopback mount"
@@ -86,6 +87,8 @@ echo "=== xfs_growfs ==="
 xfs_growfs $tmpdir \
 	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
 		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
+		-e "s/, projid32bit=[0-9]//" \
+		-e "s/ ftype=[0-9]//" \
 		-e "/.*crc=/d"
 
 # and double-check the new geometry
@@ -93,6 +96,8 @@ echo "=== xfs_info ==="
 xfs_info $tmpdir \
 	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
 		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
+		-e "s/, projid32bit=[0-9]//" \
+		-e "s/ ftype=[0-9]//" \
 		-e "/.*crc=/d"
 
 # _cleanup cleans up for us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
