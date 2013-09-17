Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F035D7F56
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 14:30:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C9022304053
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 12:30:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id asuF92XNc6HbKEoS for
	<xfs@oss.sgi.com>; Tue, 17 Sep 2013 12:30:43 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r8HJUgam023637
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 15:30:42 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r8HJUfZN030180
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 17 Sep 2013 15:30:42 -0400
Message-ID: <5238ADE1.5050204@redhat.com>
Date: Tue, 17 Sep 2013 14:30:41 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: check for valid input to _scratch_mkfs_sized
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
To: xfs-oss <xfs@oss.sgi.com>

_scratch_mkfs_sized requires an integer number of bytes
as input; if it's given something else, catch it and _notrun.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common/rc b/common/rc
index 77e96c4..6afc164 100644
--- a/common/rc
+++ b/common/rc
@@ -569,6 +569,15 @@ _scratch_mkfs_sized()
     fssize=$1
     blocksize=$2
     [ -z "$blocksize" ] && blocksize=4096
+
+    re='^[0-9]+$'
+    if ! [[ $fssize =~ $re ]] ; then
+        _notrun "error: _scratch_mkfs_sized: fs size \"$fssize\" not an integer."
+    fi
+    if ! [[ $blocksize =~ $re ]] ; then
+        _notrun "error: _scratch_mkfs_sized: block size \"$blocksize\" not an integer."
+    fi
+
     blocks=`expr $fssize / $blocksize`
 
     if [ "$HOSTOS" == "Linux" ]; then


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
