Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n73LhuIq116472 for <xfs@oss.sgi.com>; Mon, 3 Aug 2009 16:43:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 907993A2561
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2009 14:44:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 1I9oVPeozT5SLguh for
	<xfs@oss.sgi.com>; Mon, 03 Aug 2009 14:44:46 -0700 (PDT)
Date: Mon, 3 Aug 2009 17:44:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for July 2009
Message-ID: <20090803214445.GA3167@infradead.org>
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
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

As a traditional summer vacation month July has not seen a lot of XFS
activity.  The mainline 2.6.31 kernel made it to the 5th release candidate
but besides a few kernel-wide patches touching XFS the only activity were
two small patches fixing a bug in FIEMAP and working around writeback
performance problems in the VM.

A few more patches were posted to the list but haven't been merged yet.
Two big patch series deal with theoretically possible deadlocks due to
locks taken in reclaim contexts, which are now detected by lockdep.

The pace on the userspace side has been slow.  There have been a couple
of fixes to xfs_repair and xfs_db, and xfstests grew a few more testcases.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
