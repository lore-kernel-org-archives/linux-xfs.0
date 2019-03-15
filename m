Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:49564 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbfCOFaj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Mar 2019 01:30:39 -0400
Date: Thu, 14 Mar 2019 22:30:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 06/36] debian: enable parallel make
Message-ID: <20190315053032.GG4929@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259746044.31886.13633380455067163247.stgit@magnolia>
 <CAFMei7MhwDDLvZ41Op5ij7S0_h3FpK19eXZdX6=guS_nBJ361A@mail.gmail.com>
 <20190315010113.GB4929@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190315010113.GB4929@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nathan Scott <nathans@redhat.com>
Cc: "Sandeen, Eric" <sandeen@sandeen.net>, xfs <linux-xfs@vger.kernel.org>

On Thu, Mar 14, 2019 at 06:01:13PM -0700, Darrick J. Wong wrote:
> On Fri, Mar 15, 2019 at 11:18:32AM +1100, Nathan Scott wrote:
> > On Fri, Mar 15, 2019 at 8:04 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > >
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > >
> > > Use parallel make to speed up dpkg builds.
> > 
> > Seems a little more involved than I woulda expected, but LGTM.
> > 
> > Reviewed-by: Nathan Scott <nathans@debian.org>
> > 
> > >                 for dir in include libxfs; do \
> > > -                       $(MAKE) -C $$dir NODEP=1 install-headers; \
> > > +                       $(MAKE) $(PMAKEFLAGS) -C $$dir NODEP=1 install-headers; \
> > >                 done; \
> > 
> > OOC, does the $(MAKE) -C above warrant the same treatment as the earlier patch?
> > (i.e. removing the -C there for less verbosity)
> 
> Hmm, that seems like it could be the case.  I'll have a look tomorrow.

It doesn't work, because buildrules sets up $(SUBDIRS) as (phony)
targets so that you can do:

$ make scrub

and have the top level Makefile set Q and then recurse into scrub/
instead of doing it yourself ("make -C scrub").  That's why the previous
-C removal patch works.

The hunk of Makefile you're talking about does:

$ make -C include install-headers

which is different because install-headers is a target that only exists
in {include,libxfs}/Makefile, not the top level build system.  So we
have to get make to chdir into include/ for the target to work at all.

--D

> --D
> 
> > cheers.
> > 
> > --
> > Nathan
