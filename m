Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P94qVW226559 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 03:04:53 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 26DD4105609F
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:07:15 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id STlICs4YB8rDQCGc for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:07:15 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Pherp-00069n-Q8
	for xfs@oss.sgi.com; Tue, 25 Jan 2011 09:07:13 +0000
Message-Id: <20110125090618.432370964@bombadil.infradead.org>
Date: Tue, 25 Jan 2011 04:06:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] resurrect realtime subvolume support
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

Fix two regressions that broke using the realtime subvolume, and
add lockdep annotations for the ilocks of the two rt metadata inodes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
