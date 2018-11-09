Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45906 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbeKJFcl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 00:32:41 -0500
Date: Fri, 9 Nov 2018 11:50:33 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] make: don't spray static check failures all over the
 subdir build
Message-ID: <20181109195033.GG15721@magnolia>
References: <20181109192822.GF15721@magnolia>
 <267751ec-88d1-cdbb-a6f2-74d6b8b437da@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <267751ec-88d1-cdbb-a6f2-74d6b8b437da@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 09, 2018 at 01:34:44PM -0600, Eric Sandeen wrote:
> On 11/9/18 1:28 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Debian package building is special -- it directly calls make -C libxfs
> > when building the debian-installer packages.  This means that any
> > variables we define in the top level Makefile don't get passed down to
> > subdir make processes.
> > 
> > This means that the new static checker support effectively runs the
> > first argument in $(CFLAGS) as a command, which is surprising.  Fix up
> > buildrules to patch out CHECK_CMD if nobody's defined it, so that direct
> > subdir make works again.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  include/buildrules |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/include/buildrules b/include/buildrules
> > index 83dfe05b..5c3e6eb9 100644
> > --- a/include/buildrules
> > +++ b/include/buildrules
> > @@ -36,6 +36,10 @@ $(SUBDIRS):
> >  	$(Q)$(MAKE) $(MAKEOPTS) -q -C $@ || $(MAKE) $(MAKEOPTS) -C $@
> >  endif
> >  
> > +ifndef CHECK_CMD
> > +CHECK_CMD = @true
> > +endif
> > +
> 
> Hm, ok, not quite clear if this is a hack or a proper fix - maybe
> all the check stuff should have gone into buildrules in the first
> place?  But at this late stage in the game, it's probably good enough.

It's a stupid hack, but if CFLAGS=-g -O2 -Wall and someone runs "make -C
repair" instead of "make repair" then make will foolishly run "g -O2
-Wall", whatever that does.  command-not-found tells me there's no known
"g" command.

As for debian builds we probably should just update debian/rules to
something more modern.

--D

> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> Thanks,
> -eric
