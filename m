Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1EIQ8Wr115776 for <xfs@oss.sgi.com>; Tue, 14 Feb 2012 12:26:08 -0600
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xeKDxrdsSBmYPFxN for
	<xfs@oss.sgi.com>; Tue, 14 Feb 2012 10:26:07 -0800 (PST)
Message-ID: <4F3AA739.1000009@redhat.com>
Date: Tue, 14 Feb 2012 10:26:01 -0800
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: more careful size grep in 256
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
Cc: Christoph Hellwig <hch@infradead.org>

Removing the "-F" flag in xfs_io changed stat output.

Before the change when -F was used, whether or not the file
was on xfs, it skipped the extra FSGEOM call.  Now that -F is 
removed, it calls FSGEOM if the file is on an xfs fs.  The "size" 
grep in test 256 was a bit too loose and matched 2 lines if the
FSGEOM output was present, breaking the test.

A more specific grep for stat.size fixes this.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/256 b/256
index 283c7f2..ffe172a 100755
--- a/256
+++ b/256
@@ -98,7 +98,7 @@ _fill_fs() {
 
 		if [ -f $dir/$file_count.bin ]
 		then
-			bytes_written=`$XFS_IO_PROG -F -c "stat"  $dir/$file_count.bin | grep size | cut -d ' ' -f3`
+			bytes_written=`$XFS_IO_PROG -F -c "stat"  $dir/$file_count.bin | grep stat.size | cut -d ' ' -f3`
 		fi
 
 		# If there was no room to make the file,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
