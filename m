Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2O3W9EJ184468 for <xfs@oss.sgi.com>; Tue, 23 Mar 2010 22:32:10 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3810C26FB36
	for <xfs@oss.sgi.com>; Tue, 23 Mar 2010 20:28:50 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id LTHDys79EcgRP2oI for
	<xfs@oss.sgi.com>; Tue, 23 Mar 2010 20:28:50 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 1ACC99E847E
	for <xfs@oss.sgi.com>; Tue, 23 Mar 2010 22:28:50 -0500 (CDT)
Message-ID: <4BA986F1.4080407@sandeen.net>
Date: Tue, 23 Mar 2010 22:28:49 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: drop readlink of test devices
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Comments say it's for devfs; it's actually breaking lvm devices, now.
I think we can just drop it.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/common.config b/common.config
index 26906aa..926846b 100644
--- a/common.config
+++ b/common.config
@@ -230,30 +230,5 @@ if [ ! -z "$SCRATCH_MNT" -a ! -d "$SCRATCH_MNT" ]; then
     exit 1
 fi
 
-_readlink()
-{
-    if [ $# -ne 1 ]; then
-        echo "Usage: _readlink filename" 1>&2
-        exit 1
-    fi
-
-    perl -e "\$in=\"$1\";" -e '
-    $lnk = readlink($in);
-    if ($lnk =~ m!^/.*!) {
-        print "$lnk\n";
-    }
-    else {
-        chomp($dir = `dirname $in`);
-        print "$dir/$lnk\n";
-    }'
-}
-
-# if devfs is running expand the full /dev/.. pathname - this is what will be
-# returned by utilities such as mount
-[ -L "$TEST_DEV" ] && TEST_DEV=`_readlink $TEST_DEV`
-[ -L "$SCRATCH_DEV" ] && SCRATCH_DEV=`_readlink $SCRATCH_DEV`
-[ -L "$SCRATCH_LOGDEV" ] && SCRATCH_LOGDEV=`_readlink $SCRATCH_LOGDEV`
-[ -L "$SCRATCH_RTDEV" ] && SCRATCH_RTDEV=`_readlink $SCRATCH_LOGDEV`
-
 # make sure this script returns success
 /bin/true

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
