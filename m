Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T0EZfX020644 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 19:14:35 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B48942FC6CF
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 17:16:38 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	RficI4xbllreNGpJ for <xfs@oss.sgi.com>;
	Wed, 28 Apr 2010 17:16:38 -0700 (PDT)
Received: from dastard (unverified [121.44.229.111])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	22474262-1927428
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 09:46:37 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1O7HQi-0007Pp-0C
	for xfs@oss.sgi.com; Thu, 29 Apr 2010 10:16:36 +1000
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1O7HQY-0007f0-DF
	for xfs@oss.sgi.com; Thu, 29 Apr 2010 10:16:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfsqa: keep xfs_fsr output around in test 222
Date: Thu, 29 Apr 2010 10:16:25 +1000
Message-Id: <1272500186-29393-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1272500186-29393-1-git-send-email-david@fromorbit.com>
References: <1272500186-29393-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

To confirm that xfs_fsr is doing the right thing, make it output debug
and verbose messages and store them in the 222.full file so that it
can be checked after the fact for correct operation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 222 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/222 b/222
index 574c181..a65c845 100644
--- a/222
+++ b/222
@@ -51,7 +51,7 @@ _supported_os Linux
 
 [ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
 
-xfs_fsr $TEST_MNT > /dev/null 2>&1
+xfs_fsr -d -v $TEST_MNT > $seq.full 2>&1
 
 echo "--- silence is golden ---"
 status=0 ; exit
-- 
1.5.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
