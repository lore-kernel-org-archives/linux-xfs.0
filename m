Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96IZqp4195426 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 13:35:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D87A145139E
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 11:42:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	6C3PAN5ZORN0EMH1 for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 11:42:39 -0700 (PDT)
Message-Id: <20111006183257.036884724@bombadil.infradead.org>
Date: Thu, 06 Oct 2011 14:32:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] fix AIL pushing under heavy concurrent metadata loads
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
Cc: Stefan Priebe <s.priebe@profihost.ag>

This series fixes hangs under heavy concurrent metadata workloads.  The
underlying issues seem fairly old but only really started to show when
enabling delaylog and the workqueue based AIL pushed.

A big thanks to Stefan Priebe for reporting the problem, providing a
reproducer and test filesystem image as well as testing the patches
on his system.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
