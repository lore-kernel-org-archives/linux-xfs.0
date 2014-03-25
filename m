Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8E9FF29DF7
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 18:38:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3E405AC001
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 16:38:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HNMgJOJgAzBFXy7s for
	<xfs@oss.sgi.com>; Tue, 25 Mar 2014 16:38:31 -0700 (PDT)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2PNcVSx025972
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2014 19:38:31 -0400
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 5/5] xfstests: unmount TEST_DEV and SCRATCH_DEV after test run
Date: Wed, 26 Mar 2014 00:38:11 +0100
Message-Id: <1395790691-21161-5-git-send-email-lczerner@redhat.com>
In-Reply-To: <1395790691-21161-1-git-send-email-lczerner@redhat.com>
References: <1395790691-21161-1-git-send-email-lczerner@redhat.com>
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
Cc: Lukas Czerner <lczerner@redhat.com>

Unmount TEST_DEV and SCRATCH_DEV after each test run to avoid
mounting multiple devices on the same mount point which might result
in xfstest not being able to unmount the device later down the path.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 check | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/check b/check
index b3937b3..a26fbf7 100755
--- a/check
+++ b/check
@@ -620,6 +620,9 @@ for section in $HOST_OPTIONS_SECTIONS; do
 	done
 	_wrapup
 	echo
+
+	umount $TEST_DEV 2> /dev/null
+	umount $SCRATCH_DEV 2> /dev/null
 done
 
 interrupt=false
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
