Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VKcL8c226682 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 15:38:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B04813B559C
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 13:41:46 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	EfVrV4cdC5yROcoA for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 13:41:46 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QyrYA-0006xF-1U
	for xfs@oss.sgi.com; Wed, 31 Aug 2011 20:38:18 +0000
Message-Id: <20110831203647.455809764@bombadil.infradead.org>
Date: Wed, 31 Aug 2011 16:36:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/14] RFC: quota updates
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

This is my current batch of quota updates.  Most important is the removal
of runtime explicit quota flusing, and a new lock order for the quota
manager locks.  In addition to that there are various cleanups.

This survices xfstests (with or without quotas enabled on the test device)
for quite a few runs, but I haven't done any performance testing.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
