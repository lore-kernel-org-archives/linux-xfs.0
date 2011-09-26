Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8QBj1MZ155536 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 06:45:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB80C160E003
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 04:50:50 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	b4jRb2v6RX4Kj63r for <xfs@oss.sgi.com>;
	Mon, 26 Sep 2011 04:50:50 -0700 (PDT)
Date: Mon, 26 Sep 2011 07:44:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfstests 258: Test xfs fs creation with fs size close to 4 TB
Message-ID: <20110926114458.GA1176@infradead.org>
References: <1316613160.781.8.camel@dhcp-26-208.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1316613160.781.8.camel@dhcp-26-208.brq.redhat.com>
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
To: Boris Ranto <branto@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

This one actually fails for me in a 32-bit userspace VM:

--- 259.out	2011-09-26 09:14:39.000000000 +0000
+++ 259.out.bad	2011-09-26 11:22:44.000000000 +0000
@@ -1,7 +1,157 @@
 QA output created by 259
 Trying to make 4398046511103 B long xfs fs image
+dd failed
+can't get size of data subvolume
+Usage: mkfs.xfs
+/* blocksize */		[-b log=n|size=num]

...

When removing the dd output redirection thus turn into a:

+dd: failed to truncate to 4398046509056 bytes in output file `/259.image': File too large

As it turns out testfile is assigned to early in the test, and we thus
create the images on the root filesystem.

---
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfstests: fix test 259

Move the assignment of testfile after the sourcing of the common.* files to
make sure TEST_DIR is already defined - without this we end up creating
the file on the root filesystem, which may not support large enough files.

Also add a sync after the mkfs.xfs invocation, as losetup -d might fail
the loop device deletion with -EBUSY otherwise.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/259
===================================================================
--- xfstests-dev.orig/259	2011-09-26 11:29:17.000000000 +0000
+++ xfstests-dev/259	2011-09-26 11:32:54.000000000 +0000
@@ -29,8 +29,6 @@ echo "QA output created by $seq"
 
 status=1	# failure is the default!
 
-testfile=$TEST_DIR/259.image
-
 _cleanup()
 {
     rm -f "$testfile"
@@ -45,6 +43,8 @@ trap "_cleanup ; exit \$status" 0 1 2 3
 _supported_fs xfs
 _supported_os Linux
 
+testfile=$TEST_DIR/259.image
+
 # Test various sizes slightly less than 4 TB
 # 4398046511103 = 2^42 - 1
 # 4398046510592 = 2^42 - 512
@@ -63,6 +63,7 @@ do
 	lofile=$(losetup -f)
 	losetup $lofile "$testfile"
 	"$MKFS_XFS_PROG" -b size=512 $lofile >/dev/null || echo "mkfs failed!"
+	sync
 	losetup -d $lofile
 done
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
