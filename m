Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TE3dj6104742 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 09:03:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 285171D7DD29
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 07:03:36 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	toGiizS4yGjzmiIb for <xfs@oss.sgi.com>;
	Wed, 29 Jun 2011 07:03:36 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QbvMe-00089q-Ct
	for xfs@oss.sgi.com; Wed, 29 Jun 2011 14:03:36 +0000
Message-Id: <20110629140109.003209430@bombadil.infradead.org>
Date: Wed, 29 Jun 2011 10:01:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/27] patch queue for Linux 3.1
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

This is my current patch queue for Linux 3.1.  It includes the previously
all previously sent patches I'm planning for Linux 3.1 inclusion through
the XFS tree and a few new ones.  The most important new bits is a cleanup
of the structures describing the dir2 on-disk format, which got a bit
more urgent due to more recent gcc versions complaining about the hacks
used in the current version.

The sync lifelock fix is included only in a minimal version that removes
the data syncs.  I plan to sort out the iocount waiting via the i_alloc_sem
removal patches that have been sent for inclusion in the VFS tree.  I'll
cc the XFS list on the updated version with XFS chances.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
