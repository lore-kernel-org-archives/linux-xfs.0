Return-Path: <SRS0=O+9a=AA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE66C433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 22:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B08612231B
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 22:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729499AbgFSWnh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 18:43:37 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:50530 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgFSWng (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 18:43:36 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id C66341002A3;
        Sat, 20 Jun 2020 08:43:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jmPjJ-0000y9-S2; Sat, 20 Jun 2020 08:43:25 +1000
Date:   Sat, 20 Jun 2020 08:43:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        peter green <plugwash@p10link.net>,
        Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: Bug#953537: xfsdump fails to install in /usr merged system.
Message-ID: <20200619224325.GP2005@dread.disaster.area>
References: <998fa1cb-9e9f-93cf-15f0-e97e5ec54e9a@p10link.net>
 <20200619044734.GB11245@magnolia>
 <ea662f0b-7e73-0bbe-33aa-963389b9e215@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea662f0b-7e73-0bbe-33aa-963389b9e215@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=xNf9USuDAAAA:8
        a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8 a=7_gqYDg1-YOlvv8Dm2kA:9
        a=CjuIK1q_8ugA:10 a=SEwjQc04WA-l_NiBhQ7s:22 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 19, 2020 at 12:03:35PM -0500, Eric Sandeen wrote:
> On 6/18/20 11:47 PM, Darrick J. Wong wrote:
> > On Fri, Jun 19, 2020 at 05:05:00AM +0100, peter green wrote:
> >> (original message was sent to nathans@redhat.com
> >> 953537@bugs.debian.org and linux-xfs@vger.kernel.org re-sending as
> >> plain-text only to linux-xfs@vger.kernel.org)
> >>
> >> This bug has now caused xfsdump to be kicked out of testing which is
> >> making amanda unbuildable in testing.
> > 
> > Uhoh...
> > 
> >>
> >>
> >>> Yes, what's really needed here is for a change to be merged upstream
> >>> (as all other deb packaging artifacts are) otherwise this will keep
> >>> getting lost in time.
> >> To make it easier to upstream this I whipped up a patch that should
> >> solve the issue while only modifying the debian packaging and not
> >> touching the upstream makefiles. It is attached to this message and if
> >> I get no response I will likely do some further testing and then NMU
> >> it in Debian.
> >>
> >> One issue I noticed is it's not all all obvious who upstream is. The
> >> sgi website listed in README seems to be long dead and there are no
> >> obvious upstream results in a google search for xfsdump. Gentoos page
> >> on xfsdump links to https://xfs.wiki.kernel.org but that page makes no
> >> mention of xfsdump.
> >>
> >> I eventually poked around on git.kernel.org and my best guess is that
> >> https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/ is the upstream
> >> git repository and linux-xfs@vger.kernel.org is the appropriate
> >> mailing list, I would appreciate comments on whether or not this is
> >> correct and updates to the documentation to reflect whatever the
> >> correct location is.
> > 
> > Yep, you've found us. :)
> > 
> > Uh... seeing how /sbin seems to be a symlink to /usr/sbin on more and
> > more distros now, how about we just change the upstream makefile to dump
> > them in /usr/sbin and forget all about the symlinks?
> > 
> > (He says, wondering what the actual maintainer will say...)
> 
> I wonder too :P
> 
> So, FWIW, fedora/rhel packaging also hacks this up :(

Isn't the configure script supposed to handle install locations?
Both xfsprogs and xfsdump have this in their include/builddefs.in:

PKG_ROOT_SBIN_DIR = @root_sbindir@
PKG_ROOT_LIB_DIR= @root_libdir@@libdirsuffix@

So the actual install locations are coming from the autoconf setup
the build runs under. Looking in configure.ac in xfsprogs and
xfsdump, they both do the same thing:

.....
#
# Some important tools should be installed into the root partitions.
#
# Check whether exec_prefix=/usr: and install them to /sbin in that
# case.  If the user choses a different prefix assume he just wants
# a local install for testing and not a system install.
#
case $exec_prefix:$prefix in
NONE:NONE | NONE:/usr | /usr:*)
  root_sbindir='/sbin'
  root_libdir="/${base_libdir}"
  ;;
*)
  root_sbindir="${sbindir}"
  root_libdir="${libdir}"
  ;;
esac

AC_SUBST([root_sbindir])
AC_SUBST([root_libdir])

....

I suspect that this "system install" logic - which once made sense -
doesn't work at all with symlinked /sbin setups.

IIRC debian is in a transistion stage where it will accept either
types of package, but people trying to install a "linked /sbin only"
system will be reporting issues where pacakges do the wrong thing...

> xfsdump does:
> 
> %install
> rm -rf $RPM_BUILD_ROOT
> make DIST_ROOT=$RPM_BUILD_ROOT install
> # remove non-versioned docs location
> rm -rf $RPM_BUILD_ROOT/%{_datadir}/doc/xfsdump/
> 
> # Bit of a hack to move files from /sbin to /usr/sbin
> (cd $RPM_BUILD_ROOT/%{_sbindir}; rm xfsdump xfsrestore)
> (cd $RPM_BUILD_ROOT/%{_sbindir}; mv ../../sbin/xfsdump .)
> (cd $RPM_BUILD_ROOT/%{_sbindir}; mv ../../sbin/xfsrestore .)
> 
> xfsprogs does:
> 
> %install
> make DIST_ROOT=$RPM_BUILD_ROOT install install-dev \
>         PKG_ROOT_SBIN_DIR=%{_sbindir} PKG_ROOT_LIB_DIR=%{_libdir}

So the fedora rpm package build is overriding the locations that
autoconf set in include/builddefs for the install on the make
command line?

> Both of these work around the default location of /sbin:
> 
> # grep PKG_ROOT_SBIN_DIR xfsprogs-maint/include/builddefs xfsdump/include/builddefs
> xfsprogs-maint/include/builddefs:PKG_ROOT_SBIN_DIR = /sbin
> xfsdump/include/builddefs:PKG_ROOT_SBIN_DIR = /sbin

Ok, it is.

So my question is this: what magic should we be putting in autoconf
to have it automatically detect that the package should build for a
linked /sbin and have the build always do the right thing via "make
install"?

> On one hand, it'd be easy enough to change the upstream defaults I guess.
> On the other hand, I think the PKG_ROOT_SBIN_DIR method is easy too.
> 
> How does debian fix this for xfsprogs?  Doesn't the same issue exist?

AFAICT, yes, it does exist. The buildroot from a recent package
build:

$ ls -l xfsprogs-5.7.0-rc0/debian/xfsprogs/sbin
total 928
-rwxr-xr-x 1 dave dave   1968 May 21 15:41 fsck.xfs
-rwxr-xr-x 1 dave dave 367584 May 21 15:42 mkfs.xfs
-rwxr-xr-x 1 dave dave 573536 May 21 15:42 xfs_repair
$

xfsprogs also appears to be packaging binaries in /sbin, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
