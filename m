Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4A9907F3F
	for <linux-xfs@oss.sgi.com>; Wed,  6 Feb 2013 13:31:50 -0600 (CST)
Date: Wed, 6 Feb 2013 13:31:46 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/4] Refactor release scripts to conform to using
	git?archive
Message-ID: <20130206193146.GA22182@sgi.com>
References: <50F44B2E.9050408@sgi.com> <20130201190930.GX27055@sgi.com>
	<20130206011547.GT2667@dastard>
	<loom.20130206T072310-821@post.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <loom.20130206T072310-821@post.gmane.org>
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
To: Nathan Scott <nathans@debian.org>
Cc: linux-xfs@oss.sgi.com

On Wed, Feb 06, 2013 at 06:28:10AM +0000, Nathan Scott wrote:
> Dave Chinner <david <at> fromorbit.com> writes:
> 
> > 
> > It breaks the 'make deb' command for all the trees.
> > 
> 
> (thanks for checking!)
> 
> > The debian package build creates a link tree so that it builds
> > outside the main source tree (e.g. in ./xfsprogs-3.1.10) and as part
> > of the build it runs 'make dist' to build a tarball from that link
> > tree. That now fails with:
> > 
> > fatal: current working directory is untracked
> > 
> > coming from the git archive command that is now used to build the
> > tarball.
> > 
> > Nathan, can the debian package build use git-archive? I'm under the
> > impression that you have to be able to build debian packages from a
> > source tarball or a source package, and so the build can't rely on
> > being inside a VCS controlled tree. That rules out using git archive
> > for tarball creation...
> > 
> 
> IIRC, the requirement is to be building in a tree that had a basename
> of for <package>-<version> - hence the link'd tree build previously.
> If that can be maintained somehow, the build should be fine.  Symlinks
> did not work very well (IIRC) - the build tools might've used basename
> or realpath or something like that, but I do remember trying that.
> 
> > Also, given that the previous tarball creation used the same link
> > tree build as the debian package build (i.e. make source-link), that
> > implies the debian pacakges are going to be missing files using this
> > technique. Doesn't that mean we have to fix the file list being fed
> > into the source-link target regardless of whether we use git archive
> > to build the tarball?
> 
> The source tarball definitely needs to have the package-version prefix
> for all the files it contains - has a mechanism to acheive that been
> found?

It has... with a combo of git archive --prefix and tar --transform.  I'll see
what I can do to get 'make deb' going again.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
