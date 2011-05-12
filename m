Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4C6oKk4162406 for <xfs@oss.sgi.com>; Thu, 12 May 2011 01:50:20 -0500
Received: from mx3-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A81161D674F7
	for <xfs@oss.sgi.com>; Wed, 11 May 2011 23:50:18 -0700 (PDT)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id AtmHKT4bCOvQfl5l for
	<xfs@oss.sgi.com>; Wed, 11 May 2011 23:50:18 -0700 (PDT)
Date: Thu, 12 May 2011 02:50:10 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <2082652758.471187.1305183010394.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
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

I can see why this is needed but if we remove extent at
idx 0 then wont this go negative and confuse the next
call to xfs_iext_get_ext()?

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
