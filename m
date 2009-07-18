Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6IMGqJO176609 for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 17:16:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C2278A5E09A
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:25:26 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 5E5LO1BNvsxKc8kK for
	<xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:25:26 -0700 (PDT)
Message-Id: <20090718221452.594956000@bombadil.infradead.org>
Date: Sat, 18 Jul 2009 18:14:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/9] fixes for memory allocator recursions into the filesystem
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
Cc: sage@newdream.net

lockdep has recently start tracking if a lock is used in reclaim context
and if so warns if we do allocations without the NOFS flag inside it.

This patch series fixes the easy targers involving the i_lock by switching
various allocations to the NOFS variant, or in case of the growfs code
moving the allocation out of the lock.

We still have some more issues that involve the iolock, but I think we
can simply get rid of the iolock in the reclaim path, but I'll send that
our for a separate discussion.

Sage, this should fix the two reports you've sent a while ago.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
