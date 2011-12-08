Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB8FxJ8o150198 for <xfs@oss.sgi.com>; Thu, 8 Dec 2011 09:59:20 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 58DAF1DC3F2E
	for <xfs@oss.sgi.com>; Thu,  8 Dec 2011 07:59:17 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	k6FjiRjsHNIEFQlC for <xfs@oss.sgi.com>;
	Thu, 08 Dec 2011 07:59:17 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RYgNR-0006ma-Gs
	for xfs@oss.sgi.com; Thu, 08 Dec 2011 15:59:17 +0000
Message-Id: <20111208155755.323930705@bombadil.infradead.org>
Date: Thu, 08 Dec 2011 10:57:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/11] inode shrink and misc updates
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

This series contains the inode shrink patches that have been sent out
before and a few related cleanups.  Most notably the file write path
is a lot leaner now that we could get rid of all the magic for the
xfs_inode i_size and i_new_size menipulations.

 31 files changed, 388 insertions(+), 559 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
