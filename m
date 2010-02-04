Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14MHCNK094794 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 16:17:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2CD801CA4D17
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 14:18:22 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UXD2StiEXwT20KFm for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2010 14:18:22 -0800 (PST)
Date: Thu, 4 Feb 2010 17:18:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] mkfs.xfs fix detection of empty devices
Message-ID: <20100204221822.GA26670@infradead.org>
References: <4B6AF6FC.6030101@redhat.com> <20100204194000.GA7229@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100204194000.GA7229@infradead.org>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jim Meyering <meyering@redhat.com>, xfs mailing list <xfs@oss.sgi.com>

We currently fail to detect that a device does indeed not contain any
signature and we are indeed fine to proceed with it due to mishandling
the return value of blkid_do_fullprobe.  Fix that up and add some
better diagnostics of the blkid detection.

from RH bugzilla https://bugzilla.redhat.com/show_bug.cgi?id=561870

# dd if=/dev/zero of=k bs=1MB count=2 seek=20; mkfs.xfs k 
# mkfs.xfs: probe of k failed, cannot detect existing filesystem.
# mkfs.xfs: Use the -f option to force overwrite

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfsprogs-dev/mkfs/xfs_mkfs.c
===================================================================
--- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2010-02-04 20:30:26.000000000 +0000
+++ xfsprogs-dev/mkfs/xfs_mkfs.c	2010-02-04 20:43:41.000000000 +0000
@@ -322,24 +322,40 @@ check_overwrite(
 	if (!pr)
 		goto out;
 
-	if (blkid_probe_enable_partitions(pr, 1))
+	ret = blkid_probe_enable_partitions(pr, 1);
+	if (ret < 0)
 		goto out;
 
-	if (blkid_do_fullprobe(pr))
+	ret = blkid_do_fullprobe(pr);
+	if (ret < 0)
 		goto out;
 
-	ret = 0;
+	/*
+	 * Blkid returns 1 for nothing found and 0 when it finds a signature,
+	 * but we want the exact opposite, so reverse the return value here.
+	 *
+	 * In addition print some useful diagnostics about what actually is
+	 * on the device.
+	 */
+	if (ret) {
+		ret = 0;
+		goto out;
+	}
+
 	if (!blkid_probe_lookup_value(pr, "TYPE", &type, NULL)) {
 		fprintf(stderr,
 			_("%s: %s appears to contain an existing "
 			"filesystem (%s).\n"), progname, device, type);
-		ret = 1;
 	} else if (!blkid_probe_lookup_value(pr, "PTTYPE", &type, NULL)) {
 		fprintf(stderr,
 			_("%s: %s appears to contain a partition "
 			"table (%s).\n"), progname, device, type);
-		ret = 1;
+	} else {
+		fprintf(stderr,
+			_("%s: %s appears to contain something weird "
+			"according to blkid\n"), progname, device);
 	}
+	ret = 1;
 
 out:
 	if (pr)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
