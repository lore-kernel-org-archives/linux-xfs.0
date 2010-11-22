Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAMD7Qln228582 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 07:07:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 21B121C64EBF
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 05:09:03 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id teugMO7ZHm12IQU1 for
	<xfs@oss.sgi.com>; Mon, 22 Nov 2010 05:09:03 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PKW8l-0005bp-0Q
	for xfs@oss.sgi.com; Mon, 22 Nov 2010 13:09:03 +0000
Message-Id: <20101122130506.868076797@bombadil.infradead.org>
Date: Mon, 22 Nov 2010 08:05:06 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/10] writeback updates
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

This serious revamps a lot of the way we do the block mapping for
writeback.  It gets rid of the xfs_iomap interface and now calls
xfs_bmapi directly from __xfs_get_blocks and xfs_vm_writepage,
and simplifies the code in writepage a lot.

It removes about 200 lines of code and a superflous radix tree
lookup for already allocated blocks.

It also shows a pretty clear path to how we can get rid of buffer
heads.  The new writepage code shows that we rely very little on
buffers for writeback - I think we can relatively easy switch it
from looping over bufferheads to loop over the xfs_bmapi results
and it will still work.  We'll need some more work on the get_blocks
and truncate side, but I think we can pretty easily remove the
buffer heads in XFS without any replacement and just rely on the
extent cache in the inode underneath xfs_bmapi.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
