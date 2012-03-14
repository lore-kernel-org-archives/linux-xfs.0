Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2EGaLNm213772 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 11:36:22 -0500
Date: Wed, 14 Mar 2012 11:36:28 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 4/5] xfs: remove the per-filesystem list of dquots
Message-ID: <20120314163628.GL7762@sgi.com>
References: <20120313085232.134690907@bombadil.infradead.org>
	<20120313085308.997632929@bombadil.infradead.org>
	<20120313200354.GI7762@sgi.com>
	<20120314073418.GA8455@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120314073418.GA8455@infradead.org>
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

On Wed, Mar 14, 2012 at 03:34:18AM -0400, Christoph Hellwig wrote:
> Updated version below:
> 
> -- 
> 
> From: Christoph Hellwig <hch@lst.de>
> Subject: xfs: remove the per-filesystem list of dquots
> 
> Instead of keeping a separate per-filesystem list of dquots we can walk
> the radix tree for the two places where we need to iterate all quota
> structures.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.
Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
