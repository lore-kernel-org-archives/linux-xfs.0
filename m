Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p82MN01F092432 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 17:23:00 -0500
Subject: Re: [PATCH 01/25] xfs: remove the first extent special case in
	xfs_bmap_add_extent
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060640.399504409@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060640.399504409@bombadil.infradead.org>
Date: Fri, 2 Sep 2011 17:22:56 -0500
Message-ID: <1315002176.2069.81.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> Both xfs_bmap_add_extent_hole_delay and xfs_bmap_add_extent_hole_real
> already contain code to handle the case where there is no extent to
> merge with, which is effectively the same as the code duplicated here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

It looks like an attribute fork will never get a delayed
allocation extent assigned to it.  At least I assume so,
because xfs_bmap_add_extent_hole_delay() only ever works
on the data fork.  (I didn't know that.)

Anyway, it took a bit to get myself into this--no surprise,
this is the bmapi code--but assuming the above is true this
does produce the same result as before.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
