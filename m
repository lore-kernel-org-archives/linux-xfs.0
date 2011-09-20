Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KM0V3u086318 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 17:00:32 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BCA9C1C1CD8C
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 15:00:30 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	eAwpkl6HzI59gurm for <xfs@oss.sgi.com>;
	Tue, 20 Sep 2011 15:00:30 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R68Mg-0006wN-2g
	for xfs@oss.sgi.com; Tue, 20 Sep 2011 22:00:30 +0000
Message-Id: <20110920215917.508421839@bombadil.infradead.org>
Date: Tue, 20 Sep 2011 17:59:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] improve libxfs / xfs_repair I/O error handling
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

This series fixes various issues with handling of I/O errors in libxfs.
The most important one is patch 1, which fixes a regression introduced
in xfsprogs 3.0.0 that makes xfs_repair segfault for many read I/O errors.

I would recommend distributors to backport this patch to their releases.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
