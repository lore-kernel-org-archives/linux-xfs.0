Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5T7spGT067896 for <xfs@oss.sgi.com>; Tue, 29 Jun 2010 02:54:52 -0500
Date: Tue, 29 Jun 2010 03:57:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/15] xfs: minimize DMAPI footprint
Message-ID: <20100629075734.GA31118@infradead.org>
References: <1277762653.2040.554.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1277762653.2040.554.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

> SGI has a product that uses the DMAPI support code that's
> included in mainline XFS, along with some additional code
> (the "never merged" stuff Christoph refers to) that we
> maintain separately.  To our customers that need it, this
> is an extremely important feature.

So why don't you bother to get HSM support upstream properly,
or at least maintain it somewhere where you can get at it?
What sourcxe tree do those important customers use it?

> What follows is a set of patches that I think accomplishes
> these goals.  The net result of these changes is:

While this is a lot better than the old DMAPI supoort, it's still
lots of dead code in the mainline tree, that won't ever be used
there, as proper HSM suport if it ever was merged would sit at
the VFS layer.

In addition to that the people who effectively maintain XFS for both
the community and lots of paying customers have done a large amount
of work ontop of the DMAPI removal of the last 1 1/2 month.  So I'd
say rebase your changes over

	http://git.kernel.org/?p=linux/kernel/git/dgc/xfsdev.git;a=shortlog;h=refs/heads/for-2.6.36

and keep them in a separate branch dmapi-dev branch where SGI can pull
the code for it's customers from.  This branch could also include the
actual dmapi code and core kernel modifications, so that people that
want dmapi support actually have chance to find a complete kernel tree
for it.  I'd also hope you have fixed grave bugs like the oops on
unmount after multiple mount one I pointed out to SGI about two years
ago, but which still wasn't fixed inthe last dmapi enabled tree.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
