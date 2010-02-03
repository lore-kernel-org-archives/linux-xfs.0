Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o13La7Lv245566 for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 15:36:07 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B62D81376462
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2010 13:37:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nqCyWPbM1sWwL99O for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2010 13:37:16 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o13LbG4V004051
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 16:37:16 -0500
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o13LbDFw003157
	for <xfs@oss.sgi.com>; Wed, 3 Feb 2010 16:37:15 -0500
Message-ID: <4B69EC89.5050400@sandeen.net>
Date: Wed, 03 Feb 2010 15:37:13 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/3] xfstests: routine to create scratch of certain size
References: <4B69EC23.8040207@sandeen.net>
In-Reply-To: <4B69EC23.8040207@sandeen.net>
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
To: xfs mailing list <xfs@oss.sgi.com>

This is needed for later enospc tests to be generic

We have to explicitly call the mkfs rather than
_scratch_mkfs since extN wants nr-of-blocks as
an argument -after- the device name.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/common.rc b/common.rc
index 1edea2f..0a02a2b 100644
--- a/common.rc
+++ b/common.rc
@@ -305,6 +305,29 @@ _scratch_mkfs()
     esac
 }
 
+# Create fs of certain size on scratch device
+# _scratch_mkfs_sized <size in bytes> [optional blocksize]
+_scratch_mkfs_sized()
+{
+    fssize=$1
+    blocksize=$2
+    [ -z "$blocksize" ] && blocksize=4096
+    let blocks=$fssize/$blocksize
+
+    case $FSTYP in
+    xfs)
+	_scratch_mkfs_xfs -d size=$fssize -b size=$blocksize
+	;;
+    ext2|ext3|ext4)
+	/sbin/mkfs.$FSTYP -b $blocksize $SCRATCH_DEV $blocks
+	;;
+    *)
+	_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized"
+	;;
+    esac
+    _scratch_mkfs
+}
+
 # Emulate an N-data-disk stripe w/ various stripe units
 # _scratch_mkfs_geom <sunit bytes> <swidth multiplier> [optional blocksize]
 _scratch_mkfs_geom()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
