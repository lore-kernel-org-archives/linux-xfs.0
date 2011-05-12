Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4C7L38O163603 for <xfs@oss.sgi.com>; Thu, 12 May 2011 02:21:03 -0500
Received: from mx4-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 178111BDDE90
	for <xfs@oss.sgi.com>; Thu, 12 May 2011 00:21:02 -0700 (PDT)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id aNVyScZQ84hiScYA for
	<xfs@oss.sgi.com>; Thu, 12 May 2011 00:21:02 -0700 (PDT)
Date: Thu, 12 May 2011 03:20:58 -0400 (EDT)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <1935452012.471482.1305184858098.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110511150712.222802741@bombadil.infradead.org>
Subject: Re: [PATCH 5/9] xfs: do not use unchecked extent indices in xfs_bmapi
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
> when moving on to the next index in xfs_bmapi.
> 
> Based on an earlier patch from Lachlan McIlroy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_bmap.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_bmap.c 2011-05-11 10:16:58.831733512 +0200
> +++ xfs/fs/xfs/xfs_bmap.c 2011-05-11 10:16:58.847733078 +0200
> @@ -4827,12 +4827,13 @@ xfs_bmapi(
> /*
> * Else go on to the next record.
> */
> - ep = xfs_iext_get_ext(ifp, ++lastx);
> prev = got;
> - if (lastx >= nextents)
> - eof = 1;
> - else
> + if (++lastx < nextents) {
> + ep = xfs_iext_get_ext(ifp, lastx);
> xfs_bmbt_get_all(ep, &got);
> + } else {
> + eof = 1;
> + }
> }
> *nmap = n;
> /*
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
