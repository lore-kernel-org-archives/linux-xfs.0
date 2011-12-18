Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBIK1XXK241056 for <xfs@oss.sgi.com>; Sun, 18 Dec 2011 14:01:34 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	PQEblBTtJsxPxGso for <xfs@oss.sgi.com>;
	Sun, 18 Dec 2011 12:01:31 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RcMvK-0000tr-LV
	for xfs@oss.sgi.com; Sun, 18 Dec 2011 20:01:30 +0000
Message-Id: <20111218200003.557507716@bombadil.infradead.org>
Date: Sun, 18 Dec 2011 15:00:03 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/11] inode shrink and misc updates V2
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

This series contains the inode shrink patches and a few related cleanups.
Most notably the file write path is a lot leaner now that we could get rid
of all the magic for the xfs_inode i_size and i_new_size menipulations.

 31 files changed, 388 insertions(+), 559 deletions(-)

Changes from V1:
  - update commit messages based on Daves feedback

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
