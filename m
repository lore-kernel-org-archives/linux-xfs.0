Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0EAAZxt250267 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 04:10:36 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2A61E1DB111A
	for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 02:11:31 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	IsyRoUF3MLTcR1Jo for <xfs@oss.sgi.com>;
	Thu, 14 Jan 2010 02:11:31 -0800 (PST)
Date: Thu, 14 Jan 2010 21:11:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: Make the compile output cleaner V2
Message-ID: <20100114101128.GX17483@discord.disaster>
References: <1263377007-4500-1-git-send-email-david@fromorbit.com>
	<20100113220814.GA17310@infradead.org>
	<20100113223001.GR17483@discord.disaster>
	<20100114065123.GA32559@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100114065123.GA32559@infradead.org>
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

On Thu, Jan 14, 2010 at 01:51:23AM -0500, Christoph Hellwig wrote:
> On Thu, Jan 14, 2010 at 09:30:01AM +1100, Dave Chinner wrote:
> > > >  	include/builddefs include/platform_defs.h
> > > 
> > > >  distclean: clean
> > > > -	rm -f $(LDIRT)
> > > > +	$(Q)rm -f $(DISTDIRT)
> > > 
> > > What does this have to do with the rest?
> > 
> > That's the "make clean doesn't cause configure to run again" fix.
> 
> Which is not related to the clean output build system..
> 
> I'm pretty sure we did this intentionally, but I'm open to a discussion
> about changing it.

It seems completely spurious to me - normal practice is to blow away
the config on a distclean, not a plain clean. And seeing as the
patch is about removing noise during the normal build, I figured
this qualified as a bug causing noise.

I can separate it out into another patch, but I'd really prefer that
make clean doesn't result in running configure again. Especially
considering the build dependencies are very broken so the only way
to guarantee a build catches all changes is to do 'make clean;
make'.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
