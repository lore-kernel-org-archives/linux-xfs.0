Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4C7N09c163790 for <xfs@oss.sgi.com>; Thu, 12 May 2011 02:23:00 -0500
Received: from mx4-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EBEC94493F2
	for <xfs@oss.sgi.com>; Thu, 12 May 2011 00:22:59 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id yAavw19FxtstJyJL for
	<xfs@oss.sgi.com>; Thu, 12 May 2011 00:22:59 -0700 (PDT)
Date: Thu, 12 May 2011 03:22:54 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <86249815.471503.1305184974655.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110511150712.421348825@bombadil.infradead.org>
Subject: Re: [PATCH 6/9] xfs: do not use unchecked extent indices in
	xfs_bunmapi
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Looks good.

----- Original Message -----
> Make sure to only call xfs_iext_get_ext after we've validate the
> extent index
> when moving on to the next index in xfs_bunmapi. Also remove the old
> workaround for too large indices that has been superceeded by the
> proper
> fix in xfs_bmap_del_extent.
> 
> Based on an earlier patch from Lachlan McIlroy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c 2011-05-11 10:17:04.803235692 +0200
> +++ xfs/fs/xfs/xfs_bmap.c 2011-05-11 10:17:06.432734169 +0200
> @@ -5247,17 +5247,17 @@ xfs_bunmapi(
> nodelete:
> /*
> * If not done go on to the next (previous) record.
> - * Reset ep in case the extents array was re-alloced.
> */
> - ep = xfs_iext_get_ext(ifp, lastx);
> if (bno != (xfs_fileoff_t)-1 && bno >= start) {
> - if (lastx >= XFS_IFORK_NEXTENTS(ip, whichfork) ||
> - xfs_bmbt_get_startoff(ep) > bno) {
> - if (--lastx >= 0)
> - ep = xfs_iext_get_ext(ifp, lastx);
> - }
> - if (lastx >= 0)
> + if (lastx >= 0) {
> + ep = xfs_iext_get_ext(ifp, lastx);
> + if (xfs_bmbt_get_startoff(ep) > bno) {
> + if (--lastx >= 0)
> + ep = xfs_iext_get_ext(ifp,
> + lastx);
> + }
> xfs_bmbt_get_all(ep, &got);
> + }
> extno++;
> }
> }
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
