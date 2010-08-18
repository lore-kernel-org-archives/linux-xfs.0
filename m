Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7IGGxCV122188 for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 11:17:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 17499172A92A
	for <xfs@oss.sgi.com>; Wed, 18 Aug 2010 09:17:29 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id I7MRlFTqfnXhpAHa for
	<xfs@oss.sgi.com>; Wed, 18 Aug 2010 09:17:29 -0700 (PDT)
Date: Wed, 18 Aug 2010 12:17:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: page discard on page error
Message-ID: <20100818161728.GA3511@infradead.org>
References: <AANLkTimHBE_9pD1wWOkryOnqBgL2bJQTKoe52wYjfNw3@mail.gmail.com>
	<20100818155043.GL7362@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100818155043.GL7362@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Dave Chinner <david@fromorbit.com>
Cc: Mike Gao <ygao.linux@gmail.com>, xfs@oss.sgi.com

On Thu, Aug 19, 2010 at 01:50:43AM +1000, Dave Chinner wrote:
> The current code does not handle EAGAIN at all, just discards the
> page. This looks incorrect - I think that EAGAIN should still cause
> the page to be redirtied, not discarded. I'm not sure if I missed
> something else, though - can you remember why you removed the EAGAIN
> case?

I don't think that was intentional, in fact I'm pretty sure I handled
it in an earlier version.  Mike, can you test the patch below?


Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-08-18 18:10:48.140261091 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-08-18 18:12:41.167005888 +0200
@@ -1068,7 +1068,7 @@ xfs_vm_writepage(
 	 * by themselves.
 	 */
 	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
-		goto out_fail;
+		goto redirty;
 
 	/*
 	 * We need a transaction if there are delalloc or unwritten buffers
@@ -1080,7 +1080,7 @@ xfs_vm_writepage(
 	 */
 	xfs_count_page_state(page, &delalloc, &unwritten);
 	if ((current->flags & PF_FSTRANS) && (delalloc || unwritten))
-		goto out_fail;
+		goto redirty;
 
 	/* Is this page beyond the end of the file? */
 	offset = i_size_read(inode);
@@ -1245,12 +1245,15 @@ error:
 	if (iohead)
 		xfs_cancel_ioend(iohead);
 
+	if (err == -EAGAIN)
+		goto redirty;
+
 	xfs_aops_discard_page(page);
 	ClearPageUptodate(page);
 	unlock_page(page);
 	return err;
 
-out_fail:
+redirty:
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
