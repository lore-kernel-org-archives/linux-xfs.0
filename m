Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2VBQeHL137781 for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 06:26:40 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 61229391846
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2011 04:29:52 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QVH0IPT0IbVIsu3t for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2011 04:29:52 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q5G4V-0006OZ-UW
	for xfs@oss.sgi.com; Thu, 31 Mar 2011 11:29:52 +0000
Message-Id: <20110331112850.980290062@bombadil.infradead.org>
Date: Thu, 31 Mar 2011 07:28:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/5] online discard support
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

This patch series adds support for online discard of freed extents
when commit the transaction to disk.  The first patch is a hack
to fix the block layer, which can't deal with the I/O patterns we
submit and probably needs to be replaced with something better.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
