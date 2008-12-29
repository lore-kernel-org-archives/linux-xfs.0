Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTMIhcp009485 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 16:18:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CE0817945B1
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 14:18:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nrSR4wau9TCdKY3m for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 14:18:43 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LHQRf-0002df-74
	for xfs@oss.sgi.com; Mon, 29 Dec 2008 22:18:43 +0000
Message-Id: <20081229221802.268877000@bombadil.infradead.org>
Date: Mon, 29 Dec 2008 17:18:02 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 0/3] quota lockdep fixes
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

This series fixes various lockdep warnings in the quota code.  Given
that it doesn't affect code run in non-debug builds but shuts up the
latter I think it's a 2.6.29 candidate.

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
