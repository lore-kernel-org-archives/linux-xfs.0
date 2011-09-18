Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKnBvO201698 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:49:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 717171C23412
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:49:10 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1SdE9uG5Fs3k0Xmr for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:49:10 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5OIX-0005wS-Mv
	for xfs@oss.sgi.com; Sun, 18 Sep 2011 20:49:09 +0000
Message-Id: <20110918204748.547510183@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:47:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] try to avoid locked inodes during log force
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

This series fixes a few places to unlock the inode before doing
synchronous log forces to avoid potential overly long log hold
times.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
