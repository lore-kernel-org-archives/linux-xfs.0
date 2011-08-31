Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7VKcL2p226680 for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 15:38:26 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51D3B13B559F
	for <xfs@oss.sgi.com>; Wed, 31 Aug 2011 13:41:46 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	dPvwN1c8kMNgwUsG for <xfs@oss.sgi.com>;
	Wed, 31 Aug 2011 13:41:46 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QyrYA-0006yL-Fc
	for xfs@oss.sgi.com; Wed, 31 Aug 2011 20:38:18 +0000
Message-Id: <20110831203818.430319605@bombadil.infradead.org>
Date: Wed, 31 Aug 2011 16:36:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/14] xfs: make sure to really flush all dquots in
	xfs_qm_quotacheck
References: <20110831203647.455809764@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-quotacheck-dont-trylock
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

Make sure we do not skip any dquots when flushing them out after a
quotacheck to make sure that we will never have any dirty dquots on a life
filesystem.  At this point no dquot should be pinnable, but lets be anal
about it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-08-29 14:35:18.604856167 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-08-29 14:35:33.924855391 +0200
@@ -1660,7 +1660,7 @@ xfs_qm_quotacheck(
 	 * successfully.
 	 */
 	if (!error)
-		error = xfs_qm_dqflush_all(mp, SYNC_TRYLOCK);
+		error = xfs_qm_dqflush_all(mp, 0);
 
 	/*
 	 * We can get this error if we couldn't do a dquot allocation inside

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
