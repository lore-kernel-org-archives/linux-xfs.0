Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o18ASUAo124504 for <xfs@oss.sgi.com>; Mon, 8 Feb 2010 04:28:32 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 53F431CADCAA
	for <xfs@oss.sgi.com>; Mon,  8 Feb 2010 02:29:43 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ncwwOLB85m030Gzo for
	<xfs@oss.sgi.com>; Mon, 08 Feb 2010 02:29:43 -0800 (PST)
Date: Mon, 8 Feb 2010 05:29:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: make install in the brave new build system world
Message-ID: <20100208102942.GA25395@infradead.org>
References: <20100205092229.GA32454@infradead.org>
	<20100205104414.GC11483@discord.disaster>
	<20100205112850.GB28701@infradead.org>
	<20100205114856.GE11483@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100205114856.GE11483@discord.disaster>
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

On Fri, Feb 05, 2010 at 10:48:56PM +1100, Dave Chinner wrote:
> Ah, there's a double depenency chain.
> 
> The top level make file has:
> 
> install: default
> 
> Which causes "make install" to run the top level default target,
> which runs the default target in all the target subdirs.
> 
> Then, in each subdir, the makefile has:
> 
> install: default
> 
> Which when then install target is actually run, does another
> dependency check because it's got a local dependency on the depend
> target via the default target.
> 
> Replace the previous patch with the one below and try again.
> Now the "make install" will rebuild targets out of the local
> dependencies rather than a separate run of the top level default
> target (i.e. only traverse directories once).

Thanks, this looks much better.  We still don't implement the
quite behaviour for most install targets, but that should be relatively
simple to fix.  Maybe we can even replace all those handcode install
rules with generic one - I'll look into that once I get a bit time.

So

Reviewed-by: Christoph Hellwig <hch@lst.de>

for this patch for now.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
