Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o525jJhV054376 for <xfs@oss.sgi.com>; Wed, 2 Jun 2010 00:45:19 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8015BAAC466
	for <xfs@oss.sgi.com>; Tue,  1 Jun 2010 22:50:05 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	3XaVk8ALi8x6NIcR for <xfs@oss.sgi.com>;
	Tue, 01 Jun 2010 22:50:05 -0700 (PDT)
Date: Wed, 2 Jun 2010 15:47:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 10/17] xfs: simplify buffer pinning
Message-ID: <20100602054741.GJ7011@dastard>
References: <20100531160727.842750532@bombadil.infradead.org>
	<20100531160901.186403532@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100531160901.186403532@bombadil.infradead.org>
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

On Mon, May 31, 2010 at 12:07:37PM -0400, Christoph Hellwig wrote:
> Get rid of the xfs_buf_pin/xfs_buf_unpin/xfs_buf_ispin helpers and opencode
> them in their only callers, just like we did for the inode pinning a while
> ago.  Also remove duplicate trace points - the bufitem tracepoints cover
> all the information that is present in a buffer tracepoint.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
