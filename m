Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 233AB7CA7
	for <xfs@oss.sgi.com>; Sat,  5 Mar 2016 14:22:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DB24230404E
	for <xfs@oss.sgi.com>; Sat,  5 Mar 2016 12:22:21 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gZhVRUGmICEN4m6E (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 05 Mar 2016 12:22:20 -0800 (PST)
Date: Sat, 5 Mar 2016 12:22:18 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/12] xfs/073: fix output
Message-ID: <20160305202218.GG10245@infradead.org>
References: <20160305003717.28738.98818.stgit@birch.djwong.org>
	<20160305003803.28738.34407.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160305003803.28738.34407.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Fixes one warning for my config, but adds two new ones (see below).
Looks like we need to do some better feature detection.


--- tests/xfs/073.out	2016-03-03 07:55:58.556427678 +0000
+++ /root/xfstests/results//xfs/073.out.bad	2016-03-05 20:21:07.368100504 +0000
@@ -1,6 +1,4 @@
 QA output created by 073
-warning: finobt not supported without CRC support, disabled.
-warning: rmapbt not supported without CRC support, disabled.
 warning: reflink not supported without CRC support, disabled.
 meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
 data     = bsize=XXX blocks=XXX, imaxpct=PCT
@@ -38,6 +36,7 @@
 unmounting and removing new image
 
 === copying scratch device to single target, large ro device
+warning: reflink not supported without CRC support, disabled.
 meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
 data     = bsize=XXX blocks=XXX, imaxpct=PCT
          = sunit=XXX swidth=XXX, unwritten=X
@@ -51,6 +50,7 @@
 checking new image
 mounting new image on loopback
 comparing new image files to old
+File /mnt/test/23382.source_dir/xfstests/dev is a block special file while file /mnt/test/23382.loop/xfstests/dev is a block special file
 comparing new image directories to old
 comparing new image geometry to old
 unmounting and removing new image

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
