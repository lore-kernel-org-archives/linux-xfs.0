Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8GDIRNv056385 for <xfs@oss.sgi.com>; Wed, 16 Sep 2009 08:18:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04C5F12B2BC4
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2009 06:19:41 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id r5wV3eF3gFPPw1Os for
	<xfs@oss.sgi.com>; Wed, 16 Sep 2009 06:19:41 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MnuQ9-0007o9-9v
	for xfs@oss.sgi.com; Wed, 16 Sep 2009 13:19:41 +0000
Message-Id: <20090916131818.939008605@bombadil.infradead.org>
Date: Wed, 16 Sep 2009 09:18:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] sync fixes again
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

With the flush_buftarg call moved to avoid the superblock bffer lock deadlock.
Survived about 2 days of XFSQA so far.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
