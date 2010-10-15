Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9FMSER5158249 for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 17:28:14 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58A60F4ECA
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 15:29:25 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id 9KdpxfrAciYVNnh2 for
	<xfs@oss.sgi.com>; Fri, 15 Oct 2010 15:29:25 -0700 (PDT)
Received: from hch by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P6smC-0000zS-Re
	for xfs@oss.sgi.com; Fri, 15 Oct 2010 22:29:24 +0000
Date: Fri, 15 Oct 2010 18:29:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] xfstests: handle filesystems without FIEMAP support
Message-ID: <20101015222924.GD3781@infradead.org>
References: <20101015222820.GA3655@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101015222820.GA3655@infradead.org>
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
To: xfs@oss.sgi.com

Do a _notrun in 225 if we get EOPNOSUPP back from FIEMAP instead
of failing the test.

Signed-off-by: Christoph Hellwig <hch@lst.de>

--- a/225
+++ b/225
@@ -49,13 +49,19 @@ _supported_os Linux
 _setup_testdir
 
 fiemapfile=$TEST_DIR/fiemap.$$
+fiemaplog=$TEST_DIR/fiemap.$$.log
 
 [ -x $here/src/fiemap-tester ] || _notrun "fiemap-tester not built"
 
 echo "fiemap run without preallocation"
-$here/src/fiemap-tester -q -p 0 -r 200 $TEST_DIR/fiemapfile
+$here/src/fiemap-tester -q -p 0 -r 200 $TEST_DIR/fiemapfile 2>&1 | tee $fiemaplog
+
+if grep -q "Operation not supported" $fiemaplog; then
+      _notrun "FIEMAP not supported by this filesystem type: $FSTYP"
+fi
 
 rm -f $fiemapfile
+rm -f $fiemaplog
 rm -f $seq.full
 
 status=0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
