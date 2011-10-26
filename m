Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9QAkQb6002206 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 05:46:27 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F498FB4FFE
	for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 03:46:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wSu0tiBLnNxsPIvx for
	<xfs@oss.sgi.com>; Wed, 26 Oct 2011 03:46:26 -0700 (PDT)
Received: from int-mx12.intmail.prod.int.phx2.redhat.com
	(int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p9QAkPp3001713
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 06:46:25 -0400
Subject: [PATCH] xfstests 016: Do not discard blocks at the mkfs time
From: Boris Ranto <branto@redhat.com>
Date: Wed, 26 Oct 2011 12:46:23 +0200
Message-ID: <1319625983.3074.28.camel@dhcp-26-208.brq.redhat.com>
Mime-Version: 1.0
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
To: xfs <xfs@oss.sgi.com>, Eric Sandeen <esandeen@redhat.com>

The test 016 fills scratch device with some data and then creates xfs fs
on the scratch device. Later, the test assumes that the previously
written data are still in there and checks for them at specific
locations. On ssd drive this will lead to failure since the blocks are
discarded by default when the mkfs command is run.
This simple patch that adds -K to stop the discarding (if the mkfs
command supports it) fixed the issue for me:

Signed-off-by: Boris Ranto <branto@redhat.com>

diff --git a/016 b/016
index 9275ade..db76398 100755
--- a/016
+++ b/016
@@ -65,6 +65,8 @@ _init()
     $here/src/devzero -b 2048 -n 50 -v 198 $SCRATCH_DEV
     echo "*** mkfs"
     force_opts="-dsize=50m -lsize=$log_size"
+    # Do not discard blocks, we need them for further reads
+    _scratch_mkfs_xfs -N -K $force_opts >/dev/null 2>&1 &&
force_opts="-K $force_opts"
     echo mkfs_xfs $force_opts $SCRATCH_DEV >>$seq.full
     _scratch_mkfs_xfs $force_opts >$tmp.mkfs0 2>&1
     [ $? -ne 0 ] && \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
