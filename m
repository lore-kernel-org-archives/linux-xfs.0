Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A7C7F7F3F
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 09:14:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 95F6B8F8033
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 07:14:13 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id RqENwo8xSaCNFPAm for <linux-xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 07:14:09 -0700 (PDT)
Received: from Liberator.local (c-98-240-215-156.hsd1.mn.comcast.net
	[98.240.215.156])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4DC716A699EA
	for <linux-xfs@oss.sgi.com>; Thu, 26 Sep 2013 09:14:09 -0500 (CDT)
Message-ID: <52444130.6030000@sandeen.net>
Date: Thu, 26 Sep 2013 09:14:08 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: add xfs/291 to auto group
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
To: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

291 passes just fine w/ current xfsprogs on non-crc filesystems,
so add it to the auto group.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Not sure why I didn't do this in the first commit, sorry...


diff --git a/tests/xfs/group b/tests/xfs/group
index 352a4c5..17fff27 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -171,7 +171,7 @@
 283 dump ioctl auto quick
 287 auto dump quota quick
 290 auto rw prealloc quick ioctl
-291 repair
+291 auto repair
 292 auto mkfs quick
 293 auto quick
 295 auto logprint quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
