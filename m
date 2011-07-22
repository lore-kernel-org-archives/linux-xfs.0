Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MEwikg090200 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 09:58:44 -0500
Date: Fri, 22 Jul 2011 10:58:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs: rename "linux-2.6" subdirectory to be simply
	"linux"
Message-ID: <20110722145842.GA15962@infradead.org>
References: <201107211804.p6LI4Rvf006075@stout.americas.sgi.com>
	<20110722143420.GE19681@infradead.org>
	<1311346434.2771.17.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311346434.2771.17.camel@doink>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jul 22, 2011 at 09:53:54AM -0500, Alex Elder wrote:
> On Fri, 2011-07-22 at 10:34 -0400, Christoph Hellwig wrote:
> > Actually it should just go away.  It's a leftover from when we had
> > code for Linux 2.4 and Linux 2.6 in the same ptools repository. 
> 
> So this is an admission that XFS has gone from an
> Irix-only to a Linux-only filesystem?  We have
> strayed from it but I think there is value in
> trying to separate the core platform-independent
> part of the code from the part that interfaces
> with the OS environment.

It's not Linux only, but very centered around Linux APIs.  We still
have a low-level layer that only uses library-functins like sorting
helpers, trees, etc from the generic kernel, and a higher level that
fully interacts with it.  This seems like a useful abstraction to me,
and I'd like to keep it that way (nevermind that we really have to
because of libxfs in xfsprogs).  But that border is nowhere near the
linux-2.6 directory split, and much better done using a comment in
the makefile explaining which files are shared with libxfs.  That's
what I was planning to do for my move pull request.

Note that currently the shared code doesn't even perfectly align to
files, making the libxfs resync harder than nessecary, but that's
also something on my mid-term todo list.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
