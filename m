Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9O8MMnA059125 for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 03:22:25 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CCA21161BC38
	for <xfs@oss.sgi.com>; Mon, 24 Oct 2011 01:22:20 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	huFu6Y7Fi9DZJvNV for <xfs@oss.sgi.com>;
	Mon, 24 Oct 2011 01:22:20 -0700 (PDT)
Date: Mon, 24 Oct 2011 04:22:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS read hangs in 3.1-rc10
Message-ID: <20111024082219.GA19941@infradead.org>
References: <20111020224214.GC22772@hostway.ca>
	<20111021132240.GA24136@infradead.org>
	<20111021202857.GB30100@hostway.ca>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <20111021202857.GB30100@hostway.ca>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 21, 2011 at 01:28:57PM -0700, Simon Kirby wrote:
> > So we're waiting for the inode to be flushed, aka I/O again.
> 
> But I don't seem to see any queued I/O, hmm.

Well, as far as XFS is concerned the inode is beeing flushed and
the buffer is locked.  It could be stuck in the XFS internal delwri
list because a buffer for example is pinned.

If that is the case the big hammer patch I attached below - probably
not the final issue, but it should fix the hang if that is the case.

> > If this doesn't help I'll probably need to come up with some tracing
> > patches for you.
> 
> It seemes 3.0.7+gregkh's stable-queue queue-3.0 patches seems to be
> running fine without blocking at all on this SSD box, so that should
> narrow it down significantly.
> 
> Hmm, looking at git diff --stat v3.0.7..v3.1-rc10 fs/xfs , maybe not.. :)
> 
> Maybe 3.1 fs/xfs would transplant into 3.0 or vice-versa?

If the patch above doesn't work I'll prepare a backport for you.


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=xfs-hang-fix

Index: linux-2.6/fs/xfs/xfs_sync.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_sync.c	2011-10-24 10:02:27.361971264 +0200
+++ linux-2.6/fs/xfs/xfs_sync.c	2011-10-24 10:11:03.301036954 +0200
@@ -764,7 +764,8 @@ xfs_reclaim_inode(
 	struct xfs_perag	*pag,
 	int			sync_mode)
 {
-	int	error;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
 
 restart:
 	error = 0;
@@ -772,6 +773,18 @@ restart:
 	if (!xfs_iflock_nowait(ip)) {
 		if (!(sync_mode & SYNC_WAIT))
 			goto out;
+
+		/*
+		 * If the inode is flush locked we probably had someone else
+		 * push it to the buffer and the buffer is now sitting in
+		 * the delwri list.
+		 *
+		 * Use the big hammer to force it.
+		 */
+		xfs_log_force(mp, XFS_LOG_SYNC);
+		set_bit(XBT_FORCE_FLUSH, &mp->m_ddev_targp->bt_flags);
+		wake_up_process(mp->m_ddev_targp->bt_task);
+
 		xfs_iflock(ip);
 	}
 

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--azLHFNyN32YCQGCU--
