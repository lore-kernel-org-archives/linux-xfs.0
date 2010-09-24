Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OCUqeT181029 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 07:30:52 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A72914FBFFD
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 05:44:26 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	gjyMWYN5bk12X5ss for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 05:44:26 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	40606352-1927428
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 22:01:45 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1Oz7R8-0007Uz-9O
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:34 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1Oz7Qu-000606-2H
	for xfs@oss.sgi.com; Fri, 24 Sep 2010 22:31:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/18] xfs: rename xfs_buf_get_nodaddr to be more appropriate
Date: Fri, 24 Sep 2010 22:31:04 +1000
Message-Id: <1285331476-23015-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1285331476-23015-1-git-send-email-david@fromorbit.com>
References: <1285331476-23015-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

xfs_buf_get_nodaddr() is really used to allocate a buffer that is
uncached. While it is not directly assigned a disk address, the fact
that they are not cached is a more important distinction. With the
upcoming uncached buffer read primitive, we should be consistent
with this disctinction.

While there, make page allocation in xfs_buf_get_nodaddr() safe
against memory reclaim re-entrancy into the filesystem by allowing
a flags parameter to be passed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.c   |    9 +++++----
 fs/xfs/linux-2.6/xfs_buf.h   |    2 +-
 fs/xfs/linux-2.6/xfs_trace.h |    2 +-
 fs/xfs/xfs_log.c             |    3 ++-
 fs/xfs/xfs_log_recover.c     |    3 ++-
 fs/xfs/xfs_vnodeops.c        |    6 +++---
 6 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 286e36e..eca945b 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -707,9 +707,10 @@ xfs_buf_associate_memory(
 }
 
 xfs_buf_t *
-xfs_buf_get_noaddr(
+xfs_buf_get_uncached(
+	struct xfs_buftarg	*target,
 	size_t			len,
-	xfs_buftarg_t		*target)
+	int			flags)
 {
 	unsigned long		page_count = PAGE_ALIGN(len) >> PAGE_SHIFT;
 	int			error, i;
@@ -725,7 +726,7 @@ xfs_buf_get_noaddr(
 		goto fail_free_buf;
 
 	for (i = 0; i < page_count; i++) {
-		bp->b_pages[i] = alloc_page(GFP_KERNEL);
+		bp->b_pages[i] = alloc_page(xb_to_gfp(flags));
 		if (!bp->b_pages[i])
 			goto fail_free_mem;
 	}
@@ -740,7 +741,7 @@ xfs_buf_get_noaddr(
 
 	xfs_buf_unlock(bp);
 
-	trace_xfs_buf_get_noaddr(bp, _RET_IP_);
+	trace_xfs_buf_get_uncached(bp, _RET_IP_);
 	return bp;
 
  fail_free_mem:
diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 2a05614..fb30447 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -213,7 +213,7 @@ extern xfs_buf_t *xfs_buf_read(xfs_buftarg_t *, xfs_off_t, size_t,
 				xfs_buf_flags_t);
 
 extern xfs_buf_t *xfs_buf_get_empty(size_t, xfs_buftarg_t *);
-extern xfs_buf_t *xfs_buf_get_noaddr(size_t, xfs_buftarg_t *);
+extern xfs_buf_t *xfs_buf_get_uncached(struct xfs_buftarg *, size_t, int);
 extern int xfs_buf_associate_memory(xfs_buf_t *, void *, size_t);
 extern void xfs_buf_hold(xfs_buf_t *);
 extern void xfs_buf_readahead(xfs_buftarg_t *, xfs_off_t, size_t,
diff --git a/fs/xfs/linux-2.6/xfs_trace.h b/fs/xfs/linux-2.6/xfs_trace.h
index be5dffd..2a1d4fb 100644
--- a/fs/xfs/linux-2.6/xfs_trace.h
+++ b/fs/xfs/linux-2.6/xfs_trace.h
@@ -331,7 +331,7 @@ DEFINE_BUF_EVENT(xfs_buf_iowait_done);
 DEFINE_BUF_EVENT(xfs_buf_delwri_queue);
 DEFINE_BUF_EVENT(xfs_buf_delwri_dequeue);
 DEFINE_BUF_EVENT(xfs_buf_delwri_split);
-DEFINE_BUF_EVENT(xfs_buf_get_noaddr);
+DEFINE_BUF_EVENT(xfs_buf_get_uncached);
 DEFINE_BUF_EVENT(xfs_bdstrat_shut);
 DEFINE_BUF_EVENT(xfs_buf_item_relse);
 DEFINE_BUF_EVENT(xfs_buf_item_iodone);
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 33f718f..c8a3094 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1131,7 +1131,8 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		iclog->ic_prev = prev_iclog;
 		prev_iclog = iclog;
 
-		bp = xfs_buf_get_noaddr(log->l_iclog_size, mp->m_logdev_targp);
+		bp = xfs_buf_get_uncached(mp->m_logdev_targp,
+						log->l_iclog_size, 0);
 		if (!bp)
 			goto out_free_iclog;
 		if (!XFS_BUF_CPSEMA(bp))
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6f3f5fa..3d88754 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -107,7 +107,8 @@ xlog_get_bp(
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
 
-	return xfs_buf_get_noaddr(BBTOB(nbblks), log->l_mp->m_logdev_targp);
+	return xfs_buf_get_uncached(log->l_mp->m_logdev_targp,
+					BBTOB(nbblks), 0);
 }
 
 STATIC void
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index 7413a02..e685cc6 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -2431,9 +2431,9 @@ xfs_zero_remaining_bytes(
 	if (endoff > ip->i_size)
 		endoff = ip->i_size;
 
-	bp = xfs_buf_get_noaddr(mp->m_sb.sb_blocksize,
-				XFS_IS_REALTIME_INODE(ip) ?
-				mp->m_rtdev_targp : mp->m_ddev_targp);
+	bp = xfs_buf_get_uncached(XFS_IS_REALTIME_INODE(ip) ?
+					mp->m_rtdev_targp : mp->m_ddev_targp,
+				mp->m_sb.sb_blocksize, XBF_DONT_BLOCK);
 	if (!bp)
 		return XFS_ERROR(ENOMEM);
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
