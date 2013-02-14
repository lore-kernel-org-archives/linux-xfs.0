Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 33313805C
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 16:36:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D0A22304059
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2013 14:36:18 -0800 (PST)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	Ks4V3OqRfX4dS1CP for <xfs@oss.sgi.com>;
	Thu, 14 Feb 2013 14:36:17 -0800 (PST)
Date: Fri, 15 Feb 2013 09:36:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/4] Refactor release scripts to conform to using git
	archive
Message-ID: <20130214223613.GO26694@dastard>
References: <20130214010853.GD22182@sgi.com>
	<1295709208.2558271.1360808077935.JavaMail.root@redhat.com>
	<20130214162454.GH30652@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130214162454.GH30652@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: Nathan Scott <nathans@debian.org>, xfs@oss.sgi.com, Andrew Dahl <adahl@sgi.com>

On Thu, Feb 14, 2013 at 10:24:54AM -0600, Ben Myers wrote:
> Hey Nathan,
> 
> On Wed, Feb 13, 2013 at 09:14:37PM -0500, Nathan Scott wrote:
> > ----- Original Message -----
> > > On Wed, Feb 06, 2013 at 12:15:47PM +1100, Dave Chinner wrote:
> > > > ...
> > > > It breaks the 'make deb' command for all the trees.
> > > 
> > > xfsprogs: update 'make deb' to use tarball
> > > 
> > > This patch changes the build process so that 'make deb' uses the same
> > > process of creating a source tree as the release script.
> > > 
> > > * Add a list of files which go in the release tarball in .git_census
> > >   This is needed so that you can create a tarball in a bare release
> > >   tree, when .git is not available.
> > > 
> > 
> > I think you'll need .git_census in .gitignore (ala configure).
> > Possibly remove the underscore for naming consistency - *shrug*.
> 
> Will do.  Thanks.
> 
> > 
> > > 
> > > * 'make deb' now creates unsigned packages by default, 'make debsign'
> > >   creates signed packages.
> > > 
> > 
> > Ehrm - why?  Everything else in your patch worked, but this part broke
> > (which suggests a larger problem, in that this build path is no longer
> > checked on every build) ...
> > 
> > debsign: Can't find or can't read changes file !
> > 
> > > +debsign: deb
> > > +	debsign
> > > +
> > 
> > (That's not valid usage, FWIW).
> >
> > I would recommend just removing that change in behaviour, "make deb"
> > was fine as it was (for me anyway, and evidently for Dave too).  Best
> > to go secure-by-default and not change this.
> 
> 'make deb' failed for me like this:
> 
> signfile xfsprogs_3.1.9.dsc
> gpg: skipped "Nathan Scott <nathans@debian.org>": secret key not available
> gpg: [stdin]: clearsign failed: secret key not available
> 
> dpkg-genchanges  >../xfsprogs_3.1.9_amd64.changes
> dpkg-genchanges: including full source code in upload
> dpkg-buildpackage: full upload; Debian-native package (full source is included)
> dpkg-buildpackage: warning: Failed to sign .dsc and .changes file
> make: *** [deb] Error 1

Don't know what you are doing differently to me, but make deb is not
even trying to build signed packages on my build machine. It never
has, and I don't ever recall seeing make deb fail because it was
trying to build signed packages in the last 5 years on any of my
machines...

I'm not passing -uc -us to dpkg-buildpackage, so somewhere aling the
line it is working out that it shouldn't be signing the packages
itself...

> I think it is also reasonable for devs to be able to build test debs on
> machines that have empty keyrings.

That's exactly what I have been doing for a long time.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
