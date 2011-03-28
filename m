Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2SL65Co185400 for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 16:06:06 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8963015A5E7F
	for <xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:09:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id UzQ995rlkblrQcz4 for
	<xfs@oss.sgi.com>; Mon, 28 Mar 2011 14:09:14 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q4JgY-0001qe-EJ
	for xfs@oss.sgi.com; Mon, 28 Mar 2011 21:09:14 +0000
Message-Id: <20110328210614.832613417@bombadil.infradead.org>
Date: Mon, 28 Mar 2011 17:06:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/5] improved busy extent handling
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

This is a repost of the previous series and should address all review
comments.  The discard support, which relies on the exact busy extent
tracking has been dropped temporarily until I can fix up some issues
that I found during testing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
