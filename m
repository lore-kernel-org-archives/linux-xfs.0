Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8M8Uf0v216396 for <xfs@oss.sgi.com>; Thu, 22 Sep 2011 03:30:41 -0500
Subject: Re: xfstests 258: Test xfs fs creation with fs size close to 4 TB
From: Boris Ranto <branto@redhat.com>
In-Reply-To: <1316624075.2986.22.camel@doink>
References: <1316613160.781.8.camel@dhcp-26-208.brq.redhat.com>
	<1316624075.2986.22.camel@doink>
Date: Thu, 22 Sep 2011 10:30:29 +0200
Message-ID: <1316680229.6246.21.camel@dhcp-26-208.brq.redhat.com>
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
To: aelder@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Sandeen <sandeen@redhat.com>, Eric@oss.sgi.com, xfs-oss <xfs@oss.sgi.com>

On Wed, 2011-09-21 at 11:54 -0500, Alex Elder wrote:
> On Wed, 2011-09-21 at 15:52 +0200, Boris Ranto wrote:
> > mkfs.xfs failed to create xfs filesystems with 4 TB minus few bytes due
> > to round up error in mkfs.xfs code.
> > 
> > This test case is a regression test for the fs creation problem.
> > 
> > I've tested the test case with mkfs.xfs patch (in the form posted by
> > Eric Sandeen) and the test passed (and therefore the patch fixed the
> > issue for me).
> > 
> > Signed-off-by: Boris Ranto <branto@redhat.com>
> 
> This looks OK, but I'm a little concerned about the
> shell's ability to handle > 32-bit values in its
> arithmetic expressions (within $((...))).
> 
> Using ${fourtb} works for me, but I just don't know
> whether it is written somewhere that bash always
> supports 64-bit (or even arbitrary) precision values.
> 
> Do you know?
> 
> Same general concern goes for dd, but I am more inclined
> to think it can handle large numbers.
> 
> Otherwise this looks good to me (though I haven't yet
> tried it out).
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>
> 
> . . .
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

I'm not sure whether bash guarantees at least 64-bit precision values in
its arithmetic operations.
Therefore I suppose the values can be computed in advance in this case
and the arithmetic operation can be simply left out:

Signed-off-by: Boris Ranto <branto@redhat.com>

diff --git a/258 b/258
new file mode 100755
index 0000000..75f96d2
--- /dev/null
+++ b/258
@@ -0,0 +1,59 @@
+#! /bin/bash
+# FS QA Test No. 258
+#
+# Test fs creation on 4 TB minus few bytes partition
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Red Hat.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+# creator
+owner=branto@redhat.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f "$testfile"
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+testfile=$TEST_DIR/258.image
+
+for ddseek in 4398046511103 4398046510592 4398046510080 4398046510079
4398046509056 4398046507008;
+do
+	echo "Trying to make $ddseek B long xfs fs image"
+	rm -f "$testfile"
+	dd if=/dev/zero "of=$testfile" bs=1 count=0 seek=$ddseek >/dev/null
2>&1 || echo "dd failed"
+	lofile=$(losetup -f)
+	losetup $lofile "$testfile"
+	"$MKFS_XFS_PROG" -b size=512 $lofile >/dev/null || echo "mkfs failed!"
+	losetup -d $lofile
+done
+
+status=0 ; exit
diff --git a/258.out b/258.out
new file mode 100644
index 0000000..6f27c16
--- /dev/null
+++ b/258.out
@@ -0,0 +1,7 @@
+QA output created by 258
+Trying to make 4398046511103 B long xfs fs image
+Trying to make 4398046510592 B long xfs fs image
+Trying to make 4398046510080 B long xfs fs image
+Trying to make 4398046510079 B long xfs fs image
+Trying to make 4398046509056 B long xfs fs image
+Trying to make 4398046507008 B long xfs fs image
diff --git a/group b/group
index 84c45da..739f806 100644
--- a/group
+++ b/group
@@ -371,3 +371,4 @@ deprecated
 255 auto quick prealloc
 256 auto quick
 257 auto quick
+258 auto quick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
