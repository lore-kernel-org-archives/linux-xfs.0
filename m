Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6RLLvkc221704 for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 16:22:02 -0500
Received: from mailout-de.gmx.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id B87991BFD7CC
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2011 14:21:56 -0700 (PDT)
Received: from mailout-de.gmx.net (mailout-de.gmx.net [213.165.64.23]) by
	cuda.sgi.com with SMTP id paBJVsUVRmd9aQ82 for
	<xfs@oss.sgi.com>; Wed, 27 Jul 2011 14:21:56 -0700 (PDT)
From: =?iso-8859-1?q?R=FCdiger_Meier?= <sweet_f_a@gmx.de>
Subject: Re: 2.6.xx: NFS: directory motion/cam2 contains a readdir loop
Date: Wed, 27 Jul 2011 23:21:45 +0200
References: <alpine.DEB.2.02.1107270952270.1451@p34.internal.lan>
	<201107272227.03265.sweet_f_a@gmx.de>
	<20110727204724.GA21314@infradead.org>
In-Reply-To: <20110727204724.GA21314@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <201107272321.54030.sweet_f_a@gmx.de>
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
> On Wed, Jul 27, 2011 at 10:26:55PM +0200, R?diger Meier wrote:
> > At the time I've started this thread
> > http://comments.gmane.org/gmane.linux.nfs/40863
> > I had the feeling that the readdir cache changings in 2.6.37 have
> > something to do with these loop problems.
> >
> > After that thread I've accepted that's a general problem with
> > ext4/dirindex and nfs but seeing it again on xfs with just 5000
> > files I'm in doubt again.
>
> Two separate issues. [...]

Yup, I didn't wanted to say that I'm in doubt about the general 
ext4/dirindex problem but I'am still in doubt about the complete 
innocence of readdir cache.

I guess I've run into both issues at that time. I remember that I 
couldn't easily create such "broken" dir from scratch but my users 
managed it to have dozens of them, often just about 30000 files.
Somehow it seemed to be important that the dirs were growing in a 
natural way.

However no probs again since with xfs and ext4 without dirindex. But 
still the feeling that upgrading to 2.6.37 was also a part of the 
problem.

cu,
Rudi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
