Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4C7HjIo163478 for <xfs@oss.sgi.com>; Thu, 12 May 2011 02:17:45 -0500
Received: from mx3-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9A76A14CB9AF
	for <xfs@oss.sgi.com>; Thu, 12 May 2011 00:17:43 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id BOfG9ew2CPv6g5pE for
	<xfs@oss.sgi.com>; Thu, 12 May 2011 00:17:43 -0700 (PDT)
Date: Thu, 12 May 2011 03:17:39 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <1419180781.471454.1305184659046.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110511150711.786279651@bombadil.infradead.org>
Subject: Re: [PATCH 3/9] xfs: correctly decrement the extent buffer index in
	xfs_bmap_del_extent
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
> The code in xfs_bmap_del_extent does not correctly decrement the
> extent buffer
> index when deleting a whole extent. Most of the time this gets caught
> by
> checks in xfs_bmapi that work around it and decrement it manually and
> thus
> wasn't noticed so far.
> 
> Based on an earlier patch from Lachlan McIlroy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c 2011-05-10 17:11:21.212901236 +0200
> +++ xfs/fs/xfs/xfs_bmap.c 2011-05-10 17:13:36.177399627 +0200
> @@ -2916,8 +2916,10 @@ xfs_bmap_del_extent(
> */
> xfs_iext_remove(ip, *idx, 1,
> whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
> + --*idx;
> if (delay)
> break;
> +
> XFS_IFORK_NEXT_SET(ip, whichfork,
> XFS_IFORK_NEXTENTS(ip, whichfork) - 1);
> flags |= XFS_ILOG_CORE;
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
