Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6QF6l9p131496 for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 10:06:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5E481684A7E
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 08:06:51 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	HihJ7pY0H9hqU2zl for <xfs@oss.sgi.com>;
	Tue, 26 Jul 2011 08:06:51 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QljDY-0004gm-Ie
	for xfs@oss.sgi.com; Tue, 26 Jul 2011 15:06:44 +0000
Date: Tue, 26 Jul 2011 11:06:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: flag all buffers as metadata
Message-ID: <20110726150644.GA18000@infradead.org>
References: <20110726150633.GA17400@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110726150633.GA17400@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Now that REQ_META bios aren't treated specially in the CFQ I/O schedule
anymore, we can tag all buffers as metadata to make blktrace traces more
meaningful.  Note that we use buffers also to zero out partial blocks
in the preallocation / hole punching code, and while they operate on
data blocks the zeros written certainly aren't data.  I think this case
is borderline metadata enough to not bother special casing it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-07-25 23:50:03.288230279 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2011-07-25 23:50:22.208230167 +0200
@@ -1224,6 +1224,9 @@ _xfs_buf_ioapply(
 		rw = READ;
 	}
 
+	/* we only use the buffer cache for meta-data */
+	rw |= REQ_META;
+
 next_chunk:
 	atomic_inc(&bp->b_io_remaining);
 	nr_pages = BIO_MAX_SECTORS >> (PAGE_SHIFT - BBSHIFT);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
