Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9S9c9bg144445 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 04:38:10 -0500
Received: from mx3-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76C542028AC
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 02:38:08 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id XSGtNpI9xYosTrly for
	<xfs@oss.sgi.com>; Fri, 28 Oct 2011 02:38:08 -0700 (PDT)
Date: Fri, 28 Oct 2011 05:38:06 -0400 (EDT)
From: Boris Ranto <branto@redhat.com>
Subject: [PATCH] xfstests 016: Do not discard blocks at the mkfs time,
	more verbose version
Message-ID: <be02ada1-aee5-406d-84cd-d54dde7ae871@zmail16.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1319625983.3074.28.camel@dhcp-26-208.brq.redhat.com>
MIME-Version: 1.0
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
To: xfs <xfs@oss.sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <esandeen@redhat.com>

The test 016 fills scratch device with some data and then creates xfs fs
on the scratch device. Later, the test assumes that the previously
written data are still written there and checks for them at specific
locations. On ssd drive this will lead to a failure since the blocks are
discarded by default when the mkfs command is run.
This is a more verbose version of the previous patch.
This simple patch that adds -K to stop the discarding (if the mkfs
command supports it) fixed the issue for me:

Signed-off-by: Boris Ranto <branto@redhat.com>

diff --git a/016 b/016
index 9275ade..08a73f4 100755
--- a/016
+++ b/016
@@ -65,6 +65,15 @@ _init()
     $here/src/devzero -b 2048 -n 50 -v 198 $SCRATCH_DEV
     echo "*** mkfs"
     force_opts="-dsize=50m -lsize=$log_size"
+    #
+    # Do not discard blocks as we check for patterns in free space.
+    # 
+    # First, make sure that mkfs supports '-K' option by using its
+    # dry run (-N option) and then add it to the force_opts.
+    #
+    if _scratch_mkfs_xfs -N -K $force_opts >/dev/null 2>&1; then
+        force_opts="-K $force_opts"
+    fi
     echo mkfs_xfs $force_opts $SCRATCH_DEV >>$seq.full
     _scratch_mkfs_xfs $force_opts >$tmp.mkfs0 2>&1
     [ $? -ne 0 ] && \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
