Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBUMOk6m058549 for <xfs@oss.sgi.com>; Wed, 30 Dec 2009 16:24:46 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EF136A9713
	for <xfs@oss.sgi.com>; Wed, 30 Dec 2009 14:25:31 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	9nhoWgVtIHvGhZXN for <xfs@oss.sgi.com>;
	Wed, 30 Dec 2009 14:25:31 -0800 (PST)
Date: Thu, 31 Dec 2009 09:25:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/3] repair: fix freespace btree record validation
Message-ID: <20091230222527.GB13802@discord.disaster>
References: <20091201150503.958283878@bombadil.infradead.org>
	<20091201151037.381644480@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20091201151037.381644480@bombadil.infradead.org>
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

On Tue, Dec 01, 2009 at 10:05:04AM -0500, Christoph Hellwig wrote:
> MAXEXTLEN is a limit for the bmap btree extent length, not for the freespace
> btrees which can fill out the whole u32.  Remove the check which makes
> repair skip too large freespace extents.  Also add warnings for freespace
> btree records that fail the remaining validations.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
