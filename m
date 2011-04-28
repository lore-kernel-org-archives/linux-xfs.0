Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3SD1eAs005317 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 08:01:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9380541C46A
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 06:05:14 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 9bJsnACXOv63V5zH for
	<xfs@oss.sgi.com>; Thu, 28 Apr 2011 06:05:14 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QFQu9-0003NT-Vu
	for xfs@oss.sgi.com; Thu, 28 Apr 2011 13:05:14 +0000
Message-Id: <20110428125546.696493391@bombadil.infradead.org>
Date: Thu, 28 Apr 2011 08:55:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] use write_cache_pages
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

Replace our own handcrafted I/O clustering with the generic write_cache_pages
helper.  While the old code would add any additional page in an existing
mapping, the new code iterates over the pages, either adding them to
a previous mapping if it fits or otherwise gets a new one.

This has survived xfsqa for small and 4k blocksize on x86.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
