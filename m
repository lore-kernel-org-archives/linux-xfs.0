Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9L54HB2187816 for <xfs@oss.sgi.com>; Thu, 21 Oct 2010 00:04:17 -0500
Date: Thu, 21 Oct 2010 01:05:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/4] xfstests: handle filesystems without FIEMAP support
Message-ID: <20101021050531.GB1752@infradead.org>
References: <20101015222820.GA3655@infradead.org>
	<20101015222924.GD3781@infradead.org>
	<1287596221.2284.97.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1287596221.2284.97.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Oct 20, 2010 at 12:37:01PM -0500, Alex Elder wrote:
> Looks good, but I think if the operation is not
> supported you want to delete both "${fiemapfile}"
> and "${fiemaplog}".
> 
> While you're at it, make use of the "${fiemapfile}"
> variable in the fiemap-tester command...  (This
> appears to be a bug in the original test.)

Updated version below:

---
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/4] xfstests: handle filesystems without FIEMAP support

Do a _notrun in 225 if we get EOPNOSUPP back from FIEMAP instead
of failing the test.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/225
===================================================================
--- xfstests-dev.orig/225	2010-10-21 05:00:30.000000000 +0000
+++ xfstests-dev/225	2010-10-21 05:00:38.000000000 +0000
@@ -49,13 +49,26 @@ _supported_os Linux
 _setup_testdir
 
 fiemapfile=$TEST_DIR/fiemap.$$
+fiemaplog=$TEST_DIR/fiemap.$$.log
 
 [ -x $here/src/fiemap-tester ] || _notrun "fiemap-tester not built"
 
+_cleanup()
+{
+	rm -f $fiemapfile
+	rm -f $fiemaplog
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
 echo "fiemap run without preallocation"
-$here/src/fiemap-tester -q -p 0 -r 200 $TEST_DIR/fiemapfile
+$here/src/fiemap-tester -q -p 0 -r 200 $fiemapfile 2>&1 | tee $fiemaplog
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
