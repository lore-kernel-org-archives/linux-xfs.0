Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5BGCaFC145649 for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 11:12:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AC8FA3BF87F
	for <xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:15:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id p98sp1QdvpqEUOZZ for
	<xfs@oss.sgi.com>; Fri, 11 Jun 2010 09:15:10 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1ON6st-00062q-Lw
	for xfs@oss.sgi.com; Fri, 11 Jun 2010 16:15:10 +0000
Message-Id: <20100611161312.446670249@bombadil.infradead.org>
Date: Fri, 11 Jun 2010 12:13:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] simplify the writeback code
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

The writeback path has a lot of code that's been dead for a while.  We're
never asked to release dirty and thus delayed allocated or unwritten pages
from ->releasepage, and since the introduction of ->page_mkwrite we also
don't have to deal with dirty but unmapped buffers in ->writepage.  But
there's a case masquerading as such, which needs to be fixed by a 1.5 years
old patch from Eric first.  That patch also happens to fix xfstests 194.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
