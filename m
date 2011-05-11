Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4BF7D3b128058 for <xfs@oss.sgi.com>; Wed, 11 May 2011 10:07:13 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5578C1EABFBC
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id busvqgcoqf070rUc for
	<xfs@oss.sgi.com>; Wed, 11 May 2011 08:07:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QKB0J-0005ci-7W
	for xfs@oss.sgi.com; Wed, 11 May 2011 15:07:11 +0000
Message-Id: <20110511150402.258164661@bombadil.infradead.org>
Date: Wed, 11 May 2011 11:04:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/9] extent buffer indexing fixes
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

I recently ran into some extent buffer indexing issue which turned to be
my fault in code I was working on.  But while looking into these I found
an old patch from Lachlan McIlroy that tried to fix various issue in
that area.  I went through them slowly to understand what's going on and
ended up with this series.  The first patch is not actually related but
touches the area and was in my queue so I've decided to include it.
The second patch removes the if_lastex field in struct xfs_ifork as it's
not actually needed and just makes the code using it confusing.  The
following patches fixes various places that feed too large indices into
xfs_iext_get_ext or xfs_iext_idx_to_irec, and the last patch finally
adds asserts into these to catch the incorrect accesses.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
