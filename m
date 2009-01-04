Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n04Mjo0I001725 for <xfs@oss.sgi.com>; Sun, 4 Jan 2009 16:45:50 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ABF9313D152C
	for <xfs@oss.sgi.com>; Sun,  4 Jan 2009 14:45:48 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	qKxfbPWmOyr1WWpL for <xfs@oss.sgi.com>;
	Sun, 04 Jan 2009 14:45:48 -0800 (PST)
Date: Mon, 5 Jan 2009 09:40:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] sanity check attr fork size
Message-ID: <20090104224011.GK10725@disturbed>
References: <20090104164211.GA15734@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090104164211.GA15734@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Sun, Jan 04, 2009 at 11:42:11AM -0500, Christoph Hellwig wrote:
> Recently we have quite a few kerneloops reports about dereferencing a NULL
> if_data in the attribute fork.  From looking over the code this can only
> happen if we pass a 0 size argument to xfs_iformat_local.  This implies some
> sort of corruption and in fact the only mailinglist report about this from
> earlier this year was after a powerfail presumably on a system with write
> cache and without barriers.
> 
> Add a quick sanity check for the attr fork size in xfs_iformat to catch
> these early and without an oops.

Looks sane to me.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
