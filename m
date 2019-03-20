Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60872 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfCTUXa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 20 Mar 2019 16:23:30 -0400
Subject: Re: [PATCH 18/36] scrub: fix Makefile targets which depend on
 builddefs
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
 <155259754139.31886.15219987362146132076.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <405b798e-3128-b10b-d525-229217c157b0@sandeen.net>
Date: Wed, 20 Mar 2019 15:23:29 -0500
MIME-Version: 1.0
In-Reply-To: <155259754139.31886.15219987362146132076.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On 3/14/19 4:05 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add Makefile dependencies for targets that require variables set in
> builddefs.

<wonders why this is unique to scrub/ and whether we should make
scrub/ special?>

Ok, Darrick points out that scrub is the only(?) subdir that actually
substitutes builddefs variables in the /build/ process, so it is unique in
that regard.

However, builddefs also defines all the HAVE_FOO and even (as Darrick
points out) CC= so I'm still feeling like this shouldn't be a one-off
for the scrub subdir.  Thoughts?

-Eric

> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  scrub/Makefile |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/scrub/Makefile b/scrub/Makefile
> index 6e155c2c..bbcfe338 100644
> --- a/scrub/Makefile
> +++ b/scrub/Makefile
> @@ -3,7 +3,8 @@
>  #
>  
>  TOPDIR = ..
> -include $(TOPDIR)/include/builddefs
> +builddefs=$(TOPDIR)/include/builddefs
> +include $(builddefs)
>  
>  # On linux we get fsmap from the system or define it ourselves
>  # so include this based on platform type.  If this reverts to only
> @@ -103,27 +104,27 @@ LDIRT = $(XFS_SCRUB_ALL_PROG) *.service *.cron
>  
>  default: depend $(LTCOMMAND) $(XFS_SCRUB_ALL_PROG) $(OPTIONAL_TARGETS)
>  
> -xfs_scrub_all: xfs_scrub_all.in
> +xfs_scrub_all: xfs_scrub_all.in $(builddefs)
>  	@echo "    [SED]    $@"
>  	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
>  		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
>  		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" < $< > $@
>  	$(Q)chmod a+x $@
>  
> -phase5.o unicrash.o xfs.o: $(TOPDIR)/include/builddefs
> +phase5.o unicrash.o xfs.o: $(builddefs)
>  
>  include $(BUILDRULES)
>  
>  install: $(INSTALL_SCRUB)
>  
> -%.service: %.service.in
> +%.service: %.service.in $(builddefs)
>  	@echo "    [SED]    $@"
>  	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
>  		   -e "s|@scrub_args@|$(XFS_SCRUB_ARGS)|g" \
>  		   -e "s|@pkg_lib_dir@|$(PKG_LIB_DIR)|g" \
>  		   -e "s|@pkg_name@|$(PKG_NAME)|g" < $< > $@
>  
> -%.cron: %.cron.in
> +%.cron: %.cron.in $(builddefs)
>  	@echo "    [SED]    $@"
>  	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" < $< > $@
>  
> 
