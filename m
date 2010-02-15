Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1F9ilNB047246 for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 03:44:49 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D35331D0406
	for <xfs@oss.sgi.com>; Mon, 15 Feb 2010 01:46:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zBt2WXd2rA7ddhRQ for
	<xfs@oss.sgi.com>; Mon, 15 Feb 2010 01:46:04 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NgxWl-0000DU-Pa
	for xfs@oss.sgi.com; Mon, 15 Feb 2010 09:46:03 +0000
Message-Id: <20100215094445.528696829@bombadil.infradead.org>
Date: Mon, 15 Feb 2010 04:44:45 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] implement optimized fdatasync
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

This series implements a real fdatasync, that is one that is not
simply identical to fdatasync, but one that skips logging the inode
if there are only timestamp updates.

In fact the first three patches are just broad cleanups to get the
code into shape for the rather small patch 4 implementing the optimization.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
