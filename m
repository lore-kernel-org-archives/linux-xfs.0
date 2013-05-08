Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A004529E34
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 01:04:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8FF4D8F8052
	for <xfs@oss.sgi.com>; Tue,  7 May 2013 23:04:52 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	a6INjmXsC1r1ltwd for <xfs@oss.sgi.com>;
	Tue, 07 May 2013 23:04:51 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UZxUL-0000pK-Jh
	for xfs@oss.sgi.com; Wed, 08 May 2013 16:04:29 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UZxUL-0002RC-Gk
	for xfs@oss.sgi.com; Wed, 08 May 2013 16:04:29 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfstests: quota not supported on realtime filesystems
Date: Wed,  8 May 2013 16:04:26 +1000
Message-Id: <1367993066-9313-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1367993066-9313-1-git-send-email-david@fromorbit.com>
References: <1367993066-9313-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Realtime XFS filesystems do not support quotas, so quota tests
always fail on such filesystems. Add a check to _require_quota to
detect this situation and notrun the quota tests...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/quota |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/common/quota b/common/quota
index fd5374f..3550cd4 100644
--- a/common/quota
+++ b/common/quota
@@ -40,6 +40,12 @@ _require_quota()
 	if [ ! -f /proc/fs/xfs/xqmstat ]; then
 	    _notrun "Installed kernel does not support XFS quotas"
         fi
+	if [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_RTDEV" ]; then
+	    _notrun "Quotas not supported on realtime test device"
+	fi
+	if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
+	    _notrun "Quotas not supported on realtime scratch device"
+	fi
 	;;
     *)
 	_notrun "disk quotas not supported by this filesystem type: $FSTYP"
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
