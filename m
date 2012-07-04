Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q64EuHjH221626 for <xfs@oss.sgi.com>; Wed, 4 Jul 2012 09:56:18 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	0cftW35H7mO946ZV (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 04 Jul 2012 07:56:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SmR02-0002ib-L1
	for xfs@oss.sgi.com; Wed, 04 Jul 2012 14:56:14 +0000
Message-Id: <20120704145444.863203951@bombadil.infradead.org>
Date: Wed, 04 Jul 2012 10:54:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/7] inode allocator refactoring V2
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

This series turns the higher level inode allocator upside down.

The biggest change is that we try to operate on the incore perag
structure as much as possible instead of reading the AGI buffer.

I don't have a system to measure the benefit on the large create benchmarks
right now, but even if it's not benefitial it at least greatly cleans up
the code.

Changes since V1:
  - minor cleanups noted by Dave

Note that this does not collapse the three passes in xfs_dialloc yet -
I tried it and got deadlocks that I haven't fully understood yet.  I plan
to look into them when I get a bit more time.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
