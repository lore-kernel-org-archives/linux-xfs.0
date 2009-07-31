Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6VL3xel171456 for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 16:03:59 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4688143CEFB
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2009 14:04:47 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id v8trDEkUO4qy65Cf for
	<xfs@oss.sgi.com>; Fri, 31 Jul 2009 14:04:47 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1MWzHT-0003Wt-DF
	for xfs@oss.sgi.com; Fri, 31 Jul 2009 21:04:47 +0000
Message-Id: <20090731210340.638586000@bombadil.infradead.org>
Date: Fri, 31 Jul 2009 17:03:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] more memory allocator recursion fixes
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

Now deal with the iolock, by not actually taking it anymore from reclaim
context.  As an added benefit the last patch also fixes the mmap_sem lock order
reversal.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
