Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7EMPKGf008580 for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 17:25:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F06BDAEB4
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 15:25:17 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HGhgbqZAEbMEMkSg for <xfs@oss.sgi.com>;
	Sun, 14 Aug 2011 15:25:17 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qsj7N-000754-FT
	for xfs@oss.sgi.com; Sun, 14 Aug 2011 22:25:17 +0000
Message-Id: <20110814222412.359079843@bombadil.infradead.org>
Date: Sun, 14 Aug 2011 18:24:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/5] simply and speedup I/O completion handling
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

Get rid of our own counter for pending I/O completion handling which
is superflous and lifelock-prone, and optimize the code around it while
we're at it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
