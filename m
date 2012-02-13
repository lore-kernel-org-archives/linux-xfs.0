Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DHTd70027675 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 11:29:39 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	1GNDRm5uVC14EtuD (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 09:29:38 -0800 (PST)
Date: Mon, 13 Feb 2012 12:29:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS unlink still slow on 3.1.9 kernel ?
Message-ID: <20120213172937.GA25248@infradead.org>
References: <4F394116.8080200@cape-horn-eng.com>
	<20120213170825.GA7197@infradead.org>
	<4F394442.9020307@cape-horn-eng.com>
	<20120213171556.GA13449@infradead.org>
	<4F3947D6.5060402@cape-horn-eng.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4F3947D6.5060402@cape-horn-eng.com>
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
To: Richard Ems <richard.ems@cape-horn-eng.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 13, 2012 at 06:26:46PM +0100, Richard Ems wrote:
> YES. All files (and dirs) that I checked do show something as
> 
> 0: [0..7]: 18531216..18531223
> 
> So, what improvements can I expect from a kernel > 3.2 ?
> Can I read somewhere about the changes/patches introduced?

On some crazy workloads I've seen speedups up to a factor of 10.000 (5
orders or magnitude).  You probably won't get that much of a speedup,
but it will still be significant.

The patch in mainline for this is:

commit 859f57ca00805e6c482eef1a7ab073097d02c8ca
Author: Christoph Hellwig <hch@infradead.org>
Date:   Sat Aug 27 14:45:11 2011 +0000

    xfs: avoid synchronous transactions when deleting attr blocks

> Is there another way to mount/create/mkfs the XFS to improve the unlink
> time for this case?

Try increasing the inode size during filesystem creating using the
"-i size=512" option or even "-i size=1024" if you still have
out of line attributes.  The should give you even bigger speedups
for this workload than the patch above.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
