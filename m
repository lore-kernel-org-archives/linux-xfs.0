Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0DMT9Dc195735 for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 16:29:09 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B89F1C4CFF7
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 14:30:04 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	vcU4DStfzr3rrWqE for <xfs@oss.sgi.com>;
	Wed, 13 Jan 2010 14:30:04 -0800 (PST)
Date: Thu, 14 Jan 2010 09:30:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: Make the compile output cleaner V2
Message-ID: <20100113223001.GR17483@discord.disaster>
References: <1263377007-4500-1-git-send-email-david@fromorbit.com>
	<20100113220814.GA17310@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100113220814.GA17310@infradead.org>
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

On Wed, Jan 13, 2010 at 05:08:14PM -0500, Christoph Hellwig wrote:
> On Wed, Jan 13, 2010 at 09:03:27PM +1100, Dave Chinner wrote:
> > -LDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
> > +DISTDIRT = config.log .dep config.status config.cache confdefs.h conftest* \
> >  	built .census install.* install-dev.* *.gz autom4te.cache/* libtool \
> >  	include/builddefs include/platform_defs.h
> 
> >  distclean: clean
> > -	rm -f $(LDIRT)
> > +	$(Q)rm -f $(DISTDIRT)
> 
> What does this have to do with the rest?

That's the "make clean doesn't cause configure to run again" fix.

> Otherwise looks good,
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Any chance you could also port it to xfsdump?

Yes, I'm slowly working my way through the different trees
doing this, then I'll go fix all the compile warnings we
currently have...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
