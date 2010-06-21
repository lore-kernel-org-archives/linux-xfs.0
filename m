Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L8XQ93113432 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 03:33:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0A00415113F9
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:36:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CvoE7trFdXshoR8f for
	<xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:36:06 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OQcUA-0007X1-As
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 08:36:06 +0000
Message-Id: <20100621083543.125860679@bombadil.infradead.org>
Date: Mon, 21 Jun 2010 04:35:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/12] various updates for 2.6.36
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

This is my current set of pending patches, with the writeback code updates,
various tracing updates, the write_inode speedup and a couple of cleanups.
Some of the patches have already been sent out individually, but this replaces
everything since may last big series on May 31st.  It requires that
patchset ("[PATCH 00/17] pending patches") to be fully applied and Dave's
"[PATCH 0/4, V2] xfs: validate inode numbers in file handles correctly"
from today to apply. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
