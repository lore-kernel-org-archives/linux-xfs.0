Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CLIt9o098739 for <xfs@oss.sgi.com>; Tue, 12 May 2009 16:18:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF07627F6D8
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 14:19:02 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KXxBGQiyTGqEdQaX for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 14:19:02 -0700 (PDT)
Message-Id: <20090512211607.197071000@bombadil.infradead.org>
Date: Tue, 12 May 2009 17:16:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/7] inode allocation cleanups
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


This series contains various cleanups and refactorings to xfs_ialloc.c,
some of them are my own and some are from Dave Chinner.

The last patch is also from Dave and speeds up the search for free inodes
in allocation groups with lots of inodes.  I ported it ontop of all
the previous patches, which made it a lot cleaner.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
