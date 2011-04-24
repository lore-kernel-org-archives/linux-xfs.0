Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3OJ3QGL075596 for <xfs@oss.sgi.com>; Sun, 24 Apr 2011 14:03:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F419B406A29
	for <xfs@oss.sgi.com>; Sun, 24 Apr 2011 12:06:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0UqI48oqwyaBPzW9 for
	<xfs@oss.sgi.com>; Sun, 24 Apr 2011 12:06:56 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QE4e0-0000hg-GG
	for xfs@oss.sgi.com; Sun, 24 Apr 2011 19:06:56 +0000
Message-Id: <20110424190613.404786382@bombadil.infradead.org>
Date: Sun, 24 Apr 2011 15:06:13 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] improved busy extent handling V5
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


This series optimizes how XFS deals with busy extents.  It starts to
track them exactly, and allows reuses where possible (metadata to metadata)
or else tries to avoid busy extents during allocations.  This means
we don't have a single log force due to busy extents during either
xfstests, compilebench or postmark on my testsystem, which can easily
be tracked using the new tracepoints added in the last patch.

Changes from V4:
 - fix xfs_alloc_busy_trim tracing
Changes from V3:
 - address review comments from Alex in patch 2
 - add a new patch to reduce pagb_lock roundtrips
Changes from V2:
 - remove the bmapi userdata tracking now that is unused
 - restructure the busy extent reuse code to make it more suitable
   for the discard support
 - reshuffle the patch boundaries

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
