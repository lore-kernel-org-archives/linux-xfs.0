Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4C7O6kj163865 for <xfs@oss.sgi.com>; Thu, 12 May 2011 02:24:06 -0500
Received: from mx4-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D258C1D67DC6
	for <xfs@oss.sgi.com>; Thu, 12 May 2011 00:24:05 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id I9LmjlwDXchnnYLM for
	<xfs@oss.sgi.com>; Thu, 12 May 2011 00:24:05 -0700 (PDT)
Date: Thu, 12 May 2011 03:24:03 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <1953221482.471512.1305185043208.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110511150712.830693893@bombadil.infradead.org>
Subject: Re: [PATCH 8/9] xfs: fix up asserts in xfs_iflush_fork
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
> Remove asserts in xfs_iflush_fork that would call xfs_iext_get_ext
> with
> a potentially invalid extent buffer index.
> 
> Based on an earlier patch from Lachlan McIlroy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_inode.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_inode.c 2011-05-11 10:18:39.555233397 +0200
> +++ xfs/fs/xfs/xfs_inode.c 2011-05-11 12:04:24.099733330 +0200
> @@ -2557,12 +2557,9 @@ xfs_iflush_fork(
> case XFS_DINODE_FMT_EXTENTS:
> ASSERT((ifp->if_flags & XFS_IFEXTENTS) ||
> !(iip->ili_format.ilf_fields & extflag[whichfork]));
> - ASSERT((xfs_iext_get_ext(ifp, 0) != NULL) ||
> - (ifp->if_bytes == 0));
> - ASSERT((xfs_iext_get_ext(ifp, 0) == NULL) ||
> - (ifp->if_bytes > 0));
> if ((iip->ili_format.ilf_fields & extflag[whichfork]) &&
> (ifp->if_bytes > 0)) {
> + ASSERT(xfs_iext_get_ext(ifp, 0));
> ASSERT(XFS_IFORK_NEXTENTS(ip, whichfork) > 0);
> (void)xfs_iextents_copy(ip, (xfs_bmbt_rec_t *)cp,
> whichfork);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
