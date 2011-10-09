Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p99NmBoM132506 for <xfs@oss.sgi.com>; Sun, 9 Oct 2011 18:48:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9425C4EEBFE
	for <xfs@oss.sgi.com>; Sun,  9 Oct 2011 16:48:10 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	N43NWHxTPu2IrCr5 for <xfs@oss.sgi.com>;
	Sun, 09 Oct 2011 16:48:10 -0700 (PDT)
Date: Sun, 9 Oct 2011 19:48:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] repair: don't cache large blkmap allocations
Message-ID: <20111009234809.GB13527@infradead.org>
References: <1318201910-11144-1-git-send-email-david@fromorbit.com>
	<1318201910-11144-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318201910-11144-5-git-send-email-david@fromorbit.com>
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

> +	/* consider more than 100k extents rare */
> +	if (blkmap->naexts < 100 * 1024)
> +		return;

100k extents still seems like a fairly high number.  Otherwise looks
okay.

(If only we had a non-sucky threaded memory allocator in userspace..)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
