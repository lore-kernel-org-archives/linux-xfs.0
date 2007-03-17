Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 17:35:42 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2H0ZX6p017138
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 17:35:35 -0700
Date: Sat, 17 Mar 2007 01:35:24 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: use xfs_get_buf_noaddr for iclogs
Message-ID: <20070317003524.GA17362@lst.de>
References: <20070307101314.GB30587@lst.de> <20070312044117.GK6095633@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312044117.GK6095633@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com, ecashin@coraid.com, akpm@osdl.org, linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 03:41:17PM +1100, David Chinner wrote:
> OTOH, all other buffers are supposed to be locked when under I/O.
> This change makes a special case for the log buffers, and I'd prefer
> not to have to remember that this behaviour changed fo log buffers
> at some point in time.
> 
> I suggest that adding:

...

> +		XFS_BUF_PSEMA(bp, PRIBIO);

...

> To lock the buffer should be added here. That way we don't change
> any semantics of the code at all.

Here's a patch with your suggestion implemented.  Seems to work
fine under heavy NFS load for me.  Note that the log recovery has
some inconsistancies already about doing I/O both on locked and
unlocked buffers.  Long-term it might be a good idea to change
xfs_get_buf_noaddr to return a locked buffer like xfs_get_buf(_flags)
does already.


Index: linux-2.6/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_log.c	2007-03-16 15:21:43.000000000 +0100
+++ linux-2.6/fs/xfs/xfs_log.c	2007-03-16 15:34:15.000000000 +0100
@@ -1199,11 +1199,18 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		*iclogp = (xlog_in_core_t *)
 			  kmem_zalloc(sizeof(xlog_in_core_t), KM_SLEEP);
 		iclog = *iclogp;
-		iclog->hic_data = (xlog_in_core_2_t *)
-			  kmem_zalloc(iclogsize, KM_SLEEP | KM_LARGE);
-
 		iclog->ic_prev = prev_iclog;
 		prev_iclog = iclog;
+
+		bp = xfs_buf_get_noaddr(log->l_iclog_size, mp->m_logdev_targp);
+		if (!XFS_BUF_CPSEMA(bp))
+			ASSERT(0);
+		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
+		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
+		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
+		iclog->ic_bp = bp;
+		iclog->hic_data = bp->b_addr;
+
 		log->l_iclog_bak[i] = (xfs_caddr_t)&(iclog->ic_header);
 
 		head = &iclog->ic_header;
@@ -1216,11 +1223,6 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		INT_SET(head->h_fmt, ARCH_CONVERT, XLOG_FMT);
 		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
 
-		bp = xfs_buf_get_empty(log->l_iclog_size, mp->m_logdev_targp);
-		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
-		XFS_BUF_SET_BDSTRAT_FUNC(bp, xlog_bdstrat_cb);
-		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
-		iclog->ic_bp = bp;
 
 		iclog->ic_size = XFS_BUF_SIZE(bp) - log->l_iclog_hsize;
 		iclog->ic_state = XLOG_STATE_ACTIVE;
@@ -1528,7 +1530,6 @@ xlog_dealloc_log(xlog_t *log)
 		}
 #endif
 		next_iclog = iclog->ic_next;
-		kmem_free(iclog->hic_data, log->l_iclog_size);
 		kmem_free(iclog, sizeof(xlog_in_core_t));
 		iclog = next_iclog;
 	}
