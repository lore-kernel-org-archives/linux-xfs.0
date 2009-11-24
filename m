Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAOH4VOQ151256 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 11:04:31 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 945241D9BCEB
	for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 09:04:57 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id pMn7qEDZaKHsYgtu for
	<xfs@oss.sgi.com>; Tue, 24 Nov 2009 09:04:57 -0800 (PST)
Date: Tue, 24 Nov 2009 12:04:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: protecting per-ag access in the sync path
Message-ID: <20091124170455.GA9021@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

Since Linux 2.6.29 we use the perag structures a lot in the sync path,
but we're not actually protecting against the re-allocation in growfs.

I've recently received a new, fast SSD which allows me to hit those
races.  With it 104 reproducibly crashes the system, hitting the slab
redzoning for the old per-ag structure.  I experimentally put
synchronization using m_peraglock into xfs_inode_ag_walk which fixes the
issue at the cost of lock order reversals between the i_lock and the
m_peraglock in various places.

Any better idea how to protect the new sync path against growfs?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
