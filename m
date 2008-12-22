Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMJapR9020925 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 13:36:51 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6FB7E3FDF8
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 11:36:50 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VimQGH5YMVds83Cr for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 11:36:50 -0800 (PST)
Date: Mon, 22 Dec 2008 11:58:50 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: xfstests testcase 111: Infinite xfs_bulkstat bad-inode loop case
	from Roger Willcocks
Message-ID: <20081222165848.GA17075@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Roger Willcocks <roger@filmlight.ltd.uk>
Cc: xfs@oss.sgi.com

Hi Roger,

I believe the xfstests case 111 is based on a report by you.  Do you
remember what was going on there?  From a look at the testcase it
overwrites an inode cluster and then tries to bulkstat them.  This works
fine with a non-debug kernel, but due to debug kernels panicing it fails
there.

Do you remember what the testcase was looking for?  I suspect we should
just not run it for debug kernels, but I'd like to know more about it
so we can add comments describing it.

Cheers,
	Christoph

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
