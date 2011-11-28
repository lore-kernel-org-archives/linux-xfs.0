Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAS8Kpsa225320 for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 02:20:51 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F17319D339C
	for <xfs@oss.sgi.com>; Mon, 28 Nov 2011 00:19:25 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	bZWSxICunqdU5Ggp for <xfs@oss.sgi.com>;
	Mon, 28 Nov 2011 00:19:25 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RUwQv-00076S-A5
	for xfs@oss.sgi.com; Mon, 28 Nov 2011 08:19:25 +0000
Message-Id: <20111128081732.350228200@bombadil.infradead.org>
Date: Mon, 28 Nov 2011 03:17:32 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] xfs fixes for Linux 3.2-rc3
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

These are the patches that I think should still go into Linux 3.2.

The first two are fairly trivial fixes for crashes that can be reproduced
by users action or filesystem corruption.  The third is a a fix for the
hang reported by Simon, and although he hasn't tested the final variant
yet I'm fairly confident it should fix it given we use the same pattern
for dquots.  The last one is the biggest and fixes the log space hang
first reported by Alex and then debugged by Chandra.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
