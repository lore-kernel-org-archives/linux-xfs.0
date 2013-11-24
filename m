Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E5BFD7F3F
	for <xfs@oss.sgi.com>; Sun, 24 Nov 2013 03:18:40 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8F3BAAC002
	for <xfs@oss.sgi.com>; Sun, 24 Nov 2013 01:18:37 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 2y4bNn4VITk7srcz (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 24 Nov 2013 01:18:32 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VkVpm-0001dZ-NR
	for xfs@oss.sgi.com; Sun, 24 Nov 2013 09:18:30 +0000
Date: Sun, 24 Nov 2013 01:18:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] xfs: defer EFI and EFD log formatting until
	iop_format time
Message-ID: <20131124091830.GA6253@infradead.org>
References: <20131123151151.716201348@bombadil.infradead.org>
	<20131123151534.204073240@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131123151534.204073240@bombadil.infradead.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On Sat, Nov 23, 2013 at 07:11:56AM -0800, Christoph Hellwig wrote:
> No need to allocate large chunks of memory to format each extent into
> an array when logging the EFI or EFD items.  Instead just point to the
> bmap free list and only generate the log format at iop_format time.
> 
> Also get rid of the now almost empty xfs_trans_extfree.c by merging it
> into xfs_extfree_item.c.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Turns out this version can fairly easily cause use after frees, so it'll
need a bit of an overhaul to get the lifetime rules right.  As I have
other things in that area in the queue consider patches 5 to 7 withdrawn
for now, they will be submitted as a separate series once ready.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
