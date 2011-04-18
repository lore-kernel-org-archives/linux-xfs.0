Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3I6vIoP238899 for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 01:57:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17B3F1B750B6
	for <xfs@oss.sgi.com>; Mon, 18 Apr 2011 00:00:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id y34b6to7HQTJWn3f for
	<xfs@oss.sgi.com>; Mon, 18 Apr 2011 00:00:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QBiRv-0007Tr-84
	for xfs@oss.sgi.com; Mon, 18 Apr 2011 07:00:43 +0000
Message-Id: <20110418065936.355024592@bombadil.infradead.org>
Date: Mon, 18 Apr 2011 02:59:36 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] improved busy extent handling V4
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
