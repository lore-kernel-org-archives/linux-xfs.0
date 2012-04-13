Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3DHenJB078168 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 12:40:49 -0500
Message-ID: <4F88651E.2030908@sgi.com>
Date: Fri, 13 Apr 2012 12:40:46 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 02/18] xfs: pass shutdown method into
	xfs_trans_ail_delete_bulk
References: <1334319061-12968-1-git-send-email-david@fromorbit.com>
	<1334319061-12968-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1334319061-12968-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 04/13/12 07:10, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> xfs_trans_ail_delete_bulk() can be called from different contexts so
> if the item is not in the AIL we need different shutdown for each
> context.  Pass in the shutdown method needed so the correct action
> can be taken.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Mark Tinguely<tinguely@sgi.com>



These items in my copy of Christoph's xfsbufd series are not resolved in 
this patch:

In "[01/10] xfs: remove log item from AIL in xfs_qm_dqflush after a 
shutdown" a xfs_trans_ail_delete() has been added:

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2012-02-23 17:52:53.916002428 -0800
+++ xfs/fs/xfs/xfs_dquot.c	2012-02-23 17:53:01.829335739 -0800
@@ -904,10 +904,21 @@ xfs_qm_dqflush(
  	/*
  	 * This may have been unpinned because the filesystem is shutting
  	 * down forcibly. If that's the case we must not write this dquot
-	 * to disk, because the log record didn't make it to disk!
+	 * to disk, because the log record didn't make it to disk.
+	 *
+	 * We also have to remove the log item from the AIL in this case,
+	 * as we wait for an emptry AIL as part of the unmount process.
  	 */
  	if (XFS_FORCED_SHUTDOWN(mp)) {
+		struct xfs_log_item	*lip = &dqp->q_logitem.qli_item;
  		dqp->dq_flags &= ~XFS_DQ_DIRTY;
+
+		spin_lock(&mp->m_ail->xa_lock);
+		if (lip->li_flags & XFS_LI_IN_AIL)
+			xfs_trans_ail_delete(mp->m_ail, lip);
+		else
+			spin_unlock(&mp->m_ail->xa_lock);

                       ====
In "[02/10] xfs: remove log item from AIL in xfs_iflush after a 
shutdown", he added another xfs_iflush_abort(). That is not converted 
with a boolean in this series:


Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2012-03-16 12:44:57.707030619 +0100
+++ xfs/fs/xfs/xfs_sync.c	2012-03-16 12:47:03.697032954 +0100
@@ -783,6 +783,7 @@ restart:
  		goto reclaim;
  	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
  		xfs_iunpin_wait(ip);
+		xfs_iflush_abort(ip);

Thank-you,

--Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
