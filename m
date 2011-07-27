Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RKlWr6220571 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 15:47:33 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68BDD18314AC
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 13:47:31 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	vCReKBPaF8gjIcy4 for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2011 13:47:31 -0700 (PDT)
Date: Wed, 27 Jul 2011 16:47:24 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
Message-ID: <20110727204724.GA21314@infradead.org>
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<4E306D09.5030704@netapp.com>
	<20110727200240.GA16054@infradead.org>
	<201107272227.03265.sweet_f_a@gmx.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201107272227.03265.sweet_f_a@gmx.de>
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
To: R?diger Meier <sweet_f_a@gmx.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, Bryan Schumaker <bjschuma@netapp.com>, Christoph Hellwig <hch@infradead.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

On Wed, Jul 27, 2011 at 10:26:55PM +0200, R?diger Meier wrote:
> At the time I've started this thread
> http://comments.gmane.org/gmane.linux.nfs/40863
> I had the feeling that the readdir cache changings in 2.6.37 have 
> something to do with these loop problems.
> 
> After that thread I've accepted that's a general problem with 
> ext4/dirindex and nfs but seeing it again on xfs with just 5000 files 
> I'm in doubt again.

Two separate issues.  For one thing the nfs code simply doesn't seem
to handle changing directories very well, and one and a half the Linux
NFS server might even send incoherent readdir output in a single
protocol reply.

Issue two is that the ext3/4 hashed directory format is too simply (not
to say dumb) to provide a proper 32-bit linear value for the dirent
d_off field.  It's not a complex task, and the first relatively simple
generation of xfs btree directories couldn't handle it either.  The
v2 directory format handles it fine, but at the cost of a much more
complex codebase.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
