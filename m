Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L7Idrt110170 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 02:18:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 487C414AAB62
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 00:25:23 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id 96eXZFKNuIP6ubyM for <xfs@oss.sgi.com>;
	Mon, 21 Jun 2010 00:25:23 -0700 (PDT)
Date: Mon, 21 Jun 2010 03:21:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: vmalloc, xfs_buf_get: failed to map pages
Message-ID: <20100621072118.GA1361@infradead.org>
References: <20100619150119.3ce64102@x2.grafnetz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100619150119.3ce64102@x2.grafnetz>
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
To: Mario Bachmann <grafgrimm77@gmx.de>
Cc: xfs@oss.sgi.com

On Sat, Jun 19, 2010 at 03:01:19PM +0200, Mario Bachmann wrote:
> Hello, 
> 
> on a 32bit machine, I have big problems with Linux 2.6.34. 
> With Linux 2.6.33.4 everything runs fine. 
> 
> I do not know where to search for known bugs in xfs.
> 
> /var/log/messages shows a lot of lines:
> 
> Jun 19 11:43:15 amd2000 kernel: vmap allocation for size 4194304 failed: use vmalloc=<size> to increase size.
> Jun 19 11:43:15 amd2000 kernel: xfs_buf_get: failed to map pages
> 
> What to to?

Strange.  There have been no fixes to the vmap allocator nor to the
XFS using this.  What other modules are you ising?  Maybe they increased
their amount of used vmalloc space.  For now the only thing you can do
is using the vmalloc= kernel paramter to increase the vmalloc space.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
