Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4C7Nf9C163842 for <xfs@oss.sgi.com>; Thu, 12 May 2011 02:23:42 -0500
Received: from mx4-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 767F914CB8EB
	for <xfs@oss.sgi.com>; Thu, 12 May 2011 00:23:41 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id 4IvBdCh8r2NDQg9j for
	<xfs@oss.sgi.com>; Thu, 12 May 2011 00:23:41 -0700 (PDT)
Date: Thu, 12 May 2011 03:23:38 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <77245965.471510.1305185018312.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110511150712.651478046@bombadil.infradead.org>
Subject: Re: [PATCH 7/9] xfs: do not do pointer arithmetics on extent records
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

Looks good.  Nice catch too.

----- Original Message -----
> We need to call xfs_iext_get_ext for the previous extent to get a
> valid
> pointer, and can't just do pointer arithmetics as they might be in
> different pages.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c 2011-05-11 10:16:58.847733078 +0200
> +++ xfs/fs/xfs/xfs_bmap.c 2011-05-11 10:17:04.803235692 +0200
> @@ -5145,9 +5145,12 @@ xfs_bunmapi(
> */
> ASSERT(bno >= del.br_blockcount);
> bno -= del.br_blockcount;
> - if (bno < got.br_startoff) {
> - if (--lastx >= 0)
> - xfs_bmbt_get_all(--ep, &got);
> + if (got.br_startoff > bno) {
> + if (--lastx >= 0) {
> + ep = xfs_iext_get_ext(ifp,
> + lastx);
> + xfs_bmbt_get_all(ep, &got);
> + }
> }
> continue;
> } else if (del.br_state == XFS_EXT_UNWRITTEN) {
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
