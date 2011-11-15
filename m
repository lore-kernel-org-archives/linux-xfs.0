Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAFKETlk067878 for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 14:14:29 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 73C981303890
	for <xfs@oss.sgi.com>; Tue, 15 Nov 2011 12:14:27 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HApNBFNb78k6ERaT for <xfs@oss.sgi.com>;
	Tue, 15 Nov 2011 12:14:27 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RQPOk-0007Qk-Bo
	for xfs@oss.sgi.com; Tue, 15 Nov 2011 20:14:26 +0000
Message-Id: <20111115201407.038216766@bombadil.infradead.org>
Date: Tue, 15 Nov 2011 15:14:07 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/5] for-3.2 queue
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

With more reports showing up that the VFS writeback code is not able
to write back our size updates dirtied from the I/O completion handler
in reasonable time I think it's time to move to logging all file size
updates ASAP, that is for 3.2 and maybe after a reasonable testing
period even -stable.

This series has been sent out a few times, and I've been doing QA on
it for weeks.  Note that I haven't implemented the log space reservations
from ->writepage - see the actual patch for the rationale.

Also throw in the fork offset fix as it's an user-triggerable oops.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
