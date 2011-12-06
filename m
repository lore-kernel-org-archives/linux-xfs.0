Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6Lws0F003882 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 15:58:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 248E71F45C00
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 13:58:53 -0800 (PST)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	ZpEhOlZGUD2QaW8D for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 13:58:53 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RY32L-0006NU-Fd
	for xfs@oss.sgi.com; Tue, 06 Dec 2011 21:58:53 +0000
Message-Id: <20111206215853.434529389@bombadil.infradead.org>
Date: Tue, 06 Dec 2011 16:58:11 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [patch 05/19] xfs: make sure to really flush all dquots in
	xfs_qm_quotacheck
References: <20111206215806.844405397@bombadil.infradead.org>
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
quotacheck to make sure that we will never have any dirty dquots on a
live filesystem.  At this point no dquot should be pinnable, but lets
be pedantic about it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

---
 fs/xfs/xfs_qm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-11-25 11:45:32.672075575 +0100
+++ xfs/fs/xfs/xfs_qm.c	2011-11-25 11:45:35.875391556 +0100
@@ -1661,7 +1661,7 @@ xfs_qm_quotacheck(
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
