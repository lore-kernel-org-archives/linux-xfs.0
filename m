Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O66ff6014398 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:06:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E6D6610518D
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:06:40 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	XeTAfK9wpWbCstnV for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:06:40 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qw6bo-00056d-7G
	for xfs@oss.sgi.com; Wed, 24 Aug 2011 06:06:40 +0000
Message-Id: <20110824060428.789245205@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 02:04:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/25] xfs_bmapi split and cleanups
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

This series, which is largely based on one that Dave published a couple month
ago, splits up the many armed hyrda called xfs_bmapi into multiple smaller
functions, and reduced stack usage in those pathes.

The main visible change to the rest of xfs is that there are three new
interfaces that replace xfs_bmapi:  xfs_bmapi_read to read extent maps,
xfs_bmapi_delay to add new unwritten extents, and xfs_bmapi to allocate
or convert real and unwrittent extents.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
