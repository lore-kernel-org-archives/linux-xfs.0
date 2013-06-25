Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 90D277F37
	for <xfs@oss.sgi.com>; Tue, 25 Jun 2013 17:01:49 -0500 (CDT)
Date: Tue, 25 Jun 2013 17:01:23 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfsprogs: fix make deb
Message-ID: <20130625220123.GG20932@sgi.com>
References: <1371526854-15761-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371526854-15761-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Tue, Jun 18, 2013 at 01:40:53PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Commit 48212a30 ("xfsprogs: update 'make deb' to use tarball) fixed
> a bunch of problems with making the source tarball for releases.
> However, it broke the debian package builds in a way I hadn't
> noticed until I rewrote my CI system build script.
> 
> I noticed that the CI system wasn't building from a pristine
> workarea, and instead was just updating the old workarea and running
> 'make deb'. I added a 'make realclean' to remove all previous state
> from the workarea, and then 'make deb' started failing with errors
> building the tarball because po/xfsprogs.pot didn't have a build
> rule
> 
> The above commit removed the pre-build of the translations target,
> and instead made the translation build target a dependency of
> building the the tarball. Hence the lack of a build rule of the
> translations causes the source tarball build to fail.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

My systems seem not to be having this problem.  They seem to be building
xfsprogs.pot due to the dependancy through SRCDIR->SRCTAR->SRCTARINC.  Can you
post the error?

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
