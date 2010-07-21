Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6LJ77n6093464 for <xfs@oss.sgi.com>; Wed, 21 Jul 2010 14:07:07 -0500
Subject: Re: xfsprogs: only absolute run-paths are allowed
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <alpine.DEB.2.01.1007211149320.3964@bogon.housecafe.de>
References: <alpine.DEB.2.01.1007210408390.3964@bogon.housecafe.de>
	<20100721171319.GA17772@infradead.org> <1279737202.1816.16.camel@doink>
	<alpine.DEB.2.01.1007211149320.3964@bogon.housecafe.de>
Date: Wed, 21 Jul 2010 14:10:04 -0500
Message-ID: <1279739404.1816.20.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2010-07-21 at 11:55 -0700, Christian Kujau wrote:
> On Wed, 21 Jul 2010 at 13:33, Alex Elder wrote:
> > > The patch below should fix this issue.  Note that you need to do a
> > > 
> > > 	make realclean
> > > 	make configure
> > > 
> > > to regenerate the configure script first.
> > 
> > This looks OK to me.  Once you get confirmation
> > it works for Christian you can re-format your
> > description and commit it.  (I didn't see the
> > problem in my environment for some reason.)
> 
> Yes, the patch works for me, thanks Christoph!
> 
>  Tested-by: Christian Kujau <lists@nerdbynature.de>
> 
> Btw, I noticed quite a few warnings[0] during compilation:
> 
>    warning: pointer targets in assignment differ in signedness
>    warning: pointer targets in passing argument 1 of '...' differ in signedness
> 
> I hope they're nothing to worry about?

Nothing to worry about.  We need to update some
code but it some cases it needs to match the
kernel code as well.  Eventually we'll get there.

					-Alex

> Thanks again,
> Christian.
> 
> [0] http://nerdbynature.de/bits/xfsprogs/prefix/make_v3.1.2.log.gz



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
