Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7M6ks27036585 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 01:46:55 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CD9E51388839
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 23:49:26 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	POLfazqNuhxHjKjB for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2011 23:49:26 -0700 (PDT)
Date: Mon, 22 Aug 2011 16:46:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] xfs: remove i_iocount
Message-ID: <20110822064640.GO3162@dastard>
References: <20110814222412.359079843@bombadil.infradead.org>
	<20110814222518.371157499@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110814222518.371157499@bombadil.infradead.org>
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

On Sun, Aug 14, 2011 at 06:24:17PM -0400, Christoph Hellwig wrote:
> We now have an i_dio_count filed and surrounding infrastructure to wait
> for direct I/O completion instead of i_icount, and we have never needed
> to iocount waits for buffered I/O given that we only set the page uptodate
> after finishing all required work.  Thus remove i_iocount, and replace
> the actually needed waits with calls to inode_dio_wait.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks sane. One less bit of XFS specific code. ;)

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
