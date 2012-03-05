Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q25HQBuf232739 for <xfs@oss.sgi.com>; Mon, 5 Mar 2012 11:26:12 -0600
Received: from ysabell.rzone.de (ysabell.rzone.de [81.169.144.237]) by
	cuda.sgi.com with ESMTP id CDVNIXnqfiZKcZ3W for
	<xfs@oss.sgi.com>; Mon, 05 Mar 2012 09:26:10 -0800 (PST)
Received: from gargravarr.store (gargravarr.store [192.168.42.236])
	by ysabell.rzone.de (Postfix) with ESMTP id 4FB0E6BD
	for <xfs@oss.sgi.com>; Mon,  5 Mar 2012 18:26:09 +0100 (MET)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v2] xfstests: before test execution,
	print test number to syslog
Date: Mon,  5 Mar 2012 18:26:09 +0100
Message-Id: <1330968369-31779-1-git-send-email-sbehrens@giantdisaster.de>
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

When the xfstests are executed in a batch (like "check 001-299")
and produce syslog output, it is helpful to know which test was
causing the output. Therefore each time a test is started, a
syslog message is generated that contains the number of the
xfstest.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
Changes v1->v2:
- In order to avoid noise, check that /usr/bin/logger is there
  before trying to execute it. This usually should always be the
  case except for embedded environments.

 check |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/check b/check
index f792009..a4af0f6 100755
--- a/check
+++ b/check
@@ -241,6 +241,7 @@ do
 	start=`_wallclock`
 	$timestamp && echo -n "	["`date "+%T"`"]"
 	[ ! -x $seq ] && chmod u+x $seq # ensure we can run it
+	[ -x /usr/bin/logger ] && /usr/bin/logger "run xfstest $seq"
 	./$seq >$tmp.rawout 2>&1
 	sts=$?
 	$timestamp && _timestamp
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
