Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RK5vxg219020 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 15:05:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F36049CD07
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 13:05:56 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	P20JAPGNXfdHzbZ1 for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 13:05:56 -0700 (PDT)
Date: Wed, 27 Jul 2011 16:05:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
Message-ID: <20110727200550.GA23416@infradead.org>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<20110727160752.GC974@fieldses.org>
	<alpine.DEB.2.02.1107271227340.1451@p34.internal.lan>
	<20110727181111.GA23009@infradead.org>
	<alpine.DEB.2.02.1107271530340.1451@p34.internal.lan>
	<20110727193937.GA5354@infradead.org>
	<alpine.DEB.2.02.1107271540100.1451@p34.internal.lan>
	<20110727194722.GA9345@infradead.org> <4E306D09.5030704@netapp.com>
	<20110727200240.GA16054@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110727200240.GA16054@infradead.org>
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
To: Bryan Schumaker <bjschuma@netapp.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>

On Wed, Jul 27, 2011 at 04:02:40PM -0400, Christoph Hellwig wrote:
> But looking closer at it it only prints the directory name and not that
> of any of the matching cookies, making it pretty useless to debug any
> problem.  (and it makes my previous question to Justin look stupid..).
> 
> 
> But so far I still stick to my previous theory that this sounds like
> a directory offset getting reused.  How is cache invalidation for
> the array supposed to work?  And maybe more importantly, given that he
> can only reproduce it with a .38 client did any bugs get fixed in that
> code recently that might lead to issues with the cache invalidation?

Actually we won't even need cache invalidation bugs, see
nfsd_buffered_readdir() - we might do multiple vfs_readdir calls to
fill a single nfs reply, and between these two directory contents might
have been completely replaced, in the worst (pathological case) you
might get a second readdir having exactly the same offsets, but pointing
to completely different inodes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
