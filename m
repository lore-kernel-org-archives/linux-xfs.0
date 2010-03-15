Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o2FFr77V061596 for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 10:53:07 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EE288142E945
	for <xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:54:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kiBA9bWkD27yfKER for
	<xfs@oss.sgi.com>; Mon, 15 Mar 2010 08:54:42 -0700 (PDT)
Message-Id: <20100315155151.642965370@bombadil.infradead.org>
Date: Mon, 15 Mar 2010 11:51:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] xfs_log_write cleanups and vector support
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
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

As mention during the review of the first posting of the transaction
subsystem cleanup series I really didn't like the concept of mixing
the xfs_log_write cleanup with adding the new vector functionality.

Here's a patch series to reshuffle this work into a series that I
feel able to follow and throw in some minimal additional cleanups.

First patch is the factoring out of helpers from xlog_write without
functionality change, second is a re-indent of xlog_write including
moving variable declaration to inner blocks, again without functionality
change, third is the introduction of the log vectors, including the
relatively small changes in xlog_write, and fourth is a small incremental
cleanup patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
