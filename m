Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:51028 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752116AbeDRMSN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Apr 2018 08:18:13 -0400
Date: Wed, 18 Apr 2018 05:18:12 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 3/4] blk: add blk_queue_fua() helper function
Message-ID: <20180418121812.GA27475@bombadil.infradead.org>
References: <20180418040828.18165-1-david@fromorbit.com>
 <20180418040828.18165-4-david@fromorbit.com>
 <20180418103403.GA16044@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418103403.GA16044@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, rdorr@microsoft.com

On Wed, Apr 18, 2018 at 12:34:03PM +0200, Christoph Hellwig wrote:
> s/blk/block/ for block patches.

I think this is something we should put in MAINTAINERS.  Eventually
some tooling can pull it out, but I don't think this is something
that people can reasonably be expected to know.


diff --git a/MAINTAINERS b/MAINTAINERS
index 0a1410d5a621..c6358fa58fed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -81,6 +81,7 @@ Descriptions of section entries:
 	R: Designated reviewer: FullName <address@domain>
 	   These reviewers should be CCed on patches.
 	L: Mailing list that is relevant to this area
+	J: Prefix to use when sending a patch
 	W: Web-page with status/info
 	B: URI for where to file bugs. A web-page with detailed bug
 	   filing info, a direct bug tracker link, or a mailto: URI.
@@ -2667,6 +2668,7 @@ F:	drivers/leds/leds-blinkm.c
 BLOCK LAYER
 M:	Jens Axboe <axboe@kernel.dk>
 L:	linux-block@vger.kernel.org
+J:	block
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
 S:	Maintained
 F:	block/
@@ -14927,6 +14929,7 @@ M:	Pawel Osciak <pawel@osciak.com>
 M:	Marek Szyprowski <m.szyprowski@samsung.com>
 M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	linux-media@vger.kernel.org
+J:	videobuf
 S:	Maintained
 F:	drivers/media/v4l2-core/videobuf2-*
 F:	include/media/videobuf2-*
