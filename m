Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9MGhBVl114416 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 11:43:12 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 14/14] repair: add missing locking in scanfunc_bmap
Date: Thu, 22 Oct 2009 11:42:46 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83AE00@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090902175842.262611292@bombadil.infradead.org>
From: "Alex Elder" <aelder@sgi.com>
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
Cc: Barry Naujok <bnaujok@sgi.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> Make sure to protect access to the block usage tracking btree with
> the ag_lock.


Well that one was easy.  Looks good.	-Alex

> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfsprogs-dev/repair/scan.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/scan.c	2009-08-20 03:16:13.000000000 +0000
> +++ xfsprogs-dev/repair/scan.c	2009-08-20 03:18:17.000000000 +0000
> @@ -235,6 +235,7 @@
>  		agno = XFS_FSB_TO_AGNO(mp, bno);
>  		agbno = XFS_FSB_TO_AGBNO(mp, bno);
> 
> +		pthread_mutex_lock(&ag_locks[agno]);
>  		state = get_bmap(agno, agbno);
>  		switch (state) {
>  		case XR_E_UNKNOWN:
> @@ -280,6 +281,7 @@
>  				state, ino, (__uint64_t) bno);
>  			break;
>  		}
> +		pthread_mutex_unlock(&ag_locks[agno]);
>  	} else  {
>  		/*
>  		 * attribute fork for realtime files is in the regular
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
