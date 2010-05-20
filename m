Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4K91AHK194512 for <xfs@oss.sgi.com>; Thu, 20 May 2010 04:01:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC58F156ED60
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 02:04:41 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id 8ThaSUltZExnymdR for <xfs@oss.sgi.com>;
	Thu, 20 May 2010 02:04:41 -0700 (PDT)
Date: Thu, 20 May 2010 05:03:28 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [2.6.33.3] scheduling while atomic (inode reclaim races still?)
Message-ID: <20100520090328.GA21428@infradead.org>
References: <20100520083104.GA4723@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100520083104.GA4723@hostway.ca>
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
To: Simon Kirby <sim@hostway.ca>
Cc: xfs@oss.sgi.com

On Thu, May 20, 2010 at 01:31:04AM -0700, Simon Kirby wrote:
> This started happening on host about 10 days after upgrading to 2.6.33.3
> (in hopes that it fixed all of the reclaim issues present in 2.6.33.2). 
> I don't see any fixes in 2.6.33.4 relevant to this particular issue.
> 
> After this first error, the kernel logs just filled with repeat
> occurrences with different backtraces.
> 
> BUG: scheduling while atomic: nfsd/29671/0x00000250

The bug unfortunately doesn't tell us what caused the "atomic"
situation.  But given that XFS doesn't take any spinlock in that path
it seems like this must be caused by nfsd.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
