Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB46RVoU029105 for <xfs@oss.sgi.com>; Thu, 4 Dec 2008 00:27:31 -0600
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay3.corp.sgi.com (Postfix) with SMTP id A15BEAC012
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 22:27:26 -0800 (PST)
Received: from [134.14.55.78] (redback.melbourne.sgi.com [134.14.55.78]) by
	larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF)
	via ESMTP id RAA20685 for <xfs@oss.sgi.com>;
	Thu, 4 Dec 2008 17:27:24 +1100
Message-ID: <49377863.1070109@sgi.com>
Date: Thu, 04 Dec 2008 17:27:47 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] Remove unnecessary assertion
Reply-To: lachlan@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

Hit this assert because an inode was tagged with XFS_ICI_RECLAIM_TAG but
not XFS_IRECLAIMABLE|XFS_IRECLAIM.  This is because xfs_iget_cache_hit()
first clears XFS_IRECLAIMABLE and then calls __xfs_inode_clear_reclaim_tag()
while only holding the pag_ici_lock in read mode so we can race with
xfs_reclaim_inodes_ag().  Looks like xfs_reclaim_inodes_ag() will do the
right thing anyway so just remove the assert.

Thanks to Christoph for pointing out where the problem was.

--- xfs-fix.orig/fs/xfs/linux-2.6/xfs_sync.c
+++ xfs-fix/fs/xfs/linux-2.6/xfs_sync.c
@@ -707,8 +707,6 @@ restart:
  			break;
  		}

-		ASSERT(xfs_iflags_test(ip, (XFS_IRECLAIMABLE|XFS_IRECLAIM)));
-
  		/* ignore if already under reclaim */
  		if (xfs_iflags_test(ip, XFS_IRECLAIM)) {
  			read_unlock(&pag->pag_ici_lock);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
