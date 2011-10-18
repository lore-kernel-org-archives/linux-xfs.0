Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9IKE8QD125180 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 15:14:08 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3ED001C964F0
	for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 13:14:05 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ukIfax8GbBTYFW33 for <xfs@oss.sgi.com>;
	Tue, 18 Oct 2011 13:14:05 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RGG33-0007Dq-1d
	for xfs@oss.sgi.com; Tue, 18 Oct 2011 20:14:05 +0000
Message-Id: <20111018201304.279051318@bombadil.infradead.org>
Date: Tue, 18 Oct 2011 16:13:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] inode diet, part1
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

This is the first simple part of shrinking the in-core XFS inodes.
It replaces a completion and a waitqueue with smaller bit-keyed
synchronization, just like we do in the VFS inode.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
