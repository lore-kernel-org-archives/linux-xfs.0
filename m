Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q55Emcjs093250 for <xfs@oss.sgi.com>; Tue, 5 Jun 2012 09:48:38 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	7tT4n0GgWCVK6YTM (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Jun 2012 07:48:36 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Sbv3j-0004y5-Bb
	for xfs@oss.sgi.com; Tue, 05 Jun 2012 14:48:35 +0000
Message-Id: <20120605144647.051012936@bombadil.infradead.org>
Date: Tue, 05 Jun 2012 10:46:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/7] inode allocator refactoring
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
