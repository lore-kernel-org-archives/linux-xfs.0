Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2REcSxq093892 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 09:38:28 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	AMCKVbgh7QO1ufP2 (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 07:38:27 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCXXW-0004IE-51
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 14:38:26 +0000
Message-Id: <20120327143445.196524266@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 10:34:45 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/5] reduce exclusive ilock hold times V2
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

Changes from V1:
 - do not mark xfs_qm_need_dqattach as inline
 - various comment and commit message updates

I specificly did not add the delalloc assert in the direct I/O write path
in this series, as it triggers with or without this patch.  I will look into
that issue next.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
