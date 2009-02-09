Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n192lAWL213815 for <xfs@oss.sgi.com>; Sun, 8 Feb 2009 20:47:10 -0600
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2331618EF9F0
	for <xfs@oss.sgi.com>; Sun,  8 Feb 2009 18:46:32 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net
	[203.16.214.146]) by cuda.sgi.com with ESMTP id
	gtp6R7PO7ehwldxm for <xfs@oss.sgi.com>;
	Sun, 08 Feb 2009 18:46:32 -0800 (PST)
Date: Mon, 9 Feb 2009 13:28:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 12/17] xfs: merge xfs_mkdir into xfs_create
Message-ID: <20090209022815.GG8830@disturbed>
References: <20090126073136.384490000@bombadil.infradead.org>
	<20090126073202.764168000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090126073202.764168000@bombadil.infradead.org>
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

On Mon, Jan 26, 2009 at 02:31:48AM -0500, Christoph Hellwig wrote:
> xfs_create and xfs_mkdir only have minor differences, so merge both of them
> into a sigle function.  While we're at it also make the error handling code
> more straight-forward.
> 
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
