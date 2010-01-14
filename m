Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0E6oQHY234683 for <xfs@oss.sgi.com>; Thu, 14 Jan 2010 00:50:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D2A6E15F6D5
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2010 22:51:23 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id lRJSKrqELkK8aKdb for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2010 22:51:23 -0800 (PST)
Date: Thu, 14 Jan 2010 01:51:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: Make the compile output cleaner V2
Message-ID: <20100114065123.GA32559@infradead.org>
References: <1263377007-4500-1-git-send-email-david@fromorbit.com>
	<20100113220814.GA17310@infradead.org>
	<20100113223001.GR17483@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100113223001.GR17483@discord.disaster>
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

On Thu, Jan 14, 2010 at 09:30:01AM +1100, Dave Chinner wrote:
> > >  	include/builddefs include/platform_defs.h
> > 
> > >  distclean: clean
> > > -	rm -f $(LDIRT)
> > > +	$(Q)rm -f $(DISTDIRT)
> > 
> > What does this have to do with the rest?
> 
> That's the "make clean doesn't cause configure to run again" fix.

Which is not related to the clean output build system..

I'm pretty sure we did this intentionally, but I'm open to a discussion
about changing it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
