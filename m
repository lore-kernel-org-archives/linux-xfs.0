Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p89NuISb066590 for <xfs@oss.sgi.com>; Fri, 9 Sep 2011 18:56:18 -0500
Subject: Re: [PATCH 18/25] xfs: move allocation ranges inode bmalloca structure
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110824060644.392598929@bombadil.infradead.org>
References: <20110824060428.789245205@bombadil.infradead.org>
	<20110824060644.392598929@bombadil.infradead.org>
Date: Fri, 9 Sep 2011 18:56:16 -0500
Message-ID: <1315612576.1999.134.camel@doink>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On Wed, 2011-08-24 at 02:04 -0400, Christoph Hellwig wrote:
> Most of the allocation functions take the offset length and block
> number as parameters for allocation. often they are modified so are
> passed by reference.  Make the version in the bmalloca structure the
> primary version and stop passing them around individually.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Lots of this patch is simply renaming xfs_bmalloca fields
"off" -> "offset", "rval" -> "blkno", and "alen" -> "length".
Those are very much appreciated changes.  I know there are
already a lot of patches in this series but it would have
been easier to see the "real" change had that part been
pulled out as a trivial extra one.

But it looks good, anyway.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
