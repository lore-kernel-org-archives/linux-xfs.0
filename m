Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DFB83800E
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 10:24:57 -0600 (CST)
Date: Thu, 14 Feb 2013 10:24:54 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/4] Refactor release scripts to conform to using git
	archive
Message-ID: <20130214162454.GH30652@sgi.com>
References: <20130214010853.GD22182@sgi.com>
	<1295709208.2558271.1360808077935.JavaMail.root@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1295709208.2558271.1360808077935.JavaMail.root@redhat.com>
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
Cc: xfs@oss.sgi.com, Andrew Dahl <adahl@sgi.com>

Hey Nathan,

On Wed, Feb 13, 2013 at 09:14:37PM -0500, Nathan Scott wrote:
> ----- Original Message -----
> > On Wed, Feb 06, 2013 at 12:15:47PM +1100, Dave Chinner wrote:
> > > ...
> > > It breaks the 'make deb' command for all the trees.
> > 
> > xfsprogs: update 'make deb' to use tarball
> > 
> > This patch changes the build process so that 'make deb' uses the same
> > process of creating a source tree as the release script.
> > 
> > * Add a list of files which go in the release tarball in .git_census
> >   This is needed so that you can create a tarball in a bare release
> >   tree, when .git is not available.
> > 
> 
> I think you'll need .git_census in .gitignore (ala configure).
> Possibly remove the underscore for naming consistency - *shrug*.

Will do.  Thanks.

> 
> > 
> > * 'make deb' now creates unsigned packages by default, 'make debsign'
> >   creates signed packages.
> > 
> 
> Ehrm - why?  Everything else in your patch worked, but this part broke
> (which suggests a larger problem, in that this build path is no longer
> checked on every build) ...
> 
> debsign: Can't find or can't read changes file !
> 
> > +debsign: deb
> > +	debsign
> > +
> 
> (That's not valid usage, FWIW).
>
> I would recommend just removing that change in behaviour, "make deb"
> was fine as it was (for me anyway, and evidently for Dave too).  Best
> to go secure-by-default and not change this.

'make deb' failed for me like this:

signfile xfsprogs_3.1.9.dsc
gpg: skipped "Nathan Scott <nathans@debian.org>": secret key not available
gpg: [stdin]: clearsign failed: secret key not available

dpkg-genchanges  >../xfsprogs_3.1.9_amd64.changes
dpkg-genchanges: including full source code in upload
dpkg-buildpackage: full upload; Debian-native package (full source is included)
dpkg-buildpackage: warning: Failed to sign .dsc and .changes file
make: *** [deb] Error 1

Secure-by-default is a great idea but it seems that in this case it also
requires that anyone who wants to do a build for debian has to do it on a
machine with a keyring containing your secret key. ;)

I think it is also reasonable for devs to be able to build test debs on
machines that have empty keyrings.  An unsigned 'make deb' does return 0.  I'd
like this to suit everyone's needs if it can.  I'll split this part out into a
separate patch and try to figure something out later.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
