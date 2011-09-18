Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKfhVo200864 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:41:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 47546172058
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:41:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	knOcA1iXahYsfPA3 for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:41:42 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5OBK-0004dR-FZ
	for xfs@oss.sgi.com; Sun, 18 Sep 2011 20:41:42 +0000
Message-Id: <20110918204040.266805129@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:40:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/27] xfs_bmapi split and cleanups V2
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

changes from V1:
 - address various review comments from Alex
 - make sure all attributions are correct
 - add another patch from Dave's original series, which was lost before

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
