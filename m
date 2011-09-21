Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LIjN7B166700 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 13:45:24 -0500
Subject: Re: [PATCH 3/4] libxfs: handle short reads in libxfs_readbufr
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110920220030.576600914@bombadil.infradead.org>
References: <20110920215917.508421839@bombadil.infradead.org>
	<20110920220030.576600914@bombadil.infradead.org>
Date: Wed, 21 Sep 2011 13:45:13 -0500
Message-ID: <1316630713.5872.15.camel@doink>
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

On Tue, 2011-09-20 at 17:59 -0400, Christoph Hellwig wrote:
> Copy the code from libxfs_writebufr to handle short reads, and also
> tidy up a formatting issue found in the libxfs_writebufr copy.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

That LIBXFS_B_EXIT == LIBXFS_EXIT_ON_FAILURE is a bad thing.
It might be nice if libxfs_readbuf() and libxfs_writebuf()
encoded that piece of information the same way (in b_flags).

Anyway, what you have here looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
