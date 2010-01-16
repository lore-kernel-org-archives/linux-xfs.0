Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0G0fPU2144613 for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 18:41:35 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E5ECC1C5200D
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 16:41:46 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ahGvge8Ep5id6toN for
	<xfs@oss.sgi.com>; Fri, 15 Jan 2010 16:41:46 -0800 (PST)
Received: from int-mx08.intmail.prod.int.phx2.redhat.com
	(int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o0G0fftW018644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 19:41:41 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o0G0fbjg024640
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 15 Jan 2010 19:41:40 -0500
Message-ID: <4B510B41.3070904@redhat.com>
Date: Fri, 15 Jan 2010 18:41:37 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 073: unmount source image in cleanup
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

Test 073 is currently failing w/ xfs_repair problems, and when
it does, the whole series stops because the test dir still has
a loopback mounted filesystem on it, and it can't unmount.

Fix that.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/073 b/073
index 0ef9287..756c1c8 100755
--- a/073
+++ b/073
@@ -44,6 +44,7 @@ _cleanup()
 	umount $SCRATCH_MNT 2>/dev/null
 	umount -d $imgs.loop 2>/dev/null
 	[ -d $imgs.loop ] && rmdir $imgs.loop
+	umount -d $imgs.source_dir 2>/dev/null
 	[ -d $imgs.source_dir ] && rm -rf $imgs.source_dir
 	rm -f $imgs.* $tmp.* /var/tmp/xfs_copy.log.*
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
