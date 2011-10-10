Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9A0E4FR133648 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 19:14:05 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2DCD152E8DD
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 17:21:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	K4SNlmWMy0PWBd5w for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 17:21:09 -0700 (PDT)
Date: Mon, 10 Oct 2011 11:14:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 4/5] repair: don't cache large blkmap allocations
Message-ID: <20111010001400.GO3159@dastard>
References: <1318201910-11144-1-git-send-email-david@fromorbit.com>
	<1318201910-11144-5-git-send-email-david@fromorbit.com>
	<20111009234809.GB13527@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111009234809.GB13527@infradead.org>
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

On Sun, Oct 09, 2011 at 07:48:09PM -0400, Christoph Hellwig wrote:
> > +	/* consider more than 100k extents rare */
> > +	if (blkmap->naexts < 100 * 1024)
> > +		return;
> 
> 100k extents still seems like a fairly high number.  Otherwise looks
> okay.

But not unreasonable for a filesystem full of torrents ;)

> (If only we had a non-sucky threaded memory allocator in userspace..)

Perhaps we should look at the talloc code from ccan?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
