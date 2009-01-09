Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n09MDUNp027578 for <xfs@oss.sgi.com>; Fri, 9 Jan 2009 16:13:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DCCFA17C9595
	for <xfs@oss.sgi.com>; Fri,  9 Jan 2009 14:13:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rcTRIdycnhZGPcP3 for
	<xfs@oss.sgi.com>; Fri, 09 Jan 2009 14:13:29 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LLPb9-0003sX-1z
	for xfs@oss.sgi.com; Fri, 09 Jan 2009 22:12:59 +0000
Message-Id: <20090109221104.237540000@bombadil.infradead.org>
Date: Fri, 09 Jan 2009 17:11:04 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/7] Remaining 2.6.29 queue
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

These are my current outstanding patches for 2.6.29, consisting of
small enough fixes and lockdep annotations, and an early warning
for a attr corruption frequently seen on kerneloops.org.

All but the last patch in the series still need some proper review.

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
