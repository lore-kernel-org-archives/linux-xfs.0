Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6K7WIQC007195 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 02:32:19 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C325245AACC
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 00:35:17 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail17.adl2.internode.on.net
	[150.101.137.102]) by cuda.sgi.com with ESMTP id
	THiuYPkioEtikFqJ for <xfs@oss.sgi.com>;
	Tue, 20 Jul 2010 00:35:17 -0700 (PDT)
Date: Tue, 20 Jul 2010 17:35:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/6] xfs: clean up filestreams helpers
Message-ID: <20100720073514.GG32635@dastard>
References: <20100718203848.927859114@bombadil.infradead.org>
	<20100718203926.050740375@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100718203926.050740375@bombadil.infradead.org>
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

On Sun, Jul 18, 2010 at 04:38:50PM -0400, Christoph Hellwig wrote:
> Move xfs_filestream_peek_ag, xxfs_filestream_get_ag and xfs_filestream_put_ag
> from xfs_filestream.h to xfs_filestream.c where it's only callers are, and
> remove the inline marker while we're at it to let the compiler decide on the
> inlining.  Also don't return a value from xfs_filestream_put_ag because
> we don't need it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
