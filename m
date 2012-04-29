Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3TLtvN4162934 for <xfs@oss.sgi.com>; Sun, 29 Apr 2012 16:55:57 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	UTvuTud8ndRONxtx (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 29 Apr 2012 14:55:56 -0700 (PDT)
Date: Sun, 29 Apr 2012 17:55:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 36/37] xfs: flush outstanding buffers on log mount failure
Message-ID: <20120429215555.GO19889@infradead.org>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
	<1335160747-17254-37-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1335160747-17254-37-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Apr 23, 2012 at 03:59:06PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we fail to mount the log in xfs_mountfs(), we tear down all the
> infrastructure we have already allocated. However, the process of
> mounting the log may have progressed to the point of reading,
> caching and modifying buffers in memory. Hence before we can free
> all the infrastructure, we have to flush and remove all the buffers
> from memory.
> 
> Problem first reported by Eric Sandeen, later a different incarnation
> was reported by Ben Myers.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
