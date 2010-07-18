Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6ILFLmR165739 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 16:15:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C9A415EDA90
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 14:18:20 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XUVU2CRDCDIHtPPh for
	<xfs@oss.sgi.com>; Sun, 18 Jul 2010 14:18:20 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OabFb-0005Pd-UH
	for xfs@oss.sgi.com; Sun, 18 Jul 2010 21:18:20 +0000
Message-Id: <20100718211708.327705876@bombadil.infradead.org>
Date: Sun, 18 Jul 2010 17:17:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] direct I/O fixes and speedups
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The first two patches are the AIO/DIO vs unwritten extent conversion
fixes already sent out before.  The first patch will go in through
both the XFS and ext4 tree, so it needs to be applied as-is to not
cause any problems.

The last patch optimized the I/O completion handling for direct I/O.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
