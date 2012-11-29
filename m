Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qATIj6rn068273 for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 12:45:06 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EvTVutPyZ4FxsBhS for
	<xfs@oss.sgi.com>; Thu, 29 Nov 2012 10:47:24 -0800 (PST)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qATIlN2r032715
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 13:47:23 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id qATIlMMW009856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 29 Nov 2012 13:47:23 -0500
Message-ID: <50B7ADBA.5020509@redhat.com>
Date: Thu, 29 Nov 2012 12:47:22 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: _fail in _scratch_mkfs_sized if device is too small
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

Without this, 273 was failing in cryptic ways for me
if the device size was < 2G.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common.rc b/common.rc
index bf9c86f..8906067 100644
--- a/common.rc
+++ b/common.rc
@@ -348,6 +348,11 @@ _scratch_mkfs_sized()
     [ -z "$blocksize" ] && blocksize=4096
     blocks=`expr $fssize / $blocksize`
 
+    if [ "$HOSTOS" == "Linux" ]; then
+	devsize=`blockdev --getsize64 $SCRATCH_DEV`
+	[ "$fssize" -gt "$devsize" ] && _notrun "Scratch device too small"
+    fi
+
     case $FSTYP in
     xfs)
 	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
