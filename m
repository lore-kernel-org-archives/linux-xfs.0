Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o131rQpO203516 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 19:53:27 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B92C91C9B785
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 17:54:34 -0800 (PST)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id MhynKT2gwYGx9JMG for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2010 17:54:34 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id EDFE311203F1
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 19:54:33 -0600 (CST)
Message-ID: <4B68D75A.9020105@sandeen.net>
Date: Tue, 02 Feb 2010 19:54:34 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH V2] xfstests: routine to create scratch of certain size
References: <4B621D89.8070800@sandeen.net>
In-Reply-To: <4B621D89.8070800@sandeen.net>
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

This is needed for later enospc tests to be generic

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

V2: Address Christoph's comment about use of MKFS_OPTIONS;
just do it like the other geom helper and explicitly -set-
MKFS_OPTIONS for scratch, to set the size, then just call
_scratch_mkfs

(this would override any global MKFS_OPTIONS setting, but
I think that's ok for now, and not sure how these options might
interact w/ previously set MKFS_OPTIONS anyway)

diff --git a/common.rc b/common.rc
index 9c375dc..a6526a3 100644
--- a/common.rc
+++ b/common.rc
@@ -297,6 +297,29 @@ _scratch_mkfs()
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
+	MKFS_OPTIONS="-d size=$fssize -b size=$blocksize"
+	;;
+    ext2|ext3|ext4)
+	MKFS_OPTIONS="-b $blocksize $SCRATCH_DEV $blocks"
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
