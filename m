Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9LKLAmU030652 for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 15:21:10 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 11/14] repair: cleanup alloc/free/reset of the block
	usagetracking
Date: Wed, 21 Oct 2009 15:22:37 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADF7@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090902175841.711310240@bombadil.infradead.org>
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
> Currently the code to allocate, free and reset the block usage bitmaps
> is a complete mess.  This patch reorganizes it into logical helpers.
> 
> Details:
> 
>  - the current incore_init code is called just before phase2 is called,
>    which then marks the log and the AG headers used.
>  - we get rid of incore_init init, and replace it with direct calls to the
>    unchanched incore_ino_init/incore_ext_init functions and our new init_bmaps
>    which does all the allocations for the block usage tracking, aswell
>    as a call to reset_bmaps to initialize it to the default values.
>  - reset_bmaps is also called from early phase4 code to reset all state
>    instead of opencoding it.
>  - there is a new free_bmaps helper which we call to free our block usage
>    bitmaps when we don't need them anymore after phase5.  The current
>    code frees some of it a bit early in phase5, but needs to take of it
>    in phase6 in case we didn't call phase5 due to nomodify mode, and leaks
>    it if we don't call phase 6, which might happen in case of a bad inode
>    allocation btree.


Looks good.		-Alex


> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: xfsprogs-dev/repair/phase4.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/phase4.c	2009-08-21 01:59:26.000000000 +0000
> +++ xfsprogs-dev/repair/phase4.c	2009-08-21 02:41:44.000000000 +0000
> @@ -355,19 +355,7 @@ phase4(xfs_mount_t *mp)

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
