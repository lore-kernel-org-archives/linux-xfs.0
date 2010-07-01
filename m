Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o61BgoHS191531 for <xfs@oss.sgi.com>; Thu, 1 Jul 2010 06:42:51 -0500
Received: from mail.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0C32B15AD314
	for <xfs@oss.sgi.com>; Thu,  1 Jul 2010 04:50:35 -0700 (PDT)
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20]) by cuda.sgi.com
	with SMTP id 4IBcD5MCfYdNN3dE for <xfs@oss.sgi.com>;
	Thu, 01 Jul 2010 04:50:35 -0700 (PDT)
Date: Thu, 1 Jul 2010 13:45:30 +0200
From: Mario Bachmann <grafgrimm77@gmx.de>
Subject: Re: vmalloc, xfs_buf_get: failed to map pages
Message-ID: <20100701134530.5f794758@x2.grafnetz>
In-Reply-To: <20100621072118.GA1361@infradead.org>
References: <20100619150119.3ce64102@x2.grafnetz>
	<20100621072118.GA1361@infradead.org>
Mime-Version: 1.0
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

Hi again, 

what is a good value for vmalloc= ? 
The machine has 1 GB of RAM. 

Greetings
Mario

Am Mon, 21 Jun 2010 03:21:18 -0400
schrieb Christoph Hellwig <hch@infradead.org>:

> On Sat, Jun 19, 2010 at 03:01:19PM +0200, Mario Bachmann wrote:
> > Hello, 
> > 
> > on a 32bit machine, I have big problems with Linux 2.6.34. 
> > With Linux 2.6.33.4 everything runs fine. 
> > 
> > I do not know where to search for known bugs in xfs.
> > 
> > /var/log/messages shows a lot of lines:
> > 
> > Jun 19 11:43:15 amd2000 kernel: vmap allocation for size 4194304 failed: use vmalloc=<size> to increase size.
> > Jun 19 11:43:15 amd2000 kernel: xfs_buf_get: failed to map pages
> > 
> > What to to?
> 
> Strange.  There have been no fixes to the vmap allocator nor to the
> XFS using this.  What other modules are you ising?  Maybe they increased
> their amount of used vmalloc space.  For now the only thing you can do
> is using the vmalloc= kernel paramter to increase the vmalloc space.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
