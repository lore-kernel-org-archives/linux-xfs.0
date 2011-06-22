Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5MK5bei120667 for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 15:05:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34C5F11E6644
	for <xfs@oss.sgi.com>; Wed, 22 Jun 2011 13:05:31 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	TLEBEiCkXJWwZYKi for <xfs@oss.sgi.com>;
	Wed, 22 Jun 2011 13:05:31 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QZTg2-0007qP-Ex
	for xfs@oss.sgi.com; Wed, 22 Jun 2011 20:05:30 +0000
Message-Id: <20110622200129.218994186@bombadil.infradead.org>
Date: Wed, 22 Jun 2011 16:01:29 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] RFC: always log inode updates and sync fixes
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

This combines patches that aren't really related, but have interdependenies
in their implementation.

Two patches remove the remaining use of the VFS dirty tracking in XFS
and replaces them by logging file size and timestamp updates directly.
These work fine, and performance doesn't show major changes in the few
benchmarks I've run.  They are still missing the fdatasync optimization
which I have to reimplement.

The last patch in the series is a respin of the previous sync lifelock
fix, now actually working correctly due to the lack of non-transactional
updates, and EAGAIN requeueing in the I/O completion workqueues.

Note: this series requires the previous misc updates for Linux 3.1 series
applied first.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
