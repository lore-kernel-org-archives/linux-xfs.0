Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6B5RkeY178484 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 00:27:46 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B8E317B1A03
	for <xfs@oss.sgi.com>; Sun, 10 Jul 2011 22:27:44 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	dXeLDTxNgljcFWLo for <xfs@oss.sgi.com>;
	Sun, 10 Jul 2011 22:27:44 -0700 (PDT)
Date: Mon, 11 Jul 2011 01:27:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Updated xfsprogs 2.6.38 merge
Message-ID: <20110711052744.GB13266@infradead.org>
References: <20110705024855.GA561@dastard>
	<20110710210113.GA14527@infradead.org>
	<20110711000135.GA23038@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110711000135.GA23038@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Jul 11, 2011 at 10:01:35AM +1000, Dave Chinner wrote:
> > But even after that a simple mkfs crashed for me on 32-bit x86.  Here is
> > the gdb backtrace:
> > 
> > Program received signal SIGSEGV, Segmentation fault.
> > 0x0805736b in tag_get (root=0xffffda5c, index=0) at radix-tree.c:82
> > 82		return 1 & (((const __uint32_t *)node->tags[tag])[offset >> 5] >> (offset & 31));
> > (gdb) bt
> > #0  0x0805736b in tag_get (root=0xffffda5c, index=0) at radix-tree.c:82
> > #1  radix_tree_delete (root=0xffffda5c, index=0) at radix-tree.c:726
> > #2  0x08054ee7 in libxfs_umount (mp=0xffffd8f8) at init.c:822
> > #3  0x0805277c in main (argc=3, argv=0xffffdd94) at xfs_mkfs.c:2683
> 
> What size block device? It's not failing here...

That was on a 40GB one, but I can also reproduce it on a 10GB one.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
