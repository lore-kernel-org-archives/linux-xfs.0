Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C547C29E13
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 20:21:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5BEA7AC002
	for <xfs@oss.sgi.com>; Wed,  8 May 2013 18:21:56 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	h5HcrAC0nl7VH7Os for <xfs@oss.sgi.com>;
	Wed, 08 May 2013 18:21:55 -0700 (PDT)
Received: from [192.168.1.1] (helo=disappointment)
	by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1UaFYP-00039P-R7
	for xfs@oss.sgi.com; Thu, 09 May 2013 11:21:53 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1UaFYF-0003vX-PW
	for xfs@oss.sgi.com; Thu, 09 May 2013 11:21:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/3] xfstests: quota not supported on realtime filesystems
Date: Thu,  9 May 2013 11:21:40 +1000
Message-Id: <1368062501-15046-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1368062501-15046-1-git-send-email-david@fromorbit.com>
References: <1368062501-15046-1-git-send-email-david@fromorbit.com>
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

Also, fix _require_xfs_quota and _require_prjquota to have the same
checks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/quota |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/common/quota b/common/quota
index fd5374f..b320cf2 100644
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
@@ -62,6 +68,12 @@ _require_xfs_quota()
 {
     src/feature -q $TEST_DEV
     [ $? -ne 0 ] && _notrun "Installed kernel does not support XFS quota"
+    if [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_RTDEV" ]; then
+	_notrun "Quotas not supported on realtime test device"
+    fi
+    if [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ]; then
+	_notrun "Quotas not supported on realtime scratch device"
+    fi
     [ -n $XFS_QUOTA_PROG ] || _notrun "XFS quota user tools not installed"
 }
 
@@ -73,6 +85,9 @@ _require_prjquota()
     [ -n "$1" ] && _dev="$1" || _dev="$TEST_DEV"
     src/feature -p $_dev
     [ $? -ne 0 ] && _notrun "Installed kernel does not support project quotas"
+    if [ "$USE_EXTERNAL" = yes -a ! -z "$_dev" ]; then
+	_notrun "Project quotas not supported on realtime filesystem"
+    fi
 }
 
 #
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
