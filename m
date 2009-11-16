Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAG3I48x074989 for <xfs@oss.sgi.com>; Sun, 15 Nov 2009 21:18:04 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C79A8BED3
	for <xfs@oss.sgi.com>; Sun, 15 Nov 2009 19:18:24 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	weHOC5JjoiCqjnTN for <xfs@oss.sgi.com>;
	Sun, 15 Nov 2009 19:18:24 -0800 (PST)
Date: Mon, 16 Nov 2009 14:18:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/7] xfs: uninline xfs_get_extsz_hint
Message-ID: <20091116031820.GE9467@discord.disaster>
References: <20091114161717.233372584@bombadil.infradead.org>
	<20091114161801.818601601@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091114161801.818601601@bombadil.infradead.org>
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

On Sat, Nov 14, 2009 at 11:17:21AM -0500, Christoph Hellwig wrote:
> This function is too large to efficiently be inlined.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Makes sense.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
