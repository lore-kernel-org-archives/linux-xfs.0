Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8M6i7tF050915 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 01:44:07 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5676914FA4A2
	for <xfs@oss.sgi.com>; Tue, 21 Sep 2010 23:57:27 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	jgYNuyMFUjBmIzot for <xfs@oss.sgi.com>;
	Tue, 21 Sep 2010 23:57:27 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39732795-1927428
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 16:14:59 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OyJ4b-0003ua-7N
	for xfs@oss.sgi.com; Wed, 22 Sep 2010 16:44:57 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OyJ4P-0002li-1f
	for xfs@oss.sgi.com; Wed, 22 Sep 2010 16:44:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 16/16] xfs; pack xfs_buf structure more tightly
Date: Wed, 22 Sep 2010 16:44:29 +1000
Message-Id: <1285137869-10310-17-git-send-email-david@fromorbit.com>
In-Reply-To: <1285137869-10310-1-git-send-email-david@fromorbit.com>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
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

pahole reports the struct xfs_buf has quite a few holes in it, so
packing the structure better will reduce the size of it by 16 bytes.
Also, move all the fields used in cache lookups into the first
cacheline.

Before on x86_64:

        /* size: 320, cachelines: 5 */
	/* sum members: 298, holes: 6, sum holes: 22 */

After on x86_64:

        /* size: 304, cachelines: 5 */
	/* padding: 6 */
	/* last cacheline: 48 bytes */


Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_buf.h |   30 +++++++++++++++++++-----------
 1 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.h b/fs/xfs/linux-2.6/xfs_buf.h
index 4f3c845..c2e2b50 100644
--- a/fs/xfs/linux-2.6/xfs_buf.h
+++ b/fs/xfs/linux-2.6/xfs_buf.h
@@ -162,33 +162,41 @@ typedef int (*xfs_buf_bdstrat_t)(struct xfs_buf *);
 #define XB_PAGES	2
 
 typedef struct xfs_buf {
+	/*
+	 * first cacheline holds all the fields needed for an uncontended cache
+	 * hit to be fully processed. The semaphore straddles the cacheline
+	 * boundary, but the counter and lock sits on the first cacheline,
+	 * which is the only bit that is touched if we hit the semaphore
+	 * fast-path on locking.
+	 */
+	struct rb_node		b_rbnode;	/* rbtree node */
+	xfs_off_t		b_file_offset;	/* offset in file */
+	size_t			b_buffer_length;/* size of buffer in bytes */
+	atomic_t		b_hold;		/* reference count */
+	xfs_buf_flags_t		b_flags;	/* status flags */
 	struct semaphore	b_sema;		/* semaphore for lockables */
-	unsigned long		b_queuetime;	/* time buffer was queued */
-	atomic_t		b_pin_count;	/* pin count */
+
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
-	xfs_buf_flags_t		b_flags;	/* status flags */
-	struct rb_node		b_rbnode;	/* rbtree node */
 	struct xfs_perag	*b_pag;		/* contains rbtree root */
 	xfs_buftarg_t		*b_target;	/* buffer target (device) */
-	atomic_t		b_hold;		/* reference count */
 	xfs_daddr_t		b_bn;		/* block number for I/O */
-	xfs_off_t		b_file_offset;	/* offset in file */
-	size_t			b_buffer_length;/* size of buffer in bytes */
 	size_t			b_count_desired;/* desired transfer size */
 	void			*b_addr;	/* virtual address of buffer */
 	struct work_struct	b_iodone_work;
-	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	xfs_buf_relse_t		b_relse;	/* releasing function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
 	void			*b_fspriv;
 	void			*b_fspriv2;
-	unsigned short		b_error;	/* error code on I/O */
-	unsigned int		b_page_count;	/* size of page array */
-	unsigned int		b_offset;	/* page offset in first page */
 	struct page		**b_pages;	/* array of page pointers */
 	struct page		*b_page_array[XB_PAGES]; /* inline pages */
+	unsigned long		b_queuetime;	/* time buffer was queued */
+	atomic_t		b_pin_count;	/* pin count */
+	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
+	unsigned int		b_page_count;	/* size of page array */
+	unsigned int		b_offset;	/* page offset in first page */
+	unsigned short		b_error;	/* error code on I/O */
 #ifdef XFS_BUF_LOCK_TRACKING
 	int			b_last_holder;
 #endif
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
