Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O61pFU014156 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:01:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 516BE1397663
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:04:35 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	u3WDtTMNNclmPpeJ for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:04:35 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qw6X7-0003q1-K5
	for xfs@oss.sgi.com; Wed, 24 Aug 2011 06:01:49 +0000
Message-Id: <20110824055924.139283426@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 01:59:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] RFC: log all i_size updates
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

Given the bug we recently had pop up on IRC about lost i_size updates
when writing out inodes during umount I think it's time to stop relying
on the writeback code to get these things right for us, and always
log the inode size updates normally.  Patches 1 and 2 are preparations
that should go into the tree anyway, and patch 3 switches us to directly
log the size updates from the I/O completion handler.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
