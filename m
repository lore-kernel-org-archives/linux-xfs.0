Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RKR8gb219939 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 15:27:08 -0500
Received: from mailout-de.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id F3C5A9D2E3
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 13:27:06 -0700 (PDT)
Received: from mailout-de.gmx.net (mailout-de.gmx.net [213.165.64.23]) by
	cuda.sgi.com with SMTP id 5jvFYzhs9eZZFbZ4 for
	<xfs@oss.sgi.com>; Wed, 27 Jul 2011 13:27:06 -0700 (PDT)
From: =?iso-8859-1?q?R=FCdiger_Meier?= <sweet_f_a@gmx.de>
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
Date: Wed, 27 Jul 2011 22:26:55 +0200
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<4E306D09.5030704@netapp.com>
	<20110727200240.GA16054@infradead.org>
In-Reply-To: <20110727200240.GA16054@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201107272227.03265.sweet_f_a@gmx.de>
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
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, Bryan Schumaker <bjschuma@netapp.com>

On Wednesday 27 July 2011, Christoph Hellwig wrote:
> On Wed, Jul 27, 2011 at 03:54:49PM -0400, Bryan Schumaker wrote:
> > It should be printing on the second hit of a cookie.
>
> But looking closer at it it only prints the directory name and not
> that of any of the matching cookies, making it pretty useless to
> debug any problem.  (and it makes my previous question to Justin look
> stupid..).
>
>
> But so far I still stick to my previous theory that this sounds like
> a directory offset getting reused.  How is cache invalidation for
> the array supposed to work?  And maybe more importantly, given that
> he can only reproduce it with a .38 client did any bugs get fixed in
> that code recently that might lead to issues with the cache
> invalidation?

At the time I've started this thread
http://comments.gmane.org/gmane.linux.nfs/40863
I had the feeling that the readdir cache changings in 2.6.37 have 
something to do with these loop problems.

After that thread I've accepted that's a general problem with 
ext4/dirindex and nfs but seeing it again on xfs with just 5000 files 
I'm in doubt again.

cu,
Rudi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
