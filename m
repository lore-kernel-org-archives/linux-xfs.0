Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9MGh6Z1114404 for <xfs@oss.sgi.com>; Thu, 22 Oct 2009 11:43:06 -0500
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH 13/14] repair: optimize duplicate extent tracking
Date: Thu, 22 Oct 2009 11:41:40 -0500
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE83ADFF@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <20090902175842.081792481@bombadil.infradead.org>
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
> Switch the duplicate extent tracking from an avl tree to our new btree
> implementation.  Modify search_dup_extent to find overlapping extents
> with differening start blocks instead of having the caller walk every
> possible start block.

Looks good.		-Alex

> Signed-off-by: Barry Naujok <bnaujok@sgi.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Alex Elder <aelder@sgi.com>

> Index: xfsprogs-dev/repair/incore_ext.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/incore_ext.c	2009-08-21 15:11:16.000000000 +0000
> +++ xfsprogs-dev/repair/incore_ext.c	2009-08-21 15:24:07.000000000 +0000

...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
