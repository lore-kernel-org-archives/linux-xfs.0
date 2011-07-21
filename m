Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LGVSwj036007 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 11:31:28 -0500
Received: from test.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7C06C1E6923A
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 09:31:27 -0700 (PDT)
Received: from test.thunk.org (li9-11.members.linode.com [67.18.176.11]) by
	cuda.sgi.com with ESMTP id fqo3nL23tmFcHXIY for
	<xfs@oss.sgi.com>; Thu, 21 Jul 2011 09:31:27 -0700 (PDT)
Date: Thu, 21 Jul 2011 12:31:22 -0400
From: "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Problems building xfsprogs
Message-ID: <20110721163122.GD3304@thunk.org>
References: <20110720175918.GB17971@thunk.org>
	<20110721090619.GA26263@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110721090619.GA26263@infradead.org>
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
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 21, 2011 at 05:06:19AM -0400, Christoph Hellwig wrote:
> I works fine for me on various releases of Debian, Fedsora, RHEL and
> SLES.  But all he machines I've quickly checked seem to have an autoconf
> that can handle -I, so could you please send this pach with a proper
> signoff and description?

Sure, will do.

> > b) By default xfsprogs builds with DEBUG, and this causes building
> > libxfs/xfs_ialloc.c to blow up since there a reference of
> > xfs_stack_trace() which is undefined under a #ifdef DEBUG.  The way to
> > fix this is to build with DEBUG=-DNDEBUG, but it took me an hour or
> > two figure this out....
> 
> The defaul actually is DEBUG=-DNDEBUG.  No sure how you go he debug
> build. but we surely should fix it.  I'll add the stub as soon as I get
> some time.

Well, the default from xfstest-dev/m4/package_globals.m4 is:

    DEBUG=${DEBUG:-'-DDEBUG'}					dnl  -DNDEBUG
    debug_build="$DEBUG"
    AC_SUBST(debug_build)

I'm guessing you're getting the default of DEBUG=-DNDEBUG because
you're getting the package_globals.m4 package from some other m4
directory....

						- Ted


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
