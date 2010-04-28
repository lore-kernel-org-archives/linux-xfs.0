Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SCSAGV232798 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:28:10 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13BF9154E9BD
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id R6L3utWpW35C7hI3 for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:14 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O76P8-0000kT-Eb
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 12:30:14 +0000
Message-Id: <20100428122850.075189557@bombadil.infradead.org>
Date: Wed, 28 Apr 2010 08:28:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/11] remove xfs_iomap
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

This series gets rid of the xfs_iomap structure which we use to
communicate between xfs_aops.c and xfs_iomap.c.  It's not a very
useful structure - we basically need block offsets above and below
it, but it's in terms of bytes.  Removing it and using the xfs_bmbt_irec
structure instead thus simplifies the code and reduces the stack footprint
of the writeback code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
