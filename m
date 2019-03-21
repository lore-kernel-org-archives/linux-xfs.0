Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:54770 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728775AbfCUUjO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Mar 2019 16:39:14 -0400
Date: Thu, 21 Mar 2019 13:39:02 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 18/36] scrub: fix Makefile targets which depend on
 builddefs
Message-ID: <20190321203902.GN1183@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259754139.31886.15219987362146132076.stgit@magnolia>
 <405b798e-3128-b10b-d525-229217c157b0@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <405b798e-3128-b10b-d525-229217c157b0@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org

On Wed, Mar 20, 2019 at 03:23:29PM -0500, Eric Sandeen wrote:
> On 3/14/19 4:05 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Add Makefile dependencies for targets that require variables set in
> > builddefs.
> 
> <wonders why this is unique to scrub/ and whether we should make
> scrub/ special?>
> 
> Ok, Darrick points out that scrub is the only(?) subdir that actually
> substitutes builddefs variables in the /build/ process, so it is unique in
> that regard.
> 
> However, builddefs also defines all the HAVE_FOO and even (as Darrick
> points out) CC= so I'm still feeling like this shouldn't be a one-off
> for the scrub subdir.  Thoughts?

[Summarizing IRC chatter last night]

Dave suggested using AC_CONFIG_FILES to replace the sed-using targets in
scrub/Makefile, but it turns out that AC_CONFIG_FILES only does a single
level of substitution (because that's all that's needed for Makefiles)
so if we have the statement:

@sbindir@/xfs_scrub -foo

and variables:

exec_prefix="/usr"
sbindir="${exec_prefix}/sbin"

Then AC_CONFIG_FILES emits:

${exec_prefix}/sbin/xfs_scrub -foo

Not the fully variable-expanded absolute path we were expecting:

/usr/sbin/xfs_scrub -foo

like what systemd service files and cronjob filess are supposed to have.
That's why we need the sed commands in the Makefile and the explicit
dependency on builddefs.

FWIW the AC_CONFIG_FILES documentation implies it's only supposed to be
used for generating Makefiles, not actual build targets.

--D

> -Eric
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/Makefile |   11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > 
> > diff --git a/scrub/Makefile b/scrub/Makefile
> > index 6e155c2c..bbcfe338 100644
> > --- a/scrub/Makefile
> > +++ b/scrub/Makefile
> > @@ -3,7 +3,8 @@
> >  #
> >  
> >  TOPDIR = ..
> > -include $(TOPDIR)/include/builddefs
> > +builddefs=$(TOPDIR)/include/builddefs
> > +include $(builddefs)
> >  
> >  # On linux we get fsmap from the system or define it ourselves
> >  # so include this based on platform type.  If this reverts to only
> > @@ -103,27 +104,27 @@ LDIRT = $(XFS_SCRUB_ALL_PROG) *.service *.cron
> >  
> >  default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(OPTIONAL_TARGETS)
> >  
> > -xfs_scrub_all: xfs_scrub_all.in
> > +xfs_scrub_all: xfs_scrub_all.in $(builddefs)
> >  	@echo "    [SED]    $@"
> >  	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
> >  		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
> >  		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
> >  	$(Q)chmod a+x $@
> >  
> > -phase5.o unicrash.o xfs.o: $(TOPDIR)/include/builddefs
> > +phase5.o unicrash.o xfs.o: $(builddefs)
> >  
> >  include $(BUILDRULES)
> >  
> >  install: $(INSTALL_SCRUB)
> >  
> > -%.service: %.service.in
> > +%.service: %.service.in $(builddefs)
> >  	@echo "    [SED]    $@"
> >  	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
> >  		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
> >  		   -e "s|@pkg_lib_dir@|$(PKG_LIB_DIR)|g" \
> >  		   -e "s|@pkg_name@|$(PKG_NAME)|g" < $< > $@
> >  
> > -%.cron: %.cron.in
> > +%.cron: %.cron.in $(builddefs)
> >  	@echo "    [SED]    $@"
> >  	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" < $< > $@
> >  
> > 
