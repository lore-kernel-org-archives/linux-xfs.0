Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9QL7HNC036164 for <xfs@oss.sgi.com>; Wed, 26 Oct 2011 16:07:17 -0500
Message-ID: <1319663232.5239.73.camel@doink>
Subject: Re: [PATCH 1/4] xfs: make i_flags and unsigned long
From: Alex Elder <aelder@sgi.com>
Date: Wed, 26 Oct 2011 16:07:12 -0500
In-Reply-To: <20111019182420.712347469@bombadil.infradead.org>
References: <20111019182343.762985925@bombadil.infradead.org>
	<20111019182420.712347469@bombadil.infradead.org>
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

On Wed, 2011-10-19 at 14:23 -0400, Christoph Hellwig wrote:
> To be used for bit wakeup i_flags needs to be an unsigned long or we'll
> run into trouble on big endian systems.  Beause of the 1-byte i_update
> field right after it this actually causes a fairly large size increase
> on its own (4 or 8 bytes), but that increase will be more than offset
> by the next two patches.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

Looks fine.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
