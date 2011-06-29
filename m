Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TMDB3J145481 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 17:13:11 -0500
Subject: Re: [PATCH 05/27] xfs: work around bogus gcc warning in
	xfs_allocbt_init_cursor
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110629140337.417478423@bombadil.infradead.org>
References: <20110629140109.003209430@bombadil.infradead.org>
	<20110629140337.417478423@bombadil.infradead.org>
Date: Wed, 29 Jun 2011 17:13:09 -0500
Message-ID: <1309385589.8649.35.camel@doink>
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

On Wed, 2011-06-29 at 10:01 -0400, Christoph Hellwig wrote:
> plain text document attachment
> (xfs-fix-xfs_allocbt_init_cursor-warning)
> GCC 4.6 complains about an array subscript is above array bounds when
> using the btree index to index into the agf_levels array.  The only
> two indices passed in are 0 and 1, and we have an assert insuring that.
> 
> Replace the trick of using the array index directly with using constants
> in the already existing branch for assigning the XFS_BTREE_LASTREC_UPDATE
> flag.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
