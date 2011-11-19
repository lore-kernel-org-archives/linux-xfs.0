Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJIFiC7072043 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 12:15:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CBF1256F15A
	for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 10:15:43 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	LS7MSw7zqptc7EuC for <xfs@oss.sgi.com>;
	Sat, 19 Nov 2011 10:15:43 -0800 (PST)
Message-Id: <20111119181336.964593075@bombadil.infradead.org>
Date: Sat, 19 Nov 2011 13:13:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/9] XFS update for 3.0-stable
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
To: stable@vger.kernel.org
Cc: xfs@oss.sgi.com

This is the series of XFS fixes from current mainline which is important
enough for 3.0-stable.  All but the first three would also be needed
for 3.1-stable, but given the limited resources I plan to concentrate
on 3.0-stable.  If anyone wants to take care for 3.1 by building a kernel
with the remaining patches and run QA on them you are more welcome to
help out with that tree.

Note that while the description of

        xfs: don't serialise direct IO reads on page cache checks

doesn't mention that is is a regression fix we later noticed that a
large part of the speedups wasn't in fact new, but fixed a performance
regression introduced in Linux 2.6.38 with commit:

	xfs: introduce xfs_rw_lock() helpers for locking the inode

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
