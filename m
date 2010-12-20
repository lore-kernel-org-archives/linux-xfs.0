Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBKBTiZM115739 for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 05:29:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8E0A6146C9F4
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:31:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id CiHBtTNupkuqQNMP for
	<xfs@oss.sgi.com>; Mon, 20 Dec 2010 03:31:41 -0800 (PST)
Date: Mon, 20 Dec 2010 06:31:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_efi_item slab leak
Message-ID: <20101220113139.GA10324@infradead.org>
References: <AANLkTi=LrU2CsC-VZmJ5M9U7eJpjqfAv8UgaEYv=Sg01@mail.gmail.com>
	<20101218000245.GG5193@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101218000245.GG5193@dastard>
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
Cc: Nick Piggin <npiggin@gmail.com>, xfs@oss.sgi.com

On Sat, Dec 18, 2010 at 11:02:45AM +1100, Dave Chinner wrote:
> Ok, after unmounting everything I can see two items in remaining in
> the xfs_efi_item cache after an xfstests run. ??t's probably to do
> with a filesystem shutdown not cleaning them up correctly. I'll put
> it on my list of stuff to track down.

Does it still happen with your working tree?  The incorrect handling
of IOP_UNPING with remove == 1 looks like it could cause something
similar.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
