Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o15BQcfS132220 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 05:26:39 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 66A8E1CA65FD
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2010 03:27:49 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id FJGS6OV48fkTHGV9 for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2010 03:27:49 -0800 (PST)
Date: Fri, 5 Feb 2010 06:27:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: make install in the brave new build system world
Message-ID: <20100205112747.GA28701@infradead.org>
References: <20100205092229.GA32454@infradead.org>
	<20100205104414.GC11483@discord.disaster>
	<20100205111741.GD11483@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100205111741.GD11483@discord.disaster>
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

On Fri, Feb 05, 2010 at 10:17:41PM +1100, Dave Chinner wrote:
> On Fri, Feb 05, 2010 at 09:44:14PM +1100, Dave Chinner wrote:
> > On Fri, Feb 05, 2010 at 04:22:29AM -0500, Christoph Hellwig wrote:
> > > When doing make install in xfsprogs I get a lot of spew like this:
> ....
> > >  b) for some reason the new silent make rules don't apply to this.
> > 
> > That's something I can't answer off the top of my head. I'll have a
> > look into it.
> 
> Try the patch below.

That makes it a bit better, but it still prints the full INSTALL and
LTINSTALL lines.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
