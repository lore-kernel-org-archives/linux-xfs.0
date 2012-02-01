Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q11E0hjG253123 for <xfs@oss.sgi.com>; Wed, 1 Feb 2012 08:00:43 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Yh6yJpBUZvbjQOsy (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 01 Feb 2012 06:00:39 -0800 (PST)
Message-Id: <20120201135719.202171828@bombadil.infradead.org>
Date: Wed, 01 Feb 2012 08:57:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/7] better dquot caching
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

This series improves handling of large number of dquots.  It replaced
the direct recycling of dquots from the freelist with a shrinker, removes
the upper bound of dquots, and uses per-filesystem structures for all
quota state, including switching from a hash to a radix-tree for lookups.

For repeated lookups of dquots out of a large pool I see improvements
betwen 50% and 500% compared to the previous code.  All these tests
have been performed with Q_XQUOTASYNC already disabled as it would
change the result to much for both the old and new code.

Note that the first patch probably is a candidate for Linux 3.3, as
the previous quota updates caused a lock order reversal in the old
quota reclaim code.  See the actual patch for more details.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
