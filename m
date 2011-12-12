Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCEEaSd101946 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 08:14:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5346F1EAB17A
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 06:14:33 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	4pr3jDs4GtvTHKMw for <xfs@oss.sgi.com>;
	Mon, 12 Dec 2011 06:14:33 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Ra6eH-0007r3-Dc
	for xfs@oss.sgi.com; Mon, 12 Dec 2011 14:14:33 +0000
Message-Id: <20111212141346.986825692@bombadil.infradead.org>
Date: Mon, 12 Dec 2011 09:13:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 00/12] log grant code cleanups
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

This series removes the opportunistic log space wakeups which had no
use but hiding real races for far too long, and applies various bits
of refactoring to the log grant code to make it smaller and more readable.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
