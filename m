Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2QLG7Op093870 for <xfs@oss.sgi.com>; Mon, 26 Mar 2012 16:16:07 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	y6mVUWbrSfM37yyG (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 26 Mar 2012 14:16:03 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCHGk-0000qh-Uq
	for xfs@oss.sgi.com; Mon, 26 Mar 2012 21:16:02 +0000
Message-Id: <20120326211421.518374058@bombadil.infradead.org>
Date: Mon, 26 Mar 2012 17:14:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/5] reduce exclusive ilock hold times
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

This series tries to reduce the amount we hold the ilock exclusively,
especially during direct I/O writes where they currently hurt us.

Dave showed that his earlier version which is less aggressive than this
one can already provide magnitudes of better throughput and iops for
parallel direct I/O workloads, and this one should be even better.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
