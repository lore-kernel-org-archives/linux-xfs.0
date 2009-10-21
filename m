Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9LHrgHF018915 for <xfs@oss.sgi.com>; Wed, 21 Oct 2009 12:53:42 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 08/14] repair: clean up prefetch tracing
Date: Wed, 21 Oct 2009 12:53:01 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADED@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090902175841.137658776@bombadil.infradead.org>
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
> Define a dummy pftrace macro for the non-tracing case to reduce the ifdef hell,
> clean up a few trace calls and add proper init/exit handlers for the tracing
> setup and teardown.
> 
> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yay!!!

Reviewed-by: Alex Elder <aelder@sgi.com>


> Index: xfsprogs-dev/repair/dino_chunks.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/dino_chunks.c	2009-08-19 23:42:32.000000000 +0000
> +++ xfsprogs-dev/repair/dino_chunks.c	2009-08-20 00:16:53.000000000 +0000
> @@ -629,10 +629,9 @@
>  			cluster_count * sizeof(xfs_buf_t*));

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
