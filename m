Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n73L3Bee113546 for <xfs@oss.sgi.com>; Mon, 3 Aug 2009 16:03:12 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0F423A1C92
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2009 14:04:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YJzDaDZPhtrWPcEu for
	<xfs@oss.sgi.com>; Mon, 03 Aug 2009 14:04:01 -0700 (PDT)
Date: Mon, 3 Aug 2009 17:03:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: kernel BUG at lib/radix-tree.c:464
Message-ID: <20090803210358.GA15109@infradead.org>
References: <alpine.DEB.2.01.0908022321060.5831@bogon.housecafe.de>
	<20090803122440.GA11033@infradead.org>
	<alpine.DEB.2.01.0908031340300.5831@bogon.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0908031340300.5831@bogon.housecafe.de>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Aug 03, 2009 at 01:54:42PM -0700, Christian Kujau wrote:
> I'm using the latest -git tree atm, the patch cannot be applied cleanly:
> 
> $ patch --dry-run -p1 < iget-fixes_bug13375.patch
> [...]
> Hunk #4 FAILED at 215.
> 1 out of 4 hunks FAILED -- saving rejects to file fs/inode.c.rej
> Hunk #1 FAILED at 51.
> 1 out of 1 hunk FAILED -- saving rejects to file 
> fs/xfs/linux-2.6/xfs_sync.h.rej
> 
> I'll try to go back to 2.6.30, but I'm not sure if I can even reproduce 
> this one reliably.

The latest patch is for 2.6.30, then one before is for the current
git tree.  Note that the one for current git has a small buglet if you
want to compile XFS as a module: in that case you need t ochange the
EXPORT_SYMBOL of destroy_inode in fs/inode.c to an export for
__destroy_inode.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
