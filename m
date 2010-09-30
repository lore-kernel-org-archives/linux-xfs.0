Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8U2P1pj114022 for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 21:25:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0AE9711696C9
	for <xfs@oss.sgi.com>; Wed, 29 Sep 2010 19:39:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cHKcqcDUHyvTzZ3J for
	<xfs@oss.sgi.com>; Wed, 29 Sep 2010 19:39:10 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P18qO-0007wF-S2
	for xfs@oss.sgi.com; Thu, 30 Sep 2010 02:26:00 +0000
Message-Id: <20100930022553.391390964@bombadil.infradead.org>
Date: Wed, 29 Sep 2010 22:25:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] streamline superblock modification helpers V2
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

Added the error path fixes pointed out by Alex and Dave, and made the
assert in xfs_mod_incore_sb conditional on using the percpu counters,
as well as a few cosmetic cleanups.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
