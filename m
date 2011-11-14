Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAEG2ISd217512 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 10:02:18 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D19061D08061
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 08:02:17 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	3KnbKGsoDFTTxnCm for <xfs@oss.sgi.com>;
	Mon, 14 Nov 2011 08:02:17 -0800 (PST)
Message-Id: <20111114155742.285135418@bombadil.infradead.org>
Date: Mon, 14 Nov 2011 10:57:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] xfs_repair malloc optimizations
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

This series reduces memory usage for repairing a 97 million inode filesystem
for ~7.3 GB to ~5.3 (that is the resident set, virtual memory requirements
are about 300MB higher for both).  The main change is linking against the
tcmalloc library from the Google perftools, with uses more efficient data
structures, and is able to garbage collect freed memory from the per-thread
queues.  At least for xfs_repair it doesn't scale noticably better than
ptmalloc, as the final runtime is only minimally faster, and probably not
significant.  Given that xfs_repair generally is I/O bound that is to be
expected, though.

I'd love to build with tcmalloc by default instead of requiring the
./configure opt-in, but I'm missing the autoconf-foo to not break the
build in case it isn't present.  The same applies to using the
libtcmalloc_minimal variant that doesn't include some of the debugging
infrastructure - if anyone has the autoconf foo to use it alternatively
it would be great to also offer it.

The two preceding patches just remove some useless internal freelist
and make sure we actuall return memory to the system pool.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
