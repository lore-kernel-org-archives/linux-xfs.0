Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2MJwlM5046896 for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 14:58:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D1DF613FE44C
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 13:01:37 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id uwZVBxe3G2wvVcM3 for
	<xfs@oss.sgi.com>; Tue, 22 Mar 2011 13:01:37 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q27lp-0000pk-4e
	for xfs@oss.sgi.com; Tue, 22 Mar 2011 20:01:37 +0000
Message-Id: <20110322195550.260682574@bombadil.infradead.org>
Date: Tue, 22 Mar 2011 15:55:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/6] [PATCH 0/6] more efficient busy extent handling and
	discard support
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

This series updates the busy extent tracking to:

 a) keep exact track of busy extents
 b) allow reallocations where they are not a problem, that is generally
    everything but metadata -> userdata reallocations

The result is that compilebench is around 5% faster and neither it nor
any other workload I've thrown at the patchset causes a log force anymore.

The second to last patch also adds discard support, which is rather trivial
now that we do track the busy extents exactly.  The last patch further
optimizes the discard code to not stall the log state machine but
execute asynchronously.  This does however trigger a bug in the block
layer, for the report and a workaround see:

	http://marc.info/?l=linux-kernel&m=130082329118907&w=2

There is a few further optimizations we can add but I haven't done yet:

 - do not attempt to discard blocks on the AGFL, as the chance of reuse
   is very high, and we can't avoid reallocating from them
 - on SSDs preferably reuse blocks on the busy list to avoid discards

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
