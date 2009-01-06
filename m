Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n061EH6r031757 for <xfs@oss.sgi.com>; Mon, 5 Jan 2009 19:14:17 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 477E217ACB3F
	for <xfs@oss.sgi.com>; Mon,  5 Jan 2009 17:14:16 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	hYofAh9g7KhayZNm for <xfs@oss.sgi.com>;
	Mon, 05 Jan 2009 17:14:16 -0800 (PST)
Date: Tue, 6 Jan 2009 12:14:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] define xfs_ino_t as unsigned long long
Message-ID: <20090106011414.GB9448@disturbed>
References: <20090105193129.GA19909@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090105193129.GA19909@infradead.org>
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

On Mon, Jan 05, 2009 at 02:31:29PM -0500, Christoph Hellwig wrote:
> That way we can avoid ugly casts when printining it (like the ones
> that show up on powerpc with Linus' current tree).

Is that because ppc uses int-l64.h instead of int-64ll.h and so __64 gets
defined to an unsigned long on that platform?

Whatever the reason, it looks fine to me.

Reviewed-by: Dave Chinner <david@fromorbit.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
